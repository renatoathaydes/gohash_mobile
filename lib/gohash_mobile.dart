import 'dart:async';

import 'package:flutter/services.dart';

/// GohashMobile is the top-level object that can be used to interact
/// with the go-hash native API (written in Go).
/// It used Flutter's MethodChannels to call the native code.
class GohashMobile {
  static const MethodChannel _channel = const MethodChannel('gohash_mobile');

  /// getDb reads a go-hash database at the given location.
  /// If the provided password is incorrect, an error occurs.
  static Future<GohashDb> getDb(String filePath, String password) async {
    final Map<dynamic, dynamic> db =
        await _channel.invokeMethod('getDb', [filePath, password]);
    return GohashDb.from(filePath, db);
  }
}

DateTime _timestamp(dynamic value) =>
    new DateTime.fromMillisecondsSinceEpoch(value as int);

/// GohashDb represents a go-hash database.
class GohashDb {
  final String filePath;
  final List<Group> groups;

  const GohashDb(this.filePath, this.groups);

  /// Function that converts an untyped [Map] (received from native code)
  /// into a [GohashDb] instance.
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

/// A group of [LoginInfo] entries in a [GohashDb].
class Group {
  final String name;
  final List<LoginInfo> entries;

  const Group(this.name, this.entries);
}

/// LoginInfo represents a single entry in a [GohashDb].
class LoginInfo {
  final String name, description, username, password, url;
  final DateTime updatedAt;

  const LoginInfo(this.name, this.description, this.username, this.password,
      this.url, this.updatedAt);

  /// Create a [LoginInfo] instance from an untyped [Map]
  /// (received from native code).
  LoginInfo.from(Map<dynamic, dynamic> map)
      : name = map["name"] as String,
        description = map['description'] as String,
        username = map['username'] as String,
        password = map['password'] as String,
        url = map['url'] as String,
        updatedAt = _timestamp(map['updatedAt']);
}
