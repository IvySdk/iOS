#import "SDKFirebaseFunction.h"
#import <Firebase/Firebase.h>
#import <SDKNetworkHelper.h>
#import <SDKJSONHelper.h>
#import <SDKDefine.h>

@implementation SDKFirebaseFunction

-(instancetype)init {
    self.functions = [FIRFunctions functions];
    return self;
}

-(void) call: (NSString *)method params:(NSString *)params handler: (id<SDKCloudFunctionDelegate>)handler {
    DLog(@"FirebaseFunction call >>> %@", method);
    id paramsData = nil;
    if (params != nil) {
        paramsData = [SDKJSONHelper toArrayOrNSDictionary: params];
    }
    [[self.functions HTTPSCallableWithName: method] callWithObject:paramsData completion:^(FIRHTTPSCallableResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            DLog(@"Got an error: %@", error);
            [handler onCloudFunctionFailed: [NSString stringWithFormat:@"%@|%@", method, error.localizedDescription]];
        } else {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result.data options: 0 error:&error];
            
            if (!jsonData) {
                DLog(@"Got an error: %@", error);
                [handler onCloudFunctionFailed: [NSString stringWithFormat:@"%@|%@", method, error.localizedDescription]];
            } else {
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                DLog(@"Cloud Function result: %@", jsonString);
                [handler onCloudFunctionResult: [NSString stringWithFormat:@"%@|%@", method, jsonString]];
            }
        }
    }];
}
@end

