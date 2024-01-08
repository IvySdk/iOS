//
//  SDKDouyinInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKDouyinInterstitial.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKDouyinInterstitial
{
@private
    LGFullScreenVideoAd *_interstitialAd;
}
#pragma mark ================== Interstitial AD ===================

-(BOOL)loadAd
{
    if([super loadAd]) {
        _interstitialAd = [[LGFullScreenVideoAd alloc] initWithSlotID:_adId];
        _interstitialAd.delegate = self;
        [_interstitialAd loadAdData];
        return true;
    }
    return false;
}

-(BOOL)isAvailable
{
    [super setIsAvailable:_interstitialAd && _interstitialAd.isAdValid];
    return [super isAvailable];
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

-(void)fullscreenVideoAdVideoDataDidLoad:(LGFullScreenVideoAd *)fullscreenVideoAd
{
    [self adLoaded];
}

-(void)fullscreenVideoAdDidClose:(LGFullScreenVideoAd *)fullscreenVideoAd
{
    [self adDidClose];
}

-(void)fullscreenVideoAd:(LGFullScreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

-(void)fullscreenVideoAdDidPlayFinish:(LGFullScreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error
{
    if (error) {
        [self adShowFailed];
    }
}

-(void)fullscreenVideoAdDidClick:(LGFullScreenVideoAd *)fullscreenVideoAd
{
    [self adDidClick];
}

-(void)fullscreenVideoAdDidVisible:(LGFullScreenVideoAd *)fullscreenVideoAd
{
    [self adDidShown];
}
@end
