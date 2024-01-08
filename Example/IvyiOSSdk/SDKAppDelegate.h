//
//  SDKAppDelegate.h
//  IvyiOSSdk
//
//  Created by yubingxing on 06/06/2017.
//  Copyright (c) 2017 yubingxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IvyiOSSdk/SDKUIApplication.h>
#if APPSFLYER
#import <AppsFlyerLib/AppsFlyerLib.h>
#endif
@class SDKViewController;
@interface SDKAppDelegate : SDKUIApplication<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SDKViewController *viewController;

@end
