//
//  SDKGameAnalyse.m
//  Pods
//
//  Created by 余冰星 on 2017/8/8.
//
//

#import "SDKGameAnalyse.h"
#import <IvyiOSSdk/SDKJSONHelper.h>
@implementation SDKGameAnalyse

-(void)setup:(nonnull NSDictionary *)conf
{
    NSString *key = [conf valueForKey:@"key"];
    NSString *secret = [conf valueForKey:@"secret"];
    if(key && secret) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [GameAnalytics configureBuild:version];
        // Initialize
        [GameAnalytics initializeWithGameKey:key gameSecret:secret];
#if DEBUG
        [GameAnalytics setEnabledInfoLog:YES];
        [GameAnalytics setEnabledVerboseLog:YES];
#else
        [GameAnalytics setEnabledInfoLog:NO];
        [GameAnalytics setEnabledVerboseLog:NO];
#endif
        DLog(@"[analyse] GameAnalytics init success, key = %@, secret = %@", key, secret);
    } else {
        DLog(@"[analyse] GameAnalytics init failure, please see the default.json analyse config.");
    }
}

-(BOOL)canLogEvent
{
    return false;
}

-(void)logPlayerLevel:(int)levelId
{
    [GameAnalytics addDesignEventWithEventId:@"playerLevel" value:@(levelId)];
}
    
-(void)logEvent:(nonnull NSString *)eventId
{
    [GameAnalytics addDesignEventWithEventId:eventId];
}

- (void)logEvent:(NSString *)eventId action:(NSString *)action label:(NSString *)label value:(long)value
{
    [self logEvent:eventId valueToSum:value parameters:@{@"action": action ? action : @"null", @"label":label ? label : @"null", @"value":@(value)}];
}
    
-(void)logEvent:(nonnull NSString *)eventId action:(nullable NSString *)action
{
    [GameAnalytics addDesignEventWithEventId:[NSString stringWithFormat:@"%@:%@", eventId, action]];
}
    
-(void)logEvent:(NSString *)eventId withData:(NSDictionary<NSString *,id> *)data
{
    if(data) {
        eventId = [NSString stringWithFormat:@"%@:%@", eventId, [[data allValues] componentsJoinedByString:@":"]];
    }
    [GameAnalytics addDesignEventWithEventId:eventId];
}
    
-(void)logEvent:(NSString *)eventId valueToSum:(double)value parameters:(nonnull NSDictionary *)parameters
{
    if(parameters) {
        eventId = [NSString stringWithFormat:@"%@:%@", eventId, [[parameters allValues] componentsJoinedByString:@":"]];
    }
    [GameAnalytics addDesignEventWithEventId:eventId value:@(value)];
}
    
-(void)logPageStart:(nonnull NSString *)pageName
{
    [self logEvent:@"pageStart" action:pageName];
}
    
-(void)logPageEnd:(nonnull NSString *)pageName
{
    [self logEvent:@"pageEnd" action:pageName];
}

-(void)logStartLevel:(nonnull NSString *)world stage:(nullable NSString *)stage level:(nullable NSString *)level score:(int)score
{
    [GameAnalytics addProgressionEventWithProgressionStatus:GAProgressionStatusStart progression01:world progression02:stage progression03:level score:score];
}
    
-(void)logFailLevel:(nonnull NSString *)world stage:(nullable NSString *)stage level:(nullable NSString *)level score:(int)score
{
    [GameAnalytics addProgressionEventWithProgressionStatus:GAProgressionStatusFail progression01:world progression02:stage progression03:level score:score];
}
    
-(void)logFinishLevel:(nonnull NSString *)world stage:(nullable NSString *)stage level:(nullable NSString *)level score:(int)score
{
    [GameAnalytics addProgressionEventWithProgressionStatus:GAProgressionStatusComplete progression01:world progression02:stage progression03:level score:score];
}
    
-(void)logPay:(double)money name:(NSString *)itemName number:(int)number currency:(NSString *)currency
{
    [GameAnalytics addBusinessEventWithCurrency:currency amount:number itemType:@"goods" itemId:itemName cartType:@"goods" autoFetchReceipt: YES];
}
    
-(void)logBuy:(nonnull NSString *)itemName itemType:(nonnull NSString *)itemType count:(int)count price:(double)price
{
    [GameAnalytics addResourceEventWithFlowType:GAResourceFlowTypeSink currency:@"Gems" amount:@(price) itemType:itemType itemId:itemName];
}

-(void)logUse:(NSString *)itemName number:(int)number price:(double)price
{
    [self logEvent:@"use" valueToSum:number parameters:@{@"itemName": itemName, @"price": [@(price) stringValue]}];
}

-(void)logBonus:(NSString *)itemName number:(int)number price:(double)price trigger:(int)trigger
{
    [self logEvent:@"bonus" valueToSum:number parameters:@{@"itemName": itemName, @"price": [@(price) stringValue]}];
}
@end
