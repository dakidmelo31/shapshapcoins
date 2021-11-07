// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final _formKey = GlobalKey<FormState>();
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
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        const Padding(
                            padding: EdgeInsets.only(left: 25, bottom: 25),
                            child: Text("Transfer money to number", style: TextStyle(color: Color.fromRGBO(47, 27, 87, 1), fontSize: 20, fontWeight: FontWeight.w500),),
                        ),
                        Material(
                            color: Colors.white.withOpacity(0),
                            elevation: 40,
                            shadowColor: Colors.black.withOpacity(0.6),
                            child: TextFormField(
                                controller: numberController,
                                validator: (value){
                                    print("input is $value");
                                    print("user phone number is: " + auth.currentUser!.phoneNumber.toString());

                                    int num = int.parse(value.toString());
                                    if(value!.length >9 || value.length < 9 || num > 699999999 || num < 611111111){
                                        numberController.clear();
                                        return "The number you entered is invalid.";
                                    }
                                    String p = auth.currentUser!.phoneNumber.toString();
                                    if(p.contains(value.toString())){
                                        numberController.clear();
                                        return "You can't send money to yourself.";
                                    }

                                    if( value.isEmpty ){
                                        return "You need a number for the transfer.";

                                    }
                                    return null;
                                },
                                decoration: const InputDecoration(
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: Colors.white, width: 0.0
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(45)
                                        ),
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: Colors.white, width: 0.0
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)
                                        ),
                                    ),
                                    disabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: Colors.white, width: 0.0
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)
                                        ),

                                    ),

                                    prefixIcon: Icon(Icons.person_search, color: Color.fromRGBO(47, 27, 87, 1),),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3.0
                                        )
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusColor: Color.fromRGBO(47, 27, 87, 1),
                                    hoverColor: Colors.grey,
                                    hintStyle: TextStyle(color: Color.fromRGBO(0,0,0,0.4)),
                                    hintText: "Recipient Number",
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                            ),
                        ),
                        const SizedBox(
                            height: 10,
                        ),
                        Material(
                            color: Colors.white.withOpacity(0),
                            elevation: 40,
                            shadowColor: Colors.black.withOpacity(0.6),
                            child: TextFormField(
                                controller: reasonController,
                                validator: (value){
                                    if(value == null || value.isEmpty){
                                        reason = value;
                                    }
                                    return null;
                                },
                                decoration: const InputDecoration(
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: Colors.white, width: 0.0
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)
                                        ),
                                    ),
                                    focusedBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: Colors.white, width: 0.0
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)
                                        ),
                                    ),
                                    disabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: Colors.white, width: 0.0
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)
                                        ),

                                    ),

                                    prefixIcon: Icon(Icons.message, color: Color.fromRGBO(47, 27, 87, 1),),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3.0
                                        )
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusColor: Color.fromRGBO(47, 27, 87, 1),
                                    hoverColor: Colors.grey,
                                    hintStyle: TextStyle(color: Color.fromRGBO(0,0,0,0.4)),
                                    hintText: "Reason (optional)",
                                    contentPadding: EdgeInsets.only(top: 15)
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                            ),
                        ),

                        const SizedBox(
                            height: 20,
                        ),
                        Card(
                            elevation: 35,
                            // color: Color.fromRGBO(47, 27, 87, 1),
                            color: Color.fromRGBO(47, 27, 86, 1),
                            shadowColor: Colors.black.withOpacity(0.5),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                                onTap: (){
                                    if(_formKey.currentState!.validate()){
                                        markNumber( int.parse(numberController.text));
                                    }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text("Proceed to pay", style: TextStyle(fontSize: 16, color: themeColor),),
                                            const Padding(
                                                padding: EdgeInsets.only(left: 16),
                                            ),
                                            Icon(Icons.person_search_outlined, color: themeColor, size: 16,)
                                        ],
                                    ),
                                ),
                            ),
                        )

                    ],
                ),
            ),
        );
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
