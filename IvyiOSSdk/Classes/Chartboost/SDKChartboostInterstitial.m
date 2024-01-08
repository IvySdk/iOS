//
//  SDKFacebookInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKChartboostInterstitial.h"
#import "SDKChartboostInit.h"
#import <IvyiOSSdk/SDKTimer.h>
@implementation SDKChartboostInterstitial
{
    @private
    CHBInterstitial *_inter;
}
#pragma mark ================== Interstitial AD ===================

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
        _inter = [[CHBInterstitial alloc] initWithLocation:SDK_ADTAG_DEFAULT delegate:self];
        [_inter cache];
        return YES;
    }
    return NO;
}

-(BOOL)isAvailable
{
    _isAvailable = _inter && _inter.isCached;
    return [super isAvailable];
}

-(void)adFailed:(NSString *)error
{
    _inter = nil;
    [super adFailed:error];
}

-(void)adShowFailed
{
    _inter = nil;
    [super adShowFailed];
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if ([self isAvailable]) {
        [_inter showFromViewController:vc];
        [self startCheckShowFailedTimer];
    }
}

- (void)didShowAd:(CHBShowEvent *)event error:(CHBShowError *)error
{
    if (error) {
        [self adShowFailed];
    } else {
        [self adDidShown];
    }
}

- (void)didCacheAd:(CHBCacheEvent *)event error:(CHBCacheError *)error
{
    if (error) {
        [self adFailed:error.description];
    } else {
        [self adLoaded];
    }
}

- (void)didClickAd:(CHBClickEvent *)event error:(CHBClickError *)error
{
    [self adDidClick];
}

-(void)didDismissAd:(CHBDismissEvent *)event
{
    _inter = nil;
    [self adDidClose];
}
@end
