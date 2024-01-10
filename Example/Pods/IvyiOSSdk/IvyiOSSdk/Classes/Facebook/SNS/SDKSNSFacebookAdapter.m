//
//  SDKSNSFacebookAdapter.m
//  Pods
//
//  Created by 余冰星 on 2017/8/4.
//
//

#import "SDKSNSFacebookAdapter.h"
#import "SDKHelper.h"
#import "SDKJSONHelper.h"

@implementation SDKSNSFacebookAdapter
{
@private
    NSString *share_url;
    NSString *share_msg;
    NSString *invite_url;
    NSString *invite_img;
    NSString *user_id;
    NSString *_friends;
    FBSDKLoginManager *loginManager;
    NSDictionary *_meDetails;
    NSString *_permissions;
    BOOL _isFetching;
    BOOL _flag;
    BOOL _isFBInstalled;
    BOOL _hasCheckFb;
}

-(void)setup:(nonnull NSDictionary *)conf
{
    [super setup:conf];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [self isLogin];
    if(conf) {
        share_url = [conf objectForKey:@"share_url"];
        share_msg = [conf objectForKey:@"share_msg"];
        
        invite_url = [conf objectForKey:@"invite_url"];
        invite_img = [conf objectForKey:@"invite_img"];
        
        _permissions = [conf objectForKey:@"permissions"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateContent:) name:FBSDKProfileDidChangeNotification object:nil];
}

-(BOOL)isFBInstalled
{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    if (!_hasCheckFb) {
        _isFBInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
        _hasCheckFb = YES;
    }
    return _isFBInstalled;
#endif
}

-(void)_updateContent:(NSNotification *)notification
{
    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    user_id = profile.userID;
    [self isLogin];
}

-(BOOL)isLogin
{
    if (![self isFBInstalled]) {
        return NO;
    }
    BOOL isLogin = [FBSDKAccessToken currentAccessToken] ? YES : NO;
    if (!loginManager) {
        loginManager = [[FBSDKLoginManager alloc] init];
    }
    if (isLogin) {
        if(!_meDetails) {
            [self fetchMeWithNoCallback];
        }
        if(!_friends) {
            id result = [[SDKCache cache] objectForKey:SDK_SNS_FRIENDS];
            _friends = result ? (NSString *)result : _friends;
            [self fetchFriends:NO];
        }
    }
    return _meDetails && isLogin;
}

-(void)login:(sns_login_result)handler;
{
    if ([self isFBInstalled]) {
        [super login:nil];
        BOOL isLogin = [FBSDKAccessToken currentAccessToken] ? YES : NO;
        if(!isLogin) {
            UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
            NSArray *permissions = nil;
            if (_permissions) {
                permissions = [_permissions componentsSeparatedByString:@","];
            }
            permissions = permissions ? permissions : @[@"public_profile", @"email", @"user_friends"];
//            loginManager.loginBehavior = FBSDKLoginBehaviorBrowser;
            [loginManager logInWithPermissions:permissions fromViewController:vc handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                NSString *errorStr = nil;
                if (error) {
                    errorStr = [error localizedDescription];
                } else if (result.isCancelled) {
                    NSError* loginCancelError =[[NSError alloc]
                                                initWithDomain:@"SDKSNSFacebookAdapter"
                                                code:-1
                                                userInfo:@{NSLocalizedDescriptionKey: @"Facebook log cancelled."}];
                    [self snsLoginCancel];
                    if (handler) {
                        handler(loginCancelError);
                    }
                    return;
                }
                if(errorStr) {
                    [self snsLoginFailure:errorStr];
                    if (handler) {
                        handler(error);
                    }
                } else {
                    FBSDKProfile *profile = [FBSDKProfile currentProfile];
                    self->user_id = profile.userID;
                    [self fetchMe];
                    [self fetchFriends:NO];
                    if (handler) {
                        handler(nil);
                    }
                }
            }];
        }
    } else {
        [self snsLoginFailure:@"No facebook app installed!"];
    }
}

