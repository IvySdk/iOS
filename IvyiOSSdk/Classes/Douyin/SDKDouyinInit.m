//
//  SDKFirebaseCore.m
//  Bolts
//
//  Created by 余冰星 on 2017/10/24.
//

#import "SDKDouyinInit.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <IvyiOSSdk/SDKFacade.h>
#import <IvyiOSSdk/SDKDefine.h>
#import <LightGameSDK/LightGamePromoteControl.h>
const int RECORDING_START = 1;
const int RECORDING_PAUSE = 2;
const int RECORDING_CONTINUE = 3;
const int RECORDING_STOP = 4;
const NSString *_Nonnull SHARE_DOUYIN_SUCCESS = @"share_douyin_success";
@implementation SDKDouyinInit
{
    @private
    NSDictionary *_defaultRemoteConfig;
    LightGameDouYinAppletConfig *applet;
    LightGameEditor *_editor;
    LightGamePromoteControl *_control;
    int _recordingState;
    long _lastStartRecordingTime;
    BOOL _isRecording;
    BOOL _lastRecordingSuccess;
    share_result_block _share_result_block;
}
-(void)doInit:(NSDictionary *)data
{
    @try {
        DLog(@"%@", @"[douyin] init douyin");
        NSString *appid = [data objectForKey:@"appid"];
        NSString *appName = [data objectForKey:@"appname"];
        if (appid) {
            // 深度转化相关功能配置
            LGBDConfig *bdCfg = [[LGBDConfig alloc] init];
            NSNumber *tmp = (NSNumber *)[data objectForKey:@"oversea"];
            BOOL oversea = tmp ? tmp.boolValue : NO;
            // 域名默认国内，新加坡:LGBDAutoTrackServiceVendorSG
            bdCfg.serviceVendor = oversea ? LGBDAutoTrackServiceVendorSG : LGBDAutoTrackServiceVendorCN;
#if DEBUG
            bdCfg.showDebugLog = YES;
            bdCfg.logNeedEncrypt = NO;
            
            // 设置debug log 方便查找问题
            [LightGameManager isDebuLog:YES];
            // 设置debug log 为中文
            [LightGameManager debugType:LGDebugLogType_Chinese];
#else
            // 是否在控制台输出⽇日志，仅调试使⽤用。release版本请设置为 NO
            bdCfg.showDebugLog = NO;
            // 是否加密日志，默认加密。release版本请设置为 YES
            bdCfg.logNeedEncrypt = YES;
#endif
            id header = [data objectForKey:@"header"];
            if (header && [header isKindOfClass:[NSDictionary class]]) {
                // ⾃自定义 “⽤用户公共属性”(可选，在需要的位置调⽤用，key相同会覆盖，在调⽤用 startTrackWithConfig 后⽣生效)
                bdCfg.customHeaderBlock = ^NSDictionary<NSString *,id> * _Nonnull{
                    return header;
                };
            }
            
            /** 拥有账号体系可以调用
            // 用户id
            [LightGameManager setCurrentUserUniqueID:@"YourUserAccountId"];
            // 清空用户id
            [LightGameManager clearUserUniqueID];
             **/
            
            NSString *abServerVersion = (NSString *)[data objectForKey:@"abServerVersion"];
            bdCfg.abServerVersions = abServerVersion ? abServerVersion : @"318";
            bdCfg.ABTestFinishBlock = ^(BOOL ABTestEnabled, NSDictionary * _Nullable allConfigs) {
                if (ABTestEnabled) {
                    self->_defaultRemoteConfig = allConfigs;
                }
            };
            NSString *serverVersion = (NSString *)[data objectForKey:@"serverVersion"];
            [LightGameManager setServerVersions:serverVersion ? serverVersion : @"325"];
            [[LightGameManager sharedInstance] configTTTrack:bdCfg];
            /**
             * 账号体系登录
             **/
            // 是否开启账号功能的Toast提示设置, 默认为yes, 可设置no关闭  非必须配置项
//            [LightGameLoginManager setIsLoginToastPrompt:YES];
//            [LightGameLoginManager setLoginMode:LGLoginModeSilent];
            
            // 以下为接入方向广告变现SDK申请的唯一appID
            [LightGameManager startWithAppID:appid appName:appName channel:@"App Store"];
            DLog(@"[init] douyin init setup success.");
        } else {
            @throw [NSException exceptionWithName:@"No douyin-appid" reason:@"not configure douyin-appid, please check your default.json!" userInfo:nil];
        }
        NSDictionary *appletData = [data objectForKey:@"applet"];
        if (appletData) {
            applet = [[LightGameDouYinAppletConfig alloc] init];
            NSString *appletId = [appletData objectForKey:@"appid"];
            NSString *url = [appletData objectForKey:@"url"];
            NSString *title = [appletData objectForKey:@"title"];
            NSString *desc = [appletData objectForKey:@"desc"];
            applet.appletID = appletId;
            applet.startPageUrl = url;
            applet.title = title;
            applet.descriptionTitle = desc;
        }
        
    } @catch (NSException *exception) {
        DLog(@"[douyin] err: %@", exception.description);
    } @finally {
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
//    return [LightGameManager handleOpenURL:url delegate:self];
    return [LightGameManager application:application openURL:url options:options delegate:self];
//    return [LightGameManager application:application openURL:url options:options delegate:self] || [LGTouTiaoLogin handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    return [LightGameManager handleOpenURL:url delegate:self];
    return [LightGameManager application:application openURL:url options:@{} delegate:self];
//    return [LightGameManager application:application openURL:url options:@{} delegate:self] || [LGTouTiaoLogin handleOpenURL:url];
}

- (void)didReceiveResponseErrorCode:(LGADouyinOpenSDKErrorCode)errorCode errorString:(NSString *)errorString state:(NSString *)state
{
    DLog(@"[douyin] receive response error : %@", errorString);
}
- (void)didReceiveShareResponse:(TikTokOpenPlatformShareResponse *)resp
{
    if (_share_result_block && resp) {
        NSString *errStr = nil;
        BOOL shareSuccess = false;
        if (resp.isSucceed) {
            if ([SHARE_DOUYIN_SUCCESS isEqualToString:resp.state]) {
                shareSuccess = true;
            } else {
                errStr = @"分享失败";
            }
        } else {
            errStr = resp.errString;
        }
        _share_result_block(shareSuccess, errStr);
        _share_result_block = nil;
    }
}
#pragma mark --------------- Extend Methods ----------------

-(void)requestPhotoWritePermission:(void (^)(BOOL))result
{
    DLog(@"[douyin] requestPhotoWritePermission");
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (result) {
            BOOL permit = status == PHAuthorizationStatusAuthorized;
            DLog(@"[douyin] requestPhotoWritePermissionResult : %@", permit ? @"YES" : @"NO");
            result (permit);
        }
    }];
}

