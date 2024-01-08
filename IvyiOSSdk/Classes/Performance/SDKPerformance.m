//
//  SDKFirebaseInit.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKPerformance.h"
#import <FirebasePerformance/FirebasePerformance.h>
#import <IvyiOSSdk/SDKFirebaseInit.h>
@implementation SDKPerformance
{
    @private
    NSMutableDictionary<NSString *, FIRTrace *> *_traceMap;
}
-(instancetype)init
{
    self = [super init];
    _traceMap = [[NSMutableDictionary alloc] init];
    return self;
}

-(void)startTraceWithName:(NSString *)name
{
    FIRTrace *trace = [_traceMap objectForKey:name];
    if (trace) {
        [trace stop];
        [trace start];
    } else {
        trace = [FIRPerformance startTraceWithName:name];
        [_traceMap setObject:trace forKey:name];
    }
}

-(void)stopTraceWithName:(NSString *)name
{
    FIRTrace *trace = [_traceMap objectForKey:name];
    if (trace) {
        [trace stop];
    }
}

-(void)incrementMetric:(NSString *)name byInt:(int)intValue
{
    FIRTrace *trace = [_traceMap objectForKey:name];
    if (trace) {
        [trace incrementMetric:name byInt:intValue];
    }
}
@end
