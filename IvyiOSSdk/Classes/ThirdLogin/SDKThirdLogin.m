//
//  SDKVerifyIdCard.m
//  FlatUIKit
//
//  Created by 余冰星 on 2020/2/25.
//

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <SDKThirdLogin.h>
#import <IvyiOSSdk/SDKHelper.h>
#import <IvyiOSSdk/SDKGCDTimer.h>
#import <IvyiOSSdk/SDKCache.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKNetworkHelper.h>
#import <IvyiOSSdk/SDKNewVerifyIdCard.h>
#import <IvyiOSSdk/SDKHTTPSessionManager.h>
#import <IvyiOSSdk/EasyTextView.h>
#import <IvyiOSSdk/EasyAlertView.h>
#import "WXApi.h"
#import "SDKLoginAlertView.h"
#import "EasyShowView.h"

NSString * const WeChat_Universal_Link = @"https://www.ivymobile.cn/532/";
NSString * const WeChat_Auth_Url = @"https://api.weixin.qq.com/sns/oauth2";
NSString * const WeiBo_Redirect_Url = @"http://www.ivymobile.cn/";

@implementation SDKThirdLogin{
    NSString *wechatAppId;
    NSString *wechatAppSecret;
    NSString *qqAppId;
//    NSString *weiboAppId;
    NSString *idcardCheckUrl;
    
    NSString  *_currentSelectedPlatform;
    TencentOAuth *_tencentOAuth;
    BOOL isWechatSdkInit;
//    BOOL isWeiboSdkInit;
    
    NSString *lastLoginInfo;
    
    SDKLoginAlertView *_alertView;
    
    NSArray *authPlatforms;
    NSString *uuid;
}

- (instancetype) initWithConf:(NSDictionary *) conf
{
    self = [super init];
    if(self){
        wechatAppId = [conf objectForKey:@"wechat_app_id"];
        wechatAppSecret = [conf objectForKey:@"wechat_app_secret"];
        qqAppId = [conf objectForKey:@"qq_app_id"];
//        weiboAppId = [conf objectForKey:@"weibo_app_key"];
        idcardCheckUrl = [conf objectForKey:@"id_card_check_url"];
        authPlatforms = @[@"Anonymous",@"Apple",@"WeChat",@"QQ",@"WeiBo"];
        
        _alertView = [[SDKLoginAlertView alloc] initWithDelegate:self];
        //初始化一下
        [[SDKNewVerifyIdCard sharedInstance] paySuccess:0];
    }
    return self;
}

-(BOOL)checkCanPay
{
    return [[SDKNewVerifyIdCard sharedInstance] checkCanPay];
}

-(void)paySuccess:(double)price
{
    [[SDKNewVerifyIdCard sharedInstance] paySuccess:price];
}

-(void) showPrivacyDialog{
    [_alertView showPrivacyDialog];
}

-(void) showUserAgreementDialog{
    [_alertView showUserAgreementDialog];
}

-(void) startVerifyIdCard:(NSString *) uuid
{
    self -> uuid = uuid;
    //弹出身份证验证的dialog
    [_alertView showVerifyIdCardDialog];
}

-(void)showUserProtocolDialog
{
    [_alertView showUserProtocolDialog];
}

-(void)startLoginWithAnonymous:(BOOL) showAnonymous isCancelable:(BOOL) cancelable
{
    bool isWechatInstalled = [WXApi isWXAppInstalled];
    [_alertView showLoginDialogWithAnonymous:showAnonymous cancelable:cancelable weChatInstalled:isWechatInstalled];
}

-(NSString *) me
{
    return self -> lastLoginInfo ? self -> lastLoginInfo : @"{}";
}

-(int) getIdCardVerifiedAge
{
    return [[SDKNewVerifyIdCard sharedInstance] age];
}

- (void)setIdCardVerified:(int)age
{
    [[SDKNewVerifyIdCard sharedInstance] setAge:age];
    [[SDKNewVerifyIdCard sharedInstance] setIdCard:@""];
    [[SDKNewVerifyIdCard sharedInstance] setName:@""];
}

-(void) resetVerifyIdCard{
    [[SDKNewVerifyIdCard sharedInstance] resetVerifyIdCard];
}

#pragma mark - 具体平台登录请求

- (void)qqAuth{
    if(!_tencentOAuth){
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:self];
    }
    NSArray *permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,    //获取用户信息
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,    //移动端获取用户信息
                                nil];
    [_tencentOAuth authorize:permissions];
}

