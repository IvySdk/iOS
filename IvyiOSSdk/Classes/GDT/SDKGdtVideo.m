//
//  SDKFacebookVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKGdtVideo.h"
#import <IvyiOSSdk/SDKTimer.h>

@implementation SDKGdtVideo
{
@private
    GDTRewardVideoAd *rewardedVideoAd;
}
#pragma mark ================== Reward Video ===================

-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        rewardedVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:_adId];
        rewardedVideoAd.delegate = self;
        [rewardedVideoAd loadAd];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]) {
        [rewardedVideoAd showAdFromRootViewController:vc];
        [self startCheckShowFailedTimer];
    } else {
        [self adShowFailed];
    }
}

-(void)adDidClose
{
    rewardedVideoAd = nil;
    [super adDidClose];
}

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    DLog(@"[gdt] eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
    DLog(@"[gdt] videoDuration :%lf rewardAdType:%ld", rewardedVideoAd.videoDuration, rewardedVideoAd.rewardAdType);
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    [self adLoaded];
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    DLog(@"[gdt] 视频播放页即将打开");
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    DLog(@"[gdt] 广告已曝光");
    [self adDidShown];
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    [self adDidClose];
//    广告关闭后释放ad对象
    rewardedVideoAd = nil;
    DLog(@"[gdt] 广告已关闭");
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    DLog(@"[gdt] 广告已点击");
    [self adDidClick];
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    DLog(@"[gdt] %s",__FUNCTION__);
    if (error.code == 4014) {
        DLog(@"[gdt] 请拉取到广告后再调用展示接口");
    } else if (error.code == 4016) {
        DLog(@"[gdt] 应用方向与广告位支持方向不一致");
    } else if (error.code == 5012) {
        DLog(@"[gdt] 广告已过期");
    } else if (error.code == 4015) {
        DLog(@"[gdt] 广告已经播放过，请重新拉取");
    } else if (error.code == 5002) {
        DLog(@"[gdt] 视频下载失败");
    } else if (error.code == 5003) {
        DLog(@"[gdt] 视频播放失败");
    } else if (error.code == 5004) {
        DLog(@"[gdt] 没有合适的广告");
    } else if (error.code == 5013) {
        DLog(@"[gdt] 请求太频繁，请稍后再试");
    } else if (error.code == 3002) {
        DLog(@"[gdt] 网络连接超时");
    } else if (error.code == 5027){
        DLog(@"[gdt] 页面加载失败");
    }
    DLog(@"[gdt] ERROR: %@", error);
    [self adFailed: [error description]];
}

-(void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info
{
    DLog(@"[gdt] %s",__FUNCTION__);
    DLog(@"[gdt] 播放达到激励条件");
    _hasReward = YES;
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    DLog(@"[gdt] %s",__FUNCTION__);
    DLog(@"[gdt] 视频播放结束");
}

@end
