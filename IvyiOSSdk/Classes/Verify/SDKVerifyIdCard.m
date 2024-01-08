//
//  SDKVerifyIdCard.m
//  FlatUIKit
//
//  Created by 余冰星 on 2020/2/25.
//

#import "SDKVerifyIdCard.h"
#import <IvyiOSSdk/SDKHelper.h>
#import <IvyiOSSdk/SDKCache.h>
#import <IvyiOSSdk/SDKGCDTimer.h>
#import <EasyShowView/EasyTextView.h>
NSString * const SDK_VERIFY_AGE = @"SDK_VERIFY_AGE";
NSString * const SDK_VERIFY_NAME = @"SDK_VERIFY_NAME";
NSString * const SDK_VERIFY_IDCARD = @"SDK_VERIFY_IDCARD";
NSString * const SDK_HAS_START_VERIFY = @"SDK_HAS_START_VERIFY";
NSString * const SDK_DEMO_TIMER = @"SDK_DEMO_TIMER";
NSString * const SDK_DEMO_LAST_STARTTIME = @"SDK_DEMO_LAST_STARTTIME";
NSString * const SDK_DEMO_LEFTSECOND = @"SDK_DEMO_LEFTSECOND";
NSString * const SDK_DAILY_PAY = @"SDK_DAILY_PAY";
NSString * const SDK_MONTH_PAY = @"SDK_MONTH_PAY";
@implementation SDKVerifyIdCard
{
    @private
    BOOL _hasVerifyed;
    SDKCustomAlertView *_verifyIdCardView;
    UITextField *_nameField;
    UITextField *_idcardField;
}
@synthesize age = _age;
@synthesize name = _name;
@synthesize idCard = _idCard;
@synthesize leftSeconds = _leftSeconds;
@synthesize lastStartTime = _lastStartTime;
@synthesize dailypay = _dailypay;
@synthesize monthpay = _monthpay;
@synthesize onIdCardVerified = _onIdCardVerified;

+ (SDKVerifyIdCard *)sharedInstance
{
    static SDKVerifyIdCard *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(instancetype)init
{
    self = [super init];
    NSNumber *tmp = (NSNumber *)[[SDKCache cache] objectForKey:SDK_VERIFY_AGE];
    _age = tmp ? tmp.intValue : 0;
    _name = (NSString *)[[SDKCache cache] objectForKey:SDK_VERIFY_NAME];
    _idCard = (NSString *)[[SDKCache cache] objectForKey:SDK_VERIFY_IDCARD];
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:SDK_DEMO_LAST_STARTTIME];
    _lastStartTime = tmp ? tmp.longValue : 0;
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:SDK_DEMO_LEFTSECOND];
    _leftSeconds = tmp ? tmp.longValue : -1;
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:SDK_DAILY_PAY];
    _dailypay = tmp ? tmp.doubleValue : 0;
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:SDK_MONTH_PAY];
    _monthpay = tmp ? tmp.doubleValue : 0;
    return self;
}

-(void)setName:(NSString *)name
{
    _name = name;
    [[SDKCache cache] setObject:name forKey:SDK_VERIFY_NAME];
}

-(void)setIdCard:(NSString *)idCard
{
    _idCard = idCard;
    [[SDKCache cache] setObject:idCard forKey:SDK_VERIFY_IDCARD];
}

-(void)setAge:(int)age
{
    _age = age;
    [[SDKCache cache] setObject:[NSNumber numberWithInt:age] forKey:SDK_VERIFY_AGE];
}

-(void)setLeftSeconds:(long)leftSeconds
{
    _leftSeconds = leftSeconds;
    [[SDKCache cache] setObject:[NSNumber numberWithLong:_leftSeconds] forKey:SDK_DEMO_LEFTSECOND];
}

-(void)setLastStartTime:(long)lastStartTime
{
    _lastStartTime = lastStartTime;
    [[SDKCache cache] setObject:[NSNumber numberWithLong:_lastStartTime] forKey:SDK_DEMO_LAST_STARTTIME];
}

-(void)setDailypay:(double)dailypay
{
    _dailypay = dailypay;
    [[SDKCache cache] setObject:[NSNumber numberWithDouble:_dailypay] forKey:SDK_DAILY_PAY];
}

