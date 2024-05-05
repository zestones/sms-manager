import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsHelper {
  static Future<void> sendSms(String message, List<String> recipients) async {
    // Request SEND_SMS permission
    var status = await Permission.sms.request();
    if (status != PermissionStatus.granted) {
      throw PlatformException(
        code: 'PERMISSION_DENIED',
        message: 'SEND_SMS permission not granted',
      );
    }

    sendSMS(message: message, recipients: recipients, sendDirect: true)
        .then((result) {
      print(result);
    }).catchError((onError) {
      print(onError);
      throw onError;
    });
  }
}
