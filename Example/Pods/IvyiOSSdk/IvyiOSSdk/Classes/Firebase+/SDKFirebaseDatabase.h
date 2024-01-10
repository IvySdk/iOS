#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import <IvyiOSSdk/SDKFirebaseDatabaseDelegate.h>
@interface SDKFirebaseDatabase : NSObject

-(void) sendChat:(nonnull NSString *)database path:(nonnull NSString *)path jsonData:(nonnull NSString *)jsonData;
-(void) listen:(nonnull NSString *)database path:(nonnull NSString *)path handler:(_Nonnull id<SDKFirebaseDatabaseDelegate>)handler;
@end
