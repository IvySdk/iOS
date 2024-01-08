//
//  SDKFacebookNative.m
//  Bolts
//
//  Created by 余冰星 on 2017/12/25.
//

#import "SDKFacebookNative.h"
#import "SDKFacebookNativeView.h"
@implementation SDKFacebookNative
{
    @private
    FBNativeAd *_nativeAd;
}
#pragma mark ================== Native Ads ===================
-(NSString *)defaultNibName
{
    return @"SDKFacebookNativeView";
}

-(NSString *)defaultBundleName
{
    return @"IvyiOSSdk-Facebook";
}

-(Class)nativeAdViewClass
{
    return [SDKFacebookNativeView class];
}

-(BOOL)loadAd:(UIViewController *)vc
{
#ifdef DEBUG
//    [FBAdSettings setLogLevel:FBAdLogLevelLog];
//    [FBAdSettings addTestDevice:@"a4377c2698318a567c3461490e8868bcff69b919"];
//    [FBAdSettings addTestDevice:@"HASHED_ID"];
//    [FBAdSettings clearTestDevice:@"HASHED_ID"];
#endif
    if([super loadAd:vc]) {
        FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:_adId];
        nativeAd.delegate = self;
        //    nativeAd.mediaCachePolicy = FBNativeAdsfCachePolicyAll;
        //    [nativeAd loadAd];
        [nativeAd loadAdWithMediaCachePolicy:FBNativeAdsCachePolicyAll];
        return true;
    }
    return false;
}

-(NSMutableDictionary *)nativeAdToDict:(nonnull id)nativeAd
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    FBNativeAd *ad = (FBNativeAd *)nativeAd;
    [data setObject:ad.headline forKey:@"title"];
    [data setObject:ad.bodyText forKey:@"body"];
    [data setObject:ad.adChoicesLinkURL.absoluteString forKey:@"adChoicesLink"];
    [data setObject:ad.adChoicesText forKey:@"adChoicesText"];
    [data setObject:ad.socialContext forKey:@"socialContext"];
    [data setObject:ad.callToAction forKey:@"actionText"];
//    [data setObject:ad.subtitle forKey:@"subtitle"];
//    [data setObject:ad.icon.url.absoluteString forKey:@"icon"];
//    [data setObject:ad.coverImage.url.absoluteString forKey:@"cover"];
    return data;
}
#pragma mark ================== FBNativeAdDelegate ===================
- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    [self adLoaded:nativeAd];
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    [self adDidShown];
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    [self adDidClick];
}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
}
@end
