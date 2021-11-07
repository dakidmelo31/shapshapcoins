// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';


class QRScanScreen extends StatelessWidget {
  static const routeName = "/receiveMoney/receiveWithQRCode/qrScanScreen";
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text("Scan QR Code"),
      ),
    );
  }
}
