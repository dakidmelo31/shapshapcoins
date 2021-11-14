// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_element, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shapshapcoins/send_money/send_funds.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class QRSend extends StatefulWidget {
  static const routeName = "/qrSend";

  const QRSend({Key? key}) : super(key: key);

  @override
  _QRSendState createState() => _QRSendState();
}

class _QRSendState extends State<QRSend> {
  final qrKey = GlobalKey(debugLabel: "QR");
  TextEditingController numberController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  String? reason;
  Barcode? result;
  Widget? qrViewer;
  bool switchViewer = false;
  Color themeColor = const Color.fromRGBO(47, 27, 87, 1);
  QRViewController? qrController;
  final _formKey = GlobalKey<FormState>();

  void _onQRViewCreated(QRViewController qrController) async {
    this.qrController = qrController;
    print("now in the qr code function");
    qrController.scannedDataStream.listen((event) {
      setState(() {
        print("found something in qr code");
        print(event);
        result = event;
        switchViewer = !switchViewer;
        // qrController.stopCamera();
      });
    });
  }

  @override
  void reassemble() {
    if (Platform.isIOS) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    Color themeColor = const Color.fromRGBO(47, 27, 86, 1);

    String recipientNumber = "";
    Widget? _currentScreen;
    Future<void> setValues(int recipient) async {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final prefs = await _prefs;
      prefs.setInt("recipient", recipient);
      print("$recipient has been selected for the send");
      prefs.setString("reason", reasonController.text);
      // Navigator.pushNamed(context, EnterAmount.routeName);
      final userReason = reason.toString();
    }

    markNumber(int recipient) async {
      recipientNumber = "+237$recipient";
      print(recipientNumber);
      var result = await firestore
          .collection("users")
          .where("phone", isEqualTo: recipientNumber)
          .get();
      if (result.size > 0) {
        setValues(recipient);

        print("found a user");
        ScaffoldMessenger(
            child: SnackBar(
          content: Text(
            "the qr code is not valid, try a different qr code",
            softWrap: true,
          ),
          duration: Duration(seconds: 3),
          width: double.infinity,
          backgroundColor: themeColor,
          action: SnackBarAction(
            label: "all set, select the amount to pay next",
            onPressed: () {},
            textColor: Colors.amber,
          ),
        ));
      } else {
        print("User not found.");
        setState(() {
          _currentScreen;
          ScaffoldMessenger(
              child: SnackBar(
            content: Text(
              "the qr code is not valid, try a different qr code",
              softWrap: true,
            ),
            duration: Duration(seconds: 3),
            width: double.infinity,
            backgroundColor: themeColor,
            action: SnackBarAction(
              label: "Use Number Instead",
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: Colors.amber,
            ),
          ));
        });
      }
    }

    qrMaker() {
      String codeValue = "323".toString();
      if (codeValue.length == 28) {
        print("can proceed with qr code");
      } else {
        print("QR Code not what we expected");
        print("it's length is ${codeValue.length}");
      }

      if(switchViewer){
        if(result!.code.toString().length != 28){
          switchViewer = false;
          return Container(
              child: Center(child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Lottie.asset("assets/error-animation1.json", width: 160, height: 160, fit: BoxFit.contain, alignment: Alignment.center, animate: true, repeat: true, ),
                  Text("Unsoppurted QR Code scanned"),
                  SizedBox(
                    height: 80,
                  ),
                  Text("Available Options"),

                  TextButton.icon(icon: Icon(Icons.phone), onPressed: (){
                    Navigator.popAndPushNamed(context, SendFunds.routeName);
                  }, label: Text("Use Number Instead", style: TextStyle( color: Colors.amber))),
                  TextButton.icon(icon: Icon(Icons.phone), onPressed: (){
                    setState(() {

                    });
                  }, label: Text("Retry Scanning")),
                ],
              )));
        }
      }
      return switchViewer
          ? Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: deviceHeight * .9 * .57 * .2,
                            child: Center(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.arrow_back,
                                            color: themeColor)),
                                  ),
                                  Center(
                                      child: Text(
                                    "Transfer Your Cash",
                                    style: TextStyle(
                                        color: Color.fromRGBO(47, 27, 87, 1),
                                        fontSize: deviceHeight * .9 * .57 * .07,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),
                            ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Opacity(
                                opacity: .5,
                                child: Text(
                                    "You can add a reason for sending the money. It'll show up on the preson's message."
                                ),
                              ),
                              Text("Remember that the reason is optional so you can still proceed without adding a reason."),
                            ]
                          ),
                        ),
                        Material(
                          color: Colors.white.withOpacity(0),
                          elevation: 40,
                          shadowColor: Colors.black.withOpacity(0.6),
                          child: TextFormField(
                            controller: reasonController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                reason = value;
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                ),
                                prefixIcon: Icon(
                                  Icons.message,
                                  color: Color.fromRGBO(47, 27, 87, 1),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 3.0)),
                                fillColor: Colors.white,
                                filled: true,
                                focusColor: Color.fromRGBO(47, 27, 87, 1),
                                hoverColor: Colors.grey,
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4)),
                                hintText: "Reason (optional)",
                                contentPadding: EdgeInsets.only(top: 15)),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            maxLines: (deviceHeight * .008).ceil(),
                          ),
                        ),
                        Card(
                          elevation: 35,
                          color: themeColor,
                          shadowColor: Colors.green.withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                markNumber(int.parse(numberController.text));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Proceed to pay ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                  ),
                                  Icon(
                                    Icons.person_search_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: QRView(
                        key: qrKey,
                        cameraFacing: CameraFacing.back,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                          borderColor: Colors.pink,
                          overlayColor:
                              Color.fromRGBO(47, 27, 86, 1).withOpacity(0.5),
                          borderWidth: 3,
                          borderRadius: 8,
                          cutOutWidth: 200,
                          cutOutHeight: 200,
                          borderLength: 35,
                        ),
                      ),
                    ),
                  ]),
            );
    }

    Widget formContainer = Container(
      width: double.infinity,
      height: deviceHeight * .9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
      child: qrMaker(),
    );

    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.pink, //Theme.of(context).primaryColor,
        body: ListView(
          children: [
            Container(
              height: deviceHeight * .9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 10,
                    ),
                  ]),
              child: formContainer,
            ),
                Container(
                  height: deviceHeight * .1,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/curves.png",
                        ),
                        fit: BoxFit.contain,
                        alignment: Alignment.topRight,
                      )
                  ),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // duration: Duration(seconds: 1),
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            label:
                            Text("Back", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await qrController!.flipCamera();
                          },
                          icon: Icon(Icons.flip, color: Colors.white),
                          label: Text("Flip Cam",
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await qrController!.toggleFlash();
                          },
                          icon: Icon(Icons.flash_on, color: Colors.white),
                          label: Text(
                            "Flash",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ));
  }
}
