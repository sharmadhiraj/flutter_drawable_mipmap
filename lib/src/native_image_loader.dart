import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import 'native_image_type.dart';

/// Loads native images as PNG bytes.
///
/// [width] and [height] are logical pixels. When both are null the image
/// keeps its natural size. [scale] defaults to the device pixel ratio.
/// [brightness] picks light or dark variants, defaulting to the system setting.
/// Each method returns `null` when the image does not exist.
class FlutterDrawableMipmap {
  const FlutterDrawableMipmap._();

  static const MethodChannel _channel = MethodChannel(
    "flutter_drawable_mipmap",
  );

  /// Android `res/drawable` or iOS asset catalog image named [name].
  static Future<Uint8List?> drawable(
    String name, {
    double? width,
    double? height,
    double? scale,
    Brightness? brightness,
  }) {
    return load(
      NativeImageType.drawable,
      name,
      width: width,
      height: height,
      scale: scale,
      brightness: brightness,
    );
  }

  /// Android `res/mipmap` image named [name]. Returns `null` on iOS.
  static Future<Uint8List?> mipmap(
    String name, {
    double? width,
    double? height,
    double? scale,
    Brightness? brightness,
  }) {
    return load(
      NativeImageType.mipmap,
      name,
      width: width,
      height: height,
      scale: scale,
      brightness: brightness,
    );
  }

  /// Android `android.R.drawable` or iOS SF Symbol named [name].
  static Future<Uint8List?> system(
    String name, {
    double? width,
    double? height,
    double? scale,
    Brightness? brightness,
  }) {
    return load(
      NativeImageType.system,
      name,
      width: width,
      height: height,
      scale: scale,
      brightness: brightness,
    );
  }

  /// The app's launcher icon.
  static Future<Uint8List?> appIcon({
    double? width,
    double? height,
    double? scale,
    Brightness? brightness,
  }) {
    return load(
      NativeImageType.appIcon,
      "",
      width: width,
      height: height,
      scale: scale,
      brightness: brightness,
    );
  }

  /// Loads an image of [type] named [name]. [name] is ignored for
  /// [NativeImageType.appIcon].
  static Future<Uint8List?> load(
    NativeImageType type,
    String name, {
    double? width,
    double? height,
    double? scale,
    Brightness? brightness,
  }) async {
    try {
      return await _channel.invokeMethod<Uint8List>("load", {
        "type": type.name,
        "name": name,
        "width": width,
        "height": height,
        "scale": scale ?? _deviceScale,
        if (brightness != null) "dark": brightness == Brightness.dark,
      });
    } on PlatformException catch (error) {
      if (error.code == "NOT_FOUND") return null;
      rethrow;
    }
  }

  /// Use [drawable] or [mipmap] instead.
  @Deprecated("Use FlutterDrawableMipmap.drawable(name) or .mipmap(name).")
  static Future<Uint8List?> drawableMipmap(String name, bool isDrawable) {
    return isDrawable ? drawable(name) : mipmap(name);
  }

  static double get _deviceScale {
    return ui.PlatformDispatcher.instance.views.firstOrNull?.devicePixelRatio ??
        1.0;
  }
}
