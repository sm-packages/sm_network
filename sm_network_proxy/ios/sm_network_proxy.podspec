Pod::Spec.new do |s|
  s.name             = 'sm_network_proxy'
  s.version          = '0.1.0'
  s.summary          = 'Optional Android and iOS system proxy support for sm_network.'
  s.description      = <<-DESC
Reads the Android or iOS system HTTP proxy and creates a configured Dio adapter
for applications using sm_network.
                       DESC
  s.homepage         = 'https://github.com/sm-packages/sm_network'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Shay' => 'shay.wong@qq.com' }
  s.source           = { :git => 'https://github.com/sm-packages/sm_network.git', :tag => "proxy-v#{s.version}" }
  s.source_files     = 'sm_network_proxy/Sources/sm_network_proxy/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
