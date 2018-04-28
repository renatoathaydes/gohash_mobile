import 'dart:async';

import 'package:flutter/services.dart';

class GohashMobile {
  static const MethodChannel _channel =
      const MethodChannel('gohash_mobile');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
