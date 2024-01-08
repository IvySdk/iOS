//
//  SDKIronsourceVideo.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKIronsourceInterstitial.h"
#import "SDKIronsourceInit.h"
@implementation SDKIronsourceInterstitial
{
@private
    UIView *_adView;
}

-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        [[SDKIronsourceInit sharedInstance] setInter:self placement:_adId];
        [IronSource loadISDemandOnlyInterstitial:_adId];
        return true;
    }
    return false;
}

-(void)showAd:(UIViewController *)vc
{
    [super showAd:vc];
    if([self isAvailable]) {
        [IronSource showISDemandOnlyInterstitial:vc instanceId:_adId];
    } else {
        [self adShowFailed];
    }
}

-(BOOL)isAvailable
{
    _isAvailable = [IronSource hasISDemandOnlyInterstitial:_adId];
    return [super isAvailable];
}
@end
