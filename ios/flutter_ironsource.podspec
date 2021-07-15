#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_ironsource.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ironsource'
  s.version          = '0.0.1'
  s.summary          = 'IronSource plugin for flutter'
  s.description      = <<-DESC
  IronSource plugin for flutter
  Use Banner, Interstitial, RewardAd and OfferWall for ( Android & IOS )
                       DESC
  s.homepage         = 'https://zenozaga.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Zenozaga' => 'zenozaga@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h' 

  s.dependency 'Flutter'
  s.dependency 'IronSourceSDK','7.1.6.1'


  s.static_framework = true

  s.platform = :ios, '10.0'
  s.ios.deployment_target = '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
