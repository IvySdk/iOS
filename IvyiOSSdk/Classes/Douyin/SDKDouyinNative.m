//
//  SDKDouyinNative.m
//  Bolts
//
//  Created by 余冰星 on 2017/12/25.
//

#import "SDKDouyinNative.h"
#import "SDKDouyinNativeView.h"
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKDouyinNative
{
    @private
    LGNativeAd *_nativeAd;
}
#pragma mark ================== Native Ads ===================
-(NSString *)defaultNibName
{
    return @"SDKDouyinNativeView";
}

-(NSString *)defaultBundleName
{
    return @"IvyiOSSdk-Douyin";
}

-(Class)nativeAdViewClass
{
    return [SDKDouyinNativeView class];
}

-(BOOL)loadAd
{
    if([super loadAd]) {
        LGAdSlot *slot = [[LGAdSlot alloc] init];
        LGAdSize *imgSize = [[LGAdSize alloc] init];
        imgSize.width = 450;
        imgSize.height = 300;
        slot.imgSize = imgSize;
        slot.ID = _adId;
        slot.isOriginAd = YES;
        slot.AdType = LGAdSlotAdTypeBanner;
        slot.position = LGAdSlotPositionBottom;
        slot.isSupportDeepLink = YES;
        _nativeAd = [[LGNativeAd alloc] initWithSlot:slot];
        _nativeAd.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        _nativeAd.delegate = self;
        [_nativeAd loadAdData];
        return true;
    }
    return false;
}

-(NSMutableDictionary *)nativeAdToDict:(nonnull id)nativeAd
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    LGNativeAd *ad = (LGNativeAd *)nativeAd;
    if (ad.data != nil) {
        [data setObject:ad.data.AdTitle forKey:@"title"];
        [data setObject:ad.data.AdDescription forKey:@"body"];
        [data setObject:ad.data.source forKey:@"adChoicesText"];
        [data setObject:ad.data.buttonText forKey:@"actionText"];
        //    [data setObject:ad.subtitle forKey:@"subtitle"];
        //    [data setObject:ad.icon.url.absoluteString forKey:@"icon"];
        //    [data setObject:ad.coverImage.url.absoluteString forKey:@"cover"];
    }
    return data;
}
#pragma mark ================== FBNativeAdDelegate ===================
- (void)nativeAdDidLoad:(LGNativeAd *)nativeAd
{
    [self adLoaded:nativeAd];
}

- (void)nativeAdDidBecomeVisible:(LGNativeAd *)nativeAd
{
    [self adDidShown];
}

- (void)nativeAd:(LGNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    [self adFailed:error ? error.description : nil];
}

- (void)nativeAdDidClick:(LGNativeAd *)nativeAd withView:(UIView *)view
{
    [self adDidClick];
}

- (void)nativeAd:(LGNativeAd *)nativeAd dislikeWithReason:(NSArray<LGDislikeWords *> *)filterWords
{
}
@end
