//
//  LoginDialog.m
//  EasyShowView
//
//  Created by ivy on 2020/10/21.
//

#import <Foundation/Foundation.h>

#import <AuthenticationServices/AuthenticationServices.h>
#import "SDKLoginAlertView.h"
#import "SDKThirdLogin.h"
#import "SDKThirdLoginDialogDelegate.h"
#import <WebKit/WebKit.h>

///alertView  宽
#define AlertWidth 280
#define AlertHeight 280
#define UserProtocolHeight 323
#define BigBtnWidth 250
#define BtnHeight 40
#define SmallBtnWidth 70

#define VerifyIdCardMsg @"根据国家新闻出版署《关于防止未成年人沉迷网络游戏的通知》，为了加强未成年人保护， 落实国家相关防沉迷政策要求，游戏用户需要实名认证。"
#define UserProtocolMsg @"亲爱的用户，感谢您选择我们的游戏！我们非常重视您的个人信息和隐私保护。为向您提供基本服务，我们会遵循正当、合法、必要的原则收集和使用必要的信息。基于您的授权我们可能会申请位置信息，用于游戏好友的交流互动；我们可能会申请电话权限，用于识别手机设备信息和运营商网络；我们可能会申请存储权限，用于您启动、加载游戏、缓存相关文件；您有权拒绝或者取消授权。"
#define UserProtocolSubMsg @"您点击“同意”的行为即表示您已阅读完毕并同意《用户协议》及《隐私政策》的全部内容。"

@interface SDKLoginAlertView()

//弹窗
@property (nonatomic,retain) UIView *alertView;

@end

@implementation SDKLoginAlertView{
    NSBundle *thirdLoginBundle;
    id<SDKThirdLoginDialogDelegate> _sdkThirdLoginDialogDelegate;
    BOOL _cancelable;
    
    //用户协议和隐私政策的弹窗
    UIView *webviewParent;
    
    UITextField *playerNameField;
    UITextField *playerIdCardField;

    BOOL isShowing;
    BOOL isAlertViewMoved;
}

- (instancetype _Nonnull ) initWithDelegate:(id<SDKThirdLoginDialogDelegate> _Nonnull) delegate
{
    self = [super init];
    if(self)
    {
        _sdkThirdLoginDialogDelegate = delegate;
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    }
    return self;
}

-(void) showVerifyIdCardDialog
{
    _cancelable = false;
    [self createViewWithBaseBackground:AlertHeight handler:^{
        //身份证验证提示内容
        UITextView *msgText = [[UITextView alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 70, BigBtnWidth ,80)];
        [msgText setText:VerifyIdCardMsg];
        [msgText setEditable:false];
        [msgText setTextColor: [UIColor whiteColor]];
        [msgText setBackgroundColor:[UIColor clearColor]];
        [self.alertView addSubview:msgText];
        
        self -> playerNameField = [[UITextField alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 150, BigBtnWidth, 30)];
        [self.alertView addSubview:self -> playerNameField];
        [self -> playerNameField setReturnKeyType:UIReturnKeyNext];
        [self -> playerNameField setDelegate:self];
        [self -> playerNameField setBorderStyle: UITextBorderStyleRoundedRect];
        [self -> playerNameField setPlaceholder:@"请输入真实的用户名"];
        
        self -> playerIdCardField = [[UITextField alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 190, BigBtnWidth, 30)];
        [self.alertView addSubview:self -> playerIdCardField];
        [self -> playerIdCardField setDelegate:self];
        [self -> playerIdCardField setReturnKeyType:UIReturnKeyDone];
        [self -> playerIdCardField setBorderStyle: UITextBorderStyleRoundedRect];
        [self -> playerIdCardField setPlaceholder:@"请输入真实的身份证号"];
                
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 236, BigBtnWidth, 40)];
        [self.alertView addSubview:confirmBtn];
        [confirmBtn addTarget:self action:@selector(handleClickVerifyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"实名认证" forState:UIControlStateNormal];
        [confirmBtn setBackgroundColor:[UIColor colorWithRed:61/255.0 green:153/255.0 blue:141/255.0 alpha:1]];
        confirmBtn.layer.cornerRadius = 5;
    }];
}

