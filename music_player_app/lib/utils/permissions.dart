import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Solicitar permiso de acceso a medios para Android 13+
        var status = await Permission.audio.isGranted;
        if (!status) {
          status = (await Permission.audio.request()) as bool;
        }
        return status;
      } else if (sdkInt >= 29) {
        // Solicitar permisos de ubicación de medios y lectura de medios para Android 10+
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    } else {
      return true;
    }
  }
}
