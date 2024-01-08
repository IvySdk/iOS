//
//  SDKApplovinBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKApplovinBanner.h"

@implementation SDKApplovinBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        if(!_adView) {
            ALAdView *adView = [[ALAdView alloc] initWithSize: ALAdSize.banner];
            adView.adLoadDelegate = self;
            adView.adDisplayDelegate = self;
            adView.adEventDelegate = self;
            adView.translatesAutoresizingMaskIntoConstraints = NO;
            [self setAdView:adView];
        }
        [(ALAdView *)_adView loadNextAd];
        return true;
    }
    return false;
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    [self adDidClick];
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    [self adLoaded];
}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    [self adDidShown];
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    [self adDidClose];
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    [self adFailed:[NSString stringWithFormat:@"eror code : %d", code]];
}

#pragma mark - Ad View Event Delegate

- (void)ad:(ALAd *)ad didPresentFullscreenForAdView:(ALAdView *)adView
{
    DLog(@"SDKApplovinBanner did present fullscreen");
}

- (void)ad:(ALAd *)ad willDismissFullscreenForAdView:(ALAdView *)adView
{
    DLog(@"SDKApplovinBanner will dismiss fullscreen");
}

- (void)ad:(ALAd *)ad didDismissFullscreenForAdView:(ALAdView *)adView
{
    DLog(@"SDKApplovinBanner did dismiss fullscreen");
}

- (void)ad:(ALAd *)ad willLeaveApplicationForAdView:(ALAdView *)adView
{
    DLog(@"SDKApplovinBanner will leave application");
}

- (void)ad:(ALAd *)ad didFailToDisplayInAdView:(ALAdView *)adView withError:(ALAdViewDisplayErrorCode)code
{
    DLog(@"SDKApplovinBanner did fail to display with error code: %ld", code);
}


@end
