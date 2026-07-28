Pod::Spec.new do |s|
  s.name             = 'sm_network'
  s.version          = '1.4.0'
  s.summary          = 'Native system proxy support for sm_network.'
  s.description      = <<-DESC
Native system proxy support for the sm_network Flutter package.
                       DESC
  s.homepage         = 'https://github.com/shay-wong/flutter_sm_packages'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Shay' => 'shay.wong@qq.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'sm_network/Sources/sm_network/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
