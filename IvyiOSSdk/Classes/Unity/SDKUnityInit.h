//
//  SDKUnityInit.h
//  Bolts
//
//  Created by 余冰星 on 2019/5/5.
//

#import <Foundation/Foundation.h>
#import <UnityAds/UnityAds.h>
#import <IvyiOSSdk/SDKBaseAd.h>
#import <IvyiOSSdk/SDKBaseBanner.h>
#import <IvyiOSSdk/SDKBaseInit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SDKUnityInit : SDKBaseInit<UnityAdsInitializationDelegate>
-(void)addToLoadQueue:(nonnull SDKBaseAd *)ad; +(instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
