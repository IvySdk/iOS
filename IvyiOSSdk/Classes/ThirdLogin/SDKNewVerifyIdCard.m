//
//  SDKNewVerifyIdCard.m
//  FlatUIKit
//
//  Created by 余冰星 on 2020/2/25.
//

#import "SDKNewVerifyIdCard.h"
#import <IvyiOSSdk/SDKHelper.h>
#import <IvyiOSSdk/SDKCache.h>
#import <IvyiOSSdk/SDKGCDTimer.h>
#import <IvyiOSSdk/SDKConstants.h>
#import <IvyiOSSdk/EasyTextView.h>
#import <IvyiOSSdk/EasyLoadingView.h>
#import <IvyiOSSdk/SDKNetworkHelper.h>
#import <IvyiOSSdk/SDKFacade.h>

@implementation SDKNewVerifyIdCard
{
    //是否是打开游戏第一次打开未成年提示窗口
    BOOL isFirstTip;
    long lastGameStartTime;
}
@synthesize age = _age;
@synthesize name = _name;
@synthesize idCard = _idCard;
@synthesize dailyPlay = _dailyPlay;
@synthesize dailypay = _dailypay;
@synthesize monthpay = _monthpay;
@synthesize totalpay = _totalpay;

+ (SDKNewVerifyIdCard *)sharedInstance
{
    static SDKNewVerifyIdCard *_instance = nil;
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
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:[self getTodayPlayKey]];
    _dailyPlay = tmp ? tmp.longValue : 0;
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:[self getTodayPayKey]];
    _dailypay = tmp ? tmp.doubleValue : 0;
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:[self getMonthPayKey]];
    _monthpay = tmp ? tmp.doubleValue : 0;
    tmp = (NSNumber *)[[SDKCache cache] objectForKey:[self getTotalPayKey]];
    _totalpay = tmp ? tmp.doubleValue : 0;
    [self startCheckPlayedTimes];
    return self;
}

-(void)startCheckPlayedTimes
{
    [self checkPlayedTimes];
    [[SDKGCDTimer sharedInstance] scheduleGCDTimerWithName:SDK_DEMO_TIMER interval:60 queue:dispatch_get_main_queue() repeats:YES option:SDKGCDTimerOptionCancelPrevAction action:^{
        [self checkPlayedTimes];
    }];
}

-(void)checkPlayedTimes
{
    DLog(@"checkPlayedTimes");
    //如果是已经登陆过并且是未成年用户则需要进行游戏时间检测
    if (self ->_age > 0 && self ->_age < 18) {
        long hour = [self getCurrentHour];
      long weekDay = [self getCurrentWeekDay];
        if ((hour <= 20 || hour >=22) || (weekDay != 5 && weekDay != 6 && weekDay !=7)) {
            [self showExitAlert:@"您目前为未成年人账号，已被纳入防沉迷系统。根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，每周五、周六、周日和法定节假日每日20时至21时向未成年人提供1小时网络游戏服务，其他时间段本游戏将无法为未成年人用户提供游戏服务。"];
        }else{
            if(self -> lastGameStartTime == 0)
            {
                self -> lastGameStartTime = [[NSDate date] timeIntervalSince1970];
            }
            long nowTimeStamp = [[NSDate date] timeIntervalSince1970];
            self.dailyPlay += nowTimeStamp - self -> lastGameStartTime;
            self -> lastGameStartTime = nowTimeStamp;
            if (self.dailyPlay > 60 * 90) {
                [self showExitAlert:[NSString stringWithFormat:@"根据《未成年人保护法》，您的游戏时长已经超过90分钟，不能进行游戏。"]];
            }else{
                DLog(@"当前已经玩%ld分钟",self.dailyPlay/60);
            }
        }
    }
}

