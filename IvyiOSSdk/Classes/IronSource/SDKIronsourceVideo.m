//
//  SDKIronsourceVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKIronsourceVideo.h"
#import "SDKIronsourceInit.h"
@implementation SDKIronsourceVideo

-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        [[SDKIronsourceInit sharedInstance] setVideo:self placement:_adId];
        [IronSource loadISDemandOnlyRewardedVideo:_adId];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]) {
        [IronSource showISDemandOnlyRewardedVideo:vc instanceId:_adId];
    } else {
        [self adShowFailed];
    }
}

-(BOOL)isAvailable
{
    _isAvailable = [IronSource hasISDemandOnlyRewardedVideo:_adId];
    return [super isAvailable];
}
@end
