import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawable_mipmap/flutter_drawable_mipmap.dart';

import 'widgets/demo_section.dart';
import 'widgets/demo_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.isDark,
    required this.onToggleTheme,
    super.key,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  static String get _starSymbol => _isAndroid ? "star_big_on" : "star.fill";

  static String get _cameraSymbol =>
      _isAndroid ? "ic_menu_camera" : "camera.fill";

  static String get _platformImage => _isAndroid ? "android" : "ios";

  static final Future<Uint8List?> _platformImageBytes =
      FlutterDrawableMipmap.drawable(_platformImage, width: 48);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _buildDrawableSection(),
            if (_isAndroid) _buildMipmapSection(),
            _buildSystemSection(),
            _buildAppIconSection(),
            _buildSizeAndTintSection(),
            _buildProviderSection(),
            _buildErrorSection(),
            _buildBytesSection(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Flutter Drawable Mipmap"),
      actions: [
        Semantics(
          button: true,
          label: "Toggle dark mode",
          child: IconButton(
            tooltip: "Toggle dark mode",
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawableSection() {
    return DemoSection(
      title: "Drawable",
      description: _isAndroid
          ? "res/drawable: bitmap, vector and shape. Toggle dark mode to see "
              "values-night colors."
          : "Asset catalog image (Assets.xcassets).",
      children: [
        DemoTile(label: "$_platformImage.png", child: Drawable(_platformImage)),
        if (_isAndroid) ...[
          const DemoTile(
            label: "vector",
            child: Drawable("ic_star", width: 48, height: 48),
          ),
          const DemoTile(
            label: "shape",
            child: Drawable("gradient_circle", width: 48, height: 48),
          ),
        ],
      ],
    );
  }

  Widget _buildMipmapSection() {
    return const DemoSection(
      title: "Mipmap",
      description: "res/mipmap: bitmap and adaptive icon (Android only).",
      children: [
        DemoTile(label: "ios.png", child: Mipmap("ios")),
        DemoTile(
          label: "adaptive icon",
          child: Mipmap("adaptive_logo", width: 56, height: 56),
        ),
      ],
    );
  }

  Widget _buildSystemSection() {
    return DemoSection(
      title: "System",
      description: _isAndroid
          ? "android.R.drawable icons."
          : "SF Symbols, adapting to dark mode.",
      children: [
        DemoTile(
          label: _starSymbol,
          child: NativeImage.system(_starSymbol, width: 40, height: 40),
        ),
        DemoTile(
          label: _cameraSymbol,
          child: NativeImage.system(_cameraSymbol, width: 40, height: 40),
        ),
      ],
    );
  }

  Widget _buildAppIconSection() {
    return const DemoSection(
      title: "App icon",
      description: "The launcher icon of this app.",
      children: [
        DemoTile(
          label: "appIcon",
          child: NativeImage.appIcon(width: 56, height: 56),
        ),
      ],
    );
  }

  Widget _buildSizeAndTintSection() {
    final String name = _isAndroid ? "ic_star" : _starSymbol;
    final NativeImageType type =
        _isAndroid ? NativeImageType.drawable : NativeImageType.system;
    return DemoSection(
      title: "Size and tint",
      description: "Rendered natively at the requested size, so vectors stay "
          "sharp. color tints the image.",
      children: [
        for (final double size in [16, 32, 64])
          DemoTile(
            label: "${size.toInt()}",
            child: NativeImage(type, name, width: size, height: size),
          ),
        DemoTile(
          label: "tinted",
          child: NativeImage(
            type,
            name,
            width: 48,
            height: 48,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderSection() {
    return DemoSection(
      title: "ImageProvider",
      description: "NativeImageProvider works with CircleAvatar, "
          "DecorationImage and precacheImage.",
      children: [
        DemoTile(
          label: "CircleAvatar",
          child: CircleAvatar(
            radius: 28,
            backgroundImage: NativeImageProvider.drawable(_platformImage),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSection() {
    return DemoSection(
      title: "Missing image",
      description: "errorBuilder runs when the name does not exist.",
      children: [
        DemoTile(
          label: "not_found",
          child: Drawable(
            "not_found",
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.broken_image_outlined, size: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildBytesSection() {
    return DemoSection(
      title: "Raw bytes",
      description: "FlutterDrawableMipmap.drawable() returns PNG bytes.",
      children: [
        FutureBuilder<Uint8List?>(
          future: _platformImageBytes,
          builder: _buildBytesResult,
        ),
      ],
    );
  }

  Widget _buildBytesResult(
    BuildContext context,
    AsyncSnapshot<Uint8List?> snapshot,
  ) {
    final Uint8List? bytes = snapshot.data;
    if (bytes == null) {
      return const DemoTile(label: "loading", child: SizedBox.shrink());
    }
    return DemoTile(
      label: "${bytes.lengthInBytes} bytes",
      child: Image.memory(bytes, width: 48, height: 48),
    );
  }
}
