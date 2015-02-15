Pod::Spec.new do |s|
  s.name             = "IGXMLReader"
  s.version          = "1.0.0"
  s.summary          = " A XML Pull Parser based on libxml for Objective-C."

  s.homepage         = "https://github.com/siuying/IGXMLReader"
  s.license          = 'MIT'
  s.author           = { "Francis Chong" => "francis@ignition.hk" }
  s.source           = { :git => "https://github.com/siuying/IGXMLReader.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/siuying'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.library = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  s.source_files = 'Pod/Classes/**/*'
end
