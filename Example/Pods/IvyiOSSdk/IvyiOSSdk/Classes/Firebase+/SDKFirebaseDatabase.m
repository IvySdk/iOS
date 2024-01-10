#import "SDKFirebaseDatabase.h"
#import <IvyiOSSdk/SDKDefine.h>
#import <IvyiOSSdk/SDKJSONHelper.h>

@implementation SDKFirebaseDatabase


-(void) sendChat:(nonnull NSString *)database path:(nonnull NSString *)path jsonData:(nonnull NSString *)jsonData
{
    DLog(@"send chat %@ %@", database, path);
    [[[[[FIRDatabase databaseWithURL:database] reference] child:path] childByAutoId] setValue:[SDKJSONHelper toArrayOrNSDictionary:jsonData] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error != nil) {
            DLog(@"send Chat exception %@", [error description]);
        } else {
            DLog(@"Message send successfully");
        }
    }];
}

-(void) listen:(nonnull NSString *)database path:(nonnull NSString *)path handler:(_Nonnull id<SDKFirebaseDatabaseDelegate>)handler
{
    DLog(@"listen chat %@ %@", database, path);
    
    [[[[FIRDatabase databaseWithURL:database] reference] child:path] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        id value = [snapshot value];
        
        DLog(@"chat message received %@", value);
        
        if (value != nil && [value isKindOfClass:[NSDictionary class]]) {
            @try {
                NSString* key = [snapshot key];
                
                NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithDictionary:value];
                [resultDict setObject:key forKey:@"_id"];
                
                NSString* result = [SDKJSONHelper toJSONString:resultDict];
                
                DLog(@"data received %@", result);
                
                [handler onChatMessage:result];
            }@catch (NSException *exception) {
                
            }
        }
    }];
}
@end

