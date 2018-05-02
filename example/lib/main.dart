import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gohash_mobile/gohash_mobile.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  String _errorMessage = 'No errors!';
  GohashDb _database;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  /// Temporary function to read a go-hash database from assets, writing it
  /// to a file in the Documents dir, where it's accessible to Go code.
  Future<File> _loadDbFile() async {
    final dbBytes = await rootBundle.load('assets/gohash_db');
    final docsDir = await getApplicationDocumentsDirectory();
    final destinationFile = File("${docsDir.path}/gohash_db");
    destinationFile.createSync();
    return destinationFile.writeAsBytes(dbBytes.buffer.asUint8List());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    GohashDb database;
    var errorMessage = '';
    final dbFile = await _loadDbFile();
    final dbFileSize = await dbFile.length();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      database =
          await GohashMobile.getDb(dbFile.absolute.path, 'secret_password');
      errorMessage = '';
    } on PlatformException {
      errorMessage = 'Platform error';
    } on MissingPluginException {
      // method is missing
      errorMessage = 'Internal app error - missing method';
    } on Error catch (e) {
      errorMessage = 'Catastrophic error: $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _errorMessage = errorMessage;
      _database = database;
    });
  }

  Widget _buildGroup(Group group) {
    return new ListTile(
      title: new Text(
        group.name,
        style: _biggerFont,
      ),
    );
  }

  Widget _buildGroups() {
    final String error = (_database == null)
        ? 'Could not open the database'
        : _database.groups.isEmpty ? 'The database is empty' : null;

    if (error != null) {
      return new Column(
        children: <Widget>[new Text(error), new Text("Error: $_errorMessage")],
      );
    }

    final groupWidgets = _database.groups.map(_buildGroup).toList();

    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groupWidgets.length,
        itemBuilder: (context, i) => groupWidgets[i]);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('go-hash Mobile - Test App'),
        ),
        body: new Center(
          child: _buildGroups(),
        ),
      ),
    );
  }
}