-(void)setMonthpay:(double)monthpay
{
    _monthpay = monthpay;
    [[SDKCache cache] setObject:[NSNumber numberWithDouble:_monthpay] forKey:SDK_MONTH_PAY];
}

-(void)verifyIdCard
{
    if (![self checkProtectValid]) {
        [self showDemoPlayAlert];
    }
}

-(void)showVerifyIdCard
{
    if (!_verifyIdCardView) {
        SDKCustomAlertView *alertView = [[SDKCustomAlertView alloc] init];
        
        [alertView setContainerView:[self createVerifyIdCardView]];
        
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确认", @"快速游玩", nil]];
        [alertView setDelegate:self];
        
        [alertView setOnButtonTouchUpInside:^(SDKCustomAlertView *alertView, int buttonIndex) {
            
            [self onVerifyIdCardButtonClick:alertView clickedButtonAtIndex:buttonIndex];
        }];
        
        [alertView setUseMotionEffects:true];
        _verifyIdCardView = alertView;
    }

    // And launch the dialog
    [_verifyIdCardView show];
}

-(BOOL)checkProtectValid
{
    if (_lastStartTime <= 0) {
        [self showVerifyIdCard];
        return true;
    }
    if (_age <= 0) {
        if (_leftSeconds <= 0) {
            long now = [NSDate date].timeIntervalSince1970;
            if (now - _lastStartTime > 648000) {
                self.leftSeconds = [self getDemoSecondsByAge:self.age];
                self.lastStartTime = now;
            }
        }
    } else if (_age < 18) {
        long hour = [self getCurrentHour];
        if (hour >= 22 || hour <= 8) {
            [self showExitAlert:@"根据《未成年人保护法》，22点～08点，不能进行游戏。"];
            return true;
        } else if (_leftSeconds <= 0) {
            [self showExitAlert:[NSString stringWithFormat:@"根据《未成年人保护法》，您的游戏时长已经超过%d分钟，不能进行游戏。", [self secondsToMinutes:[self getDemoSecondsByAge:_age]]]];
            return true;
        }
    }
    return false;
}

-(BOOL)checkCanPay
{
    if (self.age <= 0) {
        [EasyTextView showErrorText:@"根据《防止未成年人沉迷网络游戏》，游客有60分钟体验时间，在此模式下不能充值和付费消费。"];
        return false;
    } else if (self.age < 8) {
        [EasyTextView showErrorText:@"根据《防止未成年人沉迷网络游戏》，未满8岁的用户无法进行充值服务。"];
        return false;
    } else if (self.age < 16) {
        if (_dailypay > 50 || _monthpay > 200) {
            [SDKHelper showAlertDialog:@"无法完成本次支付" desc:[NSString stringWithFormat:@"根据《网络游戏管理暂行办法》及未成年人保护办法, 年满8岁,未满16岁的用户，单日充值不能超过50元, 月充值不能超过200元。请健康游戏, 理性消费。本日已充值：%d，本月已充值：%d", (int)_dailypay, (int)_monthpay] okBtn:@"确定" cancelBtn:nil onOk:^{
            } onCancel:nil];
            return false;
        }
    } else if (self.age < 18) {
        if (_dailypay > 100 || _monthpay > 400) {
            [SDKHelper showAlertDialog:@"无法完成本次支付" desc:[NSString stringWithFormat:@"根据《网络游戏管理暂行办法》及未成年人保护办法, 年满16岁,未满18岁的用户，单日充值不能超过100元, 月充值不能超过400元。请健康游戏, 理性消费。本日已充值：%d，本月已充值：%d", (int)_dailypay, (int)_monthpay] okBtn:@"确定" cancelBtn:nil onOk:^{
            } onCancel:nil];
            return false;
        }
    }
    return true;
}

-(void)paySuccess:(double)price
{
    self.dailypay += price;
    self.monthpay += price;
}

-(void)resetVerifyIdCard
{
    self.age = 0;
    self.idCard = @"";
    self.name = @"";
    self.lastStartTime = 0;
    self.leftSeconds = -1;
    [[SDKGCDTimer sharedInstance] cancelTimerWithName:SDK_DEMO_TIMER];
}

