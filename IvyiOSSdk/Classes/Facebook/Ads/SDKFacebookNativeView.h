//
//  SDKFacebookNativeView.h
//  Bolts
//
//  Created by 余冰星 on 2017/12/27.
//
#import <IvyiOSSdk/SDKNativeView.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <FBAudienceNetwork/FBAdIconView.h>
#import <FBAudienceNetwork/FBAdChoicesView.h>
@interface SDKFacebookNativeView : SDKNativeView<FBMediaViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet FBAdIconView *adIconImageView;
@property (weak, nonatomic) IBOutlet FBMediaView *adCoverMediaView;
//@property (strong, nonatomic) IBOutlet UILabel *adStatusLabel;
@property (weak, nonatomic) IBOutlet FBAdOptionsView *adChoicesView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *adSocialContextLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sponsoredLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *sponsored;
@property (weak, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *adCornerView;
@end
