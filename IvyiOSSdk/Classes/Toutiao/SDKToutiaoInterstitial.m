//
//  SDKFacebookInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKToutiaoInterstitial.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKToutiaoInterstitial
{
@private
    BUNativeExpressFullscreenVideoAd *_interstitialAd;
}
#pragma mark ================== Interstitial AD ===================

-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        _interstitialAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:_adId];
        _interstitialAd.delegate = self;
        [_interstitialAd loadAdData];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if ([self isAvailable]) {
        @try{
            [_interstitialAd showAdFromRootViewController:vc];
            [self startCheckShowFailedTimer];
        }@catch (NSException *exception) {
        }
    } else {
        [self adShowFailed];
    }
}

-(void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd
{
    [self adLoaded];
}

-(void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd
{
    [self adDidClose];
}

-(void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error
{
    if (error) {
        [self adShowFailed];
    }
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd
{
    [self adDidClick];
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd
{
    [self adDidShown];
}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *)error
{
    if (error) {
        [self adShowFailed];
    }
}
@end
