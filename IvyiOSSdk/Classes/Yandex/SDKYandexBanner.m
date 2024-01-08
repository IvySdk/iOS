//
//  SDKYandexBanner.m
//  Pods
//
//  Created by IceStar on 2023/06/01.
//
//

#import "SDKYandexBanner.h"
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKYandexBanner
#pragma mark ================== Banner AD ===================
-(BOOL)loadAd:(UIViewController *)vc
{
    if([super loadAd:vc]) {
        if (!_adView) {
            YMAAdSize *adSize = [YMAAdSize inlineSizeWithWidth:Screen_width maxHeight:90.f];
            YMAAdView *adView = [[YMAAdView alloc] initWithAdUnitID:_adId adSize:adSize];
            adView.delegate = self;
            [self setAdView:adView];
        }
        if (_adView) {
            [(YMAAdView *)_adView loadAd];
            return true;
        }
    }
    return false;
}

-(void)adViewDidLoad:(YMAAdView *)adView
{
    [self adLoaded];
}

-(void)adViewDidFailLoading:(YMAAdView *)adView error:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

-(void)adViewDidClick:(YMAAdView *)adView
{
    [self adDidClick];
}
@end
