#import "SDKFirebaseFirestore.h"
#import <IvyiOSSdk/SDKDefine.h>
#import <IvyiOSSdk/SDKJSONHelper.h>
#import <IvyiOSSDk/SDKCache.h>

NSString * const SDK_FIRESTORE_ANONYMOUS = @"SDK_Firestore_Anonymous";

@implementation SDKFirebaseFirestore

-(instancetype)init
{
    self.db = [FIRFirestore firestore];
    return self;
}

-(nullable NSString*) getFirebaseUserId
{
    FIRUser* currentUser = [[FIRAuth auth] currentUser];
    return currentUser != nil ? [currentUser uid] : nil;
}

-(void) updateFirestore:(nonnull NSString *)collection transactionId:(nonnull NSString *)transactionId jsonData:(nonnull NSString *)jsonData handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    DLog(@"updateFirestore %@ %@", collection, jsonData);
    
    NSString* firebaseUserId = [self getFirebaseUserId];
    if (firebaseUserId == NULL) {
        [handler onFirestoreFail:@"onFirestoreUpdateFail" data:[NSString stringWithFormat:@"%@|%@",collection,transactionId]];
        return;
    }
    
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:firebaseUserId];
    id data = [SDKJSONHelper toArrayOrNSDictionary:jsonData];
    if (data == nil || ![data isKindOfClass: [NSDictionary class]]) {
        DLog(@"UpdateFirestore failed, data is not dictionary %@", jsonData);
        [handler onFirestoreFail:@"onFirestoreUpdateFail" data:[NSString stringWithFormat:@"%@|%@",collection,transactionId]];
    } else {
        [docRef updateData:data completion:^(NSError * _Nullable error) {
            if (error == nil) {
                [handler onFirestoreSuccess:@"onFirestoreUpdateSuccess" data:[NSString stringWithFormat:@"%@|%@",collection,transactionId]];
            } else {
                [handler onFirestoreFail:@"onFirestoreUpdateFail" data: [NSString stringWithFormat:@"%@|%@",collection,transactionId]];
            }
        }];
    }
}

-(void) setFirestore:(nonnull NSString *)collection jsonData:(nonnull NSString *)jsonData handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    DLog(@"setFirestore %@", collection);
    NSString* firebaseUserId = [self getFirebaseUserId];
    if (firebaseUserId == nil) {
        [handler onFirestoreFail:@"onFirestoreSetFail" data:collection];
        return;
    }
    
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:firebaseUserId];
    
    
    id data = [SDKJSONHelper toArrayOrNSDictionary:jsonData];
    if (data == nil || ![data isKindOfClass: [NSDictionary class]]) {
        DLog(@"UpdateFirestore failed jsonData %@", jsonData);
        [handler onFirestoreFail:@"onFirestoreSetFail" data:collection];
        return;
    }
    
    [docRef setData:data completion:^(NSError * _Nullable error) {
        if (error == nil) {
            [handler onFirestoreSuccess:@"onFirestoreSetSuccess" data:collection];
        } else {
            [handler onFirestoreFail:@"onFirestoreSetFail" data:collection];
        }
    }];
}

-(void) mergeFirestore:(nonnull NSString *)collection jsonData:(nonnull NSString *)jsonData handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    DLog(@"mergeFirestore %@", collection);
    NSString* firebaseUserId = [self getFirebaseUserId];
    if (firebaseUserId == nil) {
        [handler onFirestoreFail:@"onFirestoreMergeFail" data:collection];
        return;
    }
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:firebaseUserId];
    
    id data = [SDKJSONHelper toArrayOrNSDictionary:jsonData];
    if (data == nil || ![data isKindOfClass: [NSDictionary class]]) {
        DLog(@"UpdateFirestore failed");
        [handler onFirestoreFail:@"onFirestoreSetFail" data:collection];
        return;
    }
    [docRef setData:data merge:true completion:^(NSError * _Nullable error) {
        if (error == nil) {
            [handler onFirestoreSuccess:@"onFirestoreMergeSuccess" data:collection];
        } else {
            [handler onFirestoreFail:@"onFirestoreMergeFail" data:collection];
        }
    }];
}

-(void) deleteFirestore:(nonnull NSString *)collection handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    DLog(@"deleteFirestore %@", collection);
    NSString* firebaseUserId = [self getFirebaseUserId];
    if (firebaseUserId == nil) {
        [handler onFirestoreFail:@"onFirestoreDeleteFail" data:collection];
        return;
    }
    
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:firebaseUserId];
    [docRef deleteDocumentWithCompletion:^(NSError * _Nullable error) {
        if (error == nil) {
            [handler onFirestoreSuccess:@"onFirestoreDeleteSuccess" data:collection];
        } else {
            [handler onFirestoreFail:@"onFirestoreDeleteFail" data:collection];
        }
    }];
}

