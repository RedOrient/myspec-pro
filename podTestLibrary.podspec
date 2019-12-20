#
# Be sure to run `pod lib lint podTestLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'podTestLibrary'
  s.version          = '0.2.0'
  s.summary          = 'some category for me'


# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                   A longer description of MyExtension in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage         = 'https://github.com/RedOrient/myspec-pro'
  # s.screenshots     = 'www.example.com/screenshots_1.gif', 'www.example.com/screenshots_2.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yujingliang' => '1030807747@qq.com' }
  s.source           = { :git => 'https://github.com/RedOrient/myspec-pro.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

   s.platform     = :ios, "8.0"
  s.ios.deployment_target = '8.0'

  s.public_header_files = 'podTestLibrary/Classes/**/*.h'
  s.source_files = 'podTestLibrary/Classes/**/*.{h,m,mm,swift}'

  s.resources = 'podTestLibrary/Classes/**/*.xib'

#s.resource_bundles = {
#    'podTestLibrary' => ['podTestLibrary/Assets/*.png', 'podTestLibrary/Classes/*.xib']
#   }

 
    
    s.frameworks = 'UIKit', 'MapKit', 'WebKit', 'CoreTelephony', 'AdSupport'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.requires_arc = true
    s.dependency 'FBSDKCoreKit'
    s.dependency 'FBSDKLoginKit'
end
