#
# Be sure to run `pod lib lint IGXMLReader.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IGXMLReader"
  s.version          = "1.0.0"
  s.summary          = "A XML Pull Parser for Objective-C based on libxml."

  s.homepage         = "https://github.com/siuying/IGXMLReader"
  s.license          = 'MIT'
  s.author           = { "Francis Chong" => "francis@ignition.hk" }
  s.source           = { :git => "https://github.com/siuying/IGXMLReader.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/siuying'

  s.platform     = :ios, '7.0'
  s.platform     = :osx, '10.9'
  s.requires_arc = true

  s.library = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  s.source_files = 'Pod/Classes/**/*'
end
