//
//  SDKGoogleTestInit.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKGoogleTestInit.h"
#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonDigest.h>
#ifdef GOOGLE
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif
#ifdef FB_AUDIENCE
#import <FBAudienceNetwork/FBAdSettings.h>
#endif
@implementation SDKGoogleTestInit
-(void)doInit:(NSDictionary *)data
{
    @try {
        NSLog(@"[adlog] [init] [googletest]");
#ifdef GOOGLE
        NSString *admob_testdevice = [self admobDeviceID];
        NSLog(@"[adlog] [admob testDevice : %@]", admob_testdevice);
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[admob_testdevice];
//        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @[ @"eb1829c8bc783d0e623e2383fe4156a4" ];
#endif
#ifdef FB_AUDIENCE
        NSString *facebook_testdevice = [FBAdSettings testDeviceHash];
        NSLog(@"[adlog] [facebook testDevice : %@]", facebook_testdevice);
        [FBAdSettings setLogLevel:FBAdLogLevelLog];
        [FBAdSettings addTestDevice:facebook_testdevice];
//        [FBAdSettings addTestDevice:@"a4377c2698318a567c3461490e8868bcff69b919"];
#endif
        [GoogleMobileAdsMediationTestSuite presentOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController delegate:self];
    } @catch (NSException *exception) {
        NSLog(@"[adlog] googletest: %@", exception.description);
    } @finally {
    }
}

- (void)mediationTestSuiteWasDismissed
{
    NSLog(@"%@", @"[adlog] Google Test dismissed!");
}
#ifdef GOOGLE
- (NSString *) admobDeviceID
{
    NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    const char *cStr = [adid.UUIDString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;

}
#endif
@end