-(void)logout
{
    if ([self isFBInstalled]) {
        [super logout];
        if([FBSDKAccessToken currentAccessToken]) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions/" parameters:@{} HTTPMethod:FBSDKHTTPMethodDELETE];
            [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
                if (!error && result) {
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [FBSDKProfile setCurrentProfile:nil];
                    [self->loginManager logOut];
                } else {
                }
            }];
        }
        _isFetching = NO;
        _meDetails = nil;
        _friends = nil;
        //    [[SDKCache cache] removeObjectForKey:SDK_SNS_MEDETAILS];
        //    [[SDKCache cache] removeObjectForKey:SDK_SNS_FRIENDS];
    }
}

//id<FBSDKGameRequestDialogDelegate> gameRequestDelegate;

// Game Requests give players a mechanism for inviting their friends to play a game.
// Requests are sent by a player to one or more specific friends, and always carry a call-to-action that the sender wants the recipient to complete.
// Recipients can choose to accept the request, or they can choose to ignore or decline it.
// https://developers.facebook.com/docs/games/requests/v2.4
-(void)sendRequestWithFriendIDs: (nonnull NSArray *)friendIDs title:(nonnull NSString *)title message:(nonnull NSString *)message data:(nonnull NSDictionary *)data
{
//    [super sendRequestWithFriendIDs:friendIDs title:title message:message data:data];
//    SBJson5Writer *jsonWriter = [SBJson5Writer new];
//    NSString *dataStr = [jsonWriter stringWithObject:data];
//
//
//    FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
//    [content setTitle:title];
//    [content setMessage:message];
//    [content setRecipients:friendIDs];
//    [content setData:dataStr];
//
//    [FBSDKGameRequestDialog showWithContent:content delegate:self];
}

// Send Game Requests to Friends.e
// Using Invitiable Friends API, you can create custom friends selector.
// Then, send Game Requests to selected invitable friends
// Note that the invitable_friends API is only available for games that have a Facebook Desktop Game implementation
// https://developers.facebook.com/docs/games/invitable-friends
-(void)sendInviteWithFriendIDs: (nonnull NSArray *)friendIDs title:(nonnull NSString *)title message:(nonnull NSString *)message
{
//    [super sendInviteWithFriendIDs:friendIDs title:title message:message];
//    FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
//    [content setTitle:title];
//    [content setMessage:message];
//
//    // friendIDS are user IDs, usernames or invite tokens (NSString) of people to send request
//    [content setRecipients:friendIDs];
//
//    [FBSDKGameRequestDialog showWithContent:content delegate:self];
}

-(void)fetchMe
{
    if ([self isFBInstalled]) {
        if (_isFetching) {
            if (self->_meDetails) {
                [self snsLoginSuccess];
            } else {
                _flag = YES;
            }
            return;
        }
        _isFetching = YES;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name,last_name,name,id"}];
        [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            self->_isFetching = NO;
            if (!error && result) {
                self->_meDetails = result;
                [self snsLoginSuccess];
            } else {
                [self snsLoginFailure:error.localizedDescription];
            }
        }];
    }
}
    
-(void)fetchMeWithNoCallback
{
    if ([self isFBInstalled]) {
        if (_isFetching) {
            return;
        }
        _isFetching = YES;
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"first_name,last_name,name,id"}];
        [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            self->_isFetching = NO;
            if (!error && result) {
                self->_meDetails = result;
                if (self->_flag) {
                    [self snsLoginSuccess];
                    self->_flag = NO;
                }
            } else {
            }
        }];
    }
}

