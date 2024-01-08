//
//  SDKFacebookVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKFacebookVideo.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKFacebookVideo
{
@private
    FBRewardedVideoAd *rewardedVideoAd;
}
#pragma mark ================== Reward Video ===================

-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        rewardedVideoAd = [[FBRewardedVideoAd alloc] initWithPlacementID:_adId];
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

- (void)rewardedVideoAdDidClose:(FBRewardedVideoAd *)rewardedVideoAd
{
    [self adDidClose];
}

- (void)rewardedVideoAdServerRewardDidFail:(FBRewardedVideoAd *)rewardedVideoAd
{
}

- (void)rewardedVideoAdServerRewardDidSucceed:(FBRewardedVideoAd *)rewardedVideoAd
{
    _hasReward = YES;
}

- (void)rewardedVideoAdDidClick:(FBRewardedVideoAd *)rewardedVideoAd
{
    [self adDidClick];
}

- (void)rewardedVideoAdDidLoad:(FBRewardedVideoAd *)rewardedVideoAd
{
    [self adLoaded];
}

- (void)rewardedVideoAdWillLogImpression:(FBRewardedVideoAd *)rewardedVideoAd
{
    [self adDidShown];
}

- (void)rewardedVideoAd:(FBRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}
@end
