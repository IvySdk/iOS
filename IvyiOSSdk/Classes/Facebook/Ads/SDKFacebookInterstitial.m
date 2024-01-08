//
//  SDKFacebookInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKFacebookInterstitial.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKFacebookInterstitial
{
@private
    FBInterstitialAd *_interstitialAd;
}
#pragma mark ================== Interstitial AD ===================

-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        _interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:_adId];
        _interstitialAd.delegate = self;
        [_interstitialAd loadAd];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if (self.isAvailable) {
        @try{
            _interstitialAd.delegate = self;
            [_interstitialAd showAdFromRootViewController:vc];
            [self startCheckShowFailedTimer];
        }@catch (NSException *exception) {
        }
    } else {
        [self adShowFailed];
    }
}

-(void)adDidClose
{
    _interstitialAd = nil;
    [super adDidClose];
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    [self adLoaded];
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    [self adDidClose];
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

-(void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    [self adDidClick];
}

-(void)interstitialAdWillLogImpression:(FBInterstitialAd *)interstitialAd
{
    [self adDidShown];
}
@end