-(void)fetchFriends:(BOOL)invitable
{
    if ([self isFBInstalled]) {
        [super fetchFriends:invitable];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:(invitable ? @"me/invitable_friends" : @"me/friends")
                                      parameters:@{ @"fields":@"id,name" }
                                      HTTPMethod:@"GET"];
        
        [request startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            // Handle the result
            DLog(@"[facebook]%@", result);
            if(!error && result) {
                NSArray *data = [result objectForKey:@"data"];
                if(invitable) {
                    [self snsReceiveInvitableFriends:data];
                } else {
                    if(data) {
                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                        for (long i=data.count - 1; i >= 0; i--) {
                            NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithDictionary:[data objectAtIndex:i]];
                            NSString *uid = [obj objectForKey:@"id"];
                            NSString *name = [obj objectForKey:@"name"];
                            [obj setObject:uid forKey:@"id"];
                            [obj setObject:name forKey:@"name"];
                            [obj setObject:[[self class] fetchPictureURL:uid] forKey:@"picture"];
                            [arr addObject:obj];
                        }
                        if([arr count] > 0) {
                            self->_friends = [SDKJSONHelper toJSONString:arr];
                            if(self->_friends) {
                                [[SDKCache cache] setObject:self->_friends forKey:SDK_SNS_FRIENDS];
                            }
                        }
                        [self snsReceiveFriends:arr];
                    }
                }
            }
        }];
    }
}

// The Graph API for scores lets game developers build social leaderboards and game-matching by storing players' scores as they play.
// These scores will appearin the Games Feed on Facebook.
// https://developers.facebook.com/docs/games/scores
-(void)fetchScores
{
//    if ([self isFBInstalled]) {
//        [super fetchScores];
//        FBSDKGraphRequest *req = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/scores", [FBSDKSettings appID]] parameters:@{@"fields":@"score,user"}];
//        [req startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
//            if (!error && result)
//            {
//                NSArray* fetchedScoreData = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
//                if ([fetchedScoreData count] > 0){
//                    [self snsReceiveScores:fetchedScoreData];
//                }
//            }
//        }];
//    }
}

// The Graph API for scores lets game developers build social leaderboards and game-matching by storing players' scores as they play.
// https://developers.facebook.com/docs/games/scores
-(void)sendScore: (int)score {
    [super sendScore:score];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", score], @"score", @"score", @"fields", nil];
    
    DLog(@"[facebook]Fetching current score");
    
    FBSDKGraphRequest *req = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/scores", [self meId]] parameters:params];
    [req startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
        if (!error && result)
        {
            if ([[result objectForKey:@"data"] count] > 0){
                int nCurrentScore = [[[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"score"] intValue];
                
                DLog(@"[facebook]Current score is %d", nCurrentScore);
                
                if (score > nCurrentScore) {
                    
                    DLog(@"[facebook]Posting new score of %d", score);
                    FBSDKGraphRequest *req2 = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:[NSString stringWithFormat:@"%@/scores", [self meId]]
                                               parameters:params
                                               HTTPMethod:@"POST"];
                    [req2 startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
                        DLog(@"[facebook]Score Posted");
                    }];
                }
                else {
                    DLog(@"[facebook]Existing score is higher - not posting new score");
                }
            } else {
                DLog(@"[facebook]Posting new score of %d", score);
                FBSDKGraphRequest *req2 = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:[NSString stringWithFormat:@"%@/scores", [self meId]]
                                           parameters:params
                                           HTTPMethod:@"POST"];
                [req2 startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
                    DLog(@"[facebook]Score Posted");
                }];
            }
        }
    }];
}

// The Graph API for achievements enables you to publish achievements in your game
// so players can tell more meaningful and relevant stories.
// https://developers.facebook.com/docs/games/achievements
-(void)sendAchievement: (int)achievement {
    [super sendAchievement:achievement];
    if(_achievementURLS) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", [_achievementURLS objectAtIndex:achievement]], @"achievement", nil];
        
        FBSDKGraphRequest *req = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"%@/achievements", [self meId]]parameters:params HTTPMethod:@"POST"];
        [req startWithCompletion:^(id<FBSDKGraphRequestConnecting>  _Nullable connection, id  _Nullable result, NSError * _Nullable error) {
            DLog(@"[facebook]Achievements Posted");
        }];
    }
}

