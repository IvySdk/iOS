# RiseSDK for CocosCreator

# 前言
**default.json: sdk配置文件, 广告、计费、打点等功能均需要通过此文件配置；对各部分配置详细说明见文档最底部**
# Info.plist 配置
   以下仅用作参考，根据实际环境为准
   * admob
```js
<key>GADApplicationIdentifier</key>
	<string>ca-app-pub-4701483365698544~9261873855</string>
```
* facebook

```js
<key>FacebookAppID</key>
	<string>2031393607025870</string>
	<key>FacebookClientToken</key>
	<string>550ff04a5b6eb476d8de790d2e0cd179</string>
	<key>FacebookDisplayName</key>
	<string>Shoot Bubble</string>
	<key>FirebaseAppDelegateProxyEnabled</key>
	<true/>
```

* aps
```js
    <key>APS_APPID</key>
    <string>48f45f22-9f81-4972-9412-437a429e7572</string>
```
* applovin

```js
  <key>AppLovinConsentFlowInfo</key>
    <dict>
        <key>AppLovinConsentFlowEnabled</key>
        <true/>
        <key>AppLovinConsentFlowPrivacyPolicy</key>
        <string>http://www.ivymobileinternational.com/index.php/privacy-policy/</string>
        <key>AppLovinConsentFlowTermsOfService</key>
        <string>https://sites.google.com/view/ivymobile-terms-of-use/</string>
    </dict>
    <key>AppLovinSdkKey</key>
    <string>E8pVhU9mykQd3y0TD0Ksoq4vpf_Muat6ifcP9m96UakTWk5klQaWEeQ2IPOA-GHgxu54eEA8pvgKcn2MBdtQGH</string>
```


## 1, 添加引用
1. 在Podfile中添加引用

```js
platform :ios, '12.0'
@tag = '8.7.0'

  pod 'IvyiOSSdk/Core', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/Firebase', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/Firebase+', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
 # pod 'IvyiOSSdk/FacebookSNS', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/Google', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
 # pod 'IvyiOSSdk/Yandex', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/Appsflyer', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/AIHelp', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag

```
2. 将ios-build-copy-sources/unity目录下的SDKFacadeUnity.h、SDKFacadeUnity.mm导入ivysdk-core

## 2, Initialize 初始化SDK
在第一个场景中的一个脚本中的Awake方法中调用RiseSdk.Instance.Init()方法 Call the Init function in a gameObject's Awake function in your initialize scene
```js
void Awake() {
  RiseSdk.Instance.Init();
}
```

## 3, ADs 广告
### 1，广告状态
1. 是否已开启广告

```js
bool state = RiseSdk.Instance.IsAdsEnabled();
```
2. 设置广告状态

```js
RiseSdk.Instance.SetAdsEnable (bool enable)
```

### 2，激励视频
* 如果你想使用视频奖励广告，你需要添加以下方法
    
```js
//激励视频事件回调
    RiseSdkListener.OnAdEvent += 
    (
            RiseSdk.AdEventType result,//是否成功显示视频广告，
            //成功返回
            RiseSdk.AdEventType.RewardAdShowFinished，
            //失败返回
            RiseSdk.AdEventType.RewardAdShowFailed
        int rewardId//视频广告调用时机
    ) => {
        //to do something
    };


    //判断是否有可用的视频广告
    bool yes = RiseSdk.Instance.HasRewardAd();

    显示视频广告
    RiseSdk.Instance.ShowRewardAd(rewardId);
```
    
### 3，插屏
* 如果你想使用插屏广告，你需要添加以下方法

```js
//插屏广告事件回调
 RiseSdkListener.OnAdEvent += 
   (
     //RiseSdk.AdEventType type//广告事件类型，需要判断是否为
     RiseSdk.AdEventType.FullAdClosed（大屏广告被关闭）
     或RiseSdk.AdEventType.FullAdClicked（大屏广告被点击）
   ) => {
       //to do something
   };

//当前是否存在插屏广告
RiseSdk.Instance.HasInterstitial(string tag)
//立即展示插屏广告
RiseSdk.Instance.ShowAd(string tag)
//延迟展示插屏广告
RiseSdk.Instance.ShowAd(string tag, int delayShowSeconds)
//倒计时展示插屏广告
RiseSdk.Instance.ShowAd(string tag, int delayShowSeconds, double delayTimeInterval)

```

### 4，Banner

