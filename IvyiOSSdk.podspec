#
# Be sure to run `pod lib lint IvyiOSSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
@version = '8.6.9.1'
Pod::Spec.new do |s|
  s.name             = 'IvyiOSSdk'
  s.version          = @version
  s.summary          = 'IvyiOSSdk for ios games and apps.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is the IvySdk for ios platform.

* Markdown format.
* Don't worry about the indent, we strip it!
                       DESC

  s.homepage         = 'http://10.80.1.8/iossdk/IvyiOSSdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'IceStar' => '691484812@qq.com' }
  s.source           = { :git => 'http://10.80.1.8/iossdk/IvyiOSSdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.requires_arc = true
  s.static_framework = true
#  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
#  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
#  s.static_framework = true
  # s.source_files = 'IvyiOSSdk/Classes/**/*'
  
  # s.resource_bundles = {
  #   'IvyiOSSdk' => ['IvyiOSSdk/Assets/*.png']
  # }
  s.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)', "VALID_ARCHS" => '$(inherited)' }
  s.user_target_xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
  
  s.default_subspecs = 'Common', 'Core'
#  s.public_header_files = 'IvyiOSSdk/Classes/**/*.h*'

  s.subspec 'Common' do |common|
      common.libraries = 'sqlite3'
      common.source_files = 'IvyiOSSdk/Classes/Common/**/*'
      common.public_header_files = 'IvyiOSSdk/Classes/Common/**/*.h'
      common.frameworks = 'StoreKit', 'SystemConfiguration', 'Security'
      common.dependency 'SocketRocket', '0.7.0'
      common.prefix_header_contents = '#import <IvyiOSSdk/NSString+Base64.h>'
      common.user_target_xcconfig = { "LIBRARY_SEARCH_PATHS" => ['${PODS_CONFIGURATION_BUILD_DIR}/EasyShowView'], "HEADER_SEARCH_PATHS" => ['${PODS_ROOT}/Headers/Public/EasyShowView']}
#      common.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
#      common.user_target_xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
  end
  
  s.subspec 'Core' do |core|
      core.source_files = 'IvyiOSSdk/Classes/Core/**/*'
      core.public_header_files = 'IvyiOSSdk/Classes/Core/**/*.h*'
      core.dependency 'IvyiOSSdk/Common'
      core.resource_bundles = {
          'IvyiOSSdk-Core' => ['IvyiOSSdk/Assets/Core/*.png', 'IvyiOSSdk/Assets/Core/*.xib', 'IvyiOSSdk/Assets/Core/LocalizedStrings/*.lproj/*']
      }
      core.frameworks = 'CoreTelephony', 'GameController', 'MediaPlayer', 'GameKit', 'MessageUI', 'iAd', 'Security'
      core.prefix_header_contents = '#import <IvyiOSSdk/NSString+Base64.h>'
#      core.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'MODULES=1' }
#      core.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
#      core.user_target_xcconfig = { "FRAMEWORK_SEARCH_PATHS" => '$(inherited)', "LIBRARY_SEARCH_PATHS" => '$(inherited)', "HEADER_SEARCH_PATHS" => '$(inherited)', "OTHER_CFLAGS" => '$(inherited)', "OTHER_LDFLAGS" => '$(inherited)', "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited)' }
  end
  
