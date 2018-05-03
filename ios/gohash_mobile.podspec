#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'gohash_mobile'
  s.version          = '0.0.1'
  s.summary          = 'go-hash Flutter API for mobile phones'
  s.description      = <<-DESC
go-hash Flutter API for mobile phones
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.vendored_frameworks = 'Frameworks/Mobileapi.framework'
  
  s.ios.deployment_target = '8.0'
end

