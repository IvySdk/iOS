//
//  SDKGDTInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKGdtInterstitial.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKGdtInterstitial
{
@private
    GDTUnifiedInterstitialAd *_interstitialAd;
}
#pragma mark ================== Interstitial AD ===================

-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        _interstitialAd = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:_adId];
        _interstitialAd.delegate = self;
        [_interstitialAd loadAd];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if ([self isAvailable]) {
        @try{
            [_interstitialAd presentAdFromRootViewController: vc];
            [self startCheckShowFailedTimer];
        }@catch (NSException *exception) {
        }
    } else {
        [self adShowFailed];
    }
}

#pragma mark - GDTUnifiedInterstitialAdDelegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
    DLog(@"eCPM:%ld eCPMLevel:%@", [unifiedInterstitial eCPM], [unifiedInterstitial eCPMLevel]);
    DLog(@"videoDuration:%lf isVideo: %@", unifiedInterstitial.videoDuration, @(unifiedInterstitial.isVideoAd));
    [self adLoaded];
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    DLog(@"%s",__FUNCTION__);
    DLog(@"interstitial fail to load, Error : %@",error);
    [self adFailed: [error description]];
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    DLog(@"%s",__FUNCTION__);
    [self adShowFailed];
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
    [self adDidShown];
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
    [self adDidClose];
}

/**
 *  当点击下载应用时会调用系统程序打开
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
    [self adDidShown];
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
    [self adDidClick];
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}


/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status
{
    DLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    DLog(@"%s",__FUNCTION__);

}

@end
