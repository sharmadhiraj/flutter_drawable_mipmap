Pod::Spec.new do |s|
  s.name             = 'flutter_drawable_mipmap'
  s.version          = '2.0.0'
  s.summary          = 'Show native images (asset catalog, SF Symbols, app icon) in Flutter.'
  s.description      = 'Loads iOS asset catalog images, SF Symbols and the app icon for Flutter.'
  s.homepage         = 'https://github.com/sharmadhiraj/flutter_drawable_mipmap'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Dhiraj Sharma' => 'https://github.com/sharmadhiraj' }
  s.source           = { :path => '.' }
  s.source_files     = 'flutter_drawable_mipmap/Sources/flutter_drawable_mipmap/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.resource_bundles = {
    'flutter_drawable_mipmap_privacy' => ['flutter_drawable_mipmap/Sources/flutter_drawable_mipmap/PrivacyInfo.xcprivacy']
  }
end
