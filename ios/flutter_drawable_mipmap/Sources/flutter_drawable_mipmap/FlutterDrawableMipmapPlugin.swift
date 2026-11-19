import Flutter
import UIKit

public class FlutterDrawableMipmapPlugin: NSObject, FlutterPlugin {
  private static let channelName = "flutter_drawable_mipmap"
  private let renderer = AssetRenderer()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: messenger,
      codec: FlutterStandardMethodCodec.sharedInstance(),
      taskQueue: messenger.makeBackgroundTaskQueue?()
    )
    registrar.addMethodCallDelegate(FlutterDrawableMipmapPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "load" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard let request = ImageRequest(arguments: call.arguments) else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Unsupported image request", details: nil))
      return
    }
    guard let image = renderer.resolveImage(request) else {
      result(FlutterError(code: "NOT_FOUND", message: "No \(request.type.rawValue) named \"\(request.name)\"", details: nil))
      return
    }
    guard let png = renderer.renderPng(image, request: request) else {
      result(FlutterError(code: "RENDER_FAILED", message: "Could not encode \"\(request.name)\"", details: nil))
      return
    }
    result(FlutterStandardTypedData(bytes: png))
  }
}
