//
//  SDKViewController.m
//  IvyiOSSdk
//
//  Created by yubingxing on 06/06/2017.
//  Copyright (c) 2017 yubingxing. All rights reserved.
//

#import "SDKViewController.h"
//#import "FUIButton.h"
//#import "UIFont+FlatUI.h"
//#import "UIColor+FlatUI.h"
#import <AdSupport/AdSupport.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKJSONHelper.h>
#import <IvyiOSSdk/SDKHelper.h>
#import <IvyiOSSdk/SDKStartPromotionAd.h>
#import <IvyiOSSdk/EasyShowView.h>
@interface SDKViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;

@end

@implementation SDKViewController
{
@private
    NSArray *btnNames;
    UIView *loginBtn;
    UIView *shareBtn;
    UIView *likeBtn;
    UIView *sendBtn;
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (NSArray*)systemEmailsList{
    
    NSString *path = @"/var/mobile/Library/Preferences/com.apple.accountsettings.plist";
    NSDictionary *accountDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *accounts = [accountDic valueForKey:@"Accounts"];
    NSMutableArray *emailListArray = [NSMutableArray array];
    
    for(NSDictionary *account in accounts) {
        NSString *classValue = [account valueForKey:@"Class"];
        if([classValue isEqualToString:@"POPAccount"])    {
            [emailListArray addObject:[NSString stringWithFormat:@"%@",[account objectForKey:@"Username"]]];
        }
        if([classValue isEqualToString:@"GmailAccount"])   {
            [emailListArray addObject:[NSString stringWithFormat:@"%@",[account objectForKey:@"Username"]]];
        }
        
        if([classValue isEqualToString:@"IMAPAccount"])    {
            [emailListArray addObject:[NSString stringWithFormat:@"%@",[account objectForKey:@"Username"]]];
        }
        
        if([classValue isEqualToString:@"YahooAccount"])   {
            [emailListArray addObject:[NSString stringWithFormat:@"%@",[account objectForKey:@"Username"]]];
        }
    }
    return emailListArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self systemEmailsList];
    NSString *str = @"{\"status\":1}";
    NSString *key = @"c3fcd3d76192e4007dfb496cca67e13b";
    NSString *encryptData = @"gbv_O2mKllAgNp-XGQZvnA";
//    NSString *encryptData = @"gbv_O2mKllAgNp-XGQZvnA";
    NSString *encrypt = [SDKHelper encryptWithAES:str key:key];
    NSLog(@"encryptWithAES : %@", encrypt);
    NSString *decrypt = [SDKHelper decryptWithAES:encryptData key:key];
    NSLog(@"decryptWithAES : %@", decrypt);
    
    NSError* testErr =nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&testErr];
    if(testErr != nil) {
        NSLog(@"%@", testErr.localizedDescription);
    }else {
        NSDictionary* dict = jsonObject;
        NSLog(@"status:%@\n", [dict objectForKey:@"status"]);
    }
    
    self.ScrollView.panGestureRecognizer.delaysTouchesBegan = YES;

//    NSArray *arr2 = [[NSBundle mainBundle] loadNibNamed:@"UnifiedNativeAdView" owner:nil options:nil];
//
//    UINib *nib = [UINib nibWithNibName:@"UnifiedNativeAdView" bundle:[NSBundle mainBundle]];
//    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    NSString *dfPath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:dfPath];
    encrypt = [SDKHelper encryptWithBase64:jsonData];
    decrypt = [[NSString alloc] initWithData:[SDKHelper decryptWithBase64:encrypt] encoding:NSUTF8StringEncoding];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"idfa = %@", idfa);
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    NSLog(@"isIPhoneX = %@, isIPad = %@, %f", [SDKFacade isIPhoneX] ? @"YES" : @"NO", [SDKFacade isIPad] ? @"YES" : @"NO", UIScreen.mainScreen.bounds.size.height / UIScreen.mainScreen.bounds.size.width);
    [[SDKFacade sharedInstance] onCreate];
    [[SDKFacade sharedInstance] onCreate];
    [[SDKFacade sharedInstance] onCreate];
    [[SDKFacade sharedInstance] setAdDelegate:self];
    [[SDKFacade sharedInstance] setPaymentDelegate:self];
    [[SDKFacade sharedInstance] setSNSDelegate:self];
    [[SDKFacade sharedInstance] loginGameCenter];
