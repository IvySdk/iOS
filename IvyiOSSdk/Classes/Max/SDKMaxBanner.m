//
//  SDKMaxBanner.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKMaxBanner.h"
#import <IvyiOSSdk/SDKFacade.h>

@implementation SDKMaxBanner
{
    @private
    BOOL _hasLoadAps;
}
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        if ([DTBAds sharedInstance].appKey && !_hasLoadAps) {
            _hasLoadAps = YES;
            NSDictionary *extra = [_config objectForKey:@"extra"];
            if (extra) {
                NSString *amazonAdSlotId;
                MAAdFormat *adFormat;
                NSString *leader_slot_id = [extra objectForKey:@"aps_leader_slot_id"];
                NSString *bannerr_slot_id = [extra objectForKey:@"aps_banner_slot_id"];
                if (leader_slot_id && UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad )
                {
                    amazonAdSlotId = leader_slot_id;
                    adFormat = MAAdFormat.leader;
                }
                else if (bannerr_slot_id)
                {
                    amazonAdSlotId = bannerr_slot_id;
                    adFormat = MAAdFormat.banner;
                }
                if (amazonAdSlotId) {
                    CGSize rawSize = adFormat.size;
                    DTBAdSize *size = [[DTBAdSize alloc] initBannerAdSizeWithWidth: rawSize.width
                                                                            height: rawSize.height
                                                                       andSlotUUID: amazonAdSlotId];
                    DTBAdLoader *adLoader = [[DTBAdLoader alloc] init];
                    [adLoader setAdSizes: @[size]];
                    [adLoader loadAd: self];
                }
            }
        }
        if(!_adView) {
            MAAdView *adView = [[MAAdView alloc] initWithAdUnitIdentifier:_adId];
            adView.delegate = self;
            adView.revenueDelegate = self;
            CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;
            CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
            if (_adSize && [_adSize isEqualToString:@"adaptive"]) {
                height = MAAdFormat.banner.adaptiveSize.height;
                [adView setExtraParameterForKey: @"adaptive_banner" value: @"true"];
            }
            adView.frame = CGRectMake(0, 0, width, height);
            [self setAdView:adView];
        }
        [(MAAdView *)_adView loadAd];
        [self stopRefreshAd];
        return true;
    }
    return false;
}

- (void)onSuccess:(DTBAdResponse *)adResponse
{
    [(MAAdView *)_adView setLocalExtraParameterForKey: @"amazon_ad_response" value: adResponse];
    [(MAAdView *)_adView loadAd];
}

- (void)onFailure:(DTBAdError)error dtbAdErrorInfo:(DTBAdErrorInfo *)errorInfo
{
    [(MAAdView *)_adView setLocalExtraParameterForKey: @"amazon_ad_error" value: errorInfo];
    [(MAAdView *)_adView loadAd];
}

-(void)adNeedReload
{
}

-(void)didClickAd:(MAAd *)ad
{
    [self adDidClick];
}

-(void)didLoadAd:(MAAd *)ad
{
    if (_adView) {
        CGSize size = ad.size;
        _adView.frame = CGRectMake(0, 0, size.width, size.height);
    }
    [self adLoaded];
}

-(void)stopRefreshAd
{
    if (_adView) {
        [(MAAdView *)_adView setExtraParameterForKey: @"allow_pause_auto_refresh_immediately" value: @"true"];
        [(MAAdView *)_adView stopAutoRefresh];
    }
}

-(void)adDidClose
{
    [self stopRefreshAd];
    [super adDidClose];
}

-(void)adDidShown
{
    if (_adView) {
        [(MAAdView *)_adView startAutoRefresh];
    }
    [super adDidShown];
}

-(void)didDisplayAd:(MAAd *)ad
{
}

-(void)didHideAd:(MAAd *)ad
{
}

-(void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    [self adFailed:error.message];
}

- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error
{
    [self adShowFailed];
}

- (void)didCollapseAd:(nonnull MAAd *)ad {
}

- (void)didExpandAd:(nonnull MAAd *)ad {
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
