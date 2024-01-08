#import "SDKFirebaseInAppMessage.h"
#import <Firebase/Firebase.h>
#import <SDKNetworkHelper.h>
#import <SDKJSONHelper.h>
#import <SDKDefine.h>

@implementation SDKFirebaseInAppMessage
{
@private
    id<SDKInAppMessageDelegate> _inAppMessageDelegate;
    id<FIRInAppMessagingDisplayDelegate> _currentDisplayDelegate;
    FIRInAppMessagingDisplayMessage* _currentInAppMessagingDisplayMessage;
    FIRInAppMessagingAction* _currentInAppMessagingAction;
    
}

-(instancetype)initWithInAppMessageDelegate:(id<SDKInAppMessageDelegate>)inAppMessageDelegate {
    self->_inAppMessageDelegate = inAppMessageDelegate;
    FIRInAppMessaging.inAppMessaging.messageDisplayComponent = self;
    
    [[FIRInstallations installations] installationIDWithCompletion:^(NSString * _Nullable identifier, NSError * _Nullable error) {
        if (error == nil) {
            self->_installationId = identifier;
        }
    }];
    return self;
}

- (void)displayMessage:(FIRInAppMessagingDisplayMessage *)messageForDisplay displayDelegate:(id<FIRInAppMessagingDisplayDelegate>)displayDelegate {
    DLog(@"displayMessage called");
    
    // reset
    _currentInAppMessagingDisplayMessage = nil;
    _currentDisplayDelegate = nil;
    _currentInAppMessagingAction = nil;
    
    NSMutableDictionary* inAppMessageDict = [[NSMutableDictionary alloc] init];
    NSString* campaiginID = messageForDisplay.campaignInfo.messageID;
    [inAppMessageDict setObject: campaiginID forKey:@"id"];
    
    if ([messageForDisplay isKindOfClass:[FIRInAppMessagingModalDisplay class]]) {
        FIRInAppMessagingModalDisplay* fIRInAppMessagingModalDisplay = (FIRInAppMessagingModalDisplay *)messageForDisplay;
        NSString* title  = fIRInAppMessagingModalDisplay.title;
        if (title) {
            [inAppMessageDict setObject:title forKey:@"title"];
        }
        
        NSString* body = fIRInAppMessagingModalDisplay.bodyText;
        if (body) {
            [inAppMessageDict setObject:body forKey:@"body"];
        }
        
        NSURL* actionUrl = fIRInAppMessagingModalDisplay.actionURL;
        if (actionUrl) {
            NSString* action = actionUrl.absoluteString;
            
            self->_currentInAppMessagingAction = [[FIRInAppMessagingAction alloc] initWithActionText:fIRInAppMessagingModalDisplay.actionButton.buttonText actionURL:fIRInAppMessagingModalDisplay.actionURL];
            
            if (action) {
                [inAppMessageDict setObject:action forKey:@"action"];
            }
        }
        
        FIRInAppMessagingImageData* imageData = fIRInAppMessagingModalDisplay.imageData;
        if (imageData) {
            NSString* imageUrl = imageData.imageURL;
            if (imageUrl) {
                [inAppMessageDict setObject:imageUrl forKey:@"image"];
            }
        }
        
    } else if ([messageForDisplay isKindOfClass:[FIRInAppMessagingBannerDisplay class]]) {
        
    } else if ([messageForDisplay isKindOfClass:[FIRInAppMessagingImageOnlyDisplay class]]) {
        FIRInAppMessagingImageOnlyDisplay* fIRInAppMessagingImageOnlyDisplay = (FIRInAppMessagingImageOnlyDisplay *)messageForDisplay;
        NSURL* actionUrl = fIRInAppMessagingImageOnlyDisplay.actionURL;
        if (actionUrl) {
            NSString* action = nil;
            action = actionUrl.absoluteString;
            if (action) {
                [inAppMessageDict setObject:action forKey:@"action"];
            }
        }
        FIRInAppMessagingImageData* imageData = fIRInAppMessagingImageOnlyDisplay.imageData;
        if (imageData) {
            NSString* imageUrl = imageData.imageURL;
            if (imageUrl) {
                [inAppMessageDict setObject:imageUrl forKey:@"image"];
            }
        }
    } else if ([messageForDisplay isKindOfClass:[FIRInAppMessagingCardDisplay class]]) {
        FIRInAppMessagingCardDisplay* fIRInAppMessagingCardDisplay = (FIRInAppMessagingCardDisplay *)messageForDisplay;
        NSString* title  = fIRInAppMessagingCardDisplay.title;
        if (title) {
            [inAppMessageDict setObject:title forKey:@"title"];
        }
        
        NSString* body = fIRInAppMessagingCardDisplay.body;
        if (body) {
            [inAppMessageDict setObject:body forKey:@"body"];
        }
        NSURL* actionUrl = fIRInAppMessagingCardDisplay.primaryActionURL;
        if (actionUrl) {
            NSString* action = nil;
            action = actionUrl.absoluteString;
            if (action) {
                [inAppMessageDict setObject:action forKey:@"action"];
            }
        }
        FIRInAppMessagingImageData* imageData = fIRInAppMessagingCardDisplay.landscapeImageData;
        if (imageData) {
            NSString* imageUrl = imageData.imageURL;
            if (imageUrl) {
                [inAppMessageDict setObject:imageUrl forKey:@"image"];
            }
        }
    } else {
        return;
    }
    
    
    NSString* dataJson = [SDKJSONHelper toJSONString:inAppMessageDict];
    if (dataJson) {
        if (_inAppMessageDelegate) {
            [_inAppMessageDelegate onInAppMessageDisplayed:dataJson];
        }
    }
    self->_currentDisplayDelegate = displayDelegate;
    self->_currentInAppMessagingDisplayMessage = messageForDisplay;
    
    [displayDelegate impressionDetectedForMessage: messageForDisplay];
}

- (void)inAppMessageDismissed {
    if (_currentDisplayDelegate) {
        [_currentDisplayDelegate messageDismissed:_currentInAppMessagingDisplayMessage dismissType: FIRInAppMessagingDismissTypeUserTapClose];
    }
    _currentInAppMessagingDisplayMessage = nil;
    _currentDisplayDelegate = nil;
    _currentInAppMessagingAction = nil;
}

- (void)inAppMessageClicked{
    if (_currentDisplayDelegate && _currentInAppMessagingAction) {
        [_currentDisplayDelegate messageClicked:_currentInAppMessagingDisplayMessage withAction:_currentInAppMessagingAction];
    }
    _currentInAppMessagingDisplayMessage = nil;
    _currentDisplayDelegate = nil;
    _currentInAppMessagingAction = nil;
}

@end

