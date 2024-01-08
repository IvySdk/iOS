//
//  SDKFirebaseInit.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKAdcolonyInit.h"
#import <IvyiOSSdk/SDKCache.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <AdColony/AdColony.h>
@implementation SDKAdcolonyInit
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    @try {
        NSString *appid = [data objectForKey:@"appid"];
        NSArray *_zones = [data objectForKey:@"zones"];
        DLog(@"[adlog] [init] [adcolony] [%@]", appid);
        if (!_zones) {
            _zones = [data objectForKey:@"placements"];
        }
        if(appid && _zones && _zones.count > 0) {
            [AdColony configureWithAppID:appid options:nil completion:^(NSArray<AdColonyZone *> * _Nonnull zones) {
                            if (onComplete) {
                                onComplete();
                            }
            }];
        }
    } @catch (NSException *exception) {
        DLog(@"[adlog] adcolony: %@", exception.description);
    } @finally {
    }
}
@end
