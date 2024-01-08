//
//  SDKUnityVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKUnityInterstitial.h"
#import "SDKUnityInit.h"
@implementation SDKUnityInterstitial
{
@private
    UIView *_adView;
}
#pragma mark ================== Reward Video ===================

-(instancetype)init:(NSString *)tag index:(int)index config:(NSDictionary *)config size:(NSString *)size orientation:(SDK_ORIENTATION)orientation delegate:(id<SDKAdDelegate>)delegate
{
    self = [super init:tag index:index config:config size:size orientation:orientation delegate:delegate];
    _adId = _adId ? _adId : @"video";
    return self;
}

-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        if([UnityAds isInitialized]) {
            if (![self isAvailable]) {
                [UnityAds load:_adId loadDelegate:self];
            }
        } else {
            [[SDKUnityInit sharedInstance] addToLoadQueue:self];
        }
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]) {
        if (_adId) {
            [UnityAds show:vc placementId:_adId showDelegate:self];
        }
    } else {
        [self adShowFailed];
    }
}

- (void)unityAdsAdFailedToLoad:(nonnull NSString *)placementId withError:(UnityAdsLoadError)error withMessage:(nonnull NSString *)message {
    [self adFailed:message];
}

- (void)unityAdsAdLoaded:(nonnull NSString *)placementId {
    [self adLoaded];
}

- (void)unityAdsShowClick:(nonnull NSString *)placementId {
    [self adDidClick];
}

- (void)unityAdsShowComplete:(nonnull NSString *)placementId withFinishState:(UnityAdsShowCompletionState)state {
    [self adDidClose];
}

- (void)unityAdsShowFailed:(nonnull NSString *)placementId withError:(UnityAdsShowError)error withMessage:(nonnull NSString *)message {
    [self adShowFailed];
}

- (void)unityAdsShowStart:(nonnull NSString *)placementId {
    [self adDidShown];
}

@end
