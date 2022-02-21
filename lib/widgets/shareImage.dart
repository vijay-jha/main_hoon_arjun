
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:typed_data';

class ShareImage{
  static Future<String> saveImage(Uint8List imageBytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(imageBytes, name: name);
    return result['filePath'];
  }

 static Future shareImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/mainhoonarjun.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }
}