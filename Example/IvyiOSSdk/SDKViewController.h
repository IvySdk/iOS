//
//  SDKViewController.h
//  IvyiOSSdk
//
//  Created by yubingxing on 06/06/2017.
//  Copyright (c) 2017 yubingxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IvyiOSSdk/SDKAdDelegate.h>
#import <IvyiOSSdk/SDKAdDelegate.h>
#import <IvyiOSSdk/SDKPaymentDelegate.h>
#import <IvyiOSSdk/SDKSNSDelegate.h>
#import <IvyiOSSdk/SDKWebviewDelegate.h>
@interface SDKViewController : UIViewController<SDKAdDelegate, SDKPaymentDelegate, SDKSNSDelegate, SDKWebviewDelegate>

@end
