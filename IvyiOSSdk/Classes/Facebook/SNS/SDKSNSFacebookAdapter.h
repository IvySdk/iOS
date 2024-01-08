//
//  SDKSNSFacebookAdapter.h
//  Pods
//
//  Created by 余冰星 on 2017/8/4.
//
//

#import <Foundation/Foundation.h>
#import <IvyiOSSdk/SDKSNSAdapter.h>
#import <IvyiOSSdk/SBJson5.h>
@import FBSDKCoreKit;
@import FBSDKLoginKit;
@import FBSDKShareKit;
@interface SDKSNSFacebookAdapter : SDKSNSAdapter<FBSDKSharingDelegate>

@end