#  s.subspec 'GA' do |ga|
#      ga.source_files = 'IvyiOSSdk/Classes/GA/**/*'
#      ga.public_header_files = 'IvyiOSSdk/Classes/GA/**/*.h'
#      ga.dependency 'IvyiOSSdk/Core'
#      #    ga.dependency 'Google/Analytics'
#      #    ga.dependency 'GoogleIDFASupport'
#      ga.vendored_libraries = [
#        'IvyiOSSdk/Libraries/libGoogleAnalyticsServices.a'
#      ]
#      ga.libraries = 'z', 'sqlite3'
#      ga.frameworks = 'CoreData', 'SystemConfiguration'
#  end
  
  #s.subspec 'GameAnalytics' do |gameanalytics|
  #  gameanalytics.source_files = 'IvyiOSSdk/Classes/GameAnalytics/**/*'
  #  gameanalytics.public_header_files = 'IvyiOSSdk/Classes/GameAnalytics/**/*.h'
  #  gameanalytics.dependency 'GA-SDK-IOS'
  #  gameanalytics.dependency 'IvyiOSSdk/Core'
  #  gameanalytics.libraries = 'z', 'sqlite3'
  #  gameanalytics.frameworks = 'AdSupport', 'SystemConfiguration'
  #end
  
  s.subspec 'Appsflyer' do |appsflyer|
      appsflyer.source_files = 'IvyiOSSdk/Classes/Appsflyer/**/*'
      appsflyer.public_header_files = 'IvyiOSSdk/Classes/Appsflyer/**/*.h'
      appsflyer.dependency 'AppsFlyerFramework', '6.12.2' #'6.12.1'
#      appsflyer.dependency 'AppsFlyer-AdRevenue'#, '6.9.0'#'5.4.4'#, '5.2.0'
      appsflyer.dependency 'IvyiOSSdk/Core'
      appsflyer.frameworks = 'AdSupport', 'iAd'
      appsflyer.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'APPSFLYER=1' }
  end
  
  FirebaseVersion = '10.19.0' #'10.12.0' #'8.15.0' #'6.30.0'#'6.23.0' #'6.18.0' #'6.14.0'
  s.subspec 'Firebase' do |firebase|
      firebase.source_files = 'IvyiOSSdk/Classes/Firebase/**/*'
      firebase.public_header_files = 'IvyiOSSdk/Classes/Firebase/**/*.h'
#      firebase.dependency 'BoringSSL-GRPC', '0.0.24'
      firebase.dependency 'Firebase/Core', FirebaseVersion
      firebase.dependency 'Firebase/Auth', FirebaseVersion
      firebase.dependency 'Firebase/Analytics', FirebaseVersion
      firebase.dependency 'Firebase/RemoteConfig', FirebaseVersion
      firebase.dependency 'Firebase/Messaging', FirebaseVersion
      firebase.dependency 'Firebase/Crashlytics', FirebaseVersion
      firebase.dependency 'IvyiOSSdk/Core'
      firebase.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'FIREBASE=1' }
  end
  
  s.subspec 'Firebase+' do |firebase|
      firebase.source_files = 'IvyiOSSdk/Classes/Firebase+/**/*'
      firebase.public_header_files = 'IvyiOSSdk/Classes/Firebase+/**/*.h'
      firebase.dependency 'IvyiOSSdk/Firebase'
      firebase.dependency 'IvyiOSSdk/FacebookSNS'
      firebase.dependency 'Firebase/Functions', FirebaseVersion
      firebase.dependency 'Firebase/Firestore', FirebaseVersion
      firebase.dependency 'Firebase/Database', FirebaseVersion
      firebase.dependency 'Firebase/InAppMessaging', FirebaseVersion
      firebase.dependency 'FBSDKShareKit'
      firebase.dependency 'FBSDKLoginKit'
      firebase.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'FIREBASE_PLUS=1' }
  end
  
  FBVersion = '16.3.1' #'14.1.0' #'12.3.2' #'13.2.0' #'11.2.1' #'6.5.2' #'7.1.1' #'6.5.1' #'5.13.0' #'5.2.1'
  s.subspec 'FacebookCore' do |facebook|
      facebook.source_files = 'IvyiOSSdk/Classes/Facebook/Core/*'
      facebook.public_header_files = 'IvyiOSSdk/Classes/Facebook/Core/*.h'
      facebook.dependency 'FBSDKCoreKit', FBVersion
      facebook.dependency 'IvyiOSSdk/Core'
      facebook.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'FACEBOOK=1' }
