#
# Be sure to run `pod lib lint SynqObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SynqObjC'
  s.version          = '0.2.1'
  s.summary          = 'SynqObjC is an Objective-C SDK that lets you easily add SYNQ video functionality to your mobile app'

  s.description      = <<-DESC
This SDK contains what you need to make your app interact with the SYNQ video API. The SDK contains functionality for accessing the videos on the device, and for uploading videos into the SYNQ infrastructure. The SDK also lets you add live video streaming functionality to your app, containing a pre-configured view controller with UI elements for controlling a live video stream.
Please note: this pod is an add-on to the SYNQ video API and is of no use unless you already have created a service for accessing the API, either directly or by using one of our SDKs. (http://docs.synq.fm)
                       DESC

  s.homepage         = 'https://github.com/SYNQfm/SYNQ-iOS'
  s.social_media_url = 'http://twitter.com/synqfm'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kjartan Vestvik' => 'kjartan@synq.fm' }
  s.source           = { :git => 'https://github.com/SYNQfm/SYNQ-iOS.git', :tag => s.version.to_s }
  s.screenshot       = 'https://camo.githubusercontent.com/0ac6dafc3463d72b063977e86bbe29881c23fbc0/68747470733a2f2f7777772e73796e712e666d2f77702d636f6e74656e742f75706c6f6164732f323031372f30312f67685f73637265656e2d732e6a7067'

  s.ios.deployment_target = '9.0'

  s.vendored_frameworks = 'SynqObjC/SynqStreamer.framework'
  s.resources = 'SynqObjC/Assets/SynqStreamerResources.bundle'

  s.source_files = 'SynqObjC/Classes/**/*'
  s.public_header_files = 'SynqObjC/Classes/*.h'

  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'SynqHttpLib', '~> 0.1'

end