-(void)startDemoTimer
{
    long now = [NSDate date].timeIntervalSince1970;
    if (self.age <= 0) {
        self.lastStartTime = _lastStartTime > 0 ? _lastStartTime : now;
    } else {
        self.lastStartTime = now;
    }
    [[SDKGCDTimer sharedInstance] scheduleGCDTimerWithName:SDK_DEMO_TIMER interval:60 queue:dispatch_get_main_queue() repeats:YES option:SDKGCDTimerOptionCancelPrevAction action:^{
        if(![self checkProtectValid]) {
            [self calculateLeftSeconds];
        }
    }];
}

-(long)calculateLeftSeconds
{
    long now = [NSDate date].timeIntervalSince1970;
    self.lastStartTime = now - _lastStartTime > 100 ? now : _lastStartTime;
    self.leftSeconds -= now - _lastStartTime;
    self.lastStartTime = now;
    self.leftSeconds = _leftSeconds > 0 ? _leftSeconds : 0;
    return _leftSeconds;
}

-(void)showExitAlert:(nonnull NSString *)msg
{
    [SDKHelper showAlertDialog:@"健康游戏提示" desc:msg okBtn:@"退出游戏" cancelBtn:nil onOk:^{
    } onCancel:nil];
}

-(void)showDemoPlayAlert
{
    if (self.age <= 0) {
        // 是游客模式
        self.leftSeconds = _leftSeconds < 0 ? [self getDemoSecondsByAge:self.age] : _leftSeconds;
        NSString *desc = [NSString stringWithFormat:@"您当前为试用账号，享有%d分钟的游戏体验时间。登记实名信息后，可深度体验游戏内容。剩余游戏时间：%d分钟。", [self secondsToMinutes:[self getDemoSecondsByAge:self.age]], [self secondsToMinutes:_leftSeconds]];
        if (_leftSeconds > 0) {
            [SDKHelper showAlertDialog:@"健康游戏提示" desc:desc okBtn:@"去实名" cancelBtn:@"进入游戏" onOk:^{
                [self showVerifyIdCard];
            } onCancel:^{
                [self startDemoTimer];
            }];
        } else {
            [SDKHelper showAlertDialog:@"健康游戏提示" desc:desc okBtn:@"去实名" cancelBtn:nil onOk:^{
                [self showVerifyIdCard];
            } onCancel:nil];
        }
    } else if (self.age < 18){
        if (_lastStartTime > 0) {
            long day = [self getWeekDay:_lastStartTime];
            long today = [self getCurrentWeekDay];
            if (today != day) {
                self.leftSeconds = [self getDemoSecondsByAge:self.age];
                self.dailypay = 0;
            }
            long lastMonth = [self getMonth:_lastStartTime];
            long month = [self getCurrentMonth];
            if (lastMonth != month) {
                self.monthpay = 0;
            }
        }
        NSString *desc = [NSString stringWithFormat:@"您当前为未成年账号，享有%d分钟的游戏体验时间。剩余游戏时间：%d分钟。", [self secondsToMinutes:[self getDemoSecondsByAge:self.age]], [self secondsToMinutes:_leftSeconds]];
        [SDKHelper showAlertDialog:@"健康游戏提示" desc:desc okBtn:@"确定" cancelBtn:nil onOk:^{
            [self startDemoTimer];
        } onCancel:nil];
    }
}

- (UIView *)createVerifyIdCardView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 30)];
    title.text = @"实名认证";
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [demoView addSubview:title];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 270, 80)];
    desc.text = @"为了加强未成年人保护，落实国家相关防沉迷政策要求，游戏用户需要实名认证。（注：未成年人游戏时长及付费将受限）";
    [desc setFont:[UIFont systemFontOfSize:13.0f]];
    desc.numberOfLines = 3;
    [demoView addSubview:desc];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 290, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [demoView addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 80, 40)];
    [nameLabel setTextAlignment:NSTextAlignmentRight];
    nameLabel.text = @"姓名：";
    [demoView addSubview:nameLabel];
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(90, 110, 200, 40)];
    _nameField.placeholder = @"请输入真实姓名";
    [demoView addSubview:_nameField];
    
    UILabel *idcardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 80, 40)];
    [idcardLabel setTextAlignment:NSTextAlignmentRight];
    idcardLabel.text = @"身份证：";
    [demoView addSubview:idcardLabel];
    _idcardField = [[UITextField alloc] initWithFrame:CGRectMake(90, 155, 200, 40)];
    _idcardField.placeholder = @"请输入真实身份证号";
    [demoView addSubview:_idcardField];
    
    return demoView;
}

