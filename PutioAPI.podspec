#
# Be sure to run `pod lib lint PutioAPI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PutioAPI'
  s.version          = '0.16.3'
  s.swift_version    = '4.2'

  s.summary          = 'Swift client for Put.io API v2'
  s.description      = 'Swift client for Put.io API v2 [https://api.put.io]'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Putio' => 'devs@put.io' }

  s.homepage         = 'https://github.com/putdotio/putio.swift'
  s.source           = { :git => 'https://github.com/putdotio/putio.swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/putdotio'

  s.ios.deployment_target = '10.0'
  s.source_files = 'PutioAPI/Classes/**/*'

  s.dependency 'Alamofire', '~> 4.9'
  s.dependency 'SwiftyJSON', '~> 5.0'
end
