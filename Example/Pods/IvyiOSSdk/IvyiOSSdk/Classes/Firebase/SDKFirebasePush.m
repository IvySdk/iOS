//
//  SDKFirebasePush.m
//  Pods
//
//  Created by 余冰星 on 2017/9/20.
//
//

#import "SDKFirebasePush.h"
#import <IvyiOSSdk/SDKTimer.h>
#import <IvyiOSSdk/SDKHelper.h>
#import <IvyiOSSdk/SDKCache.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKJSONHelper.h>
#import <IvyiOSSdk/SDKNetworkHelper.h>
#import <Firebase/Firebase.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface SDKFirebasePush () <FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif
NSString * const kGCMMessageIDKey = @"gcm.message_id";

@implementation SDKFirebasePush
#pragma mark ================== Push Notification ===================
-(void)setup:(NSDictionary *)conf
{
    [super setup:conf];
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    // For iOS 10 data message (sent via FCM)
    [FIRMessaging messaging].delegate = self;
#endif
//    [FIRMessaging messaging].shouldEstablishDirectChannel = YES;
    [FIRMessaging messaging].autoInitEnabled = YES;
    // [END configure_firebase]
    // [START add_token_refresh_observer]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:FIRMessagingRegistrationTokenRefreshedNotification object:nil];
}