#      facebook.user_target_xcconfig = { "LIBRARY_SEARCH_PATHS" => ['${PODS_CONFIGURATION_BUILD_DIR}/FBAEMKit', '${PODS_CONFIGURATION_BUILD_DIR}/FBSDKCoreKit'], "HEADER_SEARCH_PATHS" => ['${PODS_ROOT}/Headers/Public/FBAEMKit', '${PODS_ROOT}/Headers/Public/FBSDKCoreKit']}
#      facebook.libraries = 'swiftCore'
  end
  
  s.subspec 'FacebookSNS' do |facebook|
      facebook.source_files = 'IvyiOSSdk/Classes/Facebook/SNS/*'
      facebook.public_header_files = 'IvyiOSSdk/Classes/Facebook/SNS/*.h'
      facebook.dependency 'FBSDKShareKit', FBVersion
      facebook.dependency 'FBSDKLoginKit', FBVersion
      facebook.dependency 'IvyiOSSdk/FacebookCore'
      facebook.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'FACEBOOK=1' }
#      facebook.user_target_xcconfig = { "LIBRARY_SEARCH_PATHS" => ['${PODS_CONFIGURATION_BUILD_DIR}/FBSDKShareKit', '${PODS_CONFIGURATION_BUILD_DIR}/FBSDKLoginKit'], "HEADER_SEARCH_PATHS" => ['${PODS_ROOT}/Headers/Public/FBSDKShareKit', '${PODS_ROOT}/Headers/Public/FBSDKLoginKit']}
  end
  
  s.subspec 'Google' do |google|
      google.source_files = 'IvyiOSSdk/Classes/Google/**/*'
      google.public_header_files= 'IvyiOSSdk/Classes/Google/**/*.h'
      google.resource_bundles = {
          'IvyiOSSdk-Admob' => ['IvyiOSSdk/Assets/Admob/*.png', 'IvyiOSSdk/Assets/Admob/*.xib', 'IvyiOSSdk/Assets/Admob/LocalizedStrings/*.lproj/*']#,
          #'IvyiOSSdk-DFP' => ['IvyiOSSdk/Assets/Dfp/*.png', 'IvyiOSSdk/Assets/Dfp/*.xib', 'IvyiOSSdk/Assets/Dfp/LocalizedStrings/*.lproj/*']
      }
      google.dependency 'Google-Mobile-Ads-SDK', '10.10.0' #'10.6.0'
      #google.dependency 'PersonalizedAdConsent', '1.0.5'
      google.dependency 'GoogleMobileAdsMediationFyber', '8.2.5.0'
      google.dependency 'GoogleMobileAdsMediationIronSource', '7.6.0.0'
      #google.dependency 'GoogleMobileAdsMediationInMobi', '10.5.4.0'
      google.dependency 'GoogleMobileAdsMediationVungle', '7.2.0.0'
      google.dependency 'GoogleMobileAdsMediationFacebook', '6.14.0.0'
      google.dependency 'GoogleMobileAdsMediationUnity', '4.9.2.0'
      google.dependency 'GoogleMobileAdsMediationChartboost', '9.5.1.0'
      google.dependency 'GoogleMobileAdsMediationAppLovin', '12.1.0.0'
      #google.dependency 'GoogleMobileAdsMediationPangle', '5.1.0.6.0'
      google.dependency 'GoogleMobileAdsMediationAdColony', '4.9.0.2'
      google.dependency 'GoogleMobileAdsMediationMintegral', '7.4.8.0'
      #google.dependency 'OpenWrapSDK', '3.2.0' #'2.8.0'
      google.dependency 'AdMobPubMaticAdapter', '2.2.0'#, '2.1.1'
      google.dependency 'smaato-ios-sdk', '22.6.0'
      google.dependency 'smaato-ios-sdk-mediation-admob', '10.10.0.0'
      google.dependency 'IvyiOSSdk/Core'
      google.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'GOOGLE=1' }
  end
  
