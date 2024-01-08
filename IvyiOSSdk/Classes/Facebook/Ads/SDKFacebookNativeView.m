//
//  SDKFacebookNativeView.m
//  Bolts
//
//  Created by 余冰星 on 2017/12/27.
//

#import "SDKFacebookNativeView.h"

@implementation SDKFacebookNativeView
-(void)loadNativeAd:(FBNativeAd *)nativeAd
{
    if (_nativeAd) {
        [_nativeAd unregisterView];
    }
    [super loadNativeAd:nativeAd];
    
    if (self.adCoverMediaView) {
        // Create native UI using the ad metadata.
//        [self.adCoverMediaView setNativeAd:nativeAd];
        self.adCoverMediaView.delegate = self;
    }
    
//    if (self.adIconImageView) {
//        __weak typeof(self) weakSelf = self;
//        [nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
//            __strong typeof(self) strongSelf = weakSelf;
//            strongSelf.adIconImageView.image = image;
//        }];
//    }
//    if(self.adStatusLabel) {
//        self.adStatusLabel.text = @"";
//    }
    if (self.adTitleLabel) {
//        self.adTitleLabel.text = nativeAd.title;
        self.adTitleLabel.text = nativeAd.headline;
    }
    if (self.adBodyLabel) {
//        self.adBodyLabel.text = nativeAd.body;
        self.adBodyLabel.text = nativeAd.bodyText;
    }
    
    if (self.adSocialContextLabel) {
        self.adSocialContextLabel.text = nativeAd.socialContext;
    }
//    if (self.sponsoredLabel) {
//        self.sponsoredLabel.text = @"Sponsored";
//    }
    if (self.adChoicesView) {
        [self.adChoicesView setNativeAd:nativeAd];
//        self.adChoicesView.corner = UIRectCornerTopRight;
    }
    if (self.adCallToActionButton) {
        [self.adCallToActionButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    }
    if (self.closeButton) {
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)mediaViewDidLoad:(FBMediaView *)mediaView
{
    self.adCoverMediaView = mediaView;
}

-(void)setViewsWithConfig:(NSDictionary *)config
{
    [self setViewBg:self.bgImageView config:config keyName:nil];
    [self setViewWithConfig:self.adIconImageView config:config keyName:@"icon"];
    [self setViewWithConfig:self.adCoverMediaView config:config keyName:@"image"];
    [self setViewWithConfig:self.adTitleLabel config:config keyName:@"title"];
    [self setViewWithConfig:self.adBodyLabel config:config keyName:@"desc"];
    [self setViewWithConfig:self.adCallToActionButton config:config keyName:@"action"];
    [self setViewWithConfig:self.closeButton config:config keyName:@"close"];
//    [self setViewWithConfig:self.sponsored config:config keyName:@"sponsored"];
    [self setViewWithConfig:self.adCornerView config:config keyName:@"ad"];
    [self setViewWithConfig:self.adChoicesView config:config keyName:@"adchoice"];
}

-(void)onViewsScale:(CGFloat)scaleX scaleY:(CGFloat)scaleY
{
}

-(void)setVc:(UIViewController *)vc
{
    [super setVc:vc];
    if (_nativeAd) {
        [_nativeAd unregisterView];
    }
    if (self.adCoverMediaView) {
        [self.adCoverMediaView setUserInteractionEnabled:NO];
    }
    if ([_owner enableClickSmall]) {
        if (self.adTitleLabel) {
            //        self.adTitleLabel.text = nativeAd.title;
            [self.adTitleLabel setUserInteractionEnabled:NO];
        }
        if (self.adBodyLabel) {
            //        self.adBodyLabel.text = nativeAd.body;
            [self.adBodyLabel setUserInteractionEnabled:NO];
        }
        [_nativeAd registerViewForInteraction:_nibView mediaView:self.adCoverMediaView iconView:nil viewController:vc clickableViews:@[self.adCallToActionButton]];
    } else {
        [_nativeAd registerViewForInteraction:_nibView mediaView:self.adCoverMediaView iconView:self.adIconImageView viewController:vc clickableViews:@[self.adTitleLabel, self.adBodyLabel, self.adCallToActionButton]];
    }
}

@end