-(void)submitTokenToServer
{
    if (_pushServerUrl && _token) {
        id params = @{
                      @"method":@"saveToken",
                      @"appid":[[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_APP_ID],
                      @"pkg": [NSBundle mainBundle].bundleIdentifier,
                      @"fcmProjectId":[FIRApp defaultApp].options.projectID,
                      @"languageCode":[SDKHelper getLangcode],
                      @"countryCode": [SDKHelper getCountryCode],
                      @"token":_token,
                      @"facebookId":[[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_FACEBOOK_ID],
                      @"versionName":[[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_VERSION_NAME],
                      @"uuid": [[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID]
                      };
    
        NSString *data = [SDKJSONHelper toJSONString:params];
        data = [SDKHelper encryptWithBase64:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [[SDKNetworkHelper sharedHelper] POST:_pushServerUrl parameters:@{@"data":data} jsonRequest:false jsonResponse:true success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber *status = (NSNumber *)[responseObject objectForKey:@"code"];
                if ([status intValue] < 4000) {
                    self.lastSendToken = self->_token;
                    DLog(@"[FCM]: submit token to server success! token = %@", self->_token);
                } else {
                    DLog(@"[FCM]: submit token to server error! error = %@", [responseObject objectForKey:@"err"]);
                }
            }
        } failure:^(NSError *error) {
            DLog(@"[FCM]: submit token to server failure! error = %@", [error localizedDescription]);
        }];
    }
}

-(void)subscribeToTopic:(NSString *)topic
{
    NSString *token = [FIRMessaging messaging].FCMToken;
    if (_pushServerUrl && token) {
        id params = @{@"method":@"subscribeTopic",
                      @"topic":topic,
                      @"fcmProjectId":[FIRApp defaultApp].options.projectID,
                      @"uuid": [[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID],
                      @"token":token};
        
        NSString *data = [SDKJSONHelper toJSONString:params];
        data = [SDKHelper encryptWithBase64:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [[SDKNetworkHelper sharedHelper] POST:_pushServerUrl parameters:@{@"data":data} jsonRequest:false jsonResponse:true  success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber *status = (NSNumber *)[responseObject objectForKey:@"code"];
                if ([status intValue] < 4000) {
                    DLog(@"[FCM]: subscribeToTopic : %@ success!", topic);
                } else {
                    DLog(@"[FCM]: subscribeToTopic : %@ to server error! error = %@", topic, [responseObject objectForKey:@"err"]);
                }
            }
        } failure:^(NSError *error) {
            DLog(@"[FCM]: subscribeToTopic : %@ to server failure! error = %@", topic, [error localizedDescription]);
        }];
    } else {
        [[FIRMessaging messaging] subscribeToTopic:topic];
    }
}

-(void)unsubscribeFromTopic:(NSString *)topic
{
    NSString *token = [FIRMessaging messaging].FCMToken;
    if (_pushServerUrl && token) {
        id params = @{@"method":@"unsubscribeTopic",
                      @"topic":topic,
                      @"fcmProjectId":[FIRApp defaultApp].options.projectID,
                      @"uuid": [[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID],
                      @"token":token};
        
        NSString *data = [SDKJSONHelper toJSONString:params];
        data = [SDKHelper encryptWithBase64:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [[SDKNetworkHelper sharedHelper] POST:_pushServerUrl parameters:@{@"data":data} jsonRequest:false jsonResponse:true success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber *status = (NSNumber *)[responseObject objectForKey:@"code"];
                if ([status intValue] < 4000) {
                    DLog(@"[FCM]: unsubscribeFromTopic : %@ success!", topic);
                } else {
                    DLog(@"[FCM]: unsubscribeFromTopic : %@ to server error! error = %@", topic, [responseObject objectForKey:@"err"]);
                }
            }
        } failure:^(NSError *error) {
            DLog(@"[FCM]: unsubscribeFromTopic : %@ to server failure! error = %@", topic, [error localizedDescription]);
        }];
    } else {
        [[FIRMessaging messaging] unsubscribeFromTopic:topic];
    }
}

- (void)didDeleteMessagesOnServer {
}

// [START refresh_token]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
-(void)messaging:(FIRMessaging *)messaging didRefreshRegistrationToken:(NSString *)fcmToken
{
    DLog(@"[FCM] Refresh token: %@", fcmToken);
    [self connectToFcm];
}
#endif
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    [[FIRInstallations installations] installationIDWithCompletion:^(NSString * _Nullable identifier, NSError * _Nullable error) {
        if (error) {
            return;
        }
        if (identifier) {
            NSString *refreshedToken = identifier;
            DLog(@"[FCM] InstanceID token: %@", refreshedToken);
            // Connect to FCM since connection may have failed when attempted before having a token.
            self.token = refreshedToken;
            [self connectToFcm];
        }
    }];
//    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result, NSError * _Nullable error) {
//        if (error) {
//            return;
//        }
//        if (result) {
//            NSString *refreshedToken = result.token;
//            DLog(@"[FCM] InstanceID token: %@", refreshedToken);
//            // Connect to FCM since connection may have failed when attempted before having a token.
//            self.token = refreshedToken;
//            [self connectToFcm];
//        }
//    }];
}

// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    NSString *token = [FIRMessaging messaging].FCMToken;
    if (!token) {
        return;
    }
    // 注册主题
    if (_conf) {
        NSString *topic = [_conf objectForKey:@"topic"];
        id tmp = [[SDKCache cache] objectForKey:@"hasSubscribedTopic"];
        NSString *hasSubscribedTopics = tmp ? (NSString *)tmp : @"";
        if(topic && ![topic isEqualToString:hasSubscribedTopics]) {
            if(hasSubscribedTopics.length > 0) {
                NSArray<NSString *> *array = [hasSubscribedTopics componentsSeparatedByString:@","];
                for (NSString *t in array) {
                    [self unsubscribeFromTopic:t];
                }
            }
            NSArray<NSString *> * topics = [topic componentsSeparatedByString:@","];
            if(topics && topics.count > 0) {
                NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
                for (NSString *t in topics) {
                    if ([t hasPrefix:@"language"]) {
                        NSString *topic = [SDKHelper getLangcode];
                        if (t.length > 8) {
                            topic = [[NSString stringWithFormat:@"%@%@", [SDKHelper getLangcode], [t substringFromIndex:8]] lowercaseString];
                            [self subscribeToTopic:topic];
                        } else {
                            [self subscribeToTopic:topic];
                        }
                        [array addObject:topic];
                    } else if ([t hasPrefix:@"country"]) {
                        NSString *topic = [SDKHelper getCountryCode];
                        if (t.length > 7) {
                            topic = [[NSString stringWithFormat:@"%@%@", [SDKHelper getCountryCode], [t substringFromIndex:7]] lowercaseString];
                            [self subscribeToTopic:topic];
                        } else {
                            [self subscribeToTopic:topic];
                        }
                        [array addObject:topic];
                    } else {
                        [self subscribeToTopic:t];
                        [array addObject:t];
                    }
                }
                [[SDKCache cache] setObject:topic forKey:@"hasSubscribedTopic"];
            }
        }
    }
}

// [START receive_message]
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        DLog(@"[FCM] Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // Let FCM know about the message for analytics etc.
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    // handle your message.
    
    // Print full message.
    DLog(@"[FCM] userInfo: %@", userInfo);
    
    if (_pushServerUrl && userInfo) {
        NSString *messageId = [userInfo objectForKey:@"messageId"];
        if (messageId) {
            id params = @{@"method":@"messageFeedBack",
                          @"messageId":messageId};
            
            NSString *data = [SDKJSONHelper toJSONString:params];
            data = [SDKHelper encryptWithBase64:[data dataUsingEncoding:NSUTF8StringEncoding]];
            [[SDKNetworkHelper sharedHelper] POST:_pushServerUrl parameters:@{@"data":data} jsonRequest:false jsonResponse:true success:^(id responseObject) {
                if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                    NSNumber *status = (NSNumber *)[responseObject objectForKey:@"code"];
                    if ([status intValue] < 4000) {
                        DLog(@"[FCM]: messageFeedBack messageId = %@ success!", messageId);
                    } else {
                        DLog(@"[FCM]: messageFeedBack messageId = %@ to server error! error = %@", messageId, [responseObject objectForKey:@"err"]);
                    }
                }
            } failure:^(NSError *error) {
                DLog(@"[FCM]: messageFeedBack messageId = %@ to server failure! error = %@", messageId, [error localizedDescription]);
            }];
        }
    }
    [super didReceiveRemoteNotification:userInfo];
}
// [END receive_message]

