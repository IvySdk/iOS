//
//  SDKFirebaseCore.h
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import <Foundation/Foundation.h>
#import <IvyiOSSdk/SDKBaseInit.h>
#import <IvyiOSSdk/SDKRemoteConfigDelegate.h>
#import <IvyiOSSdk/SDKExtendDelegate.h>
#import <LightGameSDK/LightGameSDK.h>
@interface SDKDouyinInit : SDKBaseInit<SDKExtendDelegate,
LGTikTokShareDelegate,
SDKRemoteConfigDelegate, LightGameVideoApplyProtocol>
@end
