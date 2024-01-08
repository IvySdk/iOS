//
//  SDKDfpInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKDfpInterstitial.h"
#import "SDKDfpRequest.h"
#import <IvyiOSSdk/SDKTimer.h>
#import <GoogleMobileAds/GAMInterstitialAd.h>
#import <GoogleMobileAds/GAMRequest.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKHelper.h>
@implementation SDKDfpInterstitial
{
@private
  GAMInterstitialAd *_interstitialAd;
}
#pragma mark ================== Interstitial AD ===================

-(BOOL)loadAd:(UIViewController *)vc
{
#if DEBUG
//    _adId = @"/6499/example/interstitial";
#endif
    if ([super loadAd:vc]) {
        GAMRequest *request = [GAMRequest request];
        [GAMInterstitialAd loadWithAdManagerAdUnitID:_adId request:request completionHandler:^(GAMInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
            if (error) {
                DLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
                
                [self adFailed:[error description]];
                DLog(@"[adlog] [tag:%@(%d)] [%@:adFailed] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, interstitialAd.responseInfo.loadedAdNetworkResponseInfo?interstitialAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName:@"admob");
                return;
            }
            self->_interstitialAd = interstitialAd;
            self->_interstitialAd.fullScreenContentDelegate = self;
            __weak typeof(self) _self = self;
            self->_interstitialAd.paidEventHandler = ^void(GADAdValue *_Nonnull adValue) {
                __strong typeof(_self) self = _self;
                [[SDKFacade sharedInstance] logAdRevenue:self->_interstitialAd && self->_interstitialAd.responseInfo.loadedAdNetworkResponseInfo ? self->_interstitialAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName : @"admob" mediationType:SdkMediationNetworkTypeGoogleAdMob adType:@"interstitial" adUnit:self->_adId placement:self->_tag country:[SDKHelper getCountryCode].lowercaseString currency:adValue.currencyCode value:adValue.value];
            };
            [self adLoaded];
            DLog(@"[adlog] [tag:%@(%d)] [%@:adLoaded] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, self->_interstitialAd.responseInfo.loadedAdNetworkResponseInfo ? self->_interstitialAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName : @"admob");
        }];
        return true;
    }
    return false;
}

-(void)adFailed:(NSString *)error
{
    _interstitialAd = nil;
    [super adFailed:error];
}

-(void)adShowFailed
{
    _interstitialAd = nil;
    [super adShowFailed];
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if (self.isAvailable) {
        @try{
            @synchronized (_interstitialAd) {
              _interstitialAd.fullScreenContentDelegate = self;
              [_interstitialAd presentFromRootViewController:vc];
            }
        }@catch (NSException *exception) {
        }
    } else {
        [self adShowFailed];
    }
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error
{
    [self adShowFailed];
}

-(void)adDidRecordImpression:(id<GADFullScreenPresentingAd>)ad
{
    [self adDidShown];
    DLog(@"[adlog] [tag:%@(%d)] [%@:adDidShown] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, self->_interstitialAd.responseInfo.loadedAdNetworkResponseInfo ? self->_interstitialAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName : @"admob");
}

-(void)adDidRecordClick:(id<GADFullScreenPresentingAd>)ad
{
    [self adDidClick];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self adDidClose];
}

-(void)adDidClose
{
    _interstitialAd = nil;
    [super adDidClose];
}

@end
