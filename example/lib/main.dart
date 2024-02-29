import 'package:flutter/material.dart';
import 'package:flutter_drawable_mipmap/image_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text("Flutter Drawable Mipmap"));
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDrawable(),
            SizedBox(height: 20),
            _buildMipmap(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawable() {
    return Container(
      child: Drawable("android"),
      width: 200,
      height: 200,
    );
  }

  Widget _buildMipmap() {
    return Container(
      child: Mipmap("ios"),
      width: 200,
      height: 200,
    );
  }
}
