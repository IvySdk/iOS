//
//  SDKFirebaseCore.h
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <IvyiOSSdk/SDKBaseInit.h>
#import <IvyiOSSdk/SDKRemoteConfigDelegate.h>
@interface SDKToutiaoInit : SDKBaseInit<BUSplashAdDelegate, SDKRemoteConfigDelegate>
@end
