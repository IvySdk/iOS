#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import <IvyiOSSdk/SDKBaseInit.h>
#import <IvyiOSSdk/SDKCloudFunctionDelegate.h>

@interface SDKFirebaseFunction : NSObject

@property(strong, nonatomic) FIRFunctions *functions;

-(void) call: (NSString *)method params:(NSString *)params handler:(id<SDKCloudFunctionDelegate>)handler;

@end