-(BOOL)hasPhotoWritePermission
{
    DLog(@"[douyin] hasPhotoWritePermission");
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

-(void)openSettingPage
{
    DLog(@"[douyin] openSettingPage");
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        [[UIApplication sharedApplication] openURL:settingUrl];
    }
}

-(BOOL)isRecording
{
//    return [[LightGameRecorder shareInstance] isRecording];
    return _isRecording;
}

- (void)startRecording
{
    // 录屏参数设置
    // 打开智能编辑，默认关闭。只有含智能编辑的SDK才有该接口
    [LightGameRecorder shareInstance].isNeedEditor = YES;
    //帧率设置
    [LightGameRecorder shareInstance].frameIntervalKey = 60;
//设置录屏时间达到阈值是的回调，目前最多可录屏3min。到达3min自动停止，之前用户可手动停止
    [[LightGameRecorder shareInstance] setStopRecordingByLightGameBlock:^(BOOL success) {
        self->_lastRecordingSuccess = success;
    }];
    long now = CACurrentMediaTime();
    if (now - _lastStartRecordingTime > 10 && ![[LightGameRecorder shareInstance] isRecording]) {
        _recordingState = 0;
    }
    if (_recordingState == RECORDING_START) {
        return;
    }
    _lastStartRecordingTime = now;
    _recordingState = RECORDING_START;
    _isRecording = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            DLog(@"[douyin] startRecording");
            [[LightGameRecorder shareInstance] startRecording];
        } @catch (NSException *exception) {
            self->_isRecording = NO;
            DLog(@"[douyin] Exception: %@", [exception description]);
        } @catch (NSError *error) {
            self->_isRecording = NO;
            DLog(@"[douyin] Error: %@", [error localizedDescription]);
        } @finally {
        }
    });
}

