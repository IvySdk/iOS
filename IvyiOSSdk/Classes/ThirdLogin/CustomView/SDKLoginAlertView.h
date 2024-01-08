//
//  LoginDialog.h
//  Pods
//
//  Created by ivy on 2020/10/21.
//


#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizer.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>
#import "SDKThirdLoginDialogDelegate.h"

@interface SDKLoginAlertView : UIView<UIGestureRecognizerDelegate,UITextViewDelegate,UITextFieldDelegate>

- (instancetype _Nonnull ) initWithDelegate:(id<SDKThirdLoginDialogDelegate> _Nonnull) delegate;

- (void)showLoginDialogWithAnonymous:(BOOL) showAnonymous cancelable:(BOOL) cancelable weChatInstalled:(BOOL) weChatInstalled;

- (void)showVerifyIdCardDialog;

- (void)showUserProtocolDialog;

- (void)showUserAgreementDialog;

- (void)showPrivacyDialog;

- (void)hideAllAlertView;

@end