-(BOOL)checkCanPay
{
    if (self.age <= 0) {
        [EasyTextView showErrorText:@"根据《防止未成年人沉迷网络游戏》，游客有60分钟体验时间，在此模式下不能充值和付费消费。"];
        return false;
    } else if (self.age < 8) {
        [EasyTextView showErrorText:@"您目前为未成年人账号，已被纳入防沉迷系统。根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，本游戏不为未满8周岁的用户提供游戏充值服务。"];
        return false;
    } else if (self.age < 16) {
        if (_dailypay > 50 || _monthpay > 200) {
            [SDKHelper showAlertDialog:@"无法完成本次支付" desc:@"您目前为未成年人账号，已被纳入防沉迷系统。根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，游戏中8周岁以上未满16周岁的用户，单次充值金额不得超过50元人民币，每月充值金额不得超过200元人民币。" okBtn:@"确定" cancelBtn:nil onOk:^{
            } onCancel:nil];
            return false;
        }
    } else if (self.age < 18) {
        if (_dailypay > 100 || _monthpay > 400) {
            [SDKHelper showAlertDialog:@"无法完成本次支付" desc:@"您目前为未成年人账号，已被纳入防沉迷系统。根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，游戏中16周岁以上未满18周岁的用户，单次充值金额不得超过100元人民币，每月充值金额不得超过400元人民币。" okBtn:@"确定" cancelBtn:nil onOk:^{
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
}

-(void)showExitAlert:(nonnull NSString *)msg
{
    [SDKHelper showAlertDialog:@"健康游戏提示" desc:msg okBtn:@"退出游戏" cancelBtn:nil onOk:^{
        exit(0);
    } onCancel:nil];
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

-(void)verifyIdCard:(NSString *)idCard name:(NSString *)playerName uuid:(NSString *) uuid verifyUrl:(NSString *)verifyUrl verifyCallback:(void(^)(int age))callback
{
    if(playerName.length == 0) {
        [EasyTextView showErrorText:@"姓名不能为空。"];
    } else if (idCard.length == 0) {
        [EasyTextView showErrorText:@"身份证号不能为空。"];
    } else if (![self validateName:playerName]) {
        [EasyTextView showErrorText:@"请检查您的姓名格式是否正确。"];
    } else if (![self validateIdCard:idCard]) {
        [EasyTextView showErrorText:@"请检查您的身份证格式是否正确。"];
    } else {
        int age = [self calculateAgeStr:idCard];
        if (age > 0) {
            EasyLoadingView *loadingView = [EasyLoadingView showLoadingText:@"加载中..." config:^EasyLoadingConfig *{
                return [EasyLoadingConfig shared].setShowOnWindow(true).setSuperReceiveEvent(NO);
            }];
            //请求服务器进行实名验证
            NSDictionary *params = @{
                @"idCard":idCard,
                @"name":playerName,
                @"uuid":uuid,
                @"appid":[SDKFacade sharedInstance].appid
            };
            
            if(!verifyUrl || verifyUrl.length == 0){
                verifyUrl = @"https://api.winwingplane.cn/auth/idCardCheck";
            }
            [[SDKNetworkHelper sharedHelper] GET:verifyUrl parameters:params jsonRequest:false jsonResponse:false success:^(id  _Nullable responseObject) {
                NSData *respData = (NSData *)responseObject;
                NSString *respString = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];
                if(![respString isEqualToString:@"0"]){
                    self.age = age;
                    self.name = playerName;
                    self.idCard = idCard;
                    callback(age);
                }else{
                    callback(-1);
                    DLog(@"verify server with error: %@",respString);
                }
                [EasyLoadingView hidenLoading:loadingView];
            } failure:^(NSError * _Nullable error) {
                DLog(@"verify idcard with request error: 设备网络不可用");
                [EasyTextView showErrorText:@"当前设备网络不可用，请稍候再试!"];
            }];
        } else {
            [EasyTextView showErrorText:@"您的年龄小于1岁，请检查您的身份证号码。"];
        }
    }
}

-(int)secondsToMinutes:(long)seconds
{
    return trunc(seconds/60);
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

- (NSDateComponents *)getDateComponents:(NSTimeInterval)time {
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMonth fromDate:newDate];
    return components;
}

#pragma mark - setter and getter

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

- (void)setDailyPlay:(long)dailyPlay
{
    _dailyPlay = dailyPlay;
    [[SDKCache cache] setObject:[NSNumber numberWithLong:_dailyPlay] forKey:[self getTodayPlayKey]];
}

-(void)setDailypay:(double)dailypay
{
    _dailypay = dailypay;
    [[SDKCache cache] setObject:[NSNumber numberWithDouble:_dailypay] forKey:[self getTodayPayKey]];
}

-(void)setMonthpay:(double)monthpay
{
    _monthpay = monthpay;
    [[SDKCache cache] setObject:[NSNumber numberWithDouble:_monthpay] forKey:[self getMonthPayKey]];
}


#pragma mark - get date params
- (long)getWeekDay:(NSTimeInterval)time
{
    long day = [self getDateComponents:time].weekday - 1;
    return day == 0 ? 7 : day;
}

- (long)getCurrentWeekDay {
    return [self getWeekDay:[[NSDate date] timeIntervalSince1970]];
}

- (long)getMonth:(NSTimeInterval)time
{
    return [self getDateComponents:time].month;
}

- (long)getCurrentMonth {
    return [self getMonth:[[NSDate date] timeIntervalSince1970]];
}

- (long)getHour:(NSTimeInterval)time
{
    return [self getDateComponents:time].hour;
}

- (long)getCurrentHour {
    return [self getHour:[[NSDate date] timeIntervalSince1970]];
}

#pragma mark - 获取存取支付信息的key
-(NSString *)getTodayPayKey
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    return [NSString stringWithFormat:@"sdk_third_login_day_pay_%@",currentDateString];
}

-(NSString *)getMonthPayKey
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMM"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    return [NSString stringWithFormat:@"sdk_third_login_month_pay_%@",currentDateString];
}

-(NSString *)getTotalPayKey
{
    return @"sdk_third_login_total_pay";
}

-(NSString *) getTodayPlayKey
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    return [NSString stringWithFormat:@"sdk_third_login_day_play_%@",currentDateString];
}



@end
