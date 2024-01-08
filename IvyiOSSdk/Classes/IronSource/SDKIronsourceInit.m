//
//  SDKIronsourceInit.m
//  Bolts
//
//  Created by 余冰星 on 2019/5/5.
//

#import "SDKIronsourceInit.h"
#import <IvyiOSSdk/SDKVideo.h>

@implementation SDKIronsourceInit
@synthesize interMap = _interMap;
@synthesize videoMap = _videoMap;
static SDKIronsourceInit *_instance;
+(instancetype)sharedInstance
{
    return _instance;
}
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    _instance = self;
    NSString *appId = [data objectForKey:@"appid"];
    DLog(@"[adlog] [init] [ironsource] [%@]", appId);
    if (!appId) {
        @throw [[NSException alloc] initWithName:@"[IronSource init error]" reason:@"IronSource init appid not setting!" userInfo:nil];
        return;
    }
    [IronSource initISDemandOnly:appId adUnits:@[IS_REWARDED_VIDEO, IS_INTERSTITIAL]];
//    [IronSource setAdaptersDebug:YES];
    [IronSource setISDemandOnlyInterstitialDelegate:self];
    [IronSource setISDemandOnlyRewardedVideoDelegate:self];
    if (onComplete) {
        onComplete();
    }
}

-(NSMutableDictionary<NSString *,SDKInterstitial *> *)interMap
{
    if (!_interMap) {
        _interMap = [[NSMutableDictionary alloc] init];
    }
    return _interMap;
}

-(NSMutableDictionary<NSString *,SDKVideo *> *)videoMap
{
   if (!_videoMap) {
        _videoMap = [[NSMutableDictionary alloc] init];
    }
    return _videoMap;
}

-(void)setInter:(SDKInterstitial *)ad placement:(NSString *)placement
{
    [IronSource setISDemandOnlyInterstitialDelegate:self];
    [self.interMap setObject:ad forKey:placement];
}

-(void)setVideo:(SDKVideo *)ad placement:(NSString *)placement
{
    [IronSource setISDemandOnlyRewardedVideoDelegate:self];
    [self.videoMap setObject:ad forKey:placement];
}

#pragma mark -
#pragma mark Delegate
/**
 Called after a rewarded video has changed its availability.
 
 @param available The new rewarded video availability. YES if available and ready to be shown, NO otherwise.
 */
- (void)rewardedVideoHasChangedAvailability:(BOOL)available instanceId:(NSString *)instanceId
{
    if (available) {
        SDKVideo *ad = [self.videoMap objectForKey:instanceId];
        if (ad) {
            [ad adLoaded];
        }
    }
}

/**
 Called after a rewarded video has been opened.
 */
- (void)rewardedVideoDidOpen:(NSString *)instanceId
{
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adDidShown];
    }
}

/**
 Called after a rewarded video has been dismissed.
 */
- (void)rewardedVideoDidClose:(NSString *)instanceId
{
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adDidClose];
    }
}

- (void)rewardedVideoAdRewarded:(NSString *)instanceId {
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adReward];
    }
}


- (void)rewardedVideoDidClick:(NSString *)instanceId {
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adDidClick];
    }
}


- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adFailed:error.localizedDescription];
    }
}


- (void)rewardedVideoDidLoad:(NSString *)instanceId {
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adLoaded];
    }
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    SDKVideo *ad = [self.videoMap objectForKey:instanceId];
    if (ad) {
        [ad adShowFailed];
    }
}


/**
 Called after an interstitial has been loaded
 */
- (void)interstitialDidLoad:(NSString *)instanceId
{
    SDKInterstitial *ad = [self.interMap objectForKey:instanceId];
    if (ad) {
        [ad adLoaded];
    }
}

/**
 Called after an interstitial has attempted to load but failed.

 @param error The reason for the error
 */
- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    SDKInterstitial *ad = [self.interMap objectForKey:instanceId];
    if (ad) {
        [ad adFailed:error.localizedDescription];
    }
}

/**
 Called after an interstitial has been opened.
 */
- (void)interstitialDidOpen:(NSString *)instanceId
{
}

/**
  Called after an interstitial has been dismissed.
 */
- (void)interstitialDidClose:(NSString *)instanceId
{
    SDKInterstitial *ad = [self.interMap objectForKey:instanceId];
    if (ad) {
        [ad adDidClose];
    }
}

/**
 Called after an interstitial has been displayed on the screen.
 */
- (void)interstitialDidShow:(NSString *)instanceId
{
    SDKInterstitial *ad = [self.interMap objectForKey:instanceId];
    if (ad) {
        [ad adDidShown];
    }
}

/**
 Called after an interstitial has attempted to show but failed.

 @param error The reason for the error
 */
- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId
{
    SDKInterstitial *ad = [self.interMap objectForKey:instanceId];
    if (ad) {
        [ad adShowFailed];
    }
}

/**
 Called after an interstitial has been clicked.
 */
- (void)didClickInterstitial:(NSString *)instanceId
{
    SDKInterstitial *ad = [self.interMap objectForKey:instanceId];
    if (ad) {
        [ad adDidClick];
    }
}

@end
