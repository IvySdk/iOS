//
//  DTBOmSdkHelper.h
//  DTBiOSSDK
//
//  Created by Thanislas, Sahaya on 2/3/22.
//  Copyright © 2022 amazon.com. All rights reserved.
//

#ifndef APSOmSdkHelper_h
#define APSOmSdkHelper_h

@import WebKit;

#define INTEGRATED_OM_VERSION @"1_3_28"
#define DEFAULT_OMSDK_PARTNER_NAME @"Amazon1"

@interface APSOmSdkHelper : NSObject

+ (BOOL) initOmSdk;
+ (BOOL) getFeatureEnableFlag;

- (id)init;
- (BOOL) isInitialized;
- (BOOL) startHTMLDisplayOMSDKAdSession:(WKWebView *)webView;
- (BOOL) startVideoOMSDKAdSession:(WKWebView *)webView;
- (BOOL) signalAdImpression;
- (BOOL) signalAdLoaded;
- (BOOL) addFriendlyObstruction:(UIView *)view;
- (void) cleanup;

@end


#endif /* DTBOmSdkHelper_h */

