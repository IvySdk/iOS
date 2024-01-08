//
//  SDKFirebaseInit.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKVungleInit.h"
#import <IvyiOSSdk/SDKDefine.h>
#import <VungleSDK/VungleSDK.h>
@implementation SDKVungleInit
{
@private
    NSMutableDictionary <NSString *, SDKBaseAd *> *videos;
}
-(void)doInit:(NSDictionary *)data
{
    @try {
        _instance = self;
        videos = [[NSMutableDictionary alloc] init];
        NSString *appid = [data objectForKey:@"appid"];
        DLog(@"[adlog] [init] [vungle] [%@]", appid);
        if (![VungleSDK sharedSDK].isInitialized) {
            [[VungleSDK sharedSDK] startWithAppId:appid error:nil];
        }
        [[VungleSDK sharedSDK] setDelegate:self];
        [[VungleSDK sharedSDK] setLoggingEnabled:YES];
    } @catch (NSException *exception) {
        DLog(@"[adlog] %@", exception.description);
    } @finally {
    }
}

-(void)addVideo:(SDKBaseAd *)video placement:(NSString *)placement
{
    [videos setObject:video forKey:placement];
}

-(nullable SDKBaseAd *)getVideo:(nonnull NSString *)placement
{
    return [videos objectForKey:placement];
}

#pragma mark - VungleSDKDelegate Methods
-(void)vungleSDKDidInitialize
{
    DLog(@"%@", @"[adlog] vungle init success!");
}

-(void)vungleWillShowAdForPlacementID:(NSString *)placementID
{
    SDKBaseAd *ad = [self getVideo:placementID];
    if (ad) {
        [ad adDidShown];
    }
}

-(void)vungleSDKFailedToInitializeWithError:(NSError *)error
{
}

-(void)vungleDidCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID
{
    SDKBaseAd *ad = [self getVideo:placementID];
    if (ad) {
        if (info && info.didDownload) {
            [ad adDidClick];
        }
        [ad adDidClose];
    }
}

-(void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(NSString *)placementID error:(NSError *)error
{
    SDKBaseAd *ad = [self getVideo:placementID];
    if (ad) {
        if (isAdPlayable) {
            [ad adLoaded];
        } else {
            [ad adFailed:error.localizedDescription];
        }
    }
}

static SDKVungleInit *_instance;
+(instancetype)sharedInstance
{
    return _instance;
}
@end
