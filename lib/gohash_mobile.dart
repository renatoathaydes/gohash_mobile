import 'dart:async';

import 'package:flutter/services.dart';

class GohashMobile {
  static const MethodChannel _channel = const MethodChannel('gohash_mobile');

  static Future<GohashDb> getDb(String filePath, String password) async {
    final Map<dynamic, dynamic> db =
        await _channel.invokeMethod('getDb', [filePath, password]);
    return GohashDb.from(filePath, db);
  }
}

DateTime _timestamp(dynamic value) =>
    new DateTime.fromMillisecondsSinceEpoch(value as int);

class GohashDb {
  final String filePath;
  final List<Group> groups;

  const GohashDb(this.filePath, this.groups);

  static GohashDb from(String filePath, Map<dynamic, dynamic> map) {
    List<Group> groups = new List<Group>();
    map.forEach((key, contents) {
      List<dynamic> contentList = contents;
      var entries = contentList.map((e) => LoginInfo.from(e)).toList();
      groups.add(new Group(key.toString(), entries));
    });
    return new GohashDb(filePath, groups);
  }
}

class Group {
  final String name;
  final List<LoginInfo> entries;

  const Group(this.name, this.entries);
}

class LoginInfo {
  final String name, description, username, password, url;
  final DateTime updatedAt;

  const LoginInfo(this.name, this.description, this.username, this.password,
      this.url, this.updatedAt);

  LoginInfo.from(Map<dynamic, dynamic> map)
      : name = map["name"] as String,
        description = map['description'] as String,
        username = map['username'] as String,
        password = map['password'] as String,
        url = map['url'] as String,
        updatedAt = _timestamp(map['updatedAt']);
}
