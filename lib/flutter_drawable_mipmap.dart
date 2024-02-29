import 'dart:async';

import 'package:flutter/services.dart';

/// A Flutter plugin for accessing drawable and mipmap resources.
class FlutterDrawableMipmap {
  static const MethodChannel _channel =
      const MethodChannel("flutter_drawable_mipmap");

  /// Retrieves the byte array of the drawable or mipmap with the given [name].
  ///
  /// The [isDrawable] parameter specifies whether the resource is a drawable
  /// (`true`) or a mipmap (`false`).
  ///
  /// Returns a [Uint8List] containing the byte array of the drawable or mipmap,
  /// or `null` if the resource is not found.
  static Future<Uint8List?> drawableMipmap(String name, bool isDrawable) async {
    return await _channel.invokeMethod(
      "drawableMipmap",
      {
        "name": name,
        "is_drawable": isDrawable,
      },
    );
  }
}
