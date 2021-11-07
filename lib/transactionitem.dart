// ignore_for_file: unused_import, dead_code, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class TransactionItem{
  final int id;
  final String name;
  final String username;
  final String avatar;
  final int    number;
  final int    amount;
  final int    charges;
  final String transferType;
  final String transactionDate;
  final String imageSet;
  final String message;

  TransactionItem({
  required this.id,
  required this.username,
  required this.number,
  required this.name,
  required this.amount,
  required this.avatar,
  required this.charges,
  required this.imageSet,
  required this.transactionDate,
  required this.transferType,
  required this.message
  });

  factory TransactionItem.fromMap(Map<String, dynamic> json) => TransactionItem(
    id: json['id'],
    name: json['name'],
    username: json['username'],
    avatar: json['avatar'],
    amount: json['amount'],
    number: json['number'],
    message: json['message'],
    charges: json['charges'],
    transferType: json['transferType'],
    imageSet: json['imageSet'],
    transactionDate: json['transactionDate'],
  );

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      'name': name,
      'amount': amount,
      'avatar': avatar,
      'number': number,
      'message': message,
      'charges': charges,
      'username': username,
      'transferType': transferType,
      "imageSet": imageSet,
      "transactionDate": transactionDate
    };
  }

}

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async =>  _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory docdirectory = await getApplicationDocumentsDirectory();
    String path = join(docdirectory.path,  "fulltransactions.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,

    );
  }
  Future _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE mytransactions(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    username TEXT,
    avatar TEXT,
    message TEXT,
    transferType TEXT,
    transactionDate TimeStamp,
    imageSet TEXT,
    amount INTEGER,
    charges INTEGER,
    number INTEGER
    )
    ''');
  }
  Future<List<TransactionItem>> getTransactions() async{
    Database db = await instance.database;
    var transactions = await db.query("mytransactions", orderBy: "name");
    List<TransactionItem> txs = transactions.isNotEmpty? transactions.map((e) => TransactionItem.fromMap(e)).toList(): [];
    return txs;
  }

  Future<int> add(TransactionItem transactionItem) async{
    Database db = await instance.database;
    return await db.insert("mytransactions", transactionItem.toMap());
    print("we added ${transactionItem.name}'s transaction to record");
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete("mytransactions", where: "id= ?", whereArgs: [id]);
  }
}