- (void)wechatAuth{
    if(!isWechatSdkInit){
        [WXApi registerApp:wechatAppId universalLink:WeChat_Universal_Link];
        isWechatSdkInit = true;
    }
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req completion:^(BOOL success) {
            if(!success){
                [[SDKFacade sharedInstance]  onThirdLoginError:@"cannot send login request to wechat client!" platformType:self->_currentSelectedPlatform];
            }
        }];
    }else{
//        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [WXApi sendAuthReq:req viewController:vc delegate:self completion:^(BOOL success) {
//            [[SDKFacade sharedInstance]  onThirdLoginError:@"cannot send login request to wechat client!" platformType:self->_currentSelectedPlatform];
//        }];
        //[self handlePlatformClientNotInstalled:_currentSelectedPlatform];
    }
}

//-(void)weiboAuth{
//    if(!isWeiboSdkInit){
//        [WeiboSDK registerApp:weiboAppId universalLink:WeiBo_Redirect_Url];
//        isWeiboSdkInit = true;
//    }
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = WeiBo_Redirect_Url;
//    request.scope = @"all";
//    request.userInfo = @{@"SSO_From":@"SendMessageToWeiboViewController",
//                         @"Other_Info_1":[NSNumber numberWithInt:123],
//                         @"Other_Info_2":@[@"obj1",@"obj2"],
//                         @"Other_Info_3":@{@"key1":@"obj1",@"key2":@"obj2"}
//    };
//
//    [WeiboSDK sendRequest:request completion:^(BOOL success) {
//        DLog(@"send request to weibo client result: %d",success);
//    }];
////    if ([WeiboSDK isWeiboAppInstalled]) {
////
////    }else{
////        [self handlePlatformClientNotInstalled:self -> _currentSelectedPlatform];
////    }
//}

-(void) appleAuth API_AVAILABLE(ios(13.0)){
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}
 
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            SendAuthResp *resp2 = (SendAuthResp *) resp;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wxLogin" object:resp2.code];

            NSString *authUrl = [NSString stringWithFormat:@"%@/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChat_Auth_Url,wechatAppId,wechatAppSecret,resp2.code];
            [[SDKNetworkHelper sharedHelper] GET:authUrl parameters:nil jsonRequest:false jsonResponse:true success:^(id  _Nullable responseObject) {
                if(responseObject && [responseObject isKindOfClass:[NSDictionary class]]){
                    NSString *openId = responseObject[@"openid"];
                    DLog(@"obtain openid from server: %@",openId);
                    [self handleSuccessGetOpenId:openId platformType:self ->_currentSelectedPlatform];
                }else{
                    [[SDKFacade sharedInstance]  onThirdLoginError:[NSString stringWithFormat:@"auth server response error: %@",responseObject] platformType:self -> _currentSelectedPlatform];
                }
            } failure:^(NSError * _Nullable error) {
                [[SDKFacade sharedInstance]  onThirdLoginError:[NSString stringWithFormat:@"auth server response error: %@",error.localizedFailureReason] platformType:self -> _currentSelectedPlatform];
            }];
        } else { //失败
            [[SDKFacade sharedInstance] onThirdLoginError:[NSString stringWithFormat:@"wechat response with error code: %d",resp.errCode] platformType:_currentSelectedPlatform];
        }
    }
}

#pragma mark - 集中处理回调事件

-(void) handleSelectAnonymous
{
    [self generateLoginInfo:@"" platformType:@"anonymous"];
    [[SDKFacade sharedInstance] onThirdLoginAnonymous];
    [_alertView hideAllAlertView];
}

-(void) handlePlatformClientNotInstalled:(NSString *) platform
{
    [EasyTextView showErrorText:[NSString stringWithFormat:@"%@ 客户端未安装！",platform]];
}

-(void) handleSuccessGetOpenId:(NSString *)openId platformType:(NSString *)platform
{
    [self generateLoginInfo:openId platformType:platform];
    [[SDKFacade sharedInstance] onThirdLoginSuccess:platform platformType:openId];
    [_alertView hideAllAlertView];
}

-(void) generateLoginInfo:(NSString *)openId platformType:(NSString *)platformType
{
    self -> lastLoginInfo = [NSString stringWithFormat:@"{\"platform\":\"%@\",\"openid\":\"%@\"}",platformType,openId];
}

#pragma mark - do openurl callback
-(void)handleOpenUrl:(NSURL *)url
{
    if ([url.scheme hasPrefix:@"wx"]){
        [WXApi handleOpenURL:url delegate:self];
    } else if ([url.scheme hasPrefix:@"wb"]) {
//        [WeiboSDK handleOpenURL:url delegate:self];
    } else if ([url.scheme hasPrefix:@"tencent"]) {
        [TencentOAuth HandleOpenURL:url];
    }
}

