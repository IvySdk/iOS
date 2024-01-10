#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SDKAIHelp.h"
#import "SDKAppsflyerAnalyse.h"
#import "SDKAppsflyerInit.h"
#import "SDKCustomAlertView.h"
#import "SDKDebug.h"
#import "SDKDefine.h"
#import "SDKSwipeView.h"
#import "SDKCache.h"
#import "SDKDiskCache.h"
#import "SDKKVStorage.h"
#import "SDKMemoryCache.h"
#import "EasyAlertConfig.h"
#import "EasyAlertGlobalConfig.h"
#import "EasyAlertItem.h"
#import "EasyAlertPart.h"
#import "EasyAlertTypes.h"
#import "EasyAlertView.h"
#import "EasyEmptyConfig.h"
#import "EasyEmptyGlobalConfig.h"
#import "EasyEmptyPart.h"
#import "EasyEmptyTypes.h"
#import "EasyEmptyView.h"
#import "EasyLoadingConfig.h"
#import "EasyLoadingGlobalConfig.h"
#import "EasyLoadingTypes.h"
#import "EasyLoadingView.h"
#import "EasyShowLabel.h"
#import "EasyShowUtils.h"
#import "EasyShowView.h"
#import "EasyTextBgView.h"
#import "EasyTextConfig.h"
#import "EasyTextGlobalConfig.h"
#import "EasyTextTypes.h"
#import "EasyTextView.h"
#import "UIView+EasyShowExt.h"
#import "CALayer+XibBorderColor.h"
#import "MBProgressHUD+Extension.h"
#import "NSData+AES256.h"
#import "NSString+Base64.h"
#import "NSString+URLEncoding.h"
#import "UIImage+animatedGIF.h"
#import "MBProgressHUD.h"
#import "SDKHTTPSessionManager.h"
#import "SDKNetworkActivityIndicatorManager.h"
#import "SDKNetworkCache.h"
#import "SDKNetworkHelper.h"
#import "SDKNetworking.h"
#import "SDKNetworkReachabilityManager.h"
#import "SDKSecurityPolicy.h"
#import "SDKURLRequestSerialization.h"
#import "SDKURLResponseSerialization.h"
#import "SDKURLSessionManager.h"
#import "SDKAutoPurgingImageCache.h"
#import "SDKImageDownloader.h"
#import "UIActivityIndicatorView+SDKNetworking.h"
#import "UIButton+SDKNetworking.h"
#import "UIImage+SDKNetworking.h"
#import "UIImageView+SDKNetworking.h"
#import "UIKit+SDKNetworking.h"
#import "UIProgressView+SDKNetworking.h"
#import "UIRefreshControl+SDKNetworking.h"
#import "UIWebView+SDKNetworking.h"
#import "SBJson5.h"
#import "SBJson5Parser.h"
#import "SBJson5StreamParser.h"
#import "SBJson5StreamParserState.h"
#import "SBJson5StreamTokeniser.h"
#import "SBJson5StreamWriter.h"
#import "SBJson5StreamWriterState.h"
#import "SBJson5Writer.h"
#import "SDKTween.h"
#import "SDKTweenTimingFunctions.h"
#import "UICKeyChainStore.h"
#import "GTMBase64.h"
#import "GTMDefines.h"
#import "SDKGCDTimer.h"
#import "SDKGCDTimer2.h"
#import "SDKHapticHelper.h"
#import "SDKJSONHelper.h"
#import "SDKKeychainUtils.h"
#import "SDKLocalize.h"
#import "SDKLocalizeManager.h"
#import "SDKNinePatchImageFactory.h"
#import "SDKObjectPool.h"
#import "SDKTimer.h"
#import "SDKUserDB.h"
#import "SDKBannerModule.h"
#import "SDKBaseAd.h"
#import "SDKBaseAdModule.h"
#import "SDKBaseBanner.h"
#import "SDKDeliciousBanner.h"
#import "SDKDeliciousBannerView.h"
#import "SDKDeliciousIconView.h"
#import "SDKDeliciousInterstitial.h"
#import "SDKInterstitial.h"
#import "SDKInterstitialModule.h"
#import "SDKInterstitialViewController.h"
#import "SDKNative.h"
#import "SDKNativeModule.h"
#import "SDKNativeView.h"
#import "SDKOurBanner.h"
#import "SDKOurInterstitial.h"
#import "SDKOurNative.h"
#import "SDKOurNativeView.h"
#import "SDKPopupIconAdView.h"
#import "SDKVideo.h"
#import "SDKVideoModule.h"
#import "SDKAdDelegate.h"
#import "SDKCloudFunctionDelegate.h"
#import "SDKDelegate.h"
#import "SDKExtendDelegate.h"
#import "SDKFirebaseDatabaseDelegate.h"
#import "SDKFirestoreDelegate.h"
#import "SDKGameCenterDelegate.h"
#import "SDKInAppMessageDelegate.h"
#import "SDKNativeDelegate.h"
#import "SDKPaymentDelegate.h"
#import "SDKPerformanceDelegate.h"
#import "SDKRemoteConfigDelegate.h"
#import "SDKSNSDelegate.h"
#import "SDKWebviewDelegate.h"
#import "SDKAnalyse.h"
#import "SDKApplication.h"
#import "SDKAutoEvent.h"
#import "SDKBaseInit.h"
#import "SDKConstants.h"
#import "SDKFacade.h"
#import "SDKFacadeCocos.hpp"
#import "SDKGCManager.h"
#import "SDKGCMultiplayer.h"
#import "SDKGdpr.h"
#import "SDKHelper.h"
#import "SDKIAPHelper.h"
#import "SDKIvyAnalyse.h"
#import "SDKPush.h"
#import "SDKRemoteConfig.h"
#import "SDKSNSAdapter.h"
#import "SDKStartPromotionAd.h"
#import "SDKUIApplication.h"
#import "SDKFacebookAnalyse.h"
#import "SDKFacebookInit.h"
#import "SDKSNSFacebookAdapter.h"
#import "SDKFirebaseAnalyse.h"
#import "SDKFirebaseInit.h"
#import "SDKFirebasePush.h"
#import "SDKFirebaseDatabase.h"
#import "SDKFirebaseFirestore.h"
#import "SDKFirebaseFunction.h"
#import "SDKFirebaseInAppMessage.h"
#import "SDKAdmobBanner.h"
#import "SDKAdmobInit.h"
#import "SDKAdmobInterstitial.h"
#import "SDKAdmobNative.h"
#import "SDKAdmobNativeView.h"
#import "SDKAdmobRequest.h"
#import "SDKAdmobVideo.h"
#import "AdsCustomEvent.h"
#import "AdsCustomEventBanner.h"
#import "AdsCustomEventConstants.h"
#import "AdsCustomEventInterstitial.h"
#import "AdsCustomEventRewardAd.h"
#import "AdsCustomEventUtils.h"
#import "SDKGoogleGdpr.h"
#import "SDKDfpBanner.h"
#import "SDKDfpInterstitial.h"
#import "SDKDfpRequest.h"
#import "SDKDfpVideo.h"

FOUNDATION_EXPORT double IvyiOSSdkVersionNumber;
FOUNDATION_EXPORT const unsigned char IvyiOSSdkVersionString[];

