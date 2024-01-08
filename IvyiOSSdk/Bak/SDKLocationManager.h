//
//  SDKLocationManager.h
//  MusicRadio
//
//  Created by 余冰星 on 17/3/7.
//  Copyright © 2017年 IVYMOBILE INTERNATIONAL ENTERPRISE LIMITED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <IvyiOSSdk/SDKDefine.h>

typedef void(^SDKLocationSuccess) (double lat, double lng);
typedef void(^SDKLocationFailed) (NSError *error);

@interface SDKLocationManager : NSObject<CLLocationManagerDelegate>

+ (SDKLocationManager *) sharedGpsManager;

+ (void) getSDKLocationWithSuccess:(SDKLocationSuccess)success Failure:(SDKLocationFailed)failure repeatCount:(int)count;

+ (void) stop;

@end