-(void)handleOpenUniversalLink:(NSUserActivity *)activity
{
    [WXApi handleOpenUniversalLink:activity delegate:self];
}

#pragma  mark - TencentSessionDelegate, tencent qq callback
- (void)tencentDidLogin {
    [self handleSuccessGetOpenId:_tencentOAuth.openId platformType:_currentSelectedPlatform];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    [[SDKGCDTimer sharedInstance] scheduleGCDTimerWithName:SDK_DEMO_TIMER interval:0.5 queue:dispatch_get_main_queue() repeats:NO option:SDKGCDTimerOptionCancelPrevAction action:^{
        if(cancelled){
            [[SDKFacade sharedInstance]  onThirdLoginCancel:self->_currentSelectedPlatform];
        }else{
            [[SDKFacade sharedInstance]  onThirdLoginError:@"qq login with unknown error!" platformType:self->_currentSelectedPlatform];
        }
    }];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
}

- (void)tencentDidNotNetWork {
    [[SDKFacade sharedInstance] onThirdLoginError:@"qq login with network error!" platformType:_currentSelectedPlatform];
}

#pragma  mark - WeiboSDKDelegate, weibo callback
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//    if([response isKindOfClass:WBAuthorizeResponse.class]){
//        WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
//        /*
//         WeiboSDKResponseStatusCodeSuccess               = 0,//成功
//         WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
//         WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
//         WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
//         WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
//         WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
//         WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
//         WeiboSDKResponseStatusCodeUnknown               = -100,*/
//        switch (authResp.statusCode) {
//            case WeiboSDKResponseStatusCodeSuccess:
//                [self handleSuccessGetOpenId:authResp.userID platformType:self -> _currentSelectedPlatform];
//                break;
//            case WeiboSDKResponseStatusCodeUserCancel:
//                [[SDKFacade sharedInstance]  onThirdLoginCancel:self -> _currentSelectedPlatform];
//                break;
//            default:
//                [[SDKFacade sharedInstance]  onThirdLoginError:[NSString stringWithFormat:@"weibo exist error code: %ld",(long)authResp.statusCode] platformType:self -> _currentSelectedPlatform];
//                break;
//        }
//    }
//}

#pragma mark - alertdialog callback

- (void)onSelectedAuthPlatform:(long)platformId{
    if (![[SDKFacade sharedInstance] isNetworkConnected]) {
        [EasyTextView showErrorText:@"请检查设备网络是否开启。"];
        return;
    }
    _currentSelectedPlatform = self -> authPlatforms [platformId];
    switch (platformId) {
        case Tag_Anonymous:
            [self handleSelectAnonymous];
            break;
        case Tag_Apple:
            if (@available(iOS 13.0, *)) {
                [self appleAuth];
            }
            break;
        case Tag_WeChat:
            [self wechatAuth];
            break;
        case Tag_QQ:
            [self qqAuth];
            break;
        case Tag_WeiBo:
//            [self weiboAuth];
            break;
        default:
            break;
    }
}

#pragma mark - 身份证实名认证dialog回调
- (void)onStartVerifyIdCard:(NSString *)playerName idCardNum:(NSString *)idCard {
    [[SDKNewVerifyIdCard sharedInstance]verifyIdCard:idCard name:playerName uuid:self -> uuid verifyUrl:idcardCheckUrl verifyCallback:^(int age) {
        [self -> _alertView hideAllAlertView];
        [[SDKFacade sharedInstance] onThirdLoginReceiveIdCardVerifiedResult:age];
    }];
}

- (void)onPrivacyAccept:(BOOL)accept {
    [[SDKFacade sharedInstance] onThirdLoginPrivacyAccept:accept];
}

#pragma mark - Apple ASAuthorizationControllerDelegate
//sign in with apple 的成功回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *userID = credential.user;
        [self handleSuccessGetOpenId:userID platformType:self -> _currentSelectedPlatform];
    }
}

//失败回调
-(void) authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0))
{
    bool isCancel = false;
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            isCancel = true;
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    if(isCancel){
        [[SDKFacade sharedInstance] onThirdLoginCancel:self -> _currentSelectedPlatform];
    }else{
        [[SDKFacade sharedInstance] onThirdLoginError:errorMsg platformType:self -> _currentSelectedPlatform];
    }
}

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return [UIApplication sharedApplication].keyWindow;
}

@end


