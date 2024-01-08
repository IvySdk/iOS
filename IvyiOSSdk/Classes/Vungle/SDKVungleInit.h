//
//  SDKFirebaseInit.h
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import <Foundation/Foundation.h>
#import <IvyiOSSdk/SDKBaseInit.h>
#import <IvyiOSSdk/SDKBaseAd.h>
#import <VungleSDK/VungleSDK.h>
@interface SDKVungleInit : SDKBaseInit<VungleSDKDelegate>
-(void)addVideo:(nonnull SDKBaseAd *)video placement:(nonnull NSString *)placement;
-(nullable SDKBaseAd *)getVideo:(nonnull NSString *)placement;
+(nonnull instancetype)sharedInstance;
@end
