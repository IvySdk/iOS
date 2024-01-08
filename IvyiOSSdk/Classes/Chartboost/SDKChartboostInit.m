//
//  SDKFirebaseCore.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKChartboostInit.h"
#import <IvyiOSSdk/SDKDefine.h>
@implementation SDKChartboostInit
-(void)doInit:(NSDictionary *)data onComplete:(nullable dispatch_block_t)onComplete
{
    @try {
        NSString *appid = [data objectForKey:@"appid"];
        NSString *appkey = [data objectForKey:@"appkey"];
        DLog(@"[adlog] [init] [chartboost] [%@]", appid);
        if (appid && appkey) {
            [Chartboost addDataUseConsent:[CHBGDPRDataUseConsent gdprConsent:CHBGDPRConsentBehavioral]];
            [Chartboost addDataUseConsent:[CHBCCPADataUseConsent ccpaConsent:CHBCCPAConsentOptInSale]];
            [Chartboost startWithAppID:appid appSignature:appkey completion:^(CHBStartError * _Nullable error) {
                DLog(@"%@", @"[adlog] chartboost init success!");
            }];
//            [Chartboost setMuted:NO];
            if (onComplete) {
                onComplete();
            }
        } else {
            @throw [NSException exceptionWithName:@"Chartboost init fails!" reason:@"no chartboost appid/appkey, please check your default.json!" userInfo:nil];
        }
    } @catch (NSException *exception) {
        DLog(@"[adlog] chartboost: %@", exception.description);
    } @finally {
    }
}
@end