//    [SDKFacade sharedInstance].backHomeAdTag = @"custom";
    self.ScrollView.scrollEnabled = YES;
    self.ScrollView.pagingEnabled = NO;
    btnNames = @[@"0)Start AD", @"1)Pause AD", @"2)Custom AD", @"3)Reward Video", @"4)ShowBanner",
                 @"5)CloseBanner", @"6)Show Icon Ad", @"7)Close Icon Ad", @"8)Show Popup Ads", @"9)Rate In App", @"10)Show Native Ad", @"11)Close Native Ad",  @"12)Buy Consumable", @"13)Buy Non-Consumable", @"14)Buy Auto-Renewable", @"15)Buy Non-Renewing", @"16)Show Leaderboard", @"17)Report Score", @"18)Show Achievement", @"19)Report Achievement", @"20)SNS Login", @"21)Login Button", @"22)SNS Share", @"23)Share Button", @"24)Send Button", @"25)Like Button", @"26)SNS Invite", @"27)SNS GetFriends",
                 @"28)SNS GetInvitableFriends", @"29)Me Name", @"30)Me Picture", @"31)Me Id", @"32)Take ScreenShot", @"33)Share ScreenShot", @"34)IsPushRegistered", @"35)Register Push", @"36)Reset Gdpr", @"37)Delicious Interstitial", @"38)Delicious Banner", @"39)Close Deli Banner", @"40)Delicious Icon", @"41)Close Deli Icon", @"42)Push Local Notif", @"43)Cancel Local Notif", @"44)Push Remote Notif", @"45)Cancel Remote Notif", @"46)sendMail", @"47)StartRecording", @"48)StopRecording", @"49)ShareRecording", @"50)ShareImage", @"51)ShowPromotion", @"52)ShowWebView", @"53)CloseWebView", @"54)VerifyIdCard", @"55)ResetVerify",
                     @"56)showSignInWithApple", @"57)hideSignInWithApple",
                    @"58)showStartPromotion",
                 @"59)unknown"];
    
    self.ScrollView.contentSize = CGSizeMake(Screen_width, Screen_height + (btnNames.count / 2 - Screen_height / 60) * 60);
    self.title = @"Ivy Sdk Demo";
