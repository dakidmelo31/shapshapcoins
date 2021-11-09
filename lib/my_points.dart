import 'package:flutter/material.dart';

class MyPoints extends StatefulWidget {
  const MyPoints({Key? key}) : super(key: key);

  @override
  _MyPointsState createState() => _MyPointsState();
}

class _MyPointsState extends State<MyPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text("Show My Points"),
      ),
    );
  }
}
