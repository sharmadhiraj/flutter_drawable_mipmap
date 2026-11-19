/// Where a native image is loaded from.
enum NativeImageType {
  /// Android `res/drawable`, iOS asset catalog image.
  drawable,

  /// Android `res/mipmap`. Not available on iOS.
  mipmap,

  /// Android `android.R.drawable`, iOS SF Symbol.
  system,

  /// The app's launcher icon.
  appIcon,
}
