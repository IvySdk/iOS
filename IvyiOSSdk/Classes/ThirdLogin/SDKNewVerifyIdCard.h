//
//  SDKNewVerifyIdCard.h
//  FlatUIKit
//
//  Created by 余冰星 on 2020/2/25.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface SDKNewVerifyIdCard : NSObject
+ (nonnull SDKNewVerifyIdCard *)sharedInstance;

@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) long dailyPlay;
@property (nonatomic, assign) double dailypay;
@property (nonatomic, assign) double monthpay;
@property (nonatomic, assign) double totalpay;

-(void)verifyIdCard:(NSString *)idCard name:(NSString *)playerName uuid:(NSString *) uuid verifyUrl:(NSString *)verifyUrl verifyCallback:(void(^)(int age))callback;
-(void)resetVerifyIdCard;
-(BOOL)checkCanPay;
-(void)paySuccess:(double)price;
@end

NS_ASSUME_NONNULL_END
