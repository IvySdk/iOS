//
//  SDKApplovinVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKAdcolonyVideo.h"

@implementation SDKAdcolonyVideo
{
    @private
    AdColonyInterstitial *_ad;
}
#pragma mark ================== Reward Video ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        //Request an interstitial ad from AdColony
        AdColonyAdOptions *options = [AdColonyAdOptions new];
        options.showPrePopup = YES;
        options.showPostPopup = YES;
        [AdColony requestInterstitialInZone:_adId options:options andDelegate:self];
        return true;
    }
    return false;
}

-(BOOL)isAvailable{
    _isAvailable = _ad && !_ad.expired;
    return [super isAvailable];
}

-(void)adFailed:(NSString *)error
{
    _ad = nil;
    [super adFailed:error];
}

-(void)adShowFailed
{
    _ad = nil;
    [super adShowFailed];
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if (self.isAvailable) {
        [_ad showWithPresentingViewController:vc];
        [self startCheckShowFailedTimer];
    } else {
        [self adShowFailed];
    }
}

- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial *)interstitial
{
    _ad = interstitial;
    [self adLoaded];
}

- (void)adColonyInterstitialExpired:(AdColonyInterstitial *)interstitial
{
    _ad = nil;
    [self adNeedReload];
}

- (void)adColonyInterstitialDidClose:(AdColonyInterstitial *)interstitial
{
    _ad = nil;
    [self adDidClose];
}

- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *)error
{
    _ad = nil;
    [self adFailed:error.localizedDescription];
}

- (void)adColonyInterstitialDidReceiveClick:(AdColonyInterstitial *)interstitial
{
    [self adDidClick];
}

-(void)adColonyInterstitialWillOpen:(AdColonyInterstitial *)interstitial
{
    [self adDidShown];
}

- (void)adColonyInterstitial:(AdColonyInterstitial *)interstitial iapOpportunityWithProductId:(NSString *)iapProductID andEngagement:(AdColonyIAPEngagement)engagement
{
}

-(void)adColonyInterstitialWillLeaveApplication:(AdColonyInterstitial *)interstitial
{
}
@end
