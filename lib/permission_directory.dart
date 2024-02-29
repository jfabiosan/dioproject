import 'package:permission_handler/permission_handler.dart';

Future<bool> requestExternalStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    }
  } else {
    return true;
  }
  return false;
}
