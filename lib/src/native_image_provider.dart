import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'native_image_loader.dart';
import 'native_image_type.dart';

/// An [ImageProvider] for native images, cached by Flutter's [ImageCache].
///
/// Use it anywhere an [ImageProvider] is accepted, such as [DecorationImage]
/// or `CircleAvatar`. [width] and [height] are logical pixels; pass them so
/// vector images render sharply at that size.
class NativeImageProvider extends ImageProvider<NativeImageKey> {
  /// Creates a provider for an image of [type] named [name].
  const NativeImageProvider(
    this.type,
    this.name, {
    this.width,
    this.height,
    this.brightness,
  });

  /// Android `res/drawable` or iOS asset catalog image.
  const NativeImageProvider.drawable(
    this.name, {
    this.width,
    this.height,
    this.brightness,
  }) : type = NativeImageType.drawable;

  /// Android `res/mipmap` image.
  const NativeImageProvider.mipmap(
    this.name, {
    this.width,
    this.height,
    this.brightness,
  }) : type = NativeImageType.mipmap;

  /// Android `android.R.drawable` or iOS SF Symbol.
  const NativeImageProvider.system(
    this.name, {
    this.width,
    this.height,
    this.brightness,
  }) : type = NativeImageType.system;

  /// The app's launcher icon.
  const NativeImageProvider.appIcon({
    this.width,
    this.height,
    this.brightness,
  }) : type = NativeImageType.appIcon,
       name = "";

  final NativeImageType type;
  final String name;
  final double? width;
  final double? height;

  /// Light or dark variant. Defaults to the system setting.
  final Brightness? brightness;

  @override
  Future<NativeImageKey> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(
      NativeImageKey(
        type: type,
        name: name,
        width: width,
        height: height,
        brightness: brightness,
        scale: configuration.devicePixelRatio ?? 1.0,
      ),
    );
  }

  @override
  ImageStreamCompleter loadImage(
    NativeImageKey key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadCodec(key, decode),
      scale: key.scale,
      debugLabel: key.toString(),
      informationCollector: () => [
        DiagnosticsProperty<NativeImageProvider>("Image provider", this),
        DiagnosticsProperty<NativeImageKey>("Image key", key),
      ],
    );
  }

  Future<ui.Codec> _loadCodec(
    NativeImageKey key,
    ImageDecoderCallback decode,
  ) async {
    final Uint8List? bytes = await FlutterDrawableMipmap.load(
      key.type,
      key.name,
      width: key.width,
      height: key.height,
      scale: key.scale,
      brightness: key.brightness,
    );
    if (bytes == null) {
      throw NativeImageNotFoundException(key.type, key.name);
    }
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) {
    return other is NativeImageProvider &&
        other.type == type &&
        other.name == name &&
        other.width == width &&
        other.height == height &&
        other.brightness == brightness;
  }

  @override
  int get hashCode => Object.hash(type, name, width, height, brightness);

  @override
  String toString() => "NativeImageProvider(${type.name}, \"$name\")";
}

/// Cache key for [NativeImageProvider].
class NativeImageKey {
  const NativeImageKey({
    required this.type,
    required this.name,
    required this.scale,
    this.width,
    this.height,
    this.brightness,
  });

  final NativeImageType type;
  final String name;
  final double scale;
  final double? width;
  final double? height;
  final Brightness? brightness;

  @override
  bool operator ==(Object other) {
    return other is NativeImageKey &&
        other.type == type &&
        other.name == name &&
        other.scale == scale &&
        other.width == width &&
        other.height == height &&
        other.brightness == brightness;
  }

  @override
  int get hashCode => Object.hash(type, name, scale, width, height, brightness);

  @override
  String toString() => "NativeImageKey(${type.name}, \"$name\", ${scale}x)";
}

/// Thrown when a native image does not exist on the current platform.
class NativeImageNotFoundException implements Exception {
  const NativeImageNotFoundException(this.type, this.name);

  final NativeImageType type;
  final String name;

  @override
  String toString() {
    return "NativeImageNotFoundException: no ${type.name} named \"$name\"";
  }
}
