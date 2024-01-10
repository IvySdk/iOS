#import <Foundation/Foundation.h>
#import <IvyiOSSdk/SDKBaseInit.h>
#import <SDKInAppMessageDelegate.h>
#import "FirebaseInAppMessaging.h"

@interface SDKFirebaseInAppMessage : NSObject <FIRInAppMessagingDisplay>

@property (nonatomic, nullable, strong) NSString *installationId;

- (instancetype _Nonnull)initWithInAppMessageDelegate:(_Nonnull id<SDKInAppMessageDelegate>)inAppMessageDelegate;
- (void)displayMessage:(FIRInAppMessagingDisplayMessage *_Nonnull)messageForDisplay displayDelegate:(nullable id<FIRInAppMessagingDisplayDelegate>)displayDelegate;
- (void)inAppMessageDismissed;
- (void)inAppMessageClicked;

@end
