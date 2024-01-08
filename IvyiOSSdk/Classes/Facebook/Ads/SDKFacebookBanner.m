//
//  SDKFacebookBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKFacebookBanner.h"

@implementation SDKFacebookBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        if (!_adView) {
            FBAdSize adSize = kFBAdSizeHeight50Banner;
            if (_adSize && [_adSize isEqualToString:@"rect"]) {
                adSize = kFBAdSizeHeight250Rectangle;
            } else if (_adSize && [_adSize isEqualToString:@"large"]) {
                adSize = kFBAdSizeHeight90Banner;
            } else {
                adSize = isPad ? kFBAdSizeHeight90Banner : kFBAdSizeHeight50Banner;
            }
            FBAdView *adView = [[FBAdView alloc] initWithPlacementID:_adId adSize:adSize rootViewController:vc];
            _adView = adView;
        }
        if (_adView) {
            FBAdView *adView = (FBAdView *)_adView;
            adView.delegate = self;
            //        adView.frame = CGRectMake(0, 20, adView.bounds.size.width, adView.bounds.size.height);
            [(FBAdView *)_adView loadAd];
        }
        return true;
    }
    return false;
}

- (void)adViewDidEnd:(FBAdView *)adView
{
}

- (void)adViewDidLoad:(FBAdView *)adView
{
    adView.delegate = nil;
    [self adLoaded];
}

- (void)adViewDidClick:(FBAdView *)adView
{
    [self adDidClick];
}

- (void)adViewWillLogImpression:(FBAdView *)adView
{
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}
@end
