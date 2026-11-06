// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/icons
  $AssetsImagesIconsGen get icons => const $AssetsImagesIconsGen();
}

class $AssetsImagesIconsGen {
  const $AssetsImagesIconsGen();

  /// File path: assets/images/icons/appstore.png
  AssetGenImage get appstore =>
      const AssetGenImage('assets/images/icons/appstore.png');

  /// File path: assets/images/icons/appstore_dev.png
  AssetGenImage get appstoreDev =>
      const AssetGenImage('assets/images/icons/appstore_dev.png');

  /// File path: assets/images/icons/appstore_sit.png
  AssetGenImage get appstoreSit =>
      const AssetGenImage('assets/images/icons/appstore_sit.png');

  /// File path: assets/images/icons/appstore_uat.png
  AssetGenImage get appstoreUat =>
      const AssetGenImage('assets/images/icons/appstore_uat.png');

  /// File path: assets/images/icons/playstore.png
  AssetGenImage get playstore =>
      const AssetGenImage('assets/images/icons/playstore.png');

  /// File path: assets/images/icons/playstore_dev.png
  AssetGenImage get playstoreDev =>
      const AssetGenImage('assets/images/icons/playstore_dev.png');

  /// File path: assets/images/icons/playstore_sit.png
  AssetGenImage get playstoreSit =>
      const AssetGenImage('assets/images/icons/playstore_sit.png');

  /// File path: assets/images/icons/playstore_uat.png
  AssetGenImage get playstoreUat =>
      const AssetGenImage('assets/images/icons/playstore_uat.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        appstore,
        appstoreDev,
        appstoreSit,
        appstoreUat,
        playstore,
        playstoreDev,
        playstoreSit,
        playstoreUat
      ];
}

abstract final class Assets {
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const String localization = 'assets/localization.xlsx';

  /// List of all assets
  static List<String> get values => [localization];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
