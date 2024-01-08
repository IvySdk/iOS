//
//  SDKUmengAnalyse.m
//  Pods
//
//  Created by 余冰星 on 2017/8/8.
//
//

#import "SDKUmengAnalyse.h"
#import <IvyiOSSdk/SDKConstants.h>
#import <UMMobClick/MobClick.h>
#import <UMMobClick/MobClickGameAnalytics.h>
@implementation SDKUmengAnalyse
{
    @private
    BOOL hasInit;
}

-(void)setup:(nonnull NSDictionary *)conf
{
    _platform = SDK_ANALYSE_UMENG;
    NSString *key = [conf valueForKey:@"key"];
    NSString *channel = [conf valueForKey:@"channel"];
    NSString *type = [conf valueForKey:@"type"];
    if(key) {
        UMConfigInstance.appKey = key;
        if(channel)
            UMConfigInstance.channelId = channel;
        
        UMConfigInstance.eSType = type && [[type lowercaseString] isEqualToString:@"game"] ? E_UM_GAME : E_UM_NORMAL;
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];
        [MobClick startWithConfigure:UMConfigInstance];
        [MobClick setEncryptEnabled:true];
        hasInit = YES;
        DLog(@"[analyse] init umeng success");
    } else {
        DLog(@"[analyse] UMeng analyse setup failure, please see the default.json analyse config.");
    }
}

-(void)logPlayerLevel:(int)levelId
{
    if(hasInit) {
        [MobClickGameAnalytics setUserLevelId:levelId];
    }
}
-(void)logPageStart:(nonnull NSString *)pageName
{
    if(hasInit) {
        [MobClick beginLogPageView:pageName];
    }
}
-(void)logPageEnd:(nonnull NSString *)pageName
{
    if(hasInit) {
        [MobClick endLogPageView:pageName];
    }
}
-(void)logEvent:(nonnull NSString *)eventId
{
    if(hasInit) {
        [MobClick event:eventId];
    }
}
- (void)logEvent:(NSString *)eventId action:(NSString *)action label:(NSString *)label value:(long)value
{
    if(hasInit) {
        [self logEvent:eventId valueToSum:value parameters:@{@"action": action ? action : @"null", @"label":label ? label : @"null", @"value":@(value)}];
    }
}
-(void)logEvent:(nonnull NSString *)eventId action:(nullable NSString *)action
{
    [MobClick event:eventId label:action];
}
-(void)logEvent:(NSString *)eventId withData:(NSDictionary<NSString *,id> *)data
{
    [MobClick event:eventId attributes:data];
}
-(void)logEvent:(NSString *)eventId valueToSum:(double)value parameters:(nonnull NSDictionary *)parameters
{
    [MobClick event:eventId attributes:parameters counter:value];
}
-(void)logStartLevel:(nonnull NSString *)level
{
    [MobClickGameAnalytics startLevel:level];
}
-(void)logFailLevel:(nonnull NSString *)level
{
    if(hasInit) {
        [MobClickGameAnalytics failLevel:level];
    }
}
-(void)logFinishLevel:(nonnull NSString *)level
{
    if(hasInit) {
        [MobClickGameAnalytics finishLevel:level];
    }
}
-(void)logPay:(NSString *)payId price:(NSNumber *)price name:(NSString *)itemName number:(int)number currency:(NSString *)currency
{
    if(hasInit) {
        if (UMConfigInstance.eSType == E_UM_NORMAL) {
            NSDictionary *data = @{@"revenue":price, @"itemid":itemName, @"number":[NSNumber numberWithInt:number], @"currency":currency, @"payId":payId};
            [MobClick event:@"in_app_purchase" attributes:data];
        } else {
            [MobClickGameAnalytics pay:price.doubleValue source:1 item:payId amount:number price:price.doubleValue];
        }
    }
}
-(void)logBuy:(nonnull NSString *)itemName itemType:(nonnull NSString *)itemType count:(int)count price:(double)price
{
    if(hasInit) {
        [MobClickGameAnalytics buy:itemName amount:count price:price];
    }
}
-(void)logUse:(nonnull NSString *)itemName number:(int)number price:(double)price
{
    if(hasInit) {
        [MobClickGameAnalytics use:itemName amount:number price:price];
    }
}
-(void)logBonus:(nonnull NSString *)itemName number:(int)number price:(double)price trigger:(int)trigger
{
    if(hasInit) {
        [MobClickGameAnalytics bonus:itemName amount:number price:price source:trigger];
    }
}

@end
