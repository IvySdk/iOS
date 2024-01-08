//
//  SDKFacebookVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKChartboostVideo.h"
#import "SDKChartboostInit.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKChartboostVideo
{
    @private
    CHBRewarded *_video;
}
#pragma mark ================== Reward Video ===================

-(instancetype)init:(NSString *)tag index:(int)index config:(NSDictionary *)config size:(NSString *)size orientation:(SDK_ORIENTATION)orientation delegate:(id<SDKAdDelegate>)delegate
{
    self = [super init:tag index:index config:config size:size orientation:orientation delegate:delegate];
    _adId = _adId ? _adId : tag;
    return self;
}

-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        if ([self isAvailable]) {
            [self adLoaded];
        }
        _video = [[CHBRewarded alloc] initWithLocation:SDK_ADTAG_DEFAULT delegate:self];
        [_video cache];
        return YES;
    }
    return NO;
}

-(BOOL)isAvailable
{
    _isAvailable = _video && _video.isCached;
    return [super isAvailable];
}

-(void)adFailed:(NSString *)error
{
    _video = nil;
    [super adFailed:error];
}

-(void)adShowFailed
{
    _video = nil;
    [super adShowFailed];
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if ([self isAvailable]) {
        [_video showFromViewController:vc];
        [self startCheckShowFailedTimer];
    }
}

-(void)didShowAd:(CHBShowEvent *)event error:(CHBShowError *)error
{
    if (error) {
        [self adShowFailed];
    } else {
        [self adDidShown];
    }
}

-(void)didEarnReward:(CHBRewardEvent *)event
{
    _hasReward = YES;
}

-(void)didClickAd:(CHBClickEvent *)event error:(CHBClickError *)error
{
    [self adDidClick];
}

-(void)didCacheAd:(CHBCacheEvent *)event error:(CHBCacheError *)error
{
    if (error) {
        [self adFailed:error.description];
    } else {
        [self adLoaded];
    }
}

-(void)didDismissAd:(CHBDismissEvent *)event
{
    _video = nil;
    [self adDidClose];
}
@end
