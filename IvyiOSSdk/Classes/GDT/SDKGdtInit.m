//
//  SDKFirebaseCore.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKGdtInit.h"
#import "GDTSDKConfig.h"
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKDefine.h>

@implementation SDKGdtInit
{
    @private
    NSDictionary *_defaultRemoteConfig;
}
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    @try {
        NSString *appid = [data objectForKey:@"appid"];

    
        [GDTSDKConfig registerAppId:appid];
        [GDTSDKConfig enableDefaultAudioSessionSetting: NO];
        if (onComplete) {
            onComplete();
        }
    } @catch (NSException *exception) {
        DLog(@"[GDT]: %@", exception.description);
    } @finally {
    }
}


@end
