require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "InstantpayFaceliveness"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "14.0" }
  s.source       = { :git => "https://github.com/InstantPay/react-native-instantpay-faceliveness.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,cpp,swift}" # 👈 include Swift
  s.private_header_files = "ios/**/*.h"
  #s.requires_arc = true
  #s.swift_version = "5.0" # 👇 tells CocoaPods to use Swift

  # React Native dependencies
  #s.dependency "React-Core"

  # 👇 ensures Swift runtime is embedded for consumers
  s.pod_target_xcconfig = {
    #'DEFINES_MODULE' => 'YES',
    #'SWIFT_OBJC_BRIDGING_HEADER' => '$(PODS_TARGET_SRCROOT)/ios/InstantpayFaceliveness-Bridging-Header.h', 
    #'SWIFT_OBJC_INTERFACE_HEADER_NAME' => 'InstantpayFaceliveness-Swift.h',
    #'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES' => 'YES' 
  }

  install_modules_dependencies(s)
end