- (void)showLoginDialogWithAnonymous:(BOOL) showAnonymous cancelable:(BOOL) cancelable weChatInstalled:(BOOL) weChatInstalled
{
    _cancelable = cancelable;
    [self createViewWithBaseBackground:AlertHeight handler:^{
        int firstBigBtnY = showAnonymous ? 100 : 120;
        if (@available(iOS 13.0, *)) {
            ASAuthorizationAppleIDButton *appleIDButton = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType: ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:(ASAuthorizationAppleIDButtonStyleWhite)];
            appleIDButton.tag = Tag_Apple;
            appleIDButton.frame = CGRectMake((AlertWidth - BigBtnWidth)/2, firstBigBtnY, BigBtnWidth, BtnHeight);
            appleIDButton.cornerRadius = CGRectGetHeight(appleIDButton.frame) * 0.5;
            [appleIDButton addTarget:self action:@selector(handleClickLoginIconBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:appleIDButton];
        }else{
            if(weChatInstalled){
                //wechat大按钮
                UIButton *_bigWeChatBtn = [self obtainBaseImageBthWithImageFileName:@"icon_big_wechat.png" tagName:Tag_WeChat];
                _bigWeChatBtn.frame = CGRectMake((AlertWidth - BigBtnWidth)/2, firstBigBtnY, BigBtnWidth, BtnHeight);
                [self.alertView addSubview:_bigWeChatBtn];
                [_bigWeChatBtn addTarget:self action:@selector(handleClickLoginIconBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        //匿名登陆按钮
        if(showAnonymous){
            UIButton *anonymousBigBt = [self obtainBaseImageBthWithImageFileName:@"icon_big_anonymous.png" tagName:Tag_Anonymous];
            anonymousBigBt.frame = CGRectMake((AlertWidth - BigBtnWidth)/2, 160, BigBtnWidth, BtnHeight);
            [self.alertView addSubview:anonymousBigBt];
            [anonymousBigBt addTarget:self action:@selector(handleClickLoginIconBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //底部三图标
        int smallBtnNum = 3;
        if(@available(iOS 13.0, *)){
            if(weChatInstalled){
                //wechat
                UIButton *smallWeChatBtn = [self obtainBaseImageBthWithImageFileName:@"icon_small_wechat.png" tagName:Tag_WeChat];
                smallWeChatBtn.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20, 236, BtnHeight, BtnHeight);
                [self.alertView addSubview:smallWeChatBtn];
                [smallWeChatBtn addTarget:self action:@selector(handleClickLoginIconBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                smallBtnNum = 3;
            }
        }else{
            smallBtnNum = 2;
        }
        
        //qq
        UIButton *qqSmallBt =  [self obtainBaseImageBthWithImageFileName:@"icon_small_qq.png" tagName:Tag_QQ];
        int extraWidth = weChatInstalled ? 0 : -35 ;
        if(@available(iOS 13.0,*)){
//            qqSmallBt.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20 + 70 + extraWidth, 236, BtnHeight, BtnHeight);
            qqSmallBt.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20 + 140 + extraWidth, 236, BtnHeight, BtnHeight);
        }else{
//            qqSmallBt.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20 + extraWidth, 236, BtnHeight, BtnHeight);
            qqSmallBt.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20 + 70 + extraWidth, 236, BtnHeight, BtnHeight);
        }
        [self.alertView addSubview:qqSmallBt];
        [qqSmallBt addTarget:self action:@selector(handleClickLoginIconBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //weibo
//        UIButton *weiboSmallBt = [self obtainBaseImageBthWithImageFileName:@"icon_small_weibo.png" tagName:Tag_WeiBo];
//        if(@available(iOS 13.0,*)){
//            weiboSmallBt.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20 + 140 + extraWidth, 236, BtnHeight, BtnHeight);
//        }else{
//            weiboSmallBt.frame = CGRectMake((AlertWidth - smallBtnNum * SmallBtnWidth)/2 + 20 + 70 + extraWidth, 236, BtnHeight, BtnHeight);
//        }
//        [self.alertView addSubview:weiboSmallBt];
//        [weiboSmallBt addTarget:self action:@selector(handleClickLoginIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)showUserProtocolDialog
{
    [self createViewWithBaseBackground:UserProtocolHeight handler:^{
        
        //用户协议提示信息
        UITextView *msgText = [[UITextView alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 80, BigBtnWidth, 200)];
        [msgText setText:UserProtocolMsg];
        [msgText setEditable:false];
        [msgText setScrollEnabled:false];
        [msgText setTextColor: [UIColor whiteColor]];
        [msgText setBackgroundColor:[UIColor clearColor]];
        [self.alertView addSubview:msgText];
        
        //用户协议提示信息
        UITextView *msgSubText = [[UITextView alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 220, BigBtnWidth+10, 70)];
        //[msgClickText setText:UserProtocolSubMsg];
        [msgSubText setEditable:false];
        [msgSubText setScrollEnabled:false];
        [msgSubText setBackgroundColor:[UIColor clearColor]];
        
        NSMutableAttributedString *attributedString  = [[NSMutableAttributedString alloc] initWithString:UserProtocolSubMsg attributes:@{
            NSForegroundColorAttributeName:[UIColor whiteColor]
        }];
        [attributedString addAttribute:NSLinkAttributeName value:@"ivy_agreement://" range:[[attributedString string] rangeOfString:@"《用户协议》"]];
        [attributedString addAttribute:NSLinkAttributeName value:@"ivy_privacy://" range:[[attributedString string] rangeOfString:@"《隐私政策》"]];
        [msgSubText setAttributedText:attributedString];
        [msgSubText setDelegate:self];
        [msgSubText setLinkTextAttributes:@{
            NSForegroundColorAttributeName:[UIColor greenColor],
            NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
            NSUnderlineColorAttributeName:[UIColor greenColor]
        }];
        [self.alertView addSubview:msgSubText];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2, 276, 120, 40)];
        [self.alertView addSubview:cancelBtn];
        [cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:[UIColor grayColor]];
        cancelBtn.layer.cornerRadius = 5;
        [cancelBtn addTarget:self action:@selector(handleRefuseUserProtocol) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((AlertWidth - BigBtnWidth)/2 + 130, 276, 120, 40)];
        [self.alertView addSubview:confirmBtn];
        [confirmBtn setTitle:@"同意" forState:UIControlStateNormal];
        [confirmBtn setBackgroundColor:[UIColor colorWithRed:61/255.0 green:153/255.0 blue:141/255.0 alpha:1]];
        confirmBtn.layer.cornerRadius = 5;
        [confirmBtn addTarget:self action:@selector(handleAcceptUserProtocol) forControlEvents:UIControlEventTouchUpInside];
        
    }];
}

- (void) createViewWithBaseBackground:(float)height handler:(void (^)(void)) insertContentView
{
    if(isShowing){
        [self hideAllAlertView];
    }
    
    //background 背景图片
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    self.alertView = [[UIView alloc] init];
    self.alertView.layer.cornerRadius = 10.0;
    self.alertView.backgroundColor=[UIColor clearColor];
    self.alertView.frame = CGRectMake(0, 0, AlertWidth, height);
    self.alertView.layer.position = self.center;
    
    UIImageView *dialogBackgroundView = [[UIImageView alloc]init];
    dialogBackgroundView.frame = CGRectMake(0, 0, self.alertView.frame.size.width, self.alertView.frame.size.height);
    UIImage *dialogBackgroundImage = [self findImageByName:@"dialog_bg.png"];
    dialogBackgroundImage = [dialogBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(dialogBackgroundImage.size.height / 2 - 0.5, dialogBackgroundImage.size.width / 2 - 0.5, dialogBackgroundImage.size.height / 2 - 0.5, dialogBackgroundImage.size.width / 2 - 0.5)];
    dialogBackgroundView.image = dialogBackgroundImage;
    dialogBackgroundView.layer.cornerRadius = 10.0;
    dialogBackgroundView.layer.masksToBounds = true;
    [self.alertView addSubview:dialogBackgroundView];
    
    //顶部logo
    UIImageView *ivyLogiImageView = [[UIImageView alloc] init];
    UIImage *logoImage = [self findImageByName:@"logo_ivymobile.png"];
    ivyLogiImageView.frame = CGRectMake((AlertWidth - 120)/2, 20, 120, 50);
    ivyLogiImageView.image = logoImage;
    [self.alertView addSubview:ivyLogiImageView];
    
    insertContentView();
    
    [self addSubview:self.alertView];
    
    //显示
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressInAlertViewGesture:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
    isShowing = true;
}

// 点击其他区域关闭弹窗
- (void)handletapPressInAlertViewGesture:(UITapGestureRecognizer *)sender
{
    if(!_cancelable){
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![_alertView pointInside:[_alertView convertPoint:location fromView:_alertView.window] withEvent:nil]){
            [_alertView.window removeGestureRecognizer:sender];
            [self hideAllAlertView];
            isShowing = false;
        }
    }
}


- (void)handleAcceptUserProtocol
{
    [self hideAllAlertView];
    [self -> _sdkThirdLoginDialogDelegate onPrivacyAccept:YES];
}

- (void)handleRefuseUserProtocol
{
    [self -> _sdkThirdLoginDialogDelegate onPrivacyAccept:NO];
    //直接退出
    exit(0);
}

- (void)handleClickVerifyBtn:(UIButton *)btn
{
    NSString *playerName = [self -> playerNameField text];
    NSString *playerIdCard = [self -> playerIdCardField text];
    [self -> _sdkThirdLoginDialogDelegate onStartVerifyIdCard:playerName idCardNum:playerIdCard];
}

- (void)handleClickLoginIconBtn:(UIButton *)btn
{
    [self -> _sdkThirdLoginDialogDelegate onSelectedAuthPlatform:btn.tag];
//    [self hideAllAlertView];
}

- (void)showUserAgreementDialog
{
    [self showWebView:[self getResContent:@"user_agreement.html"]];
}

- (void)showPrivacyDialog
{
    [self showWebView:[self getResContent:@"privacy.html"]];
}

- (NSString *) getResContent:(NSString *) fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void) showWebView:(NSString *) htmlContent
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    webviewParent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rootWindow.bounds.size.width, rootWindow.bounds.size.height)];
    webviewParent.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self -> webviewParent.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
    
    [rootWindow addSubview:webviewParent];
    
    WKWebView *newUserAgreementWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, rootWindow.bounds.size.width,rootWindow.bounds.size.height)];
    [webviewParent addSubview:newUserAgreementWebView];
    [newUserAgreementWebView loadHTMLString:htmlContent baseURL:nil];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(rootWindow.bounds.size.width - 50, 10, 40, 40)];
    [webviewParent addSubview:closeBtn];
    [closeBtn setBackgroundImage:[self findImageByName:@"icon_btn_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeWebView:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) closeWebView:(UIButton *)btn
{
    if(webviewParent){
        [webviewParent removeFromSuperview];
    }
}

-(void)hideAllAlertView{
    [self.alertView removeFromSuperview];
    [self removeFromSuperview];
}

-(void) createCurrentBundle
{
    if(!thirdLoginBundle){
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"IvyiOSSdk-ThirdLogin" ofType:@"bundle"];
        self -> thirdLoginBundle = [NSBundle bundleWithPath:bundlePath];
    }
}

-(UIImage *) findImageByName:(NSString *) fileName{
    [self createCurrentBundle];
    NSString *imagePath = [thirdLoginBundle pathForResource: [fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    return [UIImage imageWithContentsOfFile:imagePath];
}

-(UIButton *) obtainBaseImageBthWithImageFileName:(NSString *)fileName tagName:(long)tag
{
    [self createCurrentBundle];
    if(!thirdLoginBundle){
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"IvyiOSSdk-ThirdLogin" ofType:@"bundle"];
        self -> thirdLoginBundle = [NSBundle bundleWithPath:bundlePath];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setBackgroundImage:[self findImageByName:fileName] forState:UIControlStateNormal];
    return button;
}

#pragma mark -由于手势操作和sign in apple冲突了，所以需要对button和ASAuthorizationAppleIDButton进行特殊处理，忽略手势事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    if (@available(iOS 13.0, *)) {
        if ([touch.view isKindOfClass:[ASAuthorizationAppleIDButton class]])
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if([[URL absoluteString] hasPrefix:@"ivy_agreement"]){
        [self showUserAgreementDialog];
        return NO;
    }else if ([[URL absoluteString] hasPrefix:@"ivy_privacy"]){
        [self showPrivacyDialog];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self -> playerNameField){
        [self -> playerIdCardField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的Y坐标
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    int keyboardY = [[UIScreen mainScreen] bounds].size.height - keyboardHeight ;
    
    if(!self -> isAlertViewMoved){
        if(self.alertView.frame.origin.y + AlertHeight > keyboardY){
            [UIView beginAnimations:@"Animation_Start" context:nil];
            [UIView setAnimationDuration:0.20];
            [UIView setAnimationBeginsFromCurrentState: YES];
            self.alertView.frame = CGRectMake(self.alertView.frame.origin.x, keyboardY - AlertHeight , self.alertView.frame.size.width, self.alertView.frame.size.height);
            [UIView commitAnimations];
            self -> isAlertViewMoved = true;
        }
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if(self -> isAlertViewMoved){
        [UIView beginAnimations:@"Animation_End" context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationBeginsFromCurrentState: YES];
        self.alertView.layer.position = self.center;
        [UIView commitAnimations];
        self -> isAlertViewMoved = false;
    }
}
@end