#  s.subspec 'Max' do |max|
#      max.source_files = 'IvyiOSSdk/Classes/Max/**/*'
#      max.public_header_files = 'IvyiOSSdk/Classes/Max/**/*.h'
#      max.dependency 'AppLovinMediationAdColonyAdapter', '4.9.0.0.4'
#      max.dependency 'AppLovinMediationAmazonAdMarketplaceAdapter', '4.7.4.0'
#      max.dependency 'AppLovinMediationChartboostAdapter', '9.2.0.0'
#      max.dependency 'AppLovinMediationFyberAdapter', '8.1.9.0'
#      max.dependency 'AppLovinMediationGoogleAdManagerAdapter', '10.1.0.1'
#      max.dependency 'AppLovinMediationGoogleAdapter', '10.1.0.1'
#      max.dependency 'AppLovinMediationIronSourceAdapter', '7.3.0.0.0'
#      max.dependency 'AppLovinMediationFacebookAdapter', '6.12.0.3'
#      max.dependency 'AppLovinMediationMintegralAdapter', '7.3.4.0.2'
#      max.dependency 'AppLovinMediationMyTargetAdapter', '5.18.0.0'
#      max.dependency 'AppLovinMediationSmaatoAdapter', '22.1.3.0'
#      max.dependency 'AppLovinMediationUnityAdsAdapter', '4.6.1.0'
#      max.dependency 'AppLovinMediationVungleAdapter', '6.12.3.0'
#      max.dependency 'AppLovinMediationYandexAdapter', '5.9.1.0'
#      #max.dependency 'OpenWrapSDK', '2.8.0'
#      max.dependency 'AppLovinPubMaticAdapter', '1.0.2'
#      max.dependency 'AppLovinMediationByteDanceAdapter', '5.3.1.1.0'
#      max.dependency 'AppLovinMediationInMobiAdapter', '10.1.4.1'
#      max.dependency 'AmazonPublisherServicesSDK', '4.7.2'
#      max.dependency 'IvyiOSSdk/Applovin'
#      max.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'APPLOVIN_MAX=1' }
#      #max.vendored_frameworks = [
#      #  'IvyiOSSdk/Frameworks/APS/DTBiOSSDK.framework'
#      #]
#      #max.public_header_files = 'IvyiOSSdk/Classes'
#      #max.xcconfig = {'USER_HEADER_SEARCH_PATHS' => 'IvyiOSSdk/Frameworks/APS/DTBiOSSDK.framework'}
#  end
#  s.subspec 'FacebookAds' do |facebook|
#      facebook.source_files = 'IvyiOSSdk/Classes/Facebook/Ads/*'
#      facebook.public_header_files = 'IvyiOSSdk/Classes/Facebook/Ads/*.h'
#      facebook.resource_bundles = {
#          'IvyiOSSdk-Facebook' => ['IvyiOSSdk/Assets/Facebook/*.png', 'IvyiOSSdk/Assets/Facebook/*.xib', 'IvyiOSSdk/Assets/Facebook/LocalizedStrings/*.lproj/*']
#      }
#      facebook.dependency 'FBAudienceNetwork', '6.14.0' #'6.12.0' #'5.10.1' #'5.9.0'#, '5.8.0' #'5.7.0' #'5.6.0'
#      facebook.dependency 'GoogleMobileAdsMediationFacebook', '6.14.0.0' #'6.12.0.0' #'5.10.1.0' #'5.9.0.1'#, '5.8.0.2' #'5.7.0.0' #'5.6.0.0' #'5.5.1.0'
#      facebook.dependency 'IvyiOSSdk/FacebookCore'
#      facebook.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'FB_AUDIENCE=1' }
#  end
#
#  s.subspec 'FacebookAdsNoAdapter' do |facebook|
#      facebook.source_files = 'IvyiOSSdk/Classes/Facebook/Ads/*'
#      facebook.public_header_files = 'IvyiOSSdk/Classes/Facebook/Ads/*.h'
#      facebook.resource_bundles = {
#          'IvyiOSSdk-Facebook' => ['IvyiOSSdk/Assets/Facebook/*.png', 'IvyiOSSdk/Assets/Facebook/*.xib', 'IvyiOSSdk/Assets/Facebook/LocalizedStrings/*.lproj/*']
#      }
#      facebook.dependency 'FBAudienceNetwork', '6.14.0' #'6.12.0' #'5.10.1' #'5.9.0'#, '5.8.0' #'5.7.0' #'5.6.0'
#      facebook.dependency 'IvyiOSSdk/FacebookCore'
#  end
  
