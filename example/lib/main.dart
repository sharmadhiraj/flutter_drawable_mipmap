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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  child: Drawable("android"),
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Container(
                  child: Mipmap("ios"),
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
