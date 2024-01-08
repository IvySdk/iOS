//
//  SDKFacebookBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKGdtBanner.h"

@implementation SDKGdtBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        if (!_adView) {
            CGRect adSize = {CGPointZero, CGSizeMake(375, 60)};
     
            GDTUnifiedBannerView *adView = [[GDTUnifiedBannerView alloc]
                                                 initWithFrame:adSize
                                                 placementId:_adId
                                                 viewController:vc];
            adView.delegate = self;
            _adView = adView;
        }
        [(GDTUnifiedBannerView *)_adView loadAdAndShow];
        return true;
    }
    return false;
}


#pragma mark - GDTUnifiedBannerViewDelegate
/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"unified banner did load");
    [self adLoaded];
    if (!isPad) {
        float dx = Screen_width / 640;
        CGRect frame = CGRectMake(0, 0, Screen_width, 100 * dx);
        for (UIView *view in unifiedBannerView.subviews) {
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
        unifiedBannerView.frame = CGRectMake(unifiedBannerView.frame.origin.x, unifiedBannerView.frame.origin.y, Screen_width, frame.size.height);
    }
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
{
    DLog(@"%s",__FUNCTION__);
    [self adFailed: [error description]];
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    DLog(@"%s",__FUNCTION__);
    [self adDidShown];
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"%s",__FUNCTION__);
    [self adDidClick];
}

/**
 *  应用进入后台时调用
 *  当点击应用下载或者广告调用系统程序打开，应用将被自动切换到后台
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    DLog(@"%s",__FUNCTION__);
    [self adDidClose];
}

@end