#  s.subspec 'Unity' do |unity|
#      unity.source_files = 'IvyiOSSdk/Classes/Unity/**/*'
#      unity.public_header_files = 'IvyiOSSdk/Classes/Unity/**/*.h'
#      unity.dependency 'UnityAds', '4.7.1' #'3.4.6'#, '3.4.2' #'3.3.0'
#      unity.dependency 'GoogleMobileAdsMediationUnity', '4.7.1.0' #'3.4.6.0' #, '3.4.2.1' #'3.3.0.0'
#      unity.dependency 'IvyiOSSdk/Core'
#  end
#
#  s.subspec 'UnityNoAdapter' do |unity|
#      unity.source_files = 'IvyiOSSdk/Classes/Unity/**/*'
#      unity.public_header_files = 'IvyiOSSdk/Classes/Unity/**/*.h'
#      unity.dependency 'UnityAds', '4.7.1' #'3.4.6' #, '3.4.2' #'3.3.0'
#      unity.dependency 'IvyiOSSdk/Core'
#  end
#
#  s.subspec 'Vungle' do |vungle|
#      vungle.source_files = 'IvyiOSSdk/Classes/Vungle/**/*'
#      vungle.public_header_files = 'IvyiOSSdk/Classes/Vungle/**/*.h'
#      vungle.dependency 'VungleSDK-iOS', '6.12.3' #'6.3.2'
#      vungle.dependency 'GoogleMobileAdsMediationVungle', '6.12.3.0' #'6.3.2.3'
#      vungle.dependency 'IvyiOSSdk/Core'
#  end
#
#  s.subspec 'VungleNoAdapter' do |vungle|
#      vungle.source_files = 'IvyiOSSdk/Classes/Vungle/**/*'
#      vungle.public_header_files = 'IvyiOSSdk/Classes/Vungle/**/*.h'
#      vungle.dependency 'VungleSDK-iOS', '6.12.3' #'6.3.2'
#      vungle.dependency 'IvyiOSSdk/Core'
#  end
#
#  s.subspec 'IronSource' do |ironsource|
#      ironsource.source_files = 'IvyiOSSdk/Classes/IronSource/**/*'
#      ironsource.public_header_files = 'IvyiOSSdk/Classes/IronSource/**/*.h'
#      ironsource.dependency 'IronSourceSDK', '7.3.0.0' #'7.0.0.0'#, '6.16.0.0' #'6.13.0.1' #'6.8.7.0'
#      ironsource.dependency 'GoogleMobileAdsMediationIronSource', '7.3.0.0.0' #'6.17.0.0'#, '6.16.0.0' #'6.13.0.1.0' #'6.8.7.0'
#      ironsource.dependency 'IvyiOSSdk/Core'
#  end
#
#  s.subspec 'IronSourceNoAdapter' do |ironsource|
#      ironsource.source_files = 'IvyiOSSdk/Classes/IronSource/**/*'
#      ironsource.public_header_files = 'IvyiOSSdk/Classes/IronSource/**/*.h'
#      ironsource.dependency 'IronSourceSDK', '7.3.0.0' #'7.0.0.0'#, '6.16.0.0' #'6.13.0.1' #'6.8.7.0'
#      ironsource.dependency 'IvyiOSSdk/Core'
#  end
  s.subspec 'Applovin' do |applovin|
      applovin.source_files = 'IvyiOSSdk/Classes/Applovin/**/*'
      applovin.public_header_files = 'IvyiOSSdk/Classes/Applovin/**/*.h'
      #   applovin.vendored_frameworks = [
      #        'IvyiOSSdk/Frameworks/AppLovinSDK.framework'
      #    ]
      applovin.dependency 'AppLovinSDK', '12.1.0'#'11.11.4' #'6.15.1'#, '6.12.0' #'6.11.4' #'6.10.1' #'6.9.5'
      applovin.dependency 'GoogleMobileAdsMediationAppLovin'#, '11.10.1.0' #'6.15.1.0'#, '6.12.0.0' #'6.11.4.0' #'6.10.1.0' #'6.9.5.0'
      applovin.dependency 'IvyiOSSdk/Core'
      applovin.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'APPLOVIN=1' }
  end
