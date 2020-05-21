#import "FlutterDrawableMipmapPlugin.h"
#if __has_include(<flutter_drawable_mipmap/flutter_drawable_mipmap-Swift.h>)
#import <flutter_drawable_mipmap/flutter_drawable_mipmap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_drawable_mipmap-Swift.h"
#endif

@implementation FlutterDrawableMipmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterDrawableMipmapPlugin registerWithRegistrar:registrar];
}
@end
