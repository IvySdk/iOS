//
//  SDKApplovinVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKApplovinVideo.h"
#import <IvyiOSSdk/SDKTimer.h>

@implementation SDKApplovinVideo
{
@private
    ALIncentivizedInterstitialAd *_video;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        _video = [[ALIncentivizedInterstitialAd alloc] initWithZoneIdentifier:_adId];
        _video.adDisplayDelegate = self;
        [_video preloadAndNotify:self];
        return false;
    }
    return true;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]){
        [_video showAndNotify:self];
        [self startCheckShowFailedTimer];
    } else {
        [self adShowFailed];
    }
}

- (BOOL)isAvailable
{
    _isAvailable = _video && _video.isReadyForDisplay;
    return [super isAvailable];
}

-(void) rewardValidationRequestForAd: (ALAd*) ad didSucceedWithResponse: (NSDictionary*) response
{
    _hasReward = YES;
}

-(void) rewardValidationRequestForAd: (ALAd*) ad didExceedQuotaWithResponse: (NSDictionary*) response
{
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    //    _clickAd = YES;
    [self adDidClick];
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    [self adLoaded];
}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    [self adDidShown];
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    _video = nil;
    [self adDidClose];
    [ALIncentivizedInterstitialAd preloadAndNotify:self];
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

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    [self adFailed:[NSString stringWithFormat:@"eror code : %d", code]];
}

-(void) rewardValidationRequestForAd: (ALAd*) ad wasRejectedWithResponse: (NSDictionary*) response
{
    [self adFailed:@"Applovin user was rejected"];
}

-(void) rewardValidationRequestForAd: (ALAd*) ad didFailWithError: (NSInteger) responseCode
{
    [self adFailed:@"Applovin validation request failed"];
}
@end