```js
//展示banner
RiseSdk.Instance.ShowBanner(RiseSdk.POS_BANNER_MIDDLE_BOTTOM)
//关闭banner
RiseSdk.Instance.CloseBanner()
//是否有可用的banner
RiseSdk.Instance.HasBanner()

//参考position：
    /// <summary>
    /// 在左上角显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_LEFT_TOP = 1;
    /// <summary>
    /// 在顶部居中显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_MIDDLE_TOP = 3;
    /// <summary>
    /// 在右上角显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_RIGHT_TOP = 6;
    /// <summary>
    /// 在中间居中显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_MIDDLE_MIDDLE = 5;
    /// <summary>
    /// 在左下角显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_LEFT_BOTTOM = 2;
    /// <summary>
    /// 在底部居中显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_MIDDLE_BOTTOM = 4;
    /// <summary>
    /// 在右下角显示banner广告参数常量
    /// </summary>
    public const int POS_BANNER_RIGHT_BOTTOM = 7;
    public const int POS_BANNER_LEFT_MIDDLE = 8;
    public const int POS_BANNER_RIGHT_MIDDLE = 9;

    public const int ANIMATE_BANNER_NONE = 0;
    public const int ANIMATE_BANNER_TOP = 1;
    public const int ANIMATE_BANNER_BOTTOM = 2;
    public const int ANIMATE_BANNER_LEFT = 4;
    public const int ANIMATE_BANNER_RIGHT = 8;
    public const int ANIMATE_BANNER_ROTATION = 16;
```

## 4, Firebase Remote Config 读取
* 获取对应类型值
```js
RiseSdk.Instance.getRemoteConfigInt(string key);

RiseSdk.Instance.getRemoteConfigLong(string key);

RiseSdk.Instance.getRemoteConfigDouble(string key);

RiseSdk.Instance.getRemoteConfigBoolean(string key);

RiseSdk.Instance.getRemoteConfigString(string key);
```

## 5, apple billing 应用中内付费

```js
void InitListeners() {
  RiseSdkListener.OnPaymentEvent -= OnPaymentResult;
  RiseSdkListener.OnPaymentEvent += OnPaymentResult;
}

void OnPaymentResult(int resultCode, int billId) {
		switch (resultCode) {
		case RiseSdk.PAYMENT_RESULT_SUCCESS:
			switch (billId) {
			case 1:// the first billing Id success
				break;
			case 2:// the second billing Id success
				break;
			case 3:
				break;
			}
			Debug.LogError("On billing success : " + billId);
			break;

		case RiseSdk.PAYMENT_RESULT_FAILS:
			switch (billId) {
			case 1:
				break;
			}
			Debug.LogError("On billing failure : " + billId);
			break;

		case RiseSdk.PAYMENT_RESULT_CANCEL:
			break;
		}
}
```
* 支付

```js
RiseSdk.Instance.pay(int billingId)
```

* 获取配置中的所有商品信息

```js
RiseSdk.Instance.GetPaymentDatas()
```
* 获取配置中指定id的商品信息

```js
RiseSdk.Instance.GetPaymentData (int billingId)
```
* 检查订阅状态
```js
RiseSdk.Instance.CheckSubscriptionActive();

//回调
 RiseSdkListener.OnCheckSubscriptionResult -= OnCheckSubscriptionResult;
 RiseSdkListener.OnCheckSubscriptionResult += OnCheckSubscriptionResult;
```
* 获取所有已付费商品id记录

```js
RiseSdk.Instance.GetPurchasedIds()
```
* 清除所有已付费商品id记录
```js
RiseSdk.Instance.ClearPurchasedIds()
```
* 清除指定商品id的付费记录
```js
RiseSdk.Instance.ClearPurchasedId (int billingId)
```

## 6, GameCenter
* GameCenter是否可用
`bool value = RiseSdk.Instance.IsGameCenterAvailable()`
* 显示所有排行榜
`RiseSdk.Instance.ShowLeaderboards()`
* 显示指定排行榜
`RiseSdk.Instance.ShowLeaderboard (int leaderboardId)`
* 更新排行榜的粉
`RiseSdk.Instance.SubmitScore (int leaderboardId, long score) `
* 获取排行榜分数
`RiseSdk.Instance.GetMyHighScore (int leaderboardId) `
* 展示所有成就
`RiseSdk.Instance.ShowAchievements()`
* 更新成就进度
`RiseSdk.Instance.SubmitAchievement (int achievementId, double percent)`
* 获取成就进度
`RiseSdk.Instance.GetAchievementProgress (int achievementId)`


