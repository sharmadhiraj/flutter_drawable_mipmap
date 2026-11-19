import UIKit

enum ImageType: String {
  case drawable
  case mipmap
  case system
  case appIcon
}

/// Sizes are in points; `scale` converts them to pixels.
struct ImageRequest {
  let type: ImageType
  let name: String
  let width: CGFloat?
  let height: CGFloat?
  let scale: CGFloat
  let dark: Bool?

  init?(arguments: Any?) {
    guard let args = arguments as? [String: Any],
          let rawType = args["type"] as? String,
          let type = ImageType(rawValue: rawType) else { return nil }
    self.type = type
    name = args["name"] as? String ?? ""
    width = (args["width"] as? Double).map { CGFloat($0) }
    height = (args["height"] as? Double).map { CGFloat($0) }
    scale = CGFloat(args["scale"] as? Double ?? 1)
    dark = args["dark"] as? Bool
  }

  var traits: UITraitCollection {
    var traits = [UITraitCollection(displayScale: scale)]
    if let dark = dark {
      traits.append(UITraitCollection(userInterfaceStyle: dark ? .dark : .light))
    }
    return UITraitCollection(traitsFrom: traits)
  }
}

final class AssetRenderer {
  private static let defaultSymbolPointSize: CGFloat = 24

  /// Android-only types (mipmap) have no iOS equivalent and resolve to nil.
  func resolveImage(_ request: ImageRequest) -> UIImage? {
    switch request.type {
    case .drawable:
      return UIImage(named: request.name, in: .main, compatibleWith: request.traits)
    case .system:
      return systemSymbol(request)
    case .appIcon:
      return appIcon(request)
    case .mipmap:
      return nil
    }
  }

  func renderPng(_ image: UIImage, request: ImageRequest) -> Data? {
    let size = targetSize(image.size, requestedWidth: request.width, requestedHeight: request.height)
    let format = UIGraphicsImageRendererFormat(for: request.traits)
    format.scale = request.scale
    format.opaque = false
    return UIGraphicsImageRenderer(size: size, format: format).pngData { _ in
      image.draw(in: CGRect(origin: .zero, size: size))
    }
  }

  private func systemSymbol(_ request: ImageRequest) -> UIImage? {
    let pointSize = min(request.width ?? .infinity, request.height ?? .infinity)
    let configuration = UIImage.SymbolConfiguration(
      pointSize: pointSize.isFinite ? pointSize : Self.defaultSymbolPointSize
    )
    guard let symbol = UIImage(systemName: request.name, compatibleWith: request.traits)?
      .withConfiguration(configuration) else { return nil }
    let color = UIColor.label.resolvedColor(with: request.traits)
    return symbol.withTintColor(color, renderingMode: .alwaysOriginal)
  }

  private func appIcon(_ request: ImageRequest) -> UIImage? {
    let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any]
    let primary = icons?["CFBundlePrimaryIcon"] as? [String: Any]
    let names = (primary?["CFBundleIconFiles"] as? [String] ?? [])
      + [primary?["CFBundleIconName"] as? String].compactMap { $0 }
    for name in names.reversed() {
      if let image = UIImage(named: name, in: .main, compatibleWith: request.traits) {
        return image
      }
    }
    return nil
  }

  /// Fits the image aspect ratio inside the requested box, like BoxFit.contain.
  private func targetSize(_ source: CGSize, requestedWidth: CGFloat?, requestedHeight: CGFloat?) -> CGSize {
    guard source.width > 0, source.height > 0 else {
      return CGSize(width: requestedWidth ?? 1, height: requestedHeight ?? 1)
    }
    let ratio: CGFloat
    switch (requestedWidth, requestedHeight) {
    case let (width?, height?):
      ratio = min(width / source.width, height / source.height)
    case let (width?, nil):
      ratio = width / source.width
    case let (nil, height?):
      ratio = height / source.height
    default:
      ratio = 1
    }
    return CGSize(width: source.width * ratio, height: source.height * ratio)
  }
}
