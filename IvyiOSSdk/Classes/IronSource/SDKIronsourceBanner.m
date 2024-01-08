//
//  SDKIronsourceVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKIronsourceBanner.h"
#import "SDKIronsourceInit.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKIronsourceBanner
{
@private
    UIView *_adView;
    bool hasLoaded;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        hasLoaded = YES;
        ISBannerSize *size = ISBannerSize_BANNER;
        if (_adSize) {
            if ([_adSize isEqualToString:@"rect"]) {
                size = ISBannerSize_RECTANGLE;
            } else if ([_adSize isEqualToString:@"large"]) {
                size = ISBannerSize_LARGE;
            } else if ([_adSize isEqualToString:@"smart"]) {
                size = ISBannerSize_SMART;
            }
        }
        [IronSource setBannerDelegate:self];
        [IronSource loadBannerWithViewController:vc size:size placement:_adId];
    }
    return true;
}

/**
 Called after a banner ad has been successfully loaded
 */
- (void)bannerDidLoad:(ISBannerView *)bannerView
{
    [self setAdView:bannerView];
    [self adLoaded];
}

/**
 Called after a banner has attempted to load an ad but failed.
 
 @param error The reason for the error
 */
- (void)bannerDidFailToLoadWithError:(NSError *)error
{
    [self adFailed:error.localizedDescription];
}

/**
 Called after a banner has been clicked.
 */
- (void)didClickBanner
{
    [self adDidClick];
}

/**
 Called when a banner is about to present a full screen content.
 */
- (void)bannerWillPresentScreen
{
}

/**
 Called after a full screen content has been dismissed.
 */
- (void)bannerDidDismissScreen
{
    [self adDidClose];
}

/**
 Called when a user would be taken out of the application context.
 */
- (void)bannerWillLeaveApplication
{
}

- (void)bannerDidShow {
    [self adDidShown];
}

@end
