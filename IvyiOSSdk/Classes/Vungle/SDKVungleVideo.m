//
//  SDKVungleVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//
#import "SDKVungleVideo.h"
#import "SDKVungleInit.h"
#import <VungleSDK/VungleSDK.h>
@implementation SDKVungleVideo
#pragma mark ================== Reward Video ===================
-(instancetype)init:(NSString *)tag index:(int)index config:(NSDictionary *)config size:(nullable NSString *)size orientation:(SDK_ORIENTATION)orientation delegate:(id<SDKAdDelegate>)delegate
{
    self = [super init:tag index:index config:config size:size orientation:orientation delegate:delegate];
    [[SDKVungleInit sharedInstance] addVideo:self placement:_adId];
    return self;
}

-(BOOL)loadAd:(UIViewController *)vc
{
    if ([super loadAd:vc]) {
        NSError *error = nil;
        if([VungleSDK sharedSDK].isInitialized) {
            if ([self isAvailable]) {
                [self adLoaded];
            } else {
                [[VungleSDK sharedSDK] loadPlacementWithID:_adId error:&error];
            }
        }
        return true;
    }
    return false;
}

-(BOOL)isAvailable
{
    [super setIsAvailable:[[VungleSDK sharedSDK] isAdCachedForPlacementID:_adId]];
    return [super isAvailable];
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]) {
        NSError *error;
        [[VungleSDK sharedSDK] playAd:vc options:nil placementID:_adId error:&error];
        [self startCheckShowFailedTimer];
        if (error) {
            [self adFailed:error.localizedDescription];
        }
    } else {
        [self adShowFailed];
    }
}
@end
