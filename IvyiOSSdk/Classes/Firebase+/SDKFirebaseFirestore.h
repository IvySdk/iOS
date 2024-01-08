#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import <IvyiOSSdk/SDKFirestoreDelegate.h>
@interface SDKFirebaseFirestore : NSObject

@property(strong, nonatomic) FIRFirestore * _Nullable db;

-(void) updateFirestore:(nonnull NSString *)collection transactionId:(nonnull NSString *)transactionId jsonData:(nonnull NSString *)jsonData handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) setFirestore:(nonnull NSString *)collection jsonData:(nonnull NSString *)jsonData handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) mergeFirestore:(nonnull NSString *)collection jsonData:(nonnull NSString *)jsonData handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) deleteFirestore:(nonnull NSString *)collection handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) readFirestore:(nonnull NSString *)collection handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) readFirestore:(nonnull NSString *)collection document:(nonnull NSString*) document handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) snapshotFirestore:(nonnull NSString *)collection handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) initFirestoreAfterSignIn:(nonnull NSString *)provider handler:(_Nonnull id<SDKFirestoreDelegate>)handler;
-(void) signOutFirestore: (_Nonnull id<SDKFirestoreDelegate>)handler;
-(nullable NSString*) getFirebaseUserId;

@end