- (void)pauseRecording
{
    if (_recordingState == RECORDING_PAUSE) {
        return;
    }
    _recordingState = RECORDING_PAUSE;
    if (_isRecording) {
        DLog(@"[douyin] pauseRecording");
        [[LightGameRecorder shareInstance] pauseRecording];
    }
}

- (void)continueRecording
{
    if (_recordingState == RECORDING_CONTINUE) {
        return;
    }
    _recordingState = RECORDING_CONTINUE;
    if (_isRecording) {
        DLog(@"[douyin] continueRecording");
        [[LightGameRecorder shareInstance] continueRecording];
    }
}

- (void)stopRecording:(bool_result_block)complete
{
    if (_recordingState == RECORDING_STOP) {
        return;
    }
    _recordingState = RECORDING_STOP;
    if (_isRecording) {
        _isRecording = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"[douyin] stopRecording");
            [[LightGameRecorder shareInstance] stopRecording:^(BOOL success) {
                DLog(@"[douyin] record video success = %@", (success ? @"true" : @"false"));
                self->_lastRecordingSuccess = success;
                if (complete) {
                    complete(success);
                }
            }];
        });
    }
}

//- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(void (^)(NSString *filePatch,NSString *dTime))result {
//    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//    options.version = PHImageRequestOptionsVersionCurrent;
//    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//
//    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//
//        NSString * sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
//
//        NSArray * arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
//
//        NSString * filePath = arr[arr.count - 1];
//
//        CMTime   time = [asset duration];
//        int seconds = ceil(time.value/time.timescale);
//        //format of minute
//        NSString *str_minute = [NSString stringWithFormat:@"%d",seconds/60];
//        //format of second
//        NSString *str_second = [NSString stringWithFormat:@"%.2d",seconds%60];
//        //format of time
//        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
//
//        result(filePath,format_time);
//    }];
//}

-(void)editVideo:(NSString *)path complete:(nullable string_result_block)complete
{
    DLog(@"[douyin] editVideo : %@", path);
    if (!_editor) {
        _editor = [[LightGameEditor alloc] init];
        _editor.delegate = self;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_editor editVideo:path isSaveToAlbum:YES complete:complete];
    });
}

- (void)shareRecentRecordVideo:(share_result_block)result
{
    DLog(@"[douyin] shareRecentRecordVideo : %@", _lastRecordingSuccess ? @"true" : @"false");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_lastRecordingSuccess) {
            self->_share_result_block = result;
            [[LightGameRecorder shareInstance] recordVideoShareToDouYinWithState:SHARE_DOUYIN_SUCCESS appletInfo:self->applet];
        }
    });
}

- (BOOL)sharePhotos:(NSArray *)photoIdentifiers result:(nullable share_result_block)result
{
    _share_result_block = result;
    DLog(@"[douyin] sharePhotos");
    if (photoIdentifiers.count > 0) {
        BOOL success = [[LightGameManager sharedInstance] douyinShareWithMediaType:LGADouyinOpenSDKShareMediaTypeImage localIdentifiers:photoIdentifiers state:SHARE_DOUYIN_SUCCESS appletInfo:applet];
        if (success) {
            DLog(@"[douyin] send share req success");
//            if (result) {
//                result(success, nil);
//            }
        } else {
            [SDKHelper showAlertDialog:@"分享失败" desc:@"请升级至抖音最新版本体验此功能" okBtn:@"OK" cancelBtn:nil onOk:nil onCancel:nil];
            if (result) {
                result(success, @"请升级至抖音最新版本体验此功能");
                _share_result_block = nil;
            }
        }
        return success;
    }
    [SDKHelper showAlertDialog:@"分享失败" desc:@"相册中没有找到分享的图片内容" okBtn:@"OK" cancelBtn:nil onOk:nil onCancel:nil];
    if (result) {
        result(false, @"相册中没有找到分享的图片内容");
        _share_result_block = nil;
    }
    return false;
}

