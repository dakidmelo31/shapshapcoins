// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class OnboardScreen extends StatefulWidget {
  static const routeName = "/onboardscreen";

  const OnboardScreen({Key? key}) : super(key: key);

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: textController,
          ),
        ),
        body: Center(
          child: FutureBuilder<List<HistoryItem>>(
              future: DatabaseHelper.instance.allHistory(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<HistoryItem>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Loading...'));
                }
                return snapshot.data!.isEmpty
                    ? Center(
                        child:
                            Text('Your past transactions will show up here.'))
                    : ListView(
                        children: snapshot.data!.map((history) {
                          return Center(
                            child: Card(
                              color: selectedId == history.id
                                  ? Colors.white70
                                  : Colors.white,
                              child: ListTile(
                                title: Text(history.name),
                                onTap: () {
                                  setState(() {
                                    if (selectedId == null) {
                                      textController.text = history.name;
                                      selectedId = history.id;
                                    } else {
                                      textController.text = '';
                                      selectedId = null;
                                    }
                                  });
                                },
                                onLongPress: () {
                                  setState(() {
                                    DatabaseHelper.instance.remove(history.id!);
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            setState(() {
              textController.clear();
              selectedId = null;
            });
          },
        ),
      ),
    );
  }
}

class HistoryItem {
  final int? id;
  final String name;
  final String number;
  final String amount;
  final String charges;
  final String avatar;
  final String transactionTime;
  final String message;

  HistoryItem(
      {this.id,
      required this.name,
      required this.amount,
      required this.number,
      required this.message,
      required this.transactionTime,
      required this.avatar,
      required this.charges});

  factory HistoryItem.fromMap(Map<String, dynamic> json) => HistoryItem(
        id: json['id'],
        name: json['name'],
        number: json['number'],
        avatar: json['avatar'],
        charges: json['charges'],
        transactionTime: json['transactionTime'],
        message: json['message'],
        amount: json['amount'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'charges': charges,
      'amount': amount,
      'message': message,
      'avatar': avatar,
      'number': number,
      'transactionTime': transactionTime,
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
    String path = join(documentsDirectory.path, 'transaction_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
          id INTEGER PRIMARY KEY,
          name TEXT,
          message TEXT,
          amount TEXT,
          number TEXT,
          avatar TEXT,
          charges TEXT,
          transactionTime TEXT
      )
      ''');
  }

  Future<List<HistoryItem>> allHistory() async {
    Database db = await instance.database;

    var history = await db.query('history', orderBy: 'name');
    List<HistoryItem> historyList = history.isNotEmpty
        ? history.map((c) => HistoryItem.fromMap(c)).toList()
        : [];
    return historyList;
  }

  Future<List<HistoryItem>> allDistinctHistory() async {
    Database db = await instance.database;

    var history = await db.query('history', orderBy: 'name');
    List<HistoryItem> historyList = history.isNotEmpty
        ? history.map((c) => HistoryItem.fromMap(c)).toList()
        : [];
    return historyList;
  }

  Future<List<HistoryItem>> selectHistory(int id) async {
    Database db = await instance.database;
print("ID passed is $id");
    var history = await db.query('history',where: "id= ?", whereArgs: [id], orderBy: 'name');
    List<HistoryItem> historyItem = history.isNotEmpty
        ? history.map((c) => HistoryItem.fromMap(c)).toList()
        : [];
    return historyItem;
  }

  Future<int> add(HistoryItem history) async {
    Database db = await instance.database;
    return await db.insert('history', history.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(HistoryItem history) async {
    Database db = await instance.database;
    return await db.update('history', history.toMap(),
        where: "id = ?", whereArgs: [history.id]);
  }
}
