import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database?> initializeDatabase() async =>
      await openDatabase(join(await getDatabasesPath(), "books"),
          version: 1,
          onCreate: (Database db, int version) => onCreate(db, version));

  onCreate(Database db, int version) async {
    try {
      await db.execute(
        'CREATE TABLE my_books('
        'id INTEGER PRIMARY KEY,'
        'bookName TEXT,'
        'authorName TEXT,'
        'publicationDate TEXT,'
        'paperCount INTEGER'
        ');',
      );
      copyDatabase();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertCurrentBookData(Map<String, Object?> data) async {
    try {
      final db = await initializeDatabase();
      await db!.insert("my_books", data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> copyDatabase() async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, 'dic.db');
    final File file = File(path);
    if (!file.existsSync()) {
      ByteData data = await rootBundle.load(join('assets', 'dic.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes, flush: true);
      print('database successfully copied to $path');
    } else {
      print('database already exist');
    }
  }

  Future<void> deleteItem(String bookName) async {
    try {
      final db = await initializeDatabase();
      await db!.delete("my_books", where: "bookName = '$bookName'");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getBookData() async {
    final db = await initializeDatabase();

    return await db!.query("my_books", orderBy: "id DESC");
  }
}
