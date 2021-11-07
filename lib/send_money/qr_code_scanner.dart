// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';

class MyHome extends StatelessWidget {
  static const routeName = "MyHome";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PrettyQr(
            image: const AssetImage("assets/people4.jpg"),
            typeNumber: 3,
            size: 200,
            data: '{uname: "Dakid Melo", tel: "650-323-311"}',
            errorCorrectLevel: QrErrorCorrectLevel.L,
            roundEdges: true,
            elementColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}