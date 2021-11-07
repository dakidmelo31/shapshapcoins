// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'send_money/enter_amount.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
class SendMoneyForm extends StatefulWidget  {
    const SendMoneyForm({Key? key}) : super(key: key);

    @override
    _SendMoneyFormState createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
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
        Navigator.pushNamed(context, EnterAmount.routeName);
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
        double deviceHeight = MediaQuery.of(context).size.height;
        double boxHeight = deviceHeight;
        if(deviceHeight < 599){
            boxHeight = deviceHeight * .9;
            print("bigger height");
        }
        else{
            print("smaller height");
            boxHeight = deviceHeight * .6;
        }
        Color themeColor = const Color.fromRGBO(47, 27, 87, 1);
        themeColor = Colors.white;
        return Container(
            color: Colors.amber,
            height: boxHeight * .86,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
class ScanCode extends StatefulWidget {
  const ScanCode({Key? key}) : super(key: key);

  @override
  _ScanCodeState createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
    final qrKey = GlobalKey(debugLabel: "QR");
    String da  = "Xoz4yeivfTWhA8aSyi0B8AZ0zlh1";
    String de  = "yy0sBlQ1VXaEZC8tor2YhWEIESg2";

    Barcode? result;
    Widget? qrviewer;
    bool switchViewer = false;
    TextEditingController reasonController = TextEditingController();
    String? reason;
    Widget qrViewer(var qrKey, Barcode? res){
        String codeValue = res == null ? "" : res.code.toString();
        if(codeValue.length == 28 )
            {
                print("can proceed with qr code");
            }
        else{
            print("QR Code not what we expected");
            print("it's length is ${codeValue.length}");
        }
        Color themeColor = Color.fromRGBO(47, 27, 87, 1);
        return switchViewer ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: double.infinity,
            child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                Text("What's your reason for sending?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700 , color: Color.fromRGBO(47, 27, 86, 1)),),
                Material(
                    elevation: 40,
                    shadowColor: Colors.black.withOpacity(0.6),
                    child: TextFormField(
                        controller: reasonController,
                        validator: (value){
                            if(value == null || value.isEmpty){
                                reason = value;
                                return "This reason is not valid";
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
                        maxLines: 8,
                    ),
                    color: Colors.white.withOpacity(0),
                ),
                SizedBox(
                    height: 8,
                ),
                Card(
                    color: Colors.grey,

                  child: Expanded(
                    child: InkWell(
                        highlightColor: Colors.greenAccent.withOpacity(0.2),
                        splashColor: themeColor,
                        hoverColor: Colors.amber,
                        onTap: () async{
                            print("button pressed");
                            Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                            final prefs = await _prefs;
                            prefs.setString("recipientUID", codeValue);
                            print("user with ID: $codeValue has been chosen for the payment.");
                            prefs.setString("reason", reasonController.text);
                            Navigator.pushNamed(context, EnterAmount.routeName);
                            print("done with the number screen.");
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                    Text("Proceed to pay", style: TextStyle(fontSize: 16, color: Colors.white),),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 16),
                                    ),
                                    Icon(Icons.person_search_outlined, color: Colors.white, size: 16,)
                                ],
                            ),
                        ),
                    ),
                  ),
                )

            ],
        )) : QRView(
            key: qrKey,
            cameraFacing: CameraFacing.back,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.amber,
                overlayColor: Color.fromRGBO(47, 27, 86, 1).withOpacity(0.5),
                borderWidth: 10,
                borderRadius: 8,
                cutOutWidth: 170,
                cutOutHeight: 170,
                borderLength: 2,
            ),
        );
    }
    QRViewController? qrController;
  @override
  void reassemble(){
      if(Platform.isIOS){
          qrController!.pauseCamera();
      }
      else if(Platform.isIOS){
          qrController!.resumeCamera();
      }
  }
  
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
                      child: qrViewer(qrKey, result),
                  ),

                          // child: (result != null)
                          //     ? Text(
                          //     'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                          //     : Text('Scan a code'),
              ],
          ),
      );
  }

  void _onQRViewCreated(QRViewController qrController) async{
      this.qrController = qrController;
      qrController.scannedDataStream.listen((event) {
          setState(() {
              print("found something in qr code");
              switchViewer = !switchViewer;
            result = event;

          });
      });
  }

  @override
  void dispose(){
      qrController!.dispose();
      super.dispose();
  }
}
