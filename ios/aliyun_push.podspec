#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint push.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aliyun_push'
  s.version          = '0.2.0'
  s.summary          = 'Aliyun Push Flutter Plugin.'
  s.description      = <<-DESC
Aliyun Push Flutter Plugin with Pigeon.
                       DESC
  s.homepage         = 'https://help.aliyun.com/document_detail/434552.html'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Aliyun' => 'aliyun@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.static_framework = true

  # Swift support
  s.swift_version = '5.0'

  s.dependency 'Flutter'
  s.dependency 'AlicloudPush', '2.1.0'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'SWIFT_VERSION' => '5.0'
  }
end
