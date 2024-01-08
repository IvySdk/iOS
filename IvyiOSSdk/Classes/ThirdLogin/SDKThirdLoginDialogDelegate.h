//
//  SDKThirdLoginDialogDelegate.h
//  Pods
//
//  Created by ivy on 2020/10/24.
//

#import <Foundation/Foundation.h>

@protocol SDKThirdLoginDialogDelegate <NSObject>

- (void)onSelectedAuthPlatform:(long) platform;

//同意实名验证
- (void)onStartVerifyIdCard:(NSString *) playerName idCardNum:(NSString *) idCard;

- (void)onPrivacyAccept:(BOOL) accept;

@end
