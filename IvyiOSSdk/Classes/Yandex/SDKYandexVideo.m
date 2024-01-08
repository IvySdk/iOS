//
//  SDKYandexVideo.m
//  Pods
//
//  Created by IceStar on 2023/06/01.
//
//

#import "SDKYandexVideo.h"
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKYandexVideo
{
@private
    YMARewardedAd *_rewardedAd;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        _rewardedAd = [[YMARewardedAd alloc] initWithAdUnitID:_adId];
        _rewardedAd.delegate = self;
        [_rewardedAd load];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if (self.isAvailable && _rewardedAd) {
        [_rewardedAd presentFromViewController:vc];
    } else {
        [self adShowFailed];
    }
}

-(void)rewardedAd:(YMARewardedAd *)rewardedAd didReward:(id<YMAReward>)reward
{
    _hasReward = YES;
}

-(void)rewardedAdDidLoad:(YMARewardedAd *)rewardedAd
{
    [self adLoaded];
}

-(void)rewardedAdDidFailToLoad:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    [self adFailed:error.localizedDescription];
}

-(void)rewardedAdDidFailToPresent:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    [self adShowFailed];
}

-(void)rewardedAdDidAppear:(YMARewardedAd *)rewardedAd
{
    [self adDidShown];
}

-(void)rewardedAdDidClick:(YMARewardedAd *)rewardedAd
{
    [self adDidClick];
}

-(void)rewardedAdDidDisappear:(YMARewardedAd *)rewardedAd
{
    [self adDidClose];
}
@end

