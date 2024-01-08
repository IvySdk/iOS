//
//  SDKAppDelegate.m
//  IvyiOSSdk
//
//  Created by yubingxing on 06/06/2017.
//  Copyright (c) 2017 yubingxing. All rights reserved.
//

#import "SDKAppDelegate.h"
#import "SDKViewController.h"
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKAppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    UINib *nib = [UINib nibWithNibName:@"MyOurNativeView" bundle:nil];
//    NSArray *arr = [nib instantiateWithOwner:nil options:nil];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[SDKViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[SDKViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"will enter foreground!!");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
    id data = [[SDKFacade sharedInstance] getPushData];
    NSLog(@"%@", data);
}

@end
