//
//  SDKFirebaseCore.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKToutiaoInit.h"
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKDefine.h>
#import <TTTracker/TTTracker.h>
#import <TTTracker/TTABTestConfFetcher.h>


@implementation SDKToutiaoInit
{
    @private
    NSDictionary *_defaultRemoteConfig;
}
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    @try {
        NSString *appid = [data objectForKey:@"appid"];
        NSString *openAd = [data objectForKey:@"openad"];
        DLog(@"[adlog] [init] [toutiao] [%@]", appid);
        if (appid) {
            [BUAdSDKManager setAppID:appid];
//            [BUAdSDKManager setIsPaidApp:isPad];
            [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
            if (openAd) {
                 UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
                CGRect frame = [UIScreen mainScreen].bounds;
                BUSplashAd *_splashAd = [[BUSplashAd alloc] initWithSlotID:openAd adSize:frame.size];
                _splashAd.delegate = self;
                [_splashAd loadAdData];
                if (onComplete) {
                    onComplete();
                }
            }
        } else {
            @throw [NSException exceptionWithName:@"No toutiao-appid" reason:@"not configure toutiao-appid, please check your default.json!" userInfo:nil];
        }
        
        NSString *aid = [data objectForKey:@"aid"];
        NSString *name = [data objectForKey:@"name"];
        NSString *channel = [data objectForKey:@"channel"];
        if(aid) {
            [[TTTracker sharedInstance] setConfigParamsBlock:^(void) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"useruniqueid"];
                [params setValue:@(YES) forKey:@"needencrypt"];
                return [params copy];
            }];
            // 关闭全渠道上传数据，只上传头条渠道数据
            [[TTTracker sharedInstance] setSessionEnable:YES];
            channel = channel ? channel : @"App Store";
#if DEBUG
            channel = @"localtest";
#endif
            [TTTracker startWithAppID:aid channel:channel appName:name];
            DLog(@"[analyse] Toutiao analyse setup success.");
        } else {
            DLog(@"[analyse] Toutiao analyse setup failure, please see the default.json analyse config.");
        }
        
        [[TTABTestConfFetcher sharedInstance] startFetchABTestConf:^(NSDictionary *allConfigs) {
        }];
        NSString *abTestVersion = [data objectForKey:@"abtestversion"];
        if (abTestVersion) {
            [[TTABTestConfFetcher sharedInstance] setServerVersions:abTestVersion];
        }
    } @catch (NSException *exception) {
        DLog(@"[toutiao]: %@", exception.description);
    } @finally {
    }
}

-(void)splashAdLoadSuccess:(BUSplashAd *)splashAd
{
    DLog(@"[toutiao] openad did load");
    [[SDKFacade sharedInstance] logEvent:@"openad_loaded"];
}

-(void)splashAdDidClick:(BUSplashAd *)splashAd
{
    DLog(@"[toutiao] openad did click");
    if (splashAd) {
        [splashAd removeSplashView];
    }
    [[SDKFacade sharedInstance] logEvent:@"openad_click"];
}

-(void)splashDidCloseOtherController:(BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType
{
    if (splashAd) {
        [splashAd removeSplashView];
    }
}

-(void)splashAdDidShow:(BUSplashAd *)splashAd
{
    DLog(@"[toutiao] openad did shown");
    [[SDKFacade sharedInstance] logEvent:@"openad_show"];
}

-(void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType
{
    DLog(@"[toutiao] openad did close");
}

-(void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *)error
{
    DLog(@"[toutiao] openad did failed : %@", error.localizedDescription);
    if (splashAd) {
        [splashAd removeSplashView];
    }
    [[SDKFacade sharedInstance] logEvent:@"openad_failed" withData:@{@"error":[error localizedDescription]}];
}

-(void)splashVideoAdDidPlayFinish:(BUSplashAd *)splashAd didFailWithError:(NSError *)error
{
    if (splashAd) {
        [splashAd removeSplashView];
    }
}

-(void)splashAdRenderFail:(BUSplashAd *)splashAd error:(BUAdError *)error
{
    DLog(@"[toutiao] openad render failed : %@", error.localizedDescription);
    if (splashAd) {
        [splashAd removeSplashView];
    }
}


#pragma mark --------------- Remote Config ----------------
-(void)setDefaults:(nullable NSDictionary *)data
{
    _defaultRemoteConfig = data;
}
-(id)getDefaultValue:(NSString *)key valueClass:(Class)valueClass
{
    id value = nil;
    if (_defaultRemoteConfig) {
        value = [_defaultRemoteConfig objectForKey:key];
    }
    if (!value) {
        if ([valueClass isEqual:NSNumber.class]) {
            value = @(0);
        } else if ([valueClass isEqual:NSString.class]) {
            value = @"";
        }
    }
    return value;
}

-(int)getRemoteConfigIntValue:(nonnull NSString *)key
{
    NSNumber *result = [[TTABTestConfFetcher sharedInstance] getConfig:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.intValue;
}
-(long)getRemoteConfigLongValue:(nonnull NSString *)key
{
    NSNumber *result = [[TTABTestConfFetcher sharedInstance] getConfig:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.longValue;
}
-(double)getRemoteConfigDoubleValue:(nonnull NSString *)key
{
    NSNumber *result = [[TTABTestConfFetcher sharedInstance] getConfig:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.doubleValue;
}
-(BOOL)getRemoteConfigBoolValue:(nonnull NSString *)key
{
    NSNumber *result = [[TTABTestConfFetcher sharedInstance] getConfig:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.boolValue;
}
-(nonnull NSString *)getRemoteConfigStringValue:(nonnull NSString *)key
{
    NSString *result = [[TTABTestConfFetcher sharedInstance] getConfig:key defaultValue:[self getDefaultValue:key valueClass:NSString.class]];
    return result;
}
-(void)setUserPropertyString:(nonnull NSString *)value forName:(nonnull NSString *)key
{
}

- (nonnull NSSet *)remoteConfigKeysWithPrefix:(nullable NSString *)prefix {
    NSDictionary *_data = [[TTABTestConfFetcher sharedInstance] allConfigs];
    NSMutableSet *keys = [[NSMutableSet alloc] init];
    if (_data) {
        NSArray *allKeys = [_data allKeys];
        if (!prefix.length) {
            keys = [NSMutableSet setWithArray:allKeys];
        } else {
            for (NSString *key in allKeys) {
                if ([key hasPrefix:prefix]) {
                    [keys addObject:key];
                }
            }
        }
    }
    return [keys copy];
}

@end