#  s.subspec 'ApplovinNoAdapter' do |applovin|
#      applovin.source_files = 'IvyiOSSdk/Classes/Applovin/**/*'
#      applovin.public_header_files = 'IvyiOSSdk/Classes/Applovin/**/*.h'
#      #   applovin.vendored_frameworks = [
#      #        'IvyiOSSdk/Frameworks/AppLovinSDK.framework'
#      #    ]
#      applovin.dependency 'AppLovinSDK', '11.9.0' #'6.13.1'#, '6.12.0' #'6.11.4' #'6.10.1' #'6.9.5'
#      applovin.dependency 'IvyiOSSdk/Core'
#      applovin.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'APPLOVIN=1' }
#  end
  
#  s.subspec 'AdColony' do |adcolony|
#      adcolony.source_files = 'IvyiOSSdk/Classes/AdColony/**/*'
#      adcolony.public_header_files = 'IvyiOSSdk/Classes/AdColony/**/*.h'
#      adcolony.dependency 'AdColony', '4.9.0' #'4.3.0'#, '4.1.4' # '4.1.3' #'4.1.2'
#      adcolony.dependency 'GoogleMobileAdsMediationAdColony', '4.9.0.2' #'4.1.5.0'#, '4.1.4.1' #'4.1.3.1' #'4.1.2.0'
#      adcolony.dependency 'IvyiOSSdk/Core'
#      adcolony.xcconfig = { "OTHER_LDFLAGS" => '-fobjc-arc' }
#  end
#
#  s.subspec 'AdColonyNoAdapter' do |adcolony|
#      adcolony.source_files = 'IvyiOSSdk/Classes/AdColony/**/*'
#      adcolony.public_header_files = 'IvyiOSSdk/Classes/AdColony/**/*.h'
#      adcolony.dependency 'AdColony', '4.9.0' #'4.3.0'#, '4.1.4' # '4.1.3' #'4.1.2'
#      adcolony.dependency 'IvyiOSSdk/Core'
#      adcolony.xcconfig = { "OTHER_LDFLAGS" => '-fobjc-arc' }
#  end
#
  s.subspec 'Pangle' do |pangle|
      pangle.source_files = 'IvyiOSSdk/Classes/Pangle/**/*'
      pangle.public_header_files = 'IvyiOSSdk/Classes/Pangle/**/*.h'
      pangle.dependency 'Ads-Global', '5.6.0.9' #'5.3.1.1'
      pangle.dependency 'IvyiOSSdk/Core'
  end
  
  s.subspec 'GDT' do |gdt|
      gdt.source_files = 'IvyiOSSdk/Classes/GDT/**/*'
      gdt.public_header_files = 'IvyiOSSdk/Classes/GDT/**/*.h'
      gdt.dependency 'GDTMobSDK', '4.14.32'
      gdt.dependency 'IvyiOSSdk/Core'
  end
  
  s.subspec 'Yandex' do |yandex|
      yandex.source_files = 'IvyiOSSdk/Classes/Yandex/**/*'
      yandex.public_header_files = 'IvyiOSSdk/Classes/Yandex/**/*.h'
      yandex.dependency 'YandexMobileAds', '5.9.1'
      yandex.dependency 'IvyiOSSdk/Core'
  end
  
