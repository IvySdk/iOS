//
//  SDKMaxVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKMaxVideo.h"
#import <IvyiOSSdk/SDKTimer.h>
#import <IvyiOSSdk/SDKFacade.h>

@implementation SDKMaxVideo
{
@private
    MARewardedAd *_video;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        _video = [MARewardedAd sharedWithAdUnitIdentifier:_adId];
        _video.delegate = self;
        _video.revenueDelegate = self;
        [_video loadAd];
        return false;
    }
    return true;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]){
        [_video showAd];
        [self startCheckShowFailedTimer];
    } else {
        [self adShowFailed];
    }
}

- (BOOL)isAvailable
{
    _isAvailable = _video && _video.isReady;
    return [super isAvailable];
}

-(void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
    _hasReward = YES;
}

- (void)didCompleteRewardedVideoForAd:(nonnull MAAd *)ad {
}

- (void)didStartRewardedVideoForAd:(nonnull MAAd *)ad {
}

-(void)didClickAd:(MAAd *)ad
{
    [self adDidClick];
}

-(void)didLoadAd:(MAAd *)ad
{
    [self adLoaded];
}

-(void)didDisplayAd:(MAAd *)ad
{
    [self adDidShown];
}

-(void)didHideAd:(MAAd *)ad
{
    _video = nil;
    [self adDidClose];
}

-(void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    _video = nil;
    [super adFailed:error.message];
}

-(void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    _video = nil;
    [super adShowFailed];
}

- (void)didPayRevenueForAd:(MAAd *)ad
{
    double revenue = ad.revenue; // In USD
    // Miscellaneous data
    NSString *countryCode = [ALSdk shared].configuration.countryCode; // "US" for the United States, etc - Note: Do not confuse this with currency code which is "USD" in most cases!
    
    NSString *adUnitId = ad.adUnitIdentifier; // The MAX Ad Unit ID
    NSString *networkName = ad.networkName; // Display name of the network that showed the ad (e.g. "AdColony")
    MAAdFormat *adFormat = ad.format; // The ad format of the ad (e.g. BANNER, MREC, INTERSTITIAL, REWARDED)
    NSString *placement = ad.networkPlacement; // The placement this ad's postbacks are tied to
    [[SDKFacade sharedInstance] logAdRevenue:networkName mediationType:SdkMediationNetworkTypeApplovinMax adType:adFormat.label adUnit:adUnitId placement:placement country:countryCode currency:@"USD" value:@(revenue)];
}
@end