-(void)pushMessage:(NSString *)key title:(NSString *)title content:(NSString *)content pushTime:(long)pushTime useLocalTimeZone:(BOOL)useLocalTimeZone facebookIds:(NSString *)facebookIds uuids:(NSString *)uuids topic:(nullable NSString *)topic iosBadge:(int)iosBadge useSound:(BOOL)useSound soundName:(NSString *)soundName extraData:(NSDictionary *)data
{
    if (_pushServerUrl) {
        NSString *emptyStr = @"";
        NSString *timeZone = [[NSTimeZone localTimeZone].abbreviation substringFromIndex:3];
        NSString *dataJson = [SDKJSONHelper toJSONString:data];
        NSString *uuid = [[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID];
        long now = [SDKHelper currentTime];
        
        if (pushTime > 0 && pushTime < now) {
            pushTime = (now + pushTime) * 1000;
        } else {
            pushTime = pushTime * 1000;
        }
        id method = @{
                      @"key":(key ? [NSString stringWithFormat:@"%@_%@", uuid, key] : @""),
                      @"project":[FIRApp defaultApp].options.projectID,
                      @"title":title,
                      @"content":content,
                      @"pushTime": [NSNumber numberWithLong:pushTime],
                      @"useLocalTimeZone": [NSNumber numberWithBool:useLocalTimeZone],
                      @"sendTimeZone": timeZone,  //当前客户端与UTC时间的偏移量，以小时为单位，格式（"+8"）
                      @"facebookIds": facebookIds ? facebookIds : emptyStr,// 优先级facebookIds，uuids, receive_topic, receive_pkg, receive_appid
                      @"uuids": uuids ? uuids : emptyStr,
                      @"receive_appid":[[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_APP_ID],
                      @"receive_pkg": [NSBundle mainBundle].bundleIdentifier,
                      @"receive_topic": topic ? topic : emptyStr,
                      @"data": dataJson ? dataJson : emptyStr,  //捆绑的KV对
                      @"iosBadge": [NSNumber numberWithInt:iosBadge],
                      @"sound": [NSNumber numberWithBool:useSound],                   //是否自定义消息的声音,如果未true，请设置下面一项
                      @"soundName": soundName ? soundName : emptyStr,                  //默认为default，如需自定义请设置该选项
                      @"languageCode":[SDKHelper getLangcode],
                      @"countryCode": [SDKHelper getCountryCode]
                      };
        id params = @{
                      @"method":@"push",
                      @"message":method
                      };
        NSString *data = [SDKJSONHelper toJSONString:params];
        data = [SDKHelper encryptWithBase64:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [[SDKNetworkHelper sharedHelper] POST:_pushServerUrl parameters:@{@"data":data} jsonRequest:false jsonResponse:true success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber *status = (NSNumber *)[responseObject objectForKey:@"code"];
                if ([status intValue] < 4000) {
                    DLog(@"[FCM]: push message success!");
                } else {
                    DLog(@"[FCM]: push message failure! err = %@", [responseObject objectForKey:@"err"]);
                }
            }
        } failure:^(NSError *error) {
            DLog(@"[FCM]: push message failure! err = %@", [error localizedDescription]);
        }];
    } else {
       DLog(@"[FCM]: push message failure! err = pushServerUrl not set!!");
    }
}

-(void)cancelPush:(NSString *)key
{
    if (_pushServerUrl) {
        NSString *uuid = [[SDKFacade sharedInstance] getConfig:SDK_CONFIG_KEY_UUID];
        id params = @{
                      @"method":@"cancel",
                      @"key":(key ? [NSString stringWithFormat:@"%@_%@", uuid, key] : @"")
                      };
        NSString *data = [SDKJSONHelper toJSONString:params];
        data = [SDKHelper encryptWithBase64:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [[SDKNetworkHelper sharedHelper] POST:_pushServerUrl parameters:@{@"data":data} jsonRequest:false jsonResponse:true success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSNumber *status = (NSNumber *)[responseObject objectForKey:@"code"];
                if ([status intValue] < 4000) {
                    DLog(@"[FCM]: cancel push success!");
                } else {
                    DLog(@"[FCM]: cancel push failure! err = %@", [responseObject objectForKey:@"err"]);
                }
            }
        } failure:^(NSError *error) {
            DLog(@"[FCM]: cancel push failure! err = %@", [error localizedDescription]);
        }];
    }
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"[FCM] Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DLog(@"[FCM] APNs token retrieved: %@", [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]);
    
    // With swizzling disabled you must set the APNs token here.
#ifdef DEBUG
    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeSandbox];
#else
    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeProd];
#endif
    DLog(@"[FCM] token = %@", [FIRMessaging messaging].FCMToken);
    self.token = [FIRMessaging messaging].FCMToken;
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
    [self connectToFcm];
}

-(void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken
{
    DLog(@"[FCM] registration token: %@", fcmToken);
}

// [END connect_to_fcm]
// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self didReceiveRemoteNotification:userInfo];
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self didReceiveRemoteNotification:userInfo];
    completionHandler();
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
// Receive data message on iOS 10 devices while app is in the foreground.
//- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage API_AVAILABLE(ios(10.0)){
//    // Print full message
//    DLog(@"[FCM] %@", remoteMessage.appData);
//    [self didReceiveRemoteNotification:remoteMessage.appData];
//}
// [END ios_10_data_message_handling]


@end