#  s.subspec 'Inmobi' do |inmobi|
#      inmobi.source_files = 'IvyiOSSdk/Classes/Inmobi/**/*'
#      inmobi.public_header_files = 'IvyiOSSdk/Classes/Inmobi/**/*.h'
#      inmobi.dependency 'GoogleMobileAdsMediationInMobi', '10.1.2.1'#, '9.0.7.2' #'9.0.0.0' #'7.4.0.0'
#      inmobi.dependency 'IvyiOSSdk/Core'
#  end
#
#  s.subspec 'InmobiNoAdapter' do |inmobi|
#      inmobi.source_files = 'IvyiOSSdk/Classes/Inmobi/**/*'
#      inmobi.public_header_files = 'IvyiOSSdk/Classes/Inmobi/**/*.h'
#      inmobi.dependency 'InMobiSDK', '10.1.2'#, '9.0.7'
#      inmobi.dependency 'IvyiOSSdk/Core'
#  end
  
#  s.subspec 'Chartboost' do |chartboost|
#      chartboost.source_files = 'IvyiOSSdk/Classes/Chartboost/**/*'
#      chartboost.public_header_files = 'IvyiOSSdk/Classes/Chartboost/**/*.h'
#      chartboost.dependency 'GoogleMobileAdsMediationChartboost', '9.2.0.0' #'8.1.0.1'#, '8.0.4.0' #'8.0.1.1'
#      chartboost.dependency 'IvyiOSSdk/Core'
#      chartboost.frameworks = 'StoreKit', 'Foundation', 'CoreGraphics', 'WebKit', 'AVFoundation', 'UIKit'
#  end
#
#  s.subspec 'ChartboostNoAdapter' do |chartboost|
#      chartboost.source_files = 'IvyiOSSdk/Classes/Chartboost/**/*'
#      chartboost.public_header_files = 'IvyiOSSdk/Classes/Chartboost/**/*.h'
#      chartboost.dependency 'ChartboostSDK', '9.5.1' #'9.2.0' #'8.1.0'#, '8.0.4'
#      chartboost.dependency 'IvyiOSSdk/Core'
#      chartboost.frameworks = 'StoreKit', 'Foundation', 'CoreGraphics', 'WebKit', 'AVFoundation', 'UIKit'
#  end
  
#  s.subspec 'Umeng' do |umeng|
#      umeng.source_files = 'IvyiOSSdk/Classes/Umeng/**/*'
#      umeng.public_header_files = 'IvyiOSSdk/Classes/Umeng/**/*.h'
#      umeng.dependency 'UMengAnalytics-NO-IDFA', '4.2.5'
#      #umeng.dependency 'UMengAnalytics'
#      umeng.dependency 'IvyiOSSdk/Core'
#  end
  
#  s.subspec 'Toutiao' do |tt|
#      tt.source_files = 'IvyiOSSdk/Classes/Toutiao/**/*'
#      tt.public_header_files = 'IvyiOSSdk/Classes/Toutiao/**/*.h'
##      tt.dependency 'Ads-CN', '4.6.1.6' #'3.4.4.3' #'3.4.2.3'#'3.3.6.2'#, '2.9.0.7' #'2.8.0.1'
#      tt.dependency 'Ads-Global', '4.9.0.8' #'3.4.4.3' #'3.4.2.3'#'3.3.6.2'#, '2.9.0.7' #'2.8.0.1'
#      tt.dependency 'RangersAppLog', '5.6.6'
#      tt.vendored_frameworks = [
#        'IvyiOSSdk/Frameworks/Toutiao/TTTracker.framework'
##        'IvyiOSSdk/Frameworks/BUAdSDK.framework'
#      ]
##      tt.resource = 'IvyiOSSdk/Frameworks/BUAdSDK.bundle'
#      tt.libraries = 'z', 'c++', 'resolv.9', 'sqlite3'
#      tt.frameworks = 'JavaScriptCore', 'WebKit', 'Photos', 'AdSupport', 'SystemConfiguration', 'CoreTelephony', 'Security', 'CoreFoundation'
#      tt.dependency 'IvyiOSSdk/Core'
#  end
  
