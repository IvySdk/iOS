//
////  SDKDouyinBanner.m
////  Pods
////
////  Created by IceStar on 2017/7/12.
////
////
//
//#import "SDKDouyinBanner.h"
//
//@implementation SDKDouyinBanner
//#pragma mark ================== Banner AD ===================
//-(BOOL)loadAd
//{
//    if ([super loadAd]) {
//        if (!_adView) {
//            BUSize *adSize = [BUSize sizeBy:BUProposalSize_Banner600_90];
//            if (!isPad) {
//                adSize.width = 640;
//                adSize.height = 100;
//            }
//            if (_adSize) {
//                if ([_adSize isEqualToString:@"rect"]) {
//                    adSize = [BUSize sizeBy:BUProposalSize_Banner600_300];;
//                } else if ([_adSize isEqualToString:@"large"]) {
//                    [BUSize sizeBy:BUProposalSize_Banner600_150];
//                } else if ([_adSize isEqualToString:@"full"]) {
//                    [BUSize sizeBy:BUProposalSize_Banner600_100];
//                }
//            }
//            BUBannerAdView *adView = [[BUBannerAdView alloc] initWithSlotID:_adId size:adSize rootViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
//            adView.delegate = self;
//            _adView = adView;
//        }
//        [(BUBannerAdView *)_adView loadAdData];
//        return true;
//    }
//    return false;
//}
//
//- (void)bannerAdViewDidLoad:(BUBannerAdView *)bannerAdView WithAdmodel:(BUNativeAd *)nativeAd
//{
//    [self adLoaded];
//    if (!isPad) {
//        float dx = Screen_width / 640;
//        CGRect frame = CGRectMake(0, 0, Screen_width, 100 * dx);
//        for (UIView *view in bannerAdView.subviews) {
//            float x = view.frame.origin.x;
//            float y = view.frame.origin.y;
//            float w = view.frame.size.width;
//            float h = view.frame.size.height;
//            if (w > 100) {
//                view.frame = frame;
//            } else {
//                x = x > 0 ? Screen_width - w : x;
//                y = y > 10 ? frame.size.height - h : y;
//                view.frame = CGRectMake(x, y, w, h);
//            }
//        }
//        bannerAdView.frame = CGRectMake(bannerAdView.frame.origin.x, bannerAdView.frame.origin.y, Screen_width, frame.size.height);
//    }
//}
//
//- (void)bannerAdViewDidClick:(BUBannerAdView *)bannerAdView WithAdmodel:(BUNativeAd *)nativeAd
//{
//    [self adDidClick];
//}
//
//- (void)bannerAdViewDidBecomVisible:(BUBannerAdView *)bannerAdView WithAdmodel:(BUNativeAd *)nativeAd
//{
//    [self adDidShown];
//}
//
//-(void)bannerAdView:(BUBannerAdView *)bannerAdView didLoadFailWithError:(NSError *)error
//{
//    [self adFailed:error ? error.description : nil];
//}
//@end
