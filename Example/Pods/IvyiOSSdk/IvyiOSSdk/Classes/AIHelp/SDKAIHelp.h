//
//  SDKAIHelp.h
//  Pods
//
//  Created by iOS打包3 on 2023/7/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDKAIHelp : NSObject

-(void)showAIHelp:(nonnull NSString*) entranceId message:(nonnull NSString*)meta tag:(nullable NSString*) tags welcome:(nullable NSString*) wMsg;

-(void)showSignleFAQ:(nonnull NSString*) faqId momemt:(int)mnt;

-(BOOL)isAIHelpInitialized;

-(void)loadAIHelpUnreadMessageCount:(BOOL) onlyOnce;

-(void)stopLoadAIHelpUnreadMessageCount;

-(void)closeAIHelp;

-(void)switchLanguage:(nonnull NSString*) lang;

-(nonnull id) initWithkey:(nonnull NSString*)key withAppId:(nonnull NSString*)appId withUrl:(nonnull NSString*)url;

@end
