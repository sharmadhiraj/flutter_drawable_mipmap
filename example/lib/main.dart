import 'package:flutter/material.dart';
import 'package:flutter_drawable_mipmap/image_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Drawable Mipmap"),
        ),
        body: Column(
          children: [Drawable("android"), Mipmap("ios")],
        ),
      ),
    );
  }
}
