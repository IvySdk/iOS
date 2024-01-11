//
//  SDKAdmobVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKDfpVideo.h"
#import "SDKDfpRequest.h"
#import "SDKFacade.h"
#import <IvyiOSSdk/SDKTimer.h>
#import <GoogleMobileAds/GAMRequest.h>
#import <GoogleMobileAds/GADRewardedAd.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKHelper.h>
@interface SDKDfpVideo () <GADFullScreenContentDelegate>
@end

@implementation SDKDfpVideo
{
@private
    GADRewardedAd *_rewardedAd;
}

#pragma mark ================== Reward Video ===================
-(instancetype)init:(NSString *)tag index:(int)index config:(NSDictionary *)config size:(NSString *)size orientation:(SDK_ORIENTATION)orientation delegate:(id<SDKAdDelegate>)delegate
{
    self = [super init:tag index:index config:config size:size orientation:orientation delegate:delegate];
    _rewardSeconds = 60;
    return self;
}

-(void)adDidClose
{
    _rewardedAd = nil;
    [super adDidClose];
}

-(BOOL)loadAd:(UIViewController *)vc
{
#if DEBUG
    //    _adId = @"ca-app-pub-3940256099942544/1712485313";
#endif
    if([super loadAd:vc]) {
      
      GAMRequest *request = [GAMRequest request];
      [GADRewardedAd loadWithAdUnitID:_adId request:request completionHandler:^(GADRewardedAd *ad, NSError *error) {
          if (error) {
              DLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
              [self adFailed:error.description];
              DLog(@"[adlog] [tag:%@(%d)] [%@:adFailed] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo?self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName:@"admob");
              return;
          }
          self->_rewardedAd = ad;
          self->_rewardedAd.fullScreenContentDelegate = self;
          __weak typeof(self) _self = self;
          self->_rewardedAd.paidEventHandler = ^void(GADAdValue *_Nonnull adValue) {
              __strong typeof(_self) self = _self;
              [[SDKFacade sharedInstance] logAdRevenue:self->_rewardedAd && self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo?self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName:@"admob" mediationType:SdkMediationNetworkTypeGoogleAdMob adType:@"rewarded" adUnit:self->_adId placement:self->_tag country:[SDKHelper getCountryCode].lowercaseString currency:adValue.currencyCode value:adValue.value precision:(int)adValue.precision];
          };
          [self adLoaded];
          DLog(@"[adlog] [tag:%@(%d)] [%@:adLoaded] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo?self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName:@"admob");
      }];
      return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if(_rewardedAd && self.isAvailable) {
        [_rewardedAd presentFromRootViewController:vc userDidEarnRewardHandler:^{
            self->_hasReward = YES;
            DLog(@"[adlog] [tag:%@(%d)] [%@:adReward] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo?self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName:@"admob");
        }];
        [self startCheckShowFailedTimer];
    } else {
        [self adShowFailed];
    }
}

-(void)adFailed:(NSString *)error
{
    _rewardedAd = nil;
    [super adFailed:error];
}

-(void)adShowFailed
{
    _rewardedAd = nil;
    [super adShowFailed];
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    [self adShowFailed];
}

-(void)adDidRecordImpression:(id<GADFullScreenPresentingAd>)ad
{
    [self adDidShown];
    DLog(@"[adlog] [tag:%@(%d)] [%@:adDidShown] [id:%@] [adapter:%@]", self->_tag, self->_index, NSStringFromClass(self.class), self->_adId, self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo?self->_rewardedAd.responseInfo.loadedAdNetworkResponseInfo.adNetworkClassName:@"admob");
}

-(void)adDidRecordClick:(id<GADFullScreenPresentingAd>)ad
{
    [self adDidClick];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self adDidClose];
}
@end
