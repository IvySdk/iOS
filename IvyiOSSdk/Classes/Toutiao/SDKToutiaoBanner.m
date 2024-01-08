//
//  SDKFacebookBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKToutiaoBanner.h"

@implementation SDKToutiaoBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        if (!_adView) {
            CGRect frame = CGRectMake(0, 0, 640, 100);
            BUSize *adSize = [BUSize sizeBy:BUProposalSize_Banner640_100];
            if (!isPad) {
                adSize.width = 640;
                adSize.height = 100;
            }
            if (_adSize) {
                if ([_adSize isEqualToString:@"rect"]) {
                    adSize = [BUSize sizeBy:BUProposalSize_Banner600_300];;
                    frame = CGRectMake(0, 0, 600, 300);
                } else if ([_adSize isEqualToString:@"large"]) {
                    adSize = [BUSize sizeBy:BUProposalSize_Banner600_150];
                    frame = CGRectMake(0, 0, 600, 150);
                } else if ([_adSize isEqualToString:@"full"]) {
                    adSize = [BUSize sizeBy:BUProposalSize_Banner640_100];
                    frame = CGRectMake(0, 0, 640, 100);
                }
            }
            BUNativeExpressBannerView *adView = [[BUNativeExpressBannerView alloc] initWithSlotID:_adId rootViewController:vc adSize:CGSizeMake(adSize.width, adSize.height)];
            adView.frame = frame;
            adView.delegate = self;
            _adView = adView;
        }
        [(BUNativeExpressBannerView *)_adView loadAdData];
        return true;
    }
    return false;
}

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    DLog(@"nativeExpressBannerAdViewDidLoad");
    [self adLoaded];
    if (!isPad) {
        float dx = Screen_width / 640;
        CGRect frame = CGRectMake(0, 0, Screen_width, 100 * dx);
        for (UIView *view in bannerAdView.subviews) {
            float x = view.frame.origin.x;
            float y = view.frame.origin.y;
            float w = view.frame.size.width;
            float h = view.frame.size.height;
            if (w > 100) {
                view.frame = frame;
            } else {
                x = x > 0 ? Screen_width - w : x;
                y = y > 10 ? frame.size.height - h : y;
                view.frame = CGRectMake(x, y, w, h);
            }
        }
        bannerAdView.frame = CGRectMake(bannerAdView.frame.origin.x, bannerAdView.frame.origin.y, Screen_width, frame.size.height);
    }
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView
{
    DLog(@"nativeExpressBannerAdViewDidClick");
    [self adDidClick];
}

-(void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView
{
    DLog(@"nativeExpressBannerAdViewWillBecomVisible");
    [self adDidShown];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error
{
    DLog(@"nativeExpressBannerAdView");
    [self adFailed:error ? error.description : nil];
}

-(void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error
{
    [self adShowFailed];
}
@end
