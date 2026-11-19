import 'package:flutter/foundation.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart' as flutter_material show Theme;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' as material_ui show Theme;

import 'native_image_provider.dart';
import 'native_image_type.dart';

/// Shows a native platform image.
///
/// Images are cached, rendered at [width] x [height] (sharp for vectors), and
/// follow the app theme brightness (or the platform's, without a theme) unless
/// [brightness] is set.
/// [color] tints the image. [placeholder] shows while loading and
/// [errorBuilder] when the image is missing (defaults to empty space).
class NativeImage extends StatelessWidget {
  /// Creates an image of [type] named [name].
  const NativeImage(
    this.type,
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.brightness,
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
  });

  /// Android `res/drawable` or iOS asset catalog image.
  const NativeImage.drawable(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.brightness,
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
  }) : type = NativeImageType.drawable;

  /// Android `res/mipmap` image.
  const NativeImage.mipmap(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.brightness,
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
  }) : type = NativeImageType.mipmap;

  /// Android `android.R.drawable` or iOS SF Symbol.
  const NativeImage.system(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.brightness,
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
  }) : type = NativeImageType.system;

  /// The app's launcher icon.
  const NativeImage.appIcon({
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.brightness,
    this.placeholder,
    this.errorBuilder,
    this.semanticLabel,
  }) : type = NativeImageType.appIcon,
       name = "";

  final NativeImageType type;
  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final Brightness? brightness;
  final Widget? placeholder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: _buildProvider(context),
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      gaplessPlayback: true,
      frameBuilder: placeholder == null ? null : _buildFrame,
      errorBuilder: errorBuilder ?? _buildEmpty,
    );
  }

  NativeImageProvider _buildProvider(BuildContext context) {
    return NativeImageProvider(
      type,
      name,
      width: _finiteOrNull(width),
      height: _finiteOrNull(height),
      brightness: brightness ?? _themeBrightness(context),
    );
  }

  static Brightness _themeBrightness(BuildContext context) {
    if (context.findAncestorWidgetOfExactType<material_ui.Theme>() != null) {
      return material_ui.Theme.of(context).brightness;
    }
    if (context.findAncestorWidgetOfExactType<flutter_material.Theme>() !=
        null) {
      return flutter_material.Theme.of(context).brightness;
    }
    return MediaQuery.maybePlatformBrightnessOf(context) ?? Brightness.light;
  }

  Widget _buildFrame(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded || frame != null) return child;
    return placeholder!;
  }

  Widget _buildEmpty(BuildContext context, Object error, StackTrace? stack) {
    if (kDebugMode) debugPrint("flutter_drawable_mipmap: $error");
    return SizedBox(width: width, height: height);
  }

  static double? _finiteOrNull(double? value) {
    return value != null && value.isFinite ? value : null;
  }
}

/// Shows an Android drawable or iOS asset catalog image named [name].
class Drawable extends NativeImage {
  const Drawable(
    super.name, {
    super.key,
    super.width,
    super.height,
    super.fit,
    super.color,
    super.brightness,
    super.placeholder,
    super.errorBuilder,
    super.semanticLabel,
  }) : super.drawable();
}

/// Shows an Android mipmap named [name].
class Mipmap extends NativeImage {
  const Mipmap(
    super.name, {
    super.key,
    super.width,
    super.height,
    super.fit,
    super.color,
    super.brightness,
    super.placeholder,
    super.errorBuilder,
    super.semanticLabel,
  }) : super.mipmap();
}
