import "package:flutter/material.dart";

class JustScan extends StatefulWidget {
  static const routeName = "/justScan";
  const JustScan({Key? key}) : super(key: key);

  @override
  _JustScanState createState() => _JustScanState();
}

class _JustScanState extends State<JustScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: Text("show me")
      ),
    );
  }
}
