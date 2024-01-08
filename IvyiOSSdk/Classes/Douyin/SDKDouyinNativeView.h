//
//  SDKDouyinNativeView.h
//  Bolts
//
//  Created by 余冰星 on 2017/12/27.
//
#import <IvyiOSSdk/SDKNativeView.h>
#import <LightGameSDK/LightGameSDK.h>
@interface SDKDouyinNativeView : SDKNativeView
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end