//    self.view.backgroundColor = [UIColor cloudsColor];
    self.definesPresentationContext = YES;
    for (int i=0; i<btnNames.count; i++) {
        [self initBtn:i title:btnNames[i]];
    }
    [[SDKFacade sharedInstance] setAdsEnable:YES];
    [[SDKFacade sharedInstance] logPageStart:@"MainVC"];
    [[SDKFacade sharedInstance] getAppstoreVersion];
    [[SDKFacade sharedInstance] mmEnableNumberConfuse:YES];
    [[SDKFacade sharedInstance] mmSetIntValue:@"test" value:7890];
    int test = [[SDKFacade sharedInstance] mmGetIntValue:@"test" defaultValue:0];
    DLog(@"mmGetIntValue : test = %d", test);
    [[SDKFacade sharedInstance] mmSetLongValue:@"test1" value:1234567890];
    long test1 = [[SDKFacade sharedInstance] mmGetLongValue:@"test1" defaultValue:0L];
    DLog(@"mmGetIntValue : test1 = %ld", test1);
    [[SDKFacade sharedInstance] mmSetFloatValue:@"test2" value:11.11];
    float test2 = [[SDKFacade sharedInstance] mmGetFloatValue:@"test2" defaultValue:0];
    DLog(@"mmGetIntValue : test2 = %f", test2);
    DLog(@"sdk uuid = %@", [[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID]);
    
//    [[SDKFacade sharedInstance] startTraceWithName:@"test"];
//    [[SDKFacade sharedInstance] incrementMetric:@"test" byInt:1];
//    [[SDKFacade sharedInstance] stopTraceWithName:@"test"];
}
-(void)uiButtonPressed:(UIButton*)button {
    NSString *title = button.currentTitle;
    [[SDKFacade sharedInstance] logEvent:@"clickBtn" action:title];
    NSInteger idx = [btnNames indexOfObject:title];
    switch(idx) {
        case 0://Start AD
            for (int i=0; i<10; i++) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[SDKFacade sharedInstance] showInterstitialAd:SDK_ADTAG_START];
                 });
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[SDKFacade sharedInstance] showInterstitialAd:SDK_ADTAG_START];
                 });
            }
            break;
        case 1://Pause AD
            for (int i=0; i<10; i++) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[SDKFacade sharedInstance] showInterstitialAd:SDK_ADTAG_PAUSE];
                 });
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[SDKFacade sharedInstance] showInterstitialAd:SDK_ADTAG_PAUSE];
                 });
            }
            
            break;
        case 2://Custom AD
            [[SDKFacade sharedInstance] showInterstitialAd:SDK_ADTAG_CUSTOM];
            break;
        case 3://Reward Video
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SDKFacade sharedInstance] showRewardVideo:1];
             });
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SDKFacade sharedInstance] showRewardVideo:1];
             });
            break;
        case 4://ShowBanner
            [[SDKFacade sharedInstance] showBanner:(rand() % 10)];
            break;
        case 5://CloseBanner
            [[SDKFacade sharedInstance] closeBanner];
            [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"%@-%@", [SDKHelper getLangcode], [SDKHelper getCountryCode]] isLongTime:true];
            break;
        case 6:{//Show icon ad
            float x = [self randomFloatBetween:0 andLargerFloat:Screen_width] / Screen_width;
            float y = [self randomFloatBetween:0 andLargerFloat:Screen_height] / Screen_height;
            [[SDKFacade sharedInstance] showIconAd:80 xPercent:x yPercent:y];
            break;
        }
        case 7://Close icon ad
            [[SDKFacade sharedInstance] closeIconAd];
            [self checkPurchased];
            break;
        case 8://Show popup icons
            [[SDKFacade sharedInstance] showPopupIconAds];
            break;
        case 9://Rate
            [[SDKFacade sharedInstance] rateInApp:5];
            break;
        case 10:
        {
            //            [[SDKFacade sharedInstance] showNativeAd:@"loading" x:0 y:10 configJson:@"native"];
            float x = [self randomFloatBetween:0 andLargerFloat:200];
            float y = [self randomFloatBetween:0 andLargerFloat:400];
            [[SDKFacade sharedInstance] showNativeAd:@"loading" withFrame:CGRectMake(x, y, 400, 400) configJson:@"native"];
            break;
        }
        case 11:
            [[SDKFacade sharedInstance] closeNativeAd:@"loading"];
            break;
        case 12:
            [[SDKFacade sharedInstance] pay:1];
            break;
        case 13:
            [[SDKFacade sharedInstance] pay:4];
            break;
        case 14:
            [[SDKFacade sharedInstance] pay:3];
            break;
        case 15:
            [[SDKFacade sharedInstance] pay:5];
            break;
        case 16://show leaderboard
            //            [[SDKFacade sharedInstance] showLeaderboards];
            [[SDKFacade sharedInstance] showLeaderboard:1];
            break;
        case 17://report score
        {
            long long score = random() % 200000;
            [[SDKFacade sharedInstance] submitScore:1 score:score];
            [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"submit score : %lld", score] isLongTime:NO];
            break;
        }
        case 18://show achievement
            [[SDKFacade sharedInstance] showAchievements];
            break;
        case 19://report achievement
        {
            [[SDKFacade sharedInstance] submitAchievement:1 percent:0.1f];
            [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"submit achievement : %f", 0.1f] isLongTime:NO];
            break;
        }
        case 20://sns login
            [[SDKFacade sharedInstance] login:nil];
            [[SDKFacade sharedInstance] loginGameCenter];
            break;
        case 21://show login button
        {
            if(loginBtn) {
                [loginBtn removeFromSuperview];
                loginBtn = nil;
            } else {
                loginBtn = [[SDKFacade sharedInstance] getLoginButton];
                float x = [self randomFloatBetween:50 andLargerFloat:Screen_width-50];
                float y = [self randomFloatBetween:50 andLargerFloat:Screen_height-50];
                loginBtn.center = CGPointMake(x, y);
                [self.view addSubview:loginBtn];
            }
            break;
        }
        case 22://sns share
            [[SDKFacade sharedInstance] share:@"https://itunes.apple.com/us/app/panda-bubble-love-story/id1255090645" withTag:@"facebook" withQuote:@"this is a facebook share test."];
            //            [[SDKFacade sharedInstance] shareSheet:@"https://www.facebook.com/FacebookDevelopers" withTag:@"facebook" withQuote:@"this is a facebook share test."];
            //            [[SDKFacade sharedInstance] shareSheetOS:@"https://www.facebook.com/FacebookDevelopers" title:@"facebook share"];
            break;
        case 23://show share button
        {
            if(shareBtn) {
                [shareBtn removeFromSuperview];
                shareBtn = nil;
            } else {
                shareBtn = [[SDKFacade sharedInstance] getShareButton:@"https://www.facebook.com/FacebookDevelopers" withTag:@"facebook" withQuote:@"this is a facebook share test."];
                float x = [self randomFloatBetween:50 andLargerFloat:Screen_width-50];
                float y = [self randomFloatBetween:50 andLargerFloat:Screen_height-50];
                shareBtn.center = CGPointMake(x, y);
                [self.view addSubview:shareBtn];
            }
            break;
        }
        case 24://show send button
        {
            if(sendBtn) {
                [sendBtn removeFromSuperview];
                sendBtn = nil;
            } else {
                sendBtn = [[SDKFacade sharedInstance] getSendButton:@"https://www.facebook.com/FacebookDevelopers" withTag:@"facebook" withQuote:@"this is a facebook share test."];
                float x = [self randomFloatBetween:50 andLargerFloat:Screen_width-50];
                float y = [self randomFloatBetween:50 andLargerFloat:Screen_height-50];
                sendBtn.center = CGPointMake(x, y);
                [self.view addSubview:sendBtn];
            }
            break;
        }
        case 25://show like button
        {
            if(likeBtn) {
                [likeBtn removeFromSuperview];
                likeBtn = nil;
            } else {
                likeBtn = [[SDKFacade sharedInstance] getLikeButton:@"https://www.facebook.com/FacebookDevelopers"];
                float x = [self randomFloatBetween:50 andLargerFloat:Screen_width-50];
                float y = [self randomFloatBetween:50 andLargerFloat:Screen_height-50];
                likeBtn.center = CGPointMake(x, y);
                [self.view addSubview:likeBtn];
            }
            break;
        }
        case 26://Invite
            [[SDKFacade sharedInstance] invite];
            break;
        case 27://Fetch Friends
            [[SDKFacade sharedInstance] fetchFriends:NO];
            break;
        case 28://Fetch Friends
            [[SDKFacade sharedInstance] fetchFriends:YES];
            break;
        case 29://Me name
        {
            NSString *mename = [NSString stringWithFormat:@"%@ %@", [[SDKFacade sharedInstance] meLastName], [[SDKFacade sharedInstance] meFirstName]];
            [[SDKFacade sharedInstance] toast:mename isLongTime:YES];
            break;
        }
        case 30://Me picture
        {
            NSString *meurl = [[SDKFacade sharedInstance] mePictureURL];
            [[SDKFacade sharedInstance] toast:meurl isLongTime:YES];
            [[SDKFacade sharedInstance] cacheUrl:@"mePicture" url:meurl succes:^(NSString *tag, NSString *path){
                [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"download picture success : %@", path] isLongTime:YES];
                
                NSString *downpath = [[SDKFacade sharedInstance] cacheUrl:meurl];
                [[SDKFacade sharedInstance] toast:downpath isLongTime:YES];
                
            } failure:^(NSString *tag){
                [[SDKFacade sharedInstance] toast:@"download picture failure" isLongTime:YES];
            }];
            break;
        }
        case 31://Me Id
            [[SDKFacade sharedInstance] toast:[[SDKFacade sharedInstance] meId] isLongTime:YES];
            break;
            
        case 32://take screenshot
            [SDKHelper shareScreenshot:@"Screen Shot" url:[NSURL URLWithString:@"http://baidu.com"] completeHandler:^(BOOL success, NSError *error) {
                if(success) {
                    [[SDKFacade sharedInstance] toast:@"Share Success!" isLongTime:false];
                } else {
                    [[SDKFacade sharedInstance] toast:@"Share Failure!" isLongTime:false];
                }
            }];
            break;
            
        case 33://share screenshot
            [SDKHelper shareScreenshot:^(BOOL success, NSError *error) {
                if(success) {
                    [[SDKFacade sharedInstance] toast:@"Share Success!" isLongTime:false];
                } else {
                    [[SDKFacade sharedInstance] toast:@"Share Failure!" isLongTime:false];
                }
            }];
            break;
        case 34:
            [[SDKFacade sharedInstance] toast:([[SDKFacade sharedInstance] isPushRegistered] ? @"YES" : @"NO") isLongTime:YES];
            break;
        case 35:
            [[SDKFacade sharedInstance] registerPush];
            break;
        case 36:
            [[SDKFacade sharedInstance] resetGdpr];
            break;
        case 37:// Delicious Interstitial
        {
            [[SDKFacade sharedInstance] showDeliciousInterstitialAd:@"delicious"];
            break;
        }
        case 38:// Delicious Banner
        {
            float x = [self randomFloatBetween:0 andLargerFloat:100];
            float y = [self randomFloatBetween:0 andLargerFloat:500];
            float w = [self randomFloatBetween:250 andLargerFloat:300];
            float h = [self randomFloatBetween:60 andLargerFloat:100];
            [[SDKFacade sharedInstance] showDeliciousBannerAd:CGRectMake(x, y, w, h) configJson:@"delicious"];
            break;
        }
        case 39:// Close Delicious Banner
            [[SDKFacade sharedInstance] closeDeliciousBannerAd];
            break;
        case 40:// Delicious Icon
        {
            float x = [self randomFloatBetween:0 andLargerFloat:150];
            float y = [self randomFloatBetween:0 andLargerFloat:300];
            float w = [self randomFloatBetween:50 andLargerFloat:300];
            [[SDKFacade sharedInstance] showDeliciousIconAd:CGRectMake(x, y, w, w) configJson:@"delicious"];
            break;
        }
        case 41:// Close Delicious Icon
            [[SDKFacade sharedInstance] closeDeliciousIconAd];
            break;
        case 42:
            [[SDKFacade sharedInstance] pushLocalNotification:@"test" title:@"测试本地通知" msg:@"本地通知内容" pushTime:5 interval:SDK_INTERVAL_MINUTE repeat:YES useSound:YES soundName:nil userInfo:@{@"foo":@"bar"}];
            break;
        case 43:
            [[SDKFacade sharedInstance] cancelLocalNotification:@"test"];
            break;
        case 44: {
            //            [[SDKFacade sharedInstance] pushRepeatRemoteNotification:@"test1" title:@"test title" content:@"test content" pushTime:0 useLocalTimeZone:YES facebookIds:nil uuids:nil topic:nil iosBadge:3 useSound:YES soundName:nil extraData:@{@"hello":@"world!!"} repeatInterval:1];
            NSString *uuids = @"E5D73BE5-1E23-44F5-80E8-4BF8B54D95CC";
            [[SDKFacade sharedInstance] pushRemoteNotification:@"testkey" title:@"test title" content:@"test content" pushTime:0 useLocalTimeZone:YES facebookIds:nil uuids:uuids topic:nil iosBadge:3 useSound:YES soundName:nil extraData:@{@"hello":@"world!!"}];
            break;
        }
        case 45: {
            //            [[SDKFacade sharedInstance] cancelRepeatRemoteNotification:@"test1"];
            break;
        }
        case 46: {
            // send mail
            [[SDKFacade sharedInstance] sendMail:@"ice@ivymobile.com" subject:@"Hello World" content:@"Hello World!!!" isHTML:NO];
            break;
        }
        case 47: {
            // Start Recording
            [[SDKFacade sharedInstance] requestPhotoWritePermission:^(BOOL permit) {
                if (permit) {
                    [[SDKFacade sharedInstance] startRecording];
                } else {
                    [[SDKFacade sharedInstance] openSettingPage];
                }
            }];
            break;
        }
        case 48: {
            // Stop Recording
            [[SDKFacade sharedInstance] stopRecording:^(BOOL result) {
            }];
            break;
        }
        case 49: {
            // Share Recording
            [[SDKFacade sharedInstance] shareRecentRecordVideo:^(BOOL success, NSString * _Nullable error) {
                NSLog(@"share recording video success : %@", success ? @"true" : @"false");
            }];
            break;
        }
        case 50: {
            // Share Image
            [[SDKFacade sharedInstance] sharePhotos:@[@"bg.png"] result:^(BOOL success, NSString * _Nullable error) {

            }];
            break;
        }
        case 51: {
            // ShowPromotion
            [[SDKFacade sharedInstance] showPromotion:CGPointMake(200, 200)];
            break;
        }
        case 52:{
            [[SDKFacade sharedInstance] showWebView:@"http://10.0.0.56:3000/" frame:CGRectMake(20, 20, 600, 480) delegate:self];
            break;
        }
        case 53: {
            [[SDKFacade sharedInstance] closeWebView];
            break;
        }
        case 54: {
            [[SDKFacade sharedInstance] verifyIdCard:[[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID]];
            break;
        }
        case 55:{
            [[SDKFacade sharedInstance] resetVerifyIdCard];
            break;
        }
        case 56:{
            [[SDKFacade sharedInstance] showSignInWithApple:CGRectMake(50, 50, 200, 60) useBlackBackground:YES];
            break;
        }
        case 57:{
            [[SDKFacade sharedInstance] hideSignInWithApple];
            break;
        }
        case 58:{
            SDKStartPromotionAd *ad = [[SDKStartPromotionAd alloc] initWithData:[[SDKFacade sharedInstance] getConf:@"splash_promotion"]];
            if ([ad isValid]) {
                [ad show:^(NSString * _Nonnull appid) {
                    [EasyTextView showText:[NSString stringWithFormat:@"you clicked promotion ad:%@",appid]];
                }];
            }
            break;
        }
        case 59:
            break;
    }
}
- (void)initBtn:(int)idx title:(NSString *)title
{
    int w = Screen_width * 0.44f;
    int h = 50;
    BOOL isEven = idx % 2 == 0;
    double x = isEven ? 10 : Screen_width - w - 10;
    double y = (int)(idx / 2) * (h + 10);
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, w, h)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.backgroundColor = [UIColor lightGrayColor];

    btn.layer.cornerRadius = 6.0f;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(uiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizesSubviews = YES;
    [self.ScrollView addSubview:btn];
}

