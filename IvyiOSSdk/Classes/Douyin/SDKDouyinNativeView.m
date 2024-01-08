//
//  SDKDouyinNativeView.m
//  Bolts
//
//  Created by 余冰星 on 2017/12/27.
//

#import "SDKDouyinNativeView.h"

@implementation SDKDouyinNativeView
{
    @private
    LGNativeAdRelatedView *_relatedView;
    LGMaterialMeta *_adMeta;
}
-(void)loadNativeAd:(LGNativeAd *)nativeAd
{
    if (_nativeAd) {
        [_nativeAd unregisterView];
    }
    [super loadNativeAd:nativeAd];
    _adMeta = nativeAd.data;
    _relatedView = [[LGNativeAdRelatedView alloc] init];
    if (self.adTitleLabel) {
        self.adTitleLabel.text = nativeAd.data.AdTitle;
    }
    if (self.adBodyLabel) {
        self.adBodyLabel.text = nativeAd.data.AdDescription;
    }
    if (_adMeta.icon && _adMeta.icon.imageURL.length > 0) {
        UIImage *imagePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_adMeta.icon.imageURL]]];
        [self.iconView setImage:imagePic];
    }
    if (_adMeta.imageMode != LGFeedVideoAdModeImage) {
        if (_adMeta.imageAry.count > 0) {
            LGAdImage *image = _adMeta.imageAry.firstObject;
            if (image.imageURL.length > 0) {
                UIImage *imagePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageURL]]];
                [self.imageView setImage:imagePic];
            }
        }
    }
    if (self.adCallToActionButton) {
        [self.adCallToActionButton setTitle:nativeAd.data.buttonText forState:UIControlStateNormal];
    }
    if (self.closeButton) {
        [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    [_relatedView refreshData:_nativeAd];
}

-(void)setViewsWithConfig:(NSDictionary *)config
{
    [self setViewBg:self.bgImageView config:config keyName:nil];
    if (_relatedView) {
        if (_adMeta.imageMode == LGFeedVideoAdModeImage) {
            self.imageView.hidden = YES;
            _relatedView.videoAdView.hidden = NO;
            [self setViewWithConfig:_relatedView.videoAdView config:config keyName:@"image"];
        } else {
            self.imageView.hidden = NO;
            _relatedView.videoAdView.hidden = YES;
            [self setViewWithConfig:self.imageView config:config keyName:@"image"];
        }
        [self setViewWithConfig:self.iconView config:config keyName:@"icon"];
        [self setViewWithConfig:_relatedView.dislikeButton config:config keyName:@"adchoice"];
        [self setViewWithConfig:_relatedView.adLabel config:config keyName:@"ad"];
    }
    [self setViewWithConfig:self.adTitleLabel config:config keyName:@"title"];
    [self setViewWithConfig:self.adBodyLabel config:config keyName:@"desc"];
    [self setViewWithConfig:self.adCallToActionButton config:config keyName:@"action"];
    [self setViewWithConfig:self.closeButton config:config keyName:@"close"];
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
    if ([_owner enableClickSmall]) {
        // Register UIView with the native ad; the whole UIView will be clickable.
        [_nativeAd registerContainer:_nibView withClickableViews:@[self.adCallToActionButton]];
    } else {
        [_nativeAd registerContainer:_nibView withClickableViews:@[self.adTitleLabel, self.adBodyLabel, self.imageView,  self.adCallToActionButton]];
    }
}

@end