- (BOOL)validateIdCard:(NSString *)idcard {
    NSString *aimStr = [idcard stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *regex = @"(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}$)";
    NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [validate evaluateWithObject:aimStr];
}

- (BOOL)validateName:(NSString *)name {
    NSString *aimStr = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [validate evaluateWithObject:aimStr];
}

-(void)onVerifyIdCardButtonClick:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Block: Button at position %ld is clicked on alertView %d.", (long)buttonIndex, (int)[alertView tag]);
    switch (buttonIndex) {
        case 0:
            if(_nameField.text.length == 0) {
                [EasyTextView showErrorText:@"姓名不能为空。"];
            } else if (_idcardField.text.length == 0) {
                [EasyTextView showErrorText:@"身份证号不能为空。"];
            } else if (![self validateName:_nameField.text]) {
                [EasyTextView showErrorText:@"请检查您的姓名格式是否正确。"];
            } else if (![self validateIdCard:_idcardField.text]) {
                [EasyTextView showErrorText:@"请检查您的身份证格式是否正确。"];
            } else {
                int age = [self calculateAgeStr:_idcardField.text];
                if (age > 0) {
                    self.age = age;
                    self.name = _nameField.text;
                    self.idCard = _idcardField.text;
                    self.leftSeconds = [self getDemoSecondsByAge:self.age];
                    [alertView close];
                    if (_onIdCardVerified) {
                        _onIdCardVerified();
                    }
                    [self showDemoPlayAlert];
                } else {
                    [EasyTextView showErrorText:@"您的年龄小于1岁，请检查您的身份证号码。"];
                }
            }
            break;
        default:
            [alertView close];
            [self showDemoPlayAlert];
            break;
    }
}

-(void)touchBackground
{
    if (_nameField) {
        [_nameField endEditing:YES];
    }
    if (_idcardField) {
        [_idcardField endEditing:YES];
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self onVerifyIdCardButtonClick:alertView clickedButtonAtIndex:buttonIndex];
}

-(int)secondsToMinutes:(long)seconds
{
    return trunc(seconds/60);
}

-(int)getDemoSecondsByAge:(int)age
{
    if (age < 18) {
        if (age <= 0) {
            return 60 * 60;
        } else {
            long day = [self getCurrentWeekDay];
            if (day < 6) {
                return 90 * 60;
            } else {
                return 180 * 60;
            }
        }
    }
    return -1;
}

//截取身份证的出生日期并转换为日期格式
-(NSString *)subsIDStrToDate:(NSString *)str{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    
    NSString *dateStr = [str substringWithRange:NSMakeRange(6, 8)];
    NSString  *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString  *month = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString  *day = [dateStr substringWithRange:NSMakeRange(6,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    
    return result;
}

//计算年龄
-(int)calculateAgeStr:(NSString *)str{
    //截取身份证的出生日期并转换为日期格式
    NSString *dateStr = [self subsIDStrToDate:str];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-mm-dd";
    NSDate *birthDate = [formatter dateFromString:dateStr];
    NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
    
    // 计算年龄
    int age = trunc(dateDiff/(60*60*24))/365;
    return -age;
}

- (NSDateComponents *)getDeteComponents:(NSTimeInterval)time {
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMonth fromDate:newDate];
    return components;
}

- (long)getWeekDay:(NSTimeInterval)time
{
    long day = [self getDeteComponents:time].weekday - 1;
    return day == 0 ? 7 : day;
}

- (long)getCurrentWeekDay {
    return [self getWeekDay:[[NSDate date] timeIntervalSince1970]];
}

- (long)getMonth:(NSTimeInterval)time
{
    return [self getDeteComponents:time].month;
}

- (long)getCurrentMonth {
    return [self getMonth:[[NSDate date] timeIntervalSince1970]];
}

- (long)getHour:(NSTimeInterval)time
{
    return [self getDeteComponents:time].hour;
}

- (long)getCurrentHour {
    return [self getHour:[[NSDate date] timeIntervalSince1970]];
}
@end