-(float)randomFloatBetween:(float)num1 andLargerFloat:(float)num2
{
    int startVal = num1*1000000;
    int endVal = num2*1000000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a / 1000000.0);
}

-(void)onPaymentSuccess:(int)billId
{
    [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"Pay success : %d", billId] isLongTime:NO];
}

-(void)onPaymentFailure:(int)billId forError:(NSString *)error
{
    [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"Pay failure : %@", error] isLongTime:NO];
}

-(void)onAppStorePayRequest:(int)paymentId
{
    [[SDKFacade sharedInstance] pay:paymentId];
}

-(void)onCheckSubscriptionResult:(int)billId remainSeconds:(long)seconds
{
    DLog(@"isSubscriptionActive %d : %ld", billId, seconds);
}

-(void)checkPurchased
{
    [[SDKFacade sharedInstance] isSubscriptionActive];
}

- (void)adLoaded:(NSString *)tag adType:(int)adType
{
    
}

- (void)adDidClick:(NSString *)tag adType:(int)adType
{
    
}

- (void)adDidShown:(NSString *)tag adType:(int)adType
{
    
}

- (void)adDidClose:(NSString *)tag adType:(int)adType
{
    
}

-(void)adReward:(NSString *)tag rewardId:(int)rewardId
{
    [[SDKFacade sharedInstance] toast:[NSString stringWithFormat:@"Get Reward : %@, rewardId : %d", tag, rewardId] isLongTime:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)snsLoginSuccess
{
    [[SDKFacade sharedInstance] toast:@"Facebook Login Success!" isLongTime:YES];
}

-(void)snsLoginCancel
{
    [[SDKFacade sharedInstance] toast:@"Facebook Login Cancel!" isLongTime:YES];
}

-(void)snsLoginFailure:(NSString *)error
{
    [[SDKFacade sharedInstance] toast:error isLongTime:YES];
}

-(void)snsReceiveInvitableFriends:(NSArray *)data
{
    NSString *msg = [SDKJSONHelper toJSONString:data];
    [[SDKFacade sharedInstance] toast:msg isLongTime:YES];
}

-(void)snsReceiveFriends:(NSArray *)data
{
    NSString *msg = [SDKJSONHelper toJSONString:data];
    [[SDKFacade sharedInstance] toast:msg isLongTime:YES];
}

-(void)onWebviewLoadFailure
{
    [[SDKFacade sharedInstance] toast:@"加载失败了！" isLongTime:YES];
}
-(void)onWebviewLoadSuccess
{
    [[SDKFacade sharedInstance] toast:@"加载成功了！" isLongTime:YES];
}
-(void)onWebviewClose
{
    [[SDKFacade sharedInstance] toast:@"WebView关闭了！" isLongTime:YES];
}
-(void)jsCallOC:(NSString *)param
{
    [[SDKFacade sharedInstance] toast:param isLongTime:YES];
}
@end
