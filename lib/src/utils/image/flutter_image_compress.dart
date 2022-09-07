import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressorUtils {
  /// It compresses the image and returns the compressed image file.
  ///
  /// Args:
  ///   file (File): The file to be compressed.
  ///   targetPath (String): The path where the compressed image will be saved.
  ///   minHeight (int): The minimum height of the image. Defaults to 1124
  ///   minWidth (int): The minimum width of the image. Defaults to 1124
  ///   quality (int): The quality of the image. The value ranges from 0 to 100. The
  /// default value is 85. Defaults to 85
  ///
  /// Returns:
  ///   A Future<File?>
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

  /// It compresses the image to a certain size and quality.
  ///
  /// Args:
  ///   assetName (String): The name of the asset to compress.
  ///   minHeight (int): The minimum height of the image. Defaults to 1124
  ///   minWidth (int): The minimum width of the image. Defaults to 1124
  ///   quality (int): The quality of the image. The value ranges from 0 to 100. The
  /// default value is 85. Defaults to 85
  ///
  /// Returns:
  ///   A Future<Uint8List?>
  static Future<Uint8List?> compressAsset(String assetName,
      {int minHeight = 1124, int minWidth = 1124, int quality = 85}) async {
    return FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );
  }

  /// It compresses the image to a certain size.
  ///
  /// Args:
  ///   list (Uint8List): The image you want to compress.
  ///   minHeight (int): The minimum height of the image. Defaults to 1124
  ///   minWidth (int): The minimum width of the image. Defaults to 1124
  ///   quality (int): The quality of the image. The value ranges from 0 to 100. The
  /// default value is 85. Defaults to 85
  ///
  /// Returns:
  ///   A list of integers.
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
