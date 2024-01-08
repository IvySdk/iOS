//
//  SDKFacebookInit.m
//  FBSDKCoreKit
//
//  Created by 余冰星 on 2019/8/8.
//
#import "SDKFacebookInit.h"
#import <IvyiOSSdk/SDKDefine.h>
@import FBSDKCoreKit;
@implementation SDKFacebookInit
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    DLog(@"[adlog] [init] [facebook]");
    if (onComplete) {
        onComplete();
    }
}
@end
