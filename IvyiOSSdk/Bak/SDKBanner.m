//
//  SDKAdAdapter.m
//  Pods
//
//  Created by IceStar on 2017/7/12.
//
//

#import "SDKBanner.h"
#import "SDKHelper.h"
#import <IvyiOSSdk/SDKFacade.h>
@implementation SDKBanner
{
    @private
    long _reloadTime;
}

-(void)close
{
    [super close];
    long now = CACurrentMediaTime();
    if (now - _reloadTime >= 60) {
        _reloadTime = now;
        [super adNeedReload];
    }
}
@end