#  s.subspec 'Douyin' do |dy|
#      dy.source_files = 'IvyiOSSdk/Classes/Douyin/**/*'
#      dy.public_header_files = 'IvyiOSSdk/Classes/Douyin/**/*.h'
#      dy.vendored_frameworks = [
#        'IvyiOSSdk/Frameworks/Douyin/LightGameSDK.framework'
#      ]
#      dy.resource_bundles = {
#          'IvyiOSSdk-Douyin' => ['IvyiOSSdk/Assets/Douyin/*.png', 'IvyiOSSdk/Assets/Douyin/*.xib', 'IvyiOSSdk/Assets/Douyin/LocalizedStrings/*.lproj/*']
#      }
#      dy.resources = 'IvyiOSSdk/Frameworks/LightGameSDK.framework/LightGameSDK.bundle', 'IvyiOSSdk/Frameworks/LightGameSDK.framework/BUAdSDK.bundle'
#      dy.xcconfig = { "OTHER_LDFLAGS" => '-ObjC' }
#      dy.libraries = 'z', 'c++', 'resolv.9', 'iconv.2.4.0'
#      dy.frameworks = 'Photos', 'AdSupport', 'SystemConfiguration', 'MediaPlayer', 'WebKit', 'CoreMedia', 'CoreLocation', 'CoreMotion', 'CoreTelephony', 'StoreKit', 'MobileCoreServices'
#      dy.dependency 'IvyiOSSdk/Core'
#  end
  
#  s.subspec 'GoogleTest' do |test|
#      test.source_files = 'IvyiOSSdk/Classes/GoogleTest/**/*'
#      test.public_header_files = 'IvyiOSSdk/Classes/GoogleTest/**/*.h'
#      test.dependency 'GoogleMobileAdsMediationTestSuite', '1.4.0' #'1.1.1'
#      test.dependency 'IvyiOSSdk/Core'
#      test.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'GoogleTest=1' }
#  end
  
  s.subspec 'VerifyIdCard' do |verify|
    verify.source_files = 'IvyiOSSdk/Classes/Verify/**/*'
    verify.public_header_files = 'IvyiOSSdk/Classes/Verify/**/*.h'
    verify.dependency 'IvyiOSSdk/Common'
    verify.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'VerifyIdCard=1' }
  end
  
  s.subspec 'ThirdLogin' do |login|
      login.source_files = 'IvyiOSSdk/Classes/ThirdLogin/**/*'
      login.public_header_files = 'IvyiOSSdk/Classes/ThirdLogin/**/*.h'
      login.resource_bundles = {
          'IvyiOSSdk-ThirdLogin' => ['IvyiOSSdk/Assets/ThirdLogin/*.*']
        }
      login.dependency 'IvyiOSSdk/Common'
      login.dependency 'WechatOpenSDK', '2.0.2'
#      login.dependency 'Weibo_SDK'
      login.vendored_frameworks = [
        'IvyiOSSdk/Frameworks/QQ/TencentOpenAPI.framework'
      ]
      login.xcconfig = { "OTHER_LDFLAGS" => '-fobjc-arc'}
      login.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'ThirdLogin=1' }
  end
  
  s.subspec 'AIHelp' do |aihelp|
      aihelp.source_files = 'IvyiOSSdk/Classes/AIHelp/**/*'
      aihelp.public_header_files = 'IvyiOSSdk/Classes/AIHelp/**/*.h'
      aihelp.dependency 'AIHelpSDK', '4.5.0' #'4.3.8'
      aihelp.dependency 'IvyiOSSdk/Core'
      aihelp.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => 'AIHelp=1' }
  end


  s.frameworks = ['UIKit', 'CoreFoundation', 'QuartzCore', 'AVKit', 'AdServices']

end
