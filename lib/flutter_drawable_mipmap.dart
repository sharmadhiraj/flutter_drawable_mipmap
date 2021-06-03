import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FlutterDrawableMipmap {
  static const MethodChannel _channel =
      const MethodChannel('flutter_drawable_mipmap');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Uint8List?> drawableMipmap(String name, bool isDrawable) async {
    return await _channel.invokeMethod(
      'drawableMipmap',
      {
        "name": name,
        "is_drawable": isDrawable,
      },
    );
  }
}
