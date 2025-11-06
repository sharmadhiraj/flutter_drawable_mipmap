# Flutter Drawable Mipmap

Flutter [plugin](https://pub.dev/packages/flutter_drawable_mipmap) to show drawable and mipmap from
Android.

## Getting Started

1. [Installation Guide](https://pub.dev/packages/flutter_drawable_mipmap/install)
2. [Example](https://pub.dev/packages/flutter_drawable_mipmap/example)

## Usage Guide

#### Use this widget to show drawable in Flutter app

```
Drawable("name")
```

#### Use this widget to show mipmap in Flutter app

```
Mipmap("name")
```

#### Accessing Drawable or Mipmap as Uint8List

If you prefer accessing mipmap or drawable resources as memory (Uint8List) rather than as widgets,
allowing you to create custom widgets or perform other operations with the image data, you can use
this method.

```
Uint8List? image = await FlutterDrawableMipmap.drawableMipmap(
  "drawable_or_mipmap_name_without_R.id",
  Is_drawable, // true if drawable, false if mipmap
)
```

<hr/>

I'm always working on making improvements. If you have any feedback, issues, or suggestions, feel
free to reach out. Happy coding!