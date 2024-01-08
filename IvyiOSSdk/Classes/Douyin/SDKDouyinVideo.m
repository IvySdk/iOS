//
//  SDKDouyinVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKDouyinVideo.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKDouyinVideo
{
@private
    LGRewardedVideoAd *rewardedVideoAd;
}
#pragma mark ================== Reward Video ===================

-(BOOL)loadAd
{
    if ([super loadAd]) {
        LGRewardedVideoModel *model = [[LGRewardedVideoModel alloc] init];
//        model.isShowDownloadBar = YES;
        rewardedVideoAd = [[LGRewardedVideoAd alloc] initWithSlotID:_adId rewardedVideoModel:model];
        rewardedVideoAd.delegate = self;
        [rewardedVideoAd loadAdData];
        return true;
    }
    return false;
}

-(BOOL)isAvailable
{
    [super setIsAvailable:rewardedVideoAd && rewardedVideoAd.isAdValid];
    return [super isAvailable];
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
    [self adReward];
    [super adDidClose];
    rewardedVideoAd = nil;
}

-(void)rewardedVideoAdDidClose:(LGRewardedVideoAd *)rewardedVideoAd
{
    [self adDidClose];
}

-(void)rewardedVideoAdDidClick:(LGRewardedVideoAd *)rewardedVideoAd
{
    [self adDidClick];
}

- (void)rewardedVideoAdDidLoad:(LGRewardedVideoAd *)rewardedVideoAd
{
    [self adLoaded];
}

-(void)rewardedVideoAdDidVisible:(LGRewardedVideoAd *)rewardedVideoAd
{
    [self adDidShown];
}

- (void)rewardedVideoAd:(LGRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

-(void)rewardedVideoAdDidPlayFinish:(LGRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    if (error) {
        [self adShowFailed];
    }
}
@end
