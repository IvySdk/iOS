//
//  SDKVerifyIdCard.h
//  FlatUIKit
//
//  Created by 余冰星 on 2020/2/25.
//

#import <Foundation/Foundation.h>
#import <IvyiOSSdk/SDKCustomAlertView.h>
NS_ASSUME_NONNULL_BEGIN
@interface SDKVerifyIdCard : NSObject<SDKCustomAlertViewDelegate>
+ (nonnull SDKVerifyIdCard *)sharedInstance;
@property (nonatomic, copy) dispatch_block_t onIdCardVerified;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) long leftSeconds;
@property (nonatomic, assign) long lastStartTime;
@property (nonatomic, assign) double dailypay;
@property (nonatomic, assign) double monthpay;
-(void)verifyIdCard;
-(void)resetVerifyIdCard;
-(BOOL)checkCanPay;
-(void)paySuccess:(double)price;
@end

NS_ASSUME_NONNULL_END
