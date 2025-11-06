import 'package:flutter/material.dart';
import 'package:flutter_drawable_mipmap/image_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    return SizedBox(
      width: 200,
      height: 200,
      child: Drawable("android"),
    );
  }

  Widget _buildMipmap() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Mipmap("ios"),
    );
  }
}
