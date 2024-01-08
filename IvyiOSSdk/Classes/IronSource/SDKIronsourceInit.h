//
//  SDKIronsourceInit.h
//  Bolts
//
//  Created by 余冰星 on 2019/5/5.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <IvyiOSSdk/SDKInterstitial.h>
#import <IvyiOSSdk/SDKVideo.h>
#import <IvyiOSSdk/SDKBaseBanner.h>
#import <IvyiOSSdk/SDKBaseInit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SDKIronsourceInit : SDKBaseInit<ISDemandOnlyRewardedVideoDelegate, ISDemandOnlyInterstitialDelegate>
@property (nonatomic, nonnull, strong, readonly) NSMutableDictionary<NSString *, SDKInterstitial *> *interMap;
@property (nonatomic, nonnull, strong, readonly) NSMutableDictionary<NSString *, SDKVideo *> *videoMap;
-(void)setInter:(nonnull SDKInterstitial *)ad placement:(nonnull NSString *)placement;
-(void)setVideo:(nonnull SDKVideo *)ad placement:(nonnull NSString *)placement;
+(instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
