//
//  SDKUnityBanner.m
//  Pods
//
//  Created by IceStar on 2022/1/15.
//
//

#import "SDKUnityBanner.h"
#import "SDKUnityInit.h"
@implementation SDKUnityBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        CGSize size = CGSizeMake(320, 50);
        if (!_adView) {
            if (_adSize && [_adSize isEqualToString:@"rect"]) {
                size = CGSizeMake(300, 250);
            } else if (_adSize && [_adSize isEqualToString:@"large"]) {
                size = CGSizeMake(320, 100);
            } else if (_adSize && [_adSize isEqualToString:@"full"]) {
                if(Screen_width > 320) {
                    size = CGSizeMake(468, 60);
                }
            } else {
                if(Screen_width > 320) {
                    size = CGSizeMake(468, 60);
                }
            }
            UADSBannerView *adView = [[UADSBannerView alloc] initWithPlacementId:_adId size:size];
            _adView = adView;
            adView.delegate = self;
        }
        if (_adView) {
            UADSBannerView *adView = (UADSBannerView *)_adView;
            adView.delegate = self;
            if ([UnityAds isInitialized]) {
                [adView load];
            } else {
                [[SDKUnityInit sharedInstance] addToLoadQueue:self];
            }
            return true;
        }
    }
    return false;
}

- (void)bannerViewDidLoad: (UADSBannerView *)bannerView
{
    [self adLoaded];
}

- (void)bannerViewDidClick: (UADSBannerView *)bannerView
{
    [self adDidClick];
}

- (void)bannerViewDidLeaveApplication: (UADSBannerView *)bannerView
{
}

- (void)bannerViewDidError: (UADSBannerView *)bannerView error: (UADSBannerError *)error
{
    [self adFailed:error.description];
}
@end
