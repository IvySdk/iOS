//
//  SDKUmengAnalyse.m
//  Pods
//
//  Created by 余冰星 on 2017/8/8.
//
//

#import "SDKToutiaoAnalyse.h"
#import <IvyiOSSdk/SDKConstants.h>
#import <IvyiOSSdk/SDKHelper.h>
#import <TTTracker/TTTracker.h>
//#import <TTTracker/TTTracker+Game.h>
#import <RangersAppLog/RangersAppLog.h>

#import "BDAutoTrack.h"
#import "BDAutoTrack+Game.h"

@implementation SDKToutiaoAnalyse
{
    @private
    NSString *appLogAppId;
    NSString *appLogName;
    NSString *appLogChannel;
}

-(void)setup:(nonnull NSDictionary *)conf
{
    _platform = SDK_ANALYSE_TOUTIAO;
    DLog(@"[analyse] init toutiao success");
    
    /* 初始化开始 */
    BDAutoTrackConfig *config = [BDAutoTrackConfig new];

    /* 域名默认国内: BDAutoTrackServiceVendorCN,
         新加坡: BDAutoTrackServiceVendorSG,
         美东:BDAutoTrackServiceVendorVA,
         注意：国内外不同vendor服务注册的did不一样。由CN切换到SG或者VA，会发生变化，切回来也会发生变化。因此vendor的切换一定要慎重，随意切换导致用户新增和统计的问题，需要自行评估*/
    // config.serviceVendor = BDAutoTrackServiceVendorCN;

    appLogAppId = [conf objectForKey:@"applog.appId"];
    appLogName = [conf objectForKey:@"applog.appName"];
    appLogChannel = [conf objectForKey:@"applog.channel"];
    
    if (appLogAppId && appLogName && appLogChannel) {
        config.appID = appLogAppId; // 广告后台申请，工具-转化跟踪-跟踪应用-使用sdk
        config.appName = appLogName; // 与您申请app ID时的app_name一致
        config.channel = appLogChannel; // iOS一般默认App Store
            
        config.showDebugLog = NO; // 是否在控制台输出日志，仅调试使用。release版本请设置为 NO
        config.logNeedEncrypt = YES; // 是否加密日志，默认加密。release版本请设置为 YES
        config.gameModeEnable = YES;

        [BDAutoTrack startTrackWithConfig:config];
    }
}

-(void)logPlayerLevel:(int)levelId
{
    DLog(@"[toutiao] logPlayerLevel : %d", levelId);
    
    if(appLogAppId) {
        [BDAutoTrack updateLevelEventWithLevel:levelId];
    }

}

-(void)logPageStart:(nonnull NSString *)pageName
{
    DLog(@"[toutiao] logPageStart : %@", pageName);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"pageStart" params:@{@"page":pageName}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"pageStart" params:@{@"page":pageName}];
    }
}

-(void)logPageEnd:(nonnull NSString *)pageName
{
    DLog(@"[toutiao] logPageEnd : %@", pageName);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"pageEnd" params:@{@"page":pageName}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"pageEnd" params:@{@"page":pageName}];
    }
}
-(void)logEvent:(nonnull NSString *)eventId
{
    DLog(@"[toutiao] logEvent : %@", eventId);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:eventId params:nil];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:eventId params:nil];
    }
}
- (void)logEvent:(NSString *)eventId action:(NSString *)action label:(NSString *)label value:(long)value
{
    DLog(@"[toutiao] logEvent : %@, %@, %@", eventId, action, label);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:eventId params:@{@"action": action ? action : @"null", @"label":label ? label : @"null", @"value":@(value)}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:eventId params:@{@"action": action ? action : @"null", @"label":label ? label : @"null", @"value":@(value)}];
    }
}
-(void)logEvent:(nonnull NSString *)eventId action:(nullable NSString *)action
{
    DLog(@"[toutiao] logEvent : %@, %@", eventId, action);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:eventId params:@{@"action":action}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:eventId params:@{@"action":action}];
    }
}
-(void)logEvent:(NSString *)eventId withData:(NSDictionary<NSString *,id> *)data
{
    DLog(@"[toutiao] logEvent : %@", eventId);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:eventId params:data];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:eventId params:data];
    }
}
-(void)logEvent:(NSString *)eventId valueToSum:(double)value parameters:(nonnull NSDictionary *)parameters
{
    DLog(@"[toutiao] logEvent : %@", eventId);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:eventId params:parameters];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:eventId params:parameters];
    }
}
-(void)logStartLevel:(nonnull NSString *)level
{
    DLog(@"[toutiao] logStartLevel : %@", level);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"startLevel" params:@{@"level":level}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"startLevel" params:@{@"level":level}];
    }
}
-(void)logFailLevel:(nonnull NSString *)level
{
    DLog(@"[toutiao] logFailLevel : %@", level);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"failLevel" params:@{@"level":level}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"failLevel" params:@{@"level":level}];
    }
}
-(void)logFinishLevel:(nonnull NSString *)level
{
    DLog(@"[toutiao] logFinishLevel : %@", level);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"finishLevel" params:@{@"level":level}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"finishLevel" params:@{@"level":level}];
    }
}
-(void)logPay:(NSString *)payId price:(NSNumber *)price name:(NSString *)itemName number:(int)number currency:(NSString *)currency
{
    DLog(@"[toutiao] logPay : %@", payId);

    if(appLogAppId) {
        // 内置事件 “购买道具”，属性：道具类型，道具名称，道具ID， 道具数量，支付渠道，币种，金额（必传），是否成功（必传）
        [BDAutoTrack purchaseEventWithContentType:@"gold"
                                      contentName:itemName
                                        contentID:payId
                                    contentNumber:number
                                   paymentChannel:@"appstore"
                                         currency:currency
                                  currency_amount:[price longLongValue]
                                        isSuccess:YES];
    }
}
-(void)logBuy:(nonnull NSString *)itemName itemType:(nonnull NSString *)itemType count:(int)count price:(double)price
{
    DLog(@"[toutiao] logBuy : %@", itemName);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"buy" params:@{@"name":itemName, @"number":@(count), @"price":@(price)}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"buy" params:@{@"name":itemName, @"number":@(count), @"price":@(price)}];
    }
}
-(void)logUse:(nonnull NSString *)itemName number:(int)number price:(double)price
{
    DLog(@"[toutiao] logUse : %@", itemName);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"use" params:@{@"name":itemName, @"number":@(number), @"price":@(price)}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"use" params:@{@"name":itemName, @"number":@(number), @"price":@(price)}];
    }
}
-(void)logBonus:(nonnull NSString *)itemName number:(int)number price:(double)price trigger:(int)trigger
{
    DLog(@"[toutiao] logBonus : %@", itemName);
    if([TTTracker sharedInstance].appID) {
        [TTTracker eventV3:@"bonus" params:@{@"name":itemName, @"number":@(number), @"price":@(price)}];
    }
    if(appLogAppId) {
        [BDAutoTrack eventV3:@"bonus" params:@{@"name":itemName, @"number":@(number), @"price":@(price)}];
    }
}

-(void)logRegister:(nonnull NSString*) provider
{
    if(appLogAppId) {
        [BDAutoTrack registerEventByMethod:provider isSuccess:YES];
    }
}

@end
