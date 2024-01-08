//
//  SDKUnityInit.m
//  Bolts
//
//  Created by 余冰星 on 2019/5/5.
//

#import "SDKUnityInit.h"
#import <IvyiOSSdk/SDKVideo.h>
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKUnityInit
{
    @private
    NSMutableArray<SDKBaseAd *> *_loadQueue;
    dispatch_block_t _onComplete;
}
static SDKUnityInit *_instance;
+(instancetype)sharedInstance
{
    return _instance;
}
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    _instance = self;
    NSString *appId = [data objectForKey:@"appid"];
    _loadQueue = [[NSMutableArray alloc] init];
    DLog(@"[adlog] [init] [unity] [%@]", appId);
//    [UnityAds addDelegate:self];
//    [UnityAds initialize:appId testMode:NO enablePerPlacementLoad:YES];
    [UnityAds initialize:appId testMode:NO initializationDelegate:self];
    _onComplete = onComplete;
}

- (void)initializationComplete {
    DLog(@"[adlog] - [unity] [initComplete]");
    for (SDKBaseAd *ad in _loadQueue) {
        [ad loadAd:[[SDKFacade sharedInstance] rootVC]];
    }
    [_loadQueue removeAllObjects];
    if (_onComplete) {
        _onComplete();
        _onComplete = nil;
    }
}

- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(nonnull NSString *)message {
}


-(void)addToLoadQueue:(nonnull SDKBaseAd *)ad
{
    if (![_loadQueue containsObject:ad]) {
        [_loadQueue addObject:ad];
    }
}

//-(void)setBanner:(nonnull SDKBaseBanner *)ad placement:(nonnull NSString *)placement
//{
//    [adBannerMap setObject:ad forKey:placement];
//}

//- (void)unityAdsReady:(NSString *)placementId
//{
//}
//
//- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message
//{
//    if (adMap.count > 0) {
//        for (SDKBaseAd *ad in [adMap allValues]) {
//            if (error != kUnityAdsErrorShowError) {
//                [ad adFailed:message];
//            }
//        }
//    }
//}
//
//- (void)unityAdsDidStart:(NSString *)placementId
//{
//    SDKBaseAd *ad = [adMap objectForKey:placementId];
//    if (ad) {
//        [ad adDidShown];
//    }
//}
//
//- (void)unityAdsDidClick:(NSString *)placementId
//{
//    SDKBaseAd *ad = [adMap objectForKey:placementId];
//    if (ad) {
//        [ad adDidClick];
//    }
//}
//
//- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state
//{
//    SDKBaseAd *ad = [adMap objectForKey:placementId];
//    if (ad) {
//        switch (state) {
//            case kUnityAdsFinishStateError:
//                [ad adShowFailed];
//                break;
//
//            default:
////                if (ad.adType == SDK_ADTYPE_VIDEO) {
////                    [(SDKVideo *)ad adReward];
////                }
//                break;
//        }
//        [ad adDidClose];
//    }
//}
//
//- (void)unityAdsPlacementStateChanged:(NSString *)placementId oldState:(UnityAdsPlacementState)oldState newState:(UnityAdsPlacementState)newState
//{
//    SDKBaseAd *ad = [adMap objectForKey:placementId];
//    if (ad) {
//        switch (newState) {
//            case kUnityAdsPlacementStateReady:
//                [ad adLoaded];
//                break;
//            case kUnityAdsPlacementStateNoFill:
//                [ad adFailed:@"no fill"];
//                break;
//            case kUnityAdsPlacementStateDisabled:
//                [ad adFailed:@"disabled"];
//                break;
//            case kUnityAdsPlacementStateNotAvailable:
//                [ad adFailed:@"not available"];
//                break;
//            default:
//                break;
//        }
//    }
//}
@end
