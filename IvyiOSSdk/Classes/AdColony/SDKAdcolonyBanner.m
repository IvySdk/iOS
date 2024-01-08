//
//  SDKAdcolonyBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKAdcolonyBanner.h"

@implementation SDKAdcolonyBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        if(!_adView) {
            AdColonyAdSize size = kAdColonyAdSizeBanner;
            if (_adSize && [_adSize isEqualToString:@"rect"]) {
                size = kAdColonyAdSizeMediumRectangle;
            } else if (_adSize && [_adSize isEqualToString:@"large"]) {
                size = kAdColonyAdSizeLeaderboard;
            }
            [AdColony requestAdViewInZone:_adId withSize:kAdColonyAdSizeBanner viewController:vc andDelegate:self];
        }
        return true;
    }
    return false;
}

- (void)adColonyAdViewDidReceiveClick:(AdColonyAdView *)adView
{
    [self adDidClick];
}

- (void)adColonyAdViewDidLoad:(AdColonyAdView *)adView
{
    [self setAdView:adView];
    [self adLoaded];
}

- (void)adColonyAdViewWillOpen:(AdColonyAdView *)adView
{
    [self adDidShown];
}

- (void)adColonyAdViewDidClose:(AdColonyAdView *)adView
{
    [self adDidClose];
}

- (void)adColonyAdViewDidFailToLoad:(AdColonyAdRequestError *)error
{
    [self adFailed:error.localizedDescription];
}

@end
