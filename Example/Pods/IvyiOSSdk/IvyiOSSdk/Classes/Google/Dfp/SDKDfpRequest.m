//
//  SDKDfpRequest.m
//  Bolts
//
//  Created by 余冰星 on 2018/5/24.
//

#import "SDKDfpRequest.h"
#import <IvyiOSSdk/SDKGdpr.h>
#import <IvyiOSSdk/SDKCache.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GoogleMobileAds/GADExtras.h>
#import <GoogleMobileAds/GAMRequest.h>
@implementation SDKDfpRequest
+(GAMRequest *)createRequest
{
  GAMRequest *request = [GAMRequest request];
    id tmp = [[SDKCache cache] objectForKey:@"adsUnderAgeMode"];
    BOOL adsUnderAgeMode = tmp ? [(NSNumber *)tmp boolValue] : NO;
    if (adsUnderAgeMode) {
//        [request tagForChildDirectedTreatment:YES];
        [GADMobileAds.sharedInstance.requestConfiguration tagForChildDirectedTreatment:YES];
    }
//    if ([[SDKFacade sharedInstance] hasGdpr] && ![SDKGdpr enableAdPersonalized]) {
//        GADExtras *extras = [[GADExtras alloc] init];
//        extras.additionalParameters = @{@"npa": @"1"};
//        [request registerAdNetworkExtras:extras];
//    }
    return request;
}
@end