-(void)share
{
    [super share];
    if(![SDKHelper isEmptyString:share_url]) {
        [self share:share_url withTag:nil withQuote:share_msg mode:FBSDKShareDialogModeAutomatic];
    }
}

-(void)share:(nonnull NSString *)linkURL withTag:(nullable NSString *)tag withQuote:(nullable NSString *)quote
{
    [super share:linkURL withTag:tag withQuote:quote];
    [self share:linkURL withTag:tag withQuote:quote mode:FBSDKShareDialogModeAutomatic];
}

// Sharing stories using a dialog in the iOS integrated Facebook Share Sheet
-(void)shareSheet:(nonnull NSString *)linkURL withTag:(nullable NSString *)tag withQuote:(nullable NSString *)quote
{
    [super shareSheet:linkURL withTag:tag withQuote:quote];
    [self share:linkURL withTag:tag withQuote:quote mode:FBSDKShareDialogModeShareSheet];
}

-(void)share:(nonnull NSString *)linkURL withTag:(nullable NSString *)tag withQuote:(nullable NSString *)quote mode:(FBSDKShareDialogMode)mode
{
    [super share:linkURL withTag:tag withQuote:quote];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    [content setContentURL:[NSURL URLWithString:linkURL]];
    if(tag) {
        content.hashtag = [[FBSDKHashtag alloc] initWithString:tag];
    }
    if(quote) {
        content.quote = quote;
    }
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] initWithViewController:[UIApplication sharedApplication].keyWindow.rootViewController content:content delegate:self];
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    [dialog setMode:mode];
//        [dialog setMode:FBSDKShareDialogModeNative];
//    [dialog setShareContent:content];
//    [dialog setFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    [dialog setDelegate:self];
    
    if ([dialog canShow]){
        [dialog show];
    } else {
        DLog(@"[facebook]Cannot show share dialog");
    }
}

-(UIView *)getLoginButton
{
    return [[FBSDKLoginButton alloc] init];
}

-(UIView *)getShareButton:(nonnull NSString *)contentURL withTag:(nullable NSString *)tag withQuote:(nullable NSString *)quote
{
    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:contentURL];
    if(tag)
        content.hashtag = [[FBSDKHashtag alloc] initWithString:tag];
    if(quote)
        content.quote = quote;
    button.shareContent = content;
    return button;
}

-(UIView *)getSendButton:(nonnull NSString *)contentURL withTag:(nullable NSString *)tag withQuote:(nullable NSString *)quote
{
    FBSDKSendButton *button = [[FBSDKSendButton alloc] init];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:contentURL];
    if(tag)
        content.hashtag = [[FBSDKHashtag alloc] initWithString:tag];
    if(quote)
        content.quote = quote;
    button.shareContent = content;
    return button;
}

-(BOOL)hasPermission: (NSString *)permission
{
    if (!loginManager) {
        loginManager = [[FBSDKLoginManager alloc] init];
    }
    return [[FBSDKAccessToken currentAccessToken] hasGranted:permission];
}

-(NSString *)meFirstName
{
    return _meDetails ? [_meDetails objectForKey:@"first_name"] : @"";
}

-(NSString *)meLastName
{
    return _meDetails ? [_meDetails objectForKey:@"last_name"] : @"";
}

-(NSString *)meName
{
    return _meDetails ? [_meDetails objectForKey:@"name"] : @"";
}

-(NSString *)meId
{
    return _meDetails ? [_meDetails objectForKey:@"id"] : @"";
}

-(NSString *)mePictureURL
{
    return [[self class] fetchPictureURL:[self meId]];
}