- (BOOL)shareVideos:(NSArray *)videoIdentifiers result:(nullable share_result_block)result
{
    DLog(@"[douyin] shareVideos");
    _share_result_block = result;
    if (videoIdentifiers.count > 0) {
        BOOL success = [[LightGameManager sharedInstance] douyinShareWithMediaType:LGADouyinOpenSDKShareMediaTypeVideo localIdentifiers:videoIdentifiers state:SHARE_DOUYIN_SUCCESS appletInfo:applet];
        if (success) {
            DLog(@"[douyin] send share req success");
//            if (result) {
//                result(success, nil);
//            }
        } else {
            [SDKHelper showAlertDialog:@"分享失败" desc:@"请升级至抖音最新版本体验此功能" okBtn:@"OK" cancelBtn:nil onOk:nil onCancel:nil];
            if (result) {
                result(success, @"请升级至抖音最新版本体验此功能");
                _share_result_block = nil;
            }
        }
        return success;
    }
    [SDKHelper showAlertDialog:@"分享失败" desc:@"相册中没有找到分享的视频内容" okBtn:@"OK" cancelBtn:nil onOk:nil onCancel:nil];
    if (result) {
        result(false, @"相册中没有找到分享的视频内容");
        _share_result_block = nil;
    }
    return false;
}

- (void)showPromotion:(CGPoint)position
{
    DLog(@"[douyin] showPromotion");
    if (!_control) {
        _control = [[LightGamePromoteControl alloc] init];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        LGPromotionShakeConfiguration *config = [[LGPromotionShakeConfiguration alloc] init]; // 初始化配置
        CGFloat scale = UIScreen.mainScreen.scale;
        config.origin = CGPointMake(position.x / scale, position.y / scale);
        config.superView = [KeyWindow rootViewController].view;
        config.displayVC = [KeyWindow rootViewController];
        [self->_control promotionAlertWindow:config];
    });
}

- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        DLog(@"保存视频失败%@", error.localizedDescription);
    } else {
        DLog(@"保存视频成功");
    }
    _editor = nil;
}

- (void)videoMergeProgress:(NSInteger)progress
{
    DLog(@"智能编辑视频进度：%d", (int)progress);
}
#pragma mark --------------- Remote Config ----------------
-(void)setDefaults:(nullable NSDictionary *)data
{
    _defaultRemoteConfig = data;
}
-(id)getDefaultValue:(NSString *)key valueClass:(Class)valueClass
{
    id value = nil;
    if (_defaultRemoteConfig) {
        value = [_defaultRemoteConfig objectForKey:key];
    }
    if (!value) {
        if ([valueClass isEqual:NSNumber.class]) {
            value = @(0);
        } else if ([valueClass isEqual:NSString.class]) {
            value = @"";
        }
    }
    return value;
}
-(int)getRemoteConfigIntValue:(nonnull NSString *)key
{
    NSNumber *result = [LightGameManager ABTestConfigValueForKey:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.intValue;
}
-(long)getRemoteConfigLongValue:(nonnull NSString *)key
{
    NSNumber *result = [LightGameManager ABTestConfigValueForKey:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.longValue;
}
-(double)getRemoteConfigDoubleValue:(nonnull NSString *)key
{
    NSNumber *result = [LightGameManager ABTestConfigValueForKey:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.doubleValue;
}
-(BOOL)getRemoteConfigBoolValue:(nonnull NSString *)key
{
    NSNumber *result = [LightGameManager ABTestConfigValueForKey:key defaultValue:[self getDefaultValue:key valueClass:NSNumber.class]];
    return result.boolValue;
}
-(nonnull NSString *)getRemoteConfigStringValue:(nonnull NSString *)key
{
    NSString *result = [LightGameManager ABTestConfigValueForKey:key defaultValue:[self getDefaultValue:key valueClass:NSString.class]];
    return result;
}
-(void)setUserPropertyString:(nonnull NSString *)value forName:(nonnull NSString *)key
{
}
@end
