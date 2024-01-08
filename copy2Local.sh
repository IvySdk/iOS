#!/bin/bash
LOCAL_PATH=../IvyiOSSdk-Local
rm -fr $LOCAL_PATH/IvyiOSSdk/Frameworks/
rm -fr $LOCAL_PATH/IvyiOSSdk/Libraries/
mkdir -p $LOCAL_PATH/IvyiOSSdk/Frameworks/
mkdir -p $LOCAL_PATH/IvyiOSSdk/Libraries/

cp -fr Example/SDKFacadeUnity.* $LOCAL_PATH/Example

#copy common
rm -fr $LOCAL_PATH/IvyiOSSdk/Classes/Common
cp -fr IvyiOSSdk/Classes/Common $LOCAL_PATH/IvyiOSSdk/Classes/

#copy core
rm -fr $LOCAL_PATH/IvyiOSSdk/Classes/Core
cp -fr IvyiOSSdk/Classes/Core $LOCAL_PATH/IvyiOSSdk/Classes/
rm -fr $LOCAL_PATH/IvyiOSSdk/Assets/Core
cp -fr IvyiOSSdk/Assets/Core $LOCAL_PATH/IvyiOSSdk/Assets/

#copy ga
rm -fr $LOCAL_PATH/IvyiOSSdk/Classes/GA
cp -fr IvyiOSSdk/Classes/GA $LOCAL_PATH/IvyiOSSdk/Classes/
cp -fr IvyiOSSdk/Libraries/libGoogleAnalyticsServices.a $LOCAL_PATH/IvyiOSSdk/Libraries/libGoogleAnalyticsServices.a

#copy admob & dfp
rm -fr $LOCAL_PATH/IvyiOSSdk/Assets/Admob
rm -fr $LOCAL_PATH/IvyiOSSdk/Assets/Dfp
cp -fr IvyiOSSdk/Assets/Admob $LOCAL_PATH/IvyiOSSdk/Assets/Admob
cp -fr IvyiOSSdk/Assets/Dfp $LOCAL_PATH/IvyiOSSdk/Assets/Dfp
rm -fr $LOCAL_PATH/IvyiOSSdk/Classes/Admob
rm -fr $LOCAL_PATH/IvyiOSSdk/Classes/Dfp
cp -fr IvyiOSSdk/Classes/Admob $LOCAL_PATH/IvyiOSSdk/Classes/Admob
cp -fr IvyiOSSdk/Classes/Dfp $LOCAL_PATH/IvyiOSSdk/Classes/Dfp
cp -fr Example/Pods/Google-Mobile-Ads-SDK/Libraries/libGoogleMobileAds.a $LOCAL_PATH/IvyiOSSdk/Libraries/libGoogleMobileAds.a
cp -fr Example/Pods/Google-Mobile-Ads-SDK/Frameworks/frameworks/GoogleMobileAds.framework $LOCAL_PATH/IvyiOSSdk/Frameworks/
rm -fr $LOCAL_PATH/IvyiOSSdk/Libraries/PersonalizedAdConsent
cp -fr Example/Pods/PersonalizedAdConsent/PersonalizedAdConsent/PersonalizedAdConsent $LOCAL_PATH/IvyiOSSdk/Libraries/PersonalizedAdConsent

#copy appsflyer
rm -fr $LOCAL_PATH/IvyiOSSdk/Classes/Appsflyer
cp -fr IvyiOSSdk/Classes/Appsflyer $LOCAL_PATH/IvyiOSSdk/Classes/
cp -fr Example/Pods/AppsFlyerFramework/AppsFlyerLib.framework $LOCAL_PATH/IvyiOSSdk/Frameworks/

cd $LOCAL_PATH/Example
pod update --no-repo-update