+(NSString *)fetchPictureURL: (NSString *)fbid
{
    return [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=256&height=256", fbid];
}

-(nonnull NSString *)me
{
    return _meDetails ? [NSString stringWithFormat:@"{\"id\":\"%@\", \"name\":\"%@\", \"picture\":\"%@\"}", [self meId], [self meName], [self mePictureURL]] : @"{}";
}

-(nonnull NSString *)friends
{
    if(!_friends) {
        [self fetchFriends:NO];
    }
    return _friends ? _friends : @"[]";
}

// Publish Permissions - You must request these separately from read permissions.
// You should only request publish permissions after someone takes an action that requires it
// https://developers.facebook.com/docs/facebook-login/ios/permissions
//
-(void)requestWritePermissionFromViewController:(UIViewController *)fromViewController callback:(void (^)(BOOL))callback
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions", nil];
    
    if (!loginManager) {
        loginManager = [[FBSDKLoginManager alloc] init];
    }
    [loginManager logInWithPermissions:permissions fromViewController:fromViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if ([self hasPermission:@"publish_actions"]) {
            callback(YES);
        } else {
            callback(NO);
        }
    }];
}

// if the person does not grant user_friends permission, the app can rerequest it
-(void)requestFriendPermissionFromViewController:(UIViewController *)fromViewController callback:(void (^)(BOOL))callback
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_friends", nil];
    if (!loginManager) {
        loginManager = [[FBSDKLoginManager alloc] init];
    }
    
    [loginManager logInWithPermissions:permissions fromViewController:fromViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if ([self hasPermission:@"user_friends"]) {
            callback(YES);
        } else {
            callback(NO);
        }
    }];
}

#pragma mark ==================== delegate ======================
/**
 Sent to the delegate when the share completes without error or cancellation.
 - Parameter sharer: The FBSDKSharing that completed.
 - Parameter results: The results from the sharer.  This may be nil or empty.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSString *postId = results[@"postId"];
    FBSDKShareDialog *dialog = (FBSDKShareDialog *)sharer;
    if (dialog.mode == FBSDKShareDialogModeBrowser && (postId == nil || [postId isEqualToString:@""])) {
        // 如果使用webview分享的，但postId是空的，
        // 这种情况是用户点击了『完成』按钮，并没有真的分享
        DLog(@"[facebook]Cancel");
        [self snsShareCancel];
    } else {
        DLog(@"[facebook]Success");
        [self snsShareSuccess];
    }
}

/**
 Sent to the delegate when the sharer encounters an error.
 - Parameter sharer: The FBSDKSharing that completed.
 - Parameter error: The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    FBSDKShareDialog *dialog = (FBSDKShareDialog *)sharer;
    if (error == nil && dialog.mode != FBSDKShareDialogModeBrowser) {
        // 如果使用原生登录失败，但error为空，那是因为用户没有安装Facebook app
        // 重设dialog的mode，再次弹出对话框
        dialog.mode = FBSDKShareDialogModeBrowser;
        [dialog show];
    } else {
        DLog(@"[facebook]Failure");
        [self snsShareFailure];
    }
}

/**
 Sent to the delegate when the sharer is cancelled.
 - Parameter sharer: The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    [self snsShareCancel];
}

///*!
// @abstract Sent to the delegate when the game request completes without error.
// @param gameRequestDialog The FBSDKGameRequestDialog that completed.
// @param results The results from the dialog.  This may be nil or empty.
// */
//- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results {
//    DLog(@"[facebook]%@", results);
//}
//
///*!
// @abstract Sent to the delegate when the game request encounters an error.
// @param gameRequestDialog The FBSDKGameRequestDialog that completed.
// @param error The error.
// */
//- (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error {
//    DLog(@"[facebook]%@", error);
//}
//
///*!
// @abstract Sent to the delegate when the game request dialog is cancelled.
// @param gameRequestDialog The FBSDKGameRequestDialog that completed.
// */
//- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog {
//    DLog(@"[facebook]a game request is canceled");
//}
@end