## 9, 事件统计
1. 需要引用统计平台，可选择对应平台
```js
  pod 'IvyiOSSdk/Firebase', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/Firebase+', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/FacebookSNS', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
  pod 'IvyiOSSdk/Appsflyer', :git => 'git@github.com:IvySdk/iOS.git', 
```
2. 事件统计
```js
//keyValueData 使用，分隔; exq: key1,value1,key2,value2
RiseSdk.Instance.TrackEvent (string category, string keyValueData)

RiseSdk.Instance.TrackEvent (string category, string action, string label, int value)
```
## 7, SNS facebook相关操作接口
如果你想使用facebook相关功能，需要添加引用

```js
pod 'IvyiOSSdk/FacebookSNS', :git => 'git@github.com:IvySdk/iOS.git', :tag=>@tag
```

```js
void InitListeners() {
  RiseSdkListener.OnSNSEvent -= OnSNSEvent;
  RiseSdkListener.OnSNSEvent += OnSNSEvent;
}

void OnSNSEvent(bool success, int eventType, int extra) {
		switch (eventType) {
		case RiseSdk.SNS_EVENT_LOGIN:
			Debug.LogError ("login: " + success);
			break;

		case RiseSdk.SNS_EVENT_INVITE:
			Debug.LogError ("invite: " + success);
			break;

		case RiseSdk.SNS_EVENT_LIKE:
			Debug.LogError ("like success? " + success);
			break;

		case RiseSdk.SNS_EVENT_CHALLENGE:
			int friendsCount = extra;
			Debug.LogError ("challenge: " + friendsCount);
			break;
		}
	}
```

```js
//登陆facebook
RiseSdk.Instance.Login();

//登出facebook
RiseSdk.Instance.Logout();

//检测facebook是否登陆
RiseSdk.Instance.IsLogin();

//获取前名
RiseSdk.Instance.GetMeFirstName ();

//获取后名
RiseSdk.Instance.GetMeLastName ();

//全名
RiseSdk.Instance.GetMeName ();

//个人信息
RiseSdk.Instance.Me ();

//朋友列表
RiseSdk.Instance.GetFriends ();

//拉取朋友，invitable：用户状态是否为可邀请
RiseSdk.Instance.FetchFriends (bool invitable);

//获取分数
RiseSdk.Instance.FetchScores ();

//邀请朋友
RiseSdk.Instance.Invite ();

//分享
RiseSdk.Instance.Share ();

//分享
RiseSdk.Instance.Share (string contentURL, string tag, string quote);
```

## 8, Misc 其他
* 屏幕宽度
`RiseSdk.Instance.GetScreenWidth()`
* 屏幕高度
`RiseSdk.Instance.GetScreenHeight()`
* 是否是 IPhoneX
`RiseSdk.Instance.IsIPhoneX()`
* 好评
`RiseSdk.Instance.Rate()`
* 应用内好评
`RiseSdk.Instance.RateInApp()`
* 指定分数评价
`RiseSdk.Instance.RateWithStar(float star)`
* 指定分数应用内评价
`RiseSdk.Instance.RateInAppWithStar(float star)`
* 网络状态
`bool value = RiseSdk.Instance.IsNetworkConnected(float star)`
* 获取配置中data下数据
`string value = RiseSdk.Instance.GetExtraData()`
* 获取对应config值
```js
    string value = RiseSdk.Instance.GetConfig (int configId)
    
    //对应configId
    SDK_CONFIG_KEY_APP_ID = 1,
    SDK_CONFIG_KEY_LEADER_BOARD_URL = 2,
    SDK_CONFIG_KEY_API_VERSION = 3,
    SDK_CONFIG_KEY_SCREEN_WIDTH = 4,
    SDK_CONFIG_KEY_SCREEN_HEIGHT = 5,
    SDK_CONFIG_KEY_LANGUAGE = 6,
    SDK_CONFIG_KEY_COUNTRY = 7,
    SDK_CONFIG_KEY_VERSION_CODE = 8,
    SDK_CONFIG_KEY_VERSION_NAME = 9,
    SDK_CONFIG_KEY_PACKAGE_NAME = 10,
    SDK_CONFIG_KEY_UUID = 11,
    SDK_CONFIG_KEY_FACEBOOK_ID = 12,
    SDK_CONFIG_KEY_CHANNEL = 20,
    SDK_CONFIG_KEY_JSON_VERSION = 21,
    SDK_CONFIG_KEY_FIREBASE_USERID = 22
```
* 原生toast
`RiseSdk.Instance.Toast(string message)`
* 原生log
`RiseSdk.Instance.SdkLog(string message)`
* 发送邮件
`RiseSdk.Instance.SendMail (string address, string subject, string content, bool isHTML)`
* 是否有刘海
`RiseSdk.Instance.HasNotch()`
* 设置用户属性，体现在打点中
`RiseSdk.Instance.SetUserProperty (string key, string value)`


