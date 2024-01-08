//
//  SDKUmengAnalyse.m
//  Pods
//
//  Created by 余冰星 on 2017/8/8.
//
//

#import "SDKDouyinAnalyse.h"
#import <IvyiOSSdk/SDKHelper.h>
#import <LightGameSDK/LightGameSDK.h>
@implementation SDKDouyinAnalyse

-(void)setup:(nonnull NSDictionary *)conf
{
    DLog(@"[analyse] douyin analyse setup success.");
}

-(void)logPlayerLevel:(int)levelId
{
    DLog(@"[douyin] logPlayerLevel : %d", levelId);
    [LGCustomAutoTrack updateLevelEventWithLevel:levelId];
}
-(void)logPageStart:(nonnull NSString *)pageName
{
    DLog(@"[douyin] logPageStart : %@", pageName);
    [LightGameManager lg_event:@"pageStart" params:@{@"page":pageName}];
}
-(void)logPageEnd:(nonnull NSString *)pageName
{
    DLog(@"[douyin] logPageEnd : %@", pageName);
    [LightGameManager lg_event:@"pageEnd" params:@{@"page":pageName}];
}
-(void)logEvent:(nonnull NSString *)eventId allPlatform:(BOOL)allPlatform
{
    DLog(@"[douyin] logEvent : %@", eventId);
    [LightGameManager lg_event:eventId params:@{}];
}
- (void)logEvent:(NSString *)eventId action:(NSString *)action label:(NSString *)label value:(long)value allPlatform:(BOOL)allPlatform
{
    DLog(@"[douyin] logEvent : %@, %@, %@", eventId, action, label);
    [LightGameManager lg_event:eventId params:@{@"action": action ? action : @"null", @"label":label ? label : @"null", @"value":@(value)}];
}
-(void)logEvent:(nonnull NSString *)eventId action:(nullable NSString *)action allPlatform:(BOOL)allPlatform
{
    DLog(@"[douyin] logEvent : %@, %@", eventId, action);
    [LightGameManager lg_event:eventId params:@{@"action":action}];
}
-(void)logEvent:(NSString *)eventId withData:(NSDictionary<NSString *,id> *)data allPlatform:(BOOL)allPlatform
{
    DLog(@"[douyin] logEvent : %@", eventId);
    [LightGameManager lg_event:eventId params:data];
}
-(void)logEvent:(NSString *)eventId valueToSum:(double)value parameters:(nonnull NSDictionary *)parameters allPlatform:(BOOL)allPlatform
{
    DLog(@"[douyin] logEvent : %@", eventId);
    [LightGameManager lg_event:eventId params:parameters];
}

-(void)logStartLevel:(nonnull NSString *)level
{
    DLog(@"[douyin] logStartLevel : %@", level);
    [LightGameManager lg_event:@"startLevel" params:@{@"level":level}];
}
-(void)logFailLevel:(nonnull NSString *)level
{
    DLog(@"[douyin] logFailLevel : %@", level);
    [LightGameManager lg_event:@"failLevel" params:@{@"level":level}];
}
-(void)logFinishLevel:(nonnull NSString *)level
{
    DLog(@"[douyin] logFinishLevel : %@", level);
    [LightGameManager lg_event:@"finishLevel" params:@{@"level":level}];
}
-(void)logPay:(NSString *)payId price:(NSNumber *)price name:(NSString *)itemName number:(int)number currency:(NSString *)currency
{
    DLog(@"[douyin] logPay : %@", payId);
    [LGCustomAutoTrack purchaseEventWithContentType:@"gold" contentName:itemName contentID:payId contentNumber:number paymentChannel:@"appstore" currency:currency currency_amount:[price longLongValue] isSuccess:YES];
}
-(void)logBuy:(nonnull NSString *)itemName itemType:(nonnull NSString *)itemType count:(int)count price:(double)price
{
    DLog(@"[douyin] logBuy : %@", itemName);
    [LightGameManager lg_event:@"bug" params:@{@"name":itemName, @"number":@(count), @"price":@(price)}];
}
-(void)logUse:(nonnull NSString *)itemName number:(int)number price:(double)price
{
    DLog(@"[douyin] logUse : %@", itemName);
    [LightGameManager lg_event:@"use" params:@{@"name":itemName, @"number":@(number), @"price":@(price)}];
}
-(void)logBonus:(nonnull NSString *)itemName number:(int)number price:(double)price trigger:(int)trigger
{
    DLog(@"[douyin] logBonus : %@", itemName);
    [LightGameManager lg_event:@"bonus" params:@{@"name":itemName, @"number":@(number), @"price":@(price)}];
}

@end
