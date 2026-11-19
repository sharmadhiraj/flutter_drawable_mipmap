## 2.0.0

* Add iOS support: asset catalog images, SF Symbols and app icon
* Add `NativeImage` widget, `NativeImageProvider` and `NativeImageType`
* Add system icons (`android.R.drawable`) and app icon on Android
* Render vector, shape and all other drawables, not only bitmaps
* Render at the requested size and device pixel ratio for sharp images
* Add `width`, `height`, `fit`, `color`, `brightness`, `placeholder`, `errorBuilder` and
  `semanticLabel`
* Follow light and dark mode from Flutter material or `material_ui` themes, or the platform
* Cache images with Flutter's `ImageCache`
* Load images off the platform UI thread
* Migrate Android to built-in Kotlin
* Fix widget not reloading when its name changes
* Fix calls never completing when the plugin is detached
* Return `null` for missing images as documented
* **Breaking:** require Dart 3.13 and Flutter 3.47
* Deprecate `image_widget.dart` and `FlutterDrawableMipmap.drawableMipmap`

## 1.2.0

* Support mipmap adaptive icon
* Internal improvements

## 1.1.1

* Internal improvements

## 1.1.0

* Null Safety migration

## 1.0.1

* Update description.

## 1.0.0

* Implement Drawable & Mipmap widget
