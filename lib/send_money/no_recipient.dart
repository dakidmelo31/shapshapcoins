// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoRecipient extends StatelessWidget {
  const NoRecipient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text("No Recipient found for the number given."),
      ),
    );
  }
}
