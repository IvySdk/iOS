//
//  SDKDfpBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKDfpBanner.h"
#import "SDKDfpRequest.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GAMRequest.h>
#import <GoogleMobileAds/GADAdSize.h>
#import <IvyiOSSdk/SDKTimer.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKHelper.h>

@implementation SDKDfpBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
#if DEBUG
//    _adId = @"/6499/example/banner";
#endif
    if([super loadAd:vc]) {
        GAMBannerView *adView = [[GAMBannerView alloc] initWithAdSize:GADAdSizeBanner];
        _adView = adView;
      
        adView.translatesAutoresizingMaskIntoConstraints = NO;

        if (_adSize && [_adSize isEqualToString:@"rect"]) {
            [adView setAdSize:GADAdSizeMediumRectangle];
        } else if (_adSize && [_adSize isEqualToString:@"large"]) {
            [adView setAdSize:GADAdSizeLargeBanner];
        } else if (_adSize && [_adSize isEqualToString:@"smart"]) {
            [adView setAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(Screen_width)];
        } else if (_adSize && [_adSize isEqualToString:@"full"]) {
            if(Screen_width <= 320) {
                [adView setAdSize:GADAdSizeBanner];
            } else {
                [adView setAdSize:GADAdSizeFullBanner];
            }
        } else if (_adSize && [_adSize isEqualToString:@"adaptive"]) {
            [adView setAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(Screen_width)];
        } else {
            if(isPad) {
                [adView setAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(Screen_width)];
            } else {
                if(Screen_width <= 320) {
                    [adView setAdSize:GADAdSizeBanner];
                } else {
                    [adView setAdSize:GADAdSizeFullBanner];
                }
            }
        }
        adView.adUnitID = _adId;
        adView.delegate = self;
        __weak typeof(self) _self = self;
        adView.paidEventHandler = ^void(GADAdValue *_Nonnull adValue) {
            __strong typeof(_self) self = _self;
            GADBannerView *bannerView = (GADBannerView *)self->_adView;
            [[SDKFacade sharedInstance] logAdRevenue:bannerView && bannerView.responseInfo.loadedAdNetworkResponseInfo ? bannerView.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName : @"admob" mediationType:SdkMediationNetworkTypeGoogleAdMob adType:@"banner" adUnit:self->_adId placement:self->_tag country:[SDKHelper getCountryCode].lowercaseString currency:adValue.currencyCode value:adValue.value precision:(int)adValue.precision];
        };
        adView.adSizeDelegate = self;
        adView.autoloadEnabled = YES;
        adView.rootViewController = vc;
      
        GAMRequest *request = [SDKDfpRequest createRequest];
        [adView loadRequest:request];
        return true;
    }
    return false;
}

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd");
  bannerView.delegate = nil;
  [self adLoaded];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error
{
  NSLog(@"adFailed");
    [self adFailed:error ? error.description : nil];
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
  [self adDidShown];
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillDismissScreen");
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
  [self adDidClose];
}

- (void)adView:(nonnull GADBannerView *)bannerView willChangeAdSizeTo:(GADAdSize)size {
}

@end
