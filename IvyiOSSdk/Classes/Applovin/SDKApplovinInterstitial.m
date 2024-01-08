//
//  SDKApplovinInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKApplovinInterstitial.h"
#import <IvyiOSSdk/SDKTimer.h>

@implementation SDKApplovinInterstitial
{
@private
    ALAd *_ad;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        [ALInterstitialAd shared].adLoadDelegate = self;
        [ALInterstitialAd shared].adDisplayDelegate = self;
        [ALInterstitialAd shared].adVideoPlaybackDelegate = self;
        [[ALSdk shared].adService loadNextAdForZoneIdentifier:_adId andNotify: self];
        return false;
    }
    return true;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    //    _clickAd = NO;
    if([self isAvailable]){
        [[ALInterstitialAd shared] showAd:_ad];
    } else {
        [self adShowFailed];
    }
}

-(void)videoPlaybackBeganInAd:(ALAd *)ad
{
    
}

-(void)videoPlaybackEndedInAd:(ALAd *)ad atPlaybackPercent:(NSNumber *)percentPlayed fullyWatched:(BOOL)wasFullyWatched
{
    
}

-(void)adShowFailed{
    _ad = nil;
    [super adShowFailed];
}

-(void)adFailed:(NSString *)error
{
    _ad = nil;
    [super adFailed:error];
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    //    _clickAd = YES;
    [self adDidClick];
}

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    _ad = ad;
    [self adLoaded];
}

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    [self adDidShown];
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    [self adDidClose];
    _ad = nil;
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    [self adFailed:[NSString stringWithFormat:@"eror code : %d", code]];
}
@end
