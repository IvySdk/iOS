//
//  SDKGoogleAnalyse.m
//  Pods
//
//  Created by 余冰星 on 2017/8/8.
//
//

#import "SDKGoogleAnalyse.h"
#import <IvyiOSSdk/SDKJSONHelper.h>
#import <IvyiOSSdk/SDKConstants.h>
#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
@implementation SDKGoogleAnalyse
{
    @private
    id<GAITracker> tracker;
}
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 30;

-(void)setup:(nonnull NSDictionary *)conf
{
    _platform = SDK_ANALYSE_GA;
    NSString *key = [conf valueForKey:@"key"];
    if(key) {
        // Optional: configure GAI options.
        GAI *gai = [GAI sharedInstance];
        gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
#ifdef DEBUG
        gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
#endif
        [gai setDispatchInterval:kGaDispatchPeriod];
        [gai setDryRun:kGaDryRun];
        tracker = [gai trackerWithTrackingId:key];
//        tracker.allowIDFACollection = YES;
        DLog(@"[analyse] init GA success, id = %@", key);
    } else {
        DLog(@"[analyse] GA init failure, [id:%@] please see the default.json analyse config.", key);
    }
}

-(void)logPlayerLevel:(int)levelId
{
    [self logEvent:@"playerLevel" withData:@{@"level": @(levelId)}];
}

-(void)logPageStart:(nonnull NSString *)pageName
{
    [self logEvent:@"pageStart" withData:@{@"page": pageName}];
    [tracker set:kGAIScreenName value:pageName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}
-(void)logPageEnd:(nonnull NSString *)pageName
{
    [self logEvent:@"pageEnd" withData:@{@"page": pageName}];
}
-(void)logEvent:(nonnull NSString *)eventId
{
    if(tracker) {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventId action:nil label:nil value:nil] build]];
    }
}
- (void)logEvent:(NSString *)eventId action:(NSString *)action label:(NSString *)label value:(long)value
{
    if (tracker) {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventId action:action label:label value:[NSNumber numberWithLong:value]] build]];
    }
}
-(void)logEvent:(nonnull NSString *)eventId action:(nullable NSString *)action
{
    if(tracker) {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventId action:action label:nil value:nil] build]];
    }
}
-(void)logEvent:(NSString *)eventId withData:(NSDictionary<NSString *,id> *)data
{
    if(tracker) {
        NSString *action = nil;
        if (data) {
            action = [SDKJSONHelper toJSONString:data];
        }
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventId action:action label:nil value:nil] build]];
    }
}
-(void)logEvent:(NSString *)eventId valueToSum:(double)value parameters:(nonnull NSDictionary *)parameters
{
    if(tracker) {
        NSString *action = nil;
        if (parameters) {
            action = [SDKJSONHelper toJSONString:parameters];
        }
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventId action:action label:nil value:[NSNumber numberWithDouble:value]] build]];
    }
}

-(void)logStartLevel:(nonnull NSString *)level
{
    [self logEvent:@"startLevel" withData:@{@"level": level}];
}

-(void)logFailLevel:(nonnull NSString *)level
{
    [self logEvent:@"failLevel" withData:@{@"level": level}];
}

-(void)logFinishLevel:(nonnull NSString *)level
{
    [self logEvent:@"finishLevel" withData:@{@"level": level}];
}

-(void)logPay:(NSString *)payId price:(NSNumber *)price name:(NSString *)itemName number:(int)number currency:(NSString *)currency
{
    if(tracker) {
        [self logEvent:@"purchase" action:payId label:currency value:price.doubleValue];
    }
}
-(void)logBuy:(NSString *)itemName itemType:(NSString *)itemType count:(int)count price:(double)price
{
    if(tracker) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:itemName forKey:@"itemName"];
        [data setObject:itemType forKey:@"itemType"];
        [data setObject:[NSNumber numberWithDouble:price] forKey:@"price"];
        [self logEvent:@"buy" valueToSum:count parameters:data];
    }
}
-(void)logUse:(nonnull NSString *)itemName number:(int)number price:(double)price
{
    if(tracker) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if(itemName)
            [data setObject:itemName forKey:@"itemName"];
        [data setObject:[NSNumber numberWithDouble:price] forKey:@"price"];
        [self logEvent:@"use" valueToSum:number parameters:data];
    }
}
-(void)logBonus:(nonnull NSString *)itemName number:(int)number price:(double)price trigger:(int)trigger
{
    if(tracker) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if(itemName)
            [data setObject:itemName forKey:@"itemName"];
        [data setObject:[NSNumber numberWithDouble:price] forKey:@"price"];
        [self logEvent:@"bonus" valueToSum:number parameters:data];
    }
}

@end
