import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressorUtils {
  static Future<File?> compressAndGetFile(File file, String targetPath,
      {int minHeight = 1124, int minWidth = 1124, int quality = 85}) async {
    return FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );
  }

  static Future<Uint8List?> compressAsset(String assetName,
      {int minHeight = 1124, int minWidth = 1124, int quality = 85}) async {
    return FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );
  }

  static Future<List<int>> compressList(Uint8List list,
      {int minHeight = 1124, int minWidth = 1124, int quality = 85}) {
    return FlutterImageCompress.compressWithList(
      list,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );
  }
}