## default.json 各部分说明
sdk配置文件,放置在`conf`目录下，广告、计费、打点等功能均需要通过此文件配置
* 完整default.json 示例

```js
{
	"ads": {
		"banner": {
			"default": {
				"cache": true,
				"enable": true,
				"ids": [
					{
						"id": "ca-app-pub-1914768831611213/3402719691",
						"platform": "admob",
						"priority": 1
					}
				],
				"size": "adaptive",
				"timeout": 10
			}
		},
		"full": {
			"default": {
				"cache": true,
				"enable": true,
				"ids": [
					{
						"id": "ca-app-pub-1914768831611213/1842226018",
						"platform": "admob",
						"priority": 1
					}
				],
				"timeout": 10
			}
		},
		"video": {
			"default": {
				"cache": true,
				"enable": true,
				"ids": [
					{
						"id": "ca-app-pub-1914768831611213/3594291382",
						"platform": "admob",
						"priority": 1
					}
				],
				"timeout": 30
			}
		}
	},
	"analyse": [
		{
			"api": "firebase"
		},
		{
			"api": "appsflyer",
			"id": "6468921082",
			"key": "J6ejjnUP9fMkv29PqBuYzR"
		},
		{
			"api": "facebook"
		}
	],
	"appid": 10092,
	"appstoreid": 6468921082,
	"autoRequestIDFA": true,
	"data": [],
	"domain": "http://api2.restartad.com/api/data?v_api=10&appid=10092&channel=appstore",
	"event_targets": {
		"op1": 4,
		"op2": 4,
		"op3": 4,
		"op4": 4,
		"op5": 4,
		"op6": 4,
		"op7": 4
	},
	"gen_events": {
		"interstitial_shown_2_in1day": [
			{
				"d": 1,
				"e1": "interstitial_shown",
				"op": ">=",
				"r": false,
				"v": 2
			}
		],
		"interstitial_shown_2_in3day": [
			{
				"d": 3,
				"e1": "interstitial_shown",
				"op": ">=",
				"r": false,
				"v": 2
			}
		],
		"video_shown_2_in1day": [
			{
				"d": 1,
				"e1": "video_shown",
				"op": ">=",
				"r": false,
				"v": 2
			}
		],
		"video_shown_2_in3day": [
			{
				"d": 3,
				"e1": "video_shown",
				"op": ">=",
				"r": false,
				"v": 2
			}
		]
	},
	"gts": 0,
	"init": {
		"admob": {
			"admob-appid": "ca-app-pub-1914768831611213~8351794045"
		},
		"appsflyer": {
			"appid": "6468921082",
			"key": "J6ejjnUP9fMkv29PqBuYzR"
		},
		"ironsource": {
			"appid": ""
		},
		"unity": {
			"appid": ""
		}
	},
	"leaderboard_url": "https://ranking.runningwinner.com",
	"parfkaUrl": "",
	"payment": {
		"data": {
			"1": {
				"id": "com.runningpet.7500coins",
				"name": "7500 Coins",
				"price": "$0.99",
				"usd": 0.99
			},
			"2": {
				"id": "com.runningpet.30000coins",
				"name": "30000 Coins",
				"price": "$2.99",
				"usd": 2.99
			}
		},
		"debug": 0,
		"sharesecret": "b3dfed8592d34626b927b28100a7a244"
	},
	"push": [
		{
			"api": "firebase"
		}
	],
	"remoteconfig": [],
	"share": "",
	"sns": {
		"api": "facebook",
		"invite_img": "",
		"invite_url": "",
		"share_url": ""
	},
	"stats": "http://stats.goinfun.com:8080",
	"token": "649d732ac09e4f2a6a28cd990e5104c3",
	"track": {
		"aps": [
			1,
			2,
			3,
			4,
			5,
			10
		],
		"ci": [
			1,
			3,
			5,
			10,
			15,
			20,
			25,
			30
		],
		"cv": [
			1,
			3,
			5,
			10,
			15,
			20,
			25,
			30
		],
		"op": [
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10
		],
		"si": [
			20,
			50,
			100,
			200,
			500,
			1000
		],
		"sv": [
			10,
			20,
			50,
			300,
			200,
			500
		]
	},
	"v_api": 10,
	"v_pub": 1
}
```
### 普通属性
* appid: 自定义应用id
* appstoreid: 应用商店app id
* autoRequestIDFA: 是否申请idfa
* data : 自定义配置

### 转化事件配置
此部分不需要修改
```js
event_targets
gen_events
track
```
### 统计平台配置
参考示例
`analyse`

### sns配置
参考示例
`sns`

### 计费
参考示例
`payment`


