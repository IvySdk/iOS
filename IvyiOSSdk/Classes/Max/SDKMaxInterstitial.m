//
//  SDKMaxInterstitial.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKMaxInterstitial.h"
#import <IvyiOSSdk/SDKTimer.h>
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKMaxInterstitial
{
@private
    MAInterstitialAd *_inter;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        _inter = [[MAInterstitialAd alloc] initWithAdUnitIdentifier:_adId];
        _inter.delegate = self;
        _inter.revenueDelegate = self;
        [_inter loadAd];
        return false;
    }
    return true;
}

-(BOOL)isAvailable
{
    _isAvailable = _inter && _inter.isReady;
    return [super isAvailable];
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]){
        [_inter showAd];
    } else {
        [self adShowFailed];
    }
}

-(void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    _inter = nil;
    [super adShowFailed];
}

-(void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    _inter = nil;
    [super adFailed:error.message];
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
    _inter = nil;
    [self adDidClose];
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