-(void) readFirestore:(nonnull NSString *)collection document:(nonnull NSString*) document handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:document];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot.exists) {
            // Document data may be nil if the document exists but has no keys or values.
            NSDictionary<NSString *, id>* data = snapshot.data;
            NSString* resultJson = [SDKJSONHelper toJSONString: data];
            DLog(@"Document data: %@", resultJson);
            NSString* composeCollection = [NSString stringWithFormat:@"%@|%@", collection, document];
            
            [handler onFirestoreData: composeCollection data: resultJson];
        } else {
            DLog(@"Document does not exist");
            NSString* composeCollection = [NSString stringWithFormat:@"%@|%@", collection, document];
            [handler onFirestoreData: composeCollection data: @"{}"];
        }
    }];
}

-(void) readFirestore:(nonnull NSString *)collection handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    NSString* firebaseUserId = [self getFirebaseUserId];
    if (firebaseUserId == nil) {
        [handler onFirestoreFail:@"onFirestoreReadFail" data:collection];
        return;
    }
    
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:firebaseUserId];
    [docRef getDocumentWithCompletion:^(FIRDocumentSnapshot *snapshot, NSError *error) {
        if (snapshot && snapshot.exists && error == nil) {
            // Document data may be nil if the document exists but has no keys or values.
            NSDictionary<NSString *, id>* data = snapshot.data;
            if (data) {
                NSString* resultJson = [SDKJSONHelper toJSONString: data];
                if (resultJson) {
                    [handler onFirestoreData: collection data: resultJson];
                    return;
                }
            }
        }
        [handler onFirestoreData: collection data: @"{}"];
        
    }];
}

-(void) snapshotFirestore:(nonnull NSString *)collection handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    DLog(@"snapshotFirestore %@", collection);
    NSString* firebaseUserId = [self getFirebaseUserId];
    if (firebaseUserId == nil) {
        [handler onFirestoreFail:@"onFirestoreSnapshotFail" data:collection];
        return;
    }
    FIRDocumentReference *docRef = [[self.db collectionWithPath:collection] documentWithPath:firebaseUserId];
    [docRef addSnapshotListener:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error == nil) {
            if (snapshot && snapshot.exists) {
                // Document data may be nil if the document exists but has no keys or values.
                NSDictionary<NSString *, id>* data = snapshot.data;
                if (data) {
                    NSString* resultJson = [SDKJSONHelper toJSONString: data];
                    if (resultJson) {
                        NSString* resultJsonString = [NSString stringWithFormat:@"%@|%@", collection, resultJson];
                        [handler onFirestoreSnapshot: resultJsonString];
                    }
                }
            }
        }
    }];
}

-(void) initFirestoreAfterSignIn:(nonnull NSString *)provider handler:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    DLog(@"initFirestoreAfterSignIn %@", provider);
    FIRUser* currentUser = [[FIRAuth auth] currentUser];
    if (currentUser && [currentUser isAnonymous]) {
        [handler onFirestoreConnected: [currentUser uid]];
        return;
    }
    //获取设备id
    NSString* dId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //构造假email地址
    NSString* dMail = [NSString stringWithFormat:@"%@@ivymobile.com", dId];
    //构造密码
    NSString* dPs = @"1234567_0";
    //读取缓存中的匿名登录标志
    NSString* isNewUser = (NSString*)[[SDKCache cache] objectForKey:SDK_FIRESTORE_ANONYMOUS];
    if((isNewUser != NULL)&&([isNewUser isEqualToString:@"false"])){
        //如果缓存中有标记,则登入
        [self initFirestorReSignin:dMail password:dPs handler:handler];
        return;
    }
    //如果缓存中没有标志则创建账号
    // 1 确实是新账号
    // 2 删除重装之后匿名登录
    [[FIRAuth auth] createUserWithEmail:dMail password:dPs
                         completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (authResult && error == NULL) {
            //创建账号成功，保存匿名登录标记
            [[SDKCache cache] setObject:@"false" forKey:SDK_FIRESTORE_ANONYMOUS];
            NSString* uid = [authResult.user uid];
            [handler onFirestoreConnected: uid];
            return;
        }
        if((error != NULL)&&(error.code == 17007)){
            //该邮件地址已经创建过账号，用该邮件地址登录
            [self initFirestorReSignin:dMail password:dPs handler:handler];
        }else {
            [handler onFirestoreConnectError: @""];
        }
    }];
//    if ([provider isEqualToString: @"anonymously"]) {
//
//    } else if ([provider isEqualToString: @"facebook"]) {
//
//    } else if ([provider isEqualToString: @"apple"]) {
//
//    }
}

-(void)initFirestorReSignin:(nonnull NSString*) email password:(nonnull NSString*) pswd handler:(_Nonnull id<SDKFirestoreDelegate>)handler{
    [[FIRAuth auth] signInWithEmail:email password:pswd completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (authResult && error == NULL) {
            NSString* uid = [authResult.user uid];
            [handler onFirestoreConnected: uid];
        } else {
            [handler onFirestoreConnectError: @""];
        }
    }];
}

-(void) signOutFirestore:(_Nonnull id<SDKFirestoreDelegate>)handler
{
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        DLog(@"Error signing out: %@", signOutError);
    }
}

@end

