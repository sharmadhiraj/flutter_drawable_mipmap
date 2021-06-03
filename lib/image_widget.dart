import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'flutter_drawable_mipmap.dart';

abstract class _ImageWidget extends StatefulWidget {
  final String name;

  bool isDrawable();

  _ImageWidget(this.name);

  @override
  __ImageWidgetState createState() => __ImageWidgetState();
}

class __ImageWidgetState extends State<_ImageWidget> {
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    getDrawableMipmap();
  }

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

class Drawable extends _ImageWidget {
  Drawable(String name) : super(name);

  @override
  bool isDrawable() => true;
}

class Mipmap extends _ImageWidget {
  Mipmap(String name) : super(name);

  @override
  bool isDrawable() => false;
}
