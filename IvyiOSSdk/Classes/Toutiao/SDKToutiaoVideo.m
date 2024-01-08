//
//  SDKFacebookVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKToutiaoVideo.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKToutiaoVideo
{
@private
    BUNativeExpressRewardedVideoAd *_rewardedVideoAd;
}
#pragma mark ================== Reward Video ===================

-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
//        model.isShowDownloadBar = YES;
        _rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:_adId rewardedVideoModel:model];
        _rewardedVideoAd.delegate = self;
        [_rewardedVideoAd loadAdData];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]) {
        [_rewardedVideoAd showAdFromRootViewController:vc];
        [self startCheckShowFailedTimer];
    } else {
        [self adShowFailed];
    }
}

-(void)adDidClose
{
    _rewardedVideoAd = nil;
    [super adDidClose];
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self adDidClose];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self adDidClick];
}

- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self adLoaded];
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    [self adDidShown];
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    if (error) {
        [self adShowFailed];
    } else {
        [self adReward];
    }
}

-(void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *)error
{
    if (error) {
        [self adShowFailed];
    }
}
@end
