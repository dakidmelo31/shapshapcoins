// ignore_for_file: unused_local_variable, avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

      return Scaffold(
          body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: PrettyQr(
                          elementColor: Color.fromRGBO(89, 45, 250, 1),
                          data: auth.currentUser!.uid,
                          roundEdges: true,
                          typeNumber: 5,
                          errorCorrectLevel: 3,
                      ),
                  ),

                          // child: (result != null)
                          //     ? Text(
                          //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                          //     : Text('Scan a code'),
              ],
          ),
      );
  }

  @override
  void dispose(){
      super.dispose();
  }
}
