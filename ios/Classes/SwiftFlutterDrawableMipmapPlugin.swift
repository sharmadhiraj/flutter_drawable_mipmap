import Flutter
import UIKit

public class SwiftFlutterDrawableMipmapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_drawable_mipmap", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterDrawableMipmapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
