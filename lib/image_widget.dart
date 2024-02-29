import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'flutter_drawable_mipmap.dart';

/// An abstract widget for displaying drawable or mipmap images dynamically loaded
/// from resources.
abstract class _ImageWidget extends StatefulWidget {
  /// The name of the drawable or mipmap resource to load.
  final String name;

  /// Indicates whether the resource is a drawable (`true`) or a mipmap (`false`).
  bool isDrawable();

  /// Creates a new instance of [_ImageWidget] with the given [name].
  _ImageWidget(this.name);

  @override
  __ImageWidgetState createState() => __ImageWidgetState();
}

/// The state associated with the [_ImageWidget].
class __ImageWidgetState extends State<_ImageWidget> {
  /// The byte array representation of the loaded image resource.
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    getDrawableMipmap();
  }

  /// Loads the drawable or mipmap resource asynchronously.
  Future<void> getDrawableMipmap() async {
    FlutterDrawableMipmap.drawableMipmap(
      widget.name,
      widget.isDrawable(),
    )
        .then((value) => setState(() => image = value))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return image == null ? Container() : Image.memory(image!);
  }
}

/// A widget for displaying drawable images loaded dynamically from resources.
class Drawable extends _ImageWidget {
  /// Creates a new instance of [Drawable] with the given [name].
  Drawable(String name) : super(name);

  @override
  bool isDrawable() => true;
}

/// A widget for displaying mipmap images loaded dynamically from resources.
class Mipmap extends _ImageWidget {
  /// Creates a new instance of [Mipmap] with the given [name].
  Mipmap(String name) : super(name);

  @override
  bool isDrawable() => false;
}
