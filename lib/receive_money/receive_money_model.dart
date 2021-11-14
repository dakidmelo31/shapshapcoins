// ignore_for_file: unused_local_variable, avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
class RequestMoneyForm extends StatefulWidget  {
    const RequestMoneyForm({Key? key}) : super(key: key);

    @override
    _RequestMoneyFormState createState() => _RequestMoneyFormState();
}

class _RequestMoneyFormState extends State<RequestMoneyForm> {
    String recipientNumber = "";
    markNumber(int recipient) async{
        recipientNumber = "+237$recipient";
        print(recipientNumber);
        var result = await firestore.collection("users").where("phone", isEqualTo: recipientNumber).get();
        if(result.size > 0){
            setValues(recipient);

            print("found a user");

            numberController.clear();
        }
        else{
            print("User not found.");
            setState(() {
              _currentScreen;
            });
        }

    }
    Widget? _currentScreen;
    Future<void> setValues(int recipient) async{
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        final prefs = await _prefs;
        prefs.setInt("recipient", recipient);
        print("$recipient has been selected for the send");
        prefs.setString("reason", reasonController.text);
        // Navigator.pushNamed(context, EnterAmount.routeName);
        final userReason = reason.toString();
    }

    dynamic reason = "";
    TextEditingController numberController = TextEditingController();
    TextEditingController reasonController = TextEditingController();

    @override
    void initState() {
        super.initState();

    }

    @override
    void dispose(){
        super.dispose();
        numberController.dispose();
    }
    @override
    Widget build(BuildContext context) {
        Color themeColor = const Color.fromRGBO(47, 27, 87, 1);
        themeColor = Colors.white;
        return Text("show");
    }
}


// QR Code send money
class ShowCode extends StatefulWidget {
  const ShowCode({Key? key}) : super(key: key);

  @override
  _ShowCodeState createState() => _ShowCodeState();
}

class _ShowCodeState extends State<ShowCode> {
    final qrKey = GlobalKey(debugLabel: "QR");

    Widget? qrviewer;
    bool switchViewer = false;
    TextEditingController reasonController = TextEditingController();
    String? reason;


  @override
  Widget build(BuildContext context) {
      double deviceHeight = MediaQuery.of(context).size.width;
      double deviceWidth  = MediaQuery.of(context).size.width;

      return Scaffold(
          backgroundColor: Color.fromRGBO(47, 27, 86, 1),
          body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/gradient3.png"),
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                  ),
              ),
              child: Container(
                  color: Colors.black.withOpacity(0.3)
              )
          )
      );
  }

}
