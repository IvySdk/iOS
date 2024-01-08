//
//  SDKVerifyIdCard.h
//  FlatUIKit
//
//  Created by 余冰星 on 2020/2/25.
//

#import <Foundation/Foundation.h>
#import <IvyiOSSdk/SDKCustomAlertView.h>

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
//#import <Weibo_SDK/WeiboSDK.h>
#import <SDKThirdLoginDialogDelegate.h>
#import <AuthenticationServices/AuthenticationServices.h>

#define Tag_Anonymous 0
#define Tag_Apple 1
#define Tag_WeChat 2
#define Tag_QQ 3
#define Tag_WeiBo 4

NS_ASSUME_NONNULL_BEGIN
@interface SDKThirdLogin : NSObject<WXApiDelegate,TencentSessionDelegate,SDKThirdLoginDialogDelegate,
//WeiboSDKDelegate,
ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

- (instancetype) initWithConf:(NSDictionary *) conf;

-(void) showUserProtocolDialog;

-(void) startVerifyIdCard:(NSString *) uuid;

-(void) startLoginWithAnonymous:(BOOL) showAnonymous isCancelable:(BOOL) cancelable;

-(void) showPrivacyDialog;

-(void) showUserAgreementDialog;

-(NSString *) me;

-(int) getIdCardVerifiedAge;

-(void) setIdCardVerified:(int) age;

-(void) resetVerifyIdCard;

-(void) handleOpenUniversalLink:(NSUserActivity *)activity;

-(void) handleOpenUrl:(NSURL *)url;

-(BOOL)checkCanPay;
-(void)paySuccess:(double)price;

@end

NS_ASSUME_NONNULL_END
