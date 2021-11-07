import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ContactModel {
  final int? id;
  final String name;
  final String profile;
  final String phone;
  final String imageSet;

  ContactModel({this.id, required this.name, required this.phone, required this.profile, required this.imageSet});

  factory ContactModel.fromMap(Map<String, dynamic> json) => ContactModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    profile: json['profile'],
    imageSet: json['imageSet'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
      'phone': phone,
      'imageSet': imageSet,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'allcontacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
          id INTEGER PRIMARY KEY,
          name TEXT,
          profile TEXT,
          phone TEXT,
          imageSet TEXT
      )
      ''');
  }

  Future<List<ContactModel>> getContacts() async {
    Database db = await instance.database;
    var groceries = await db.query('contacts', orderBy: 'name');
    List<ContactModel> contactList = groceries.isNotEmpty
        ? groceries.map((c) => ContactModel.fromMap(c)).toList()
        : [];
    return contactList;
  }

  Future<int> add(ContactModel contacts) async {
    Database db = await instance.database;
    return await db.insert('contacts', contacts.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(ContactModel contacts) async {
    Database db = await instance.database;
    return await db.update('contacts', contacts.toMap(),
        where: "id = ?", whereArgs: [contacts.id]);
  }
}