// ignore_for_file: unused_local_variable, avoid_print


import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

// QR Code send money
class ShowCode extends StatefulWidget {
  const ShowCode({Key? key}) : super(key: key);

  @override
  _ShowCodeState createState() => _ShowCodeState();
}

class _ShowCodeState extends State<ShowCode> {
    String? reason;

    String? avatarPhoto;
    bool withPicture = true;
    myPhoto() async{
        final prefs = await SharedPreferences.getInstance();
        setState(() {
            avatarPhoto = prefs.getString("avatarPhoto").toString();
            debugPrint("avatar Photo is: $avatarPhoto");
        });
    }




    Future ShareReceipt(
        BuildContext context, Uint8List capturedImage) async{
      final directory = await getApplicationDocumentsDirectory();
      final image     = File('${directory.path}/receipt.png');
      image.writeAsBytesSync(capturedImage);

      await Share.shareFiles([image.path], text: "Here's my QR Code");

    }

ScreenshotController screenshotController = ScreenshotController();
    Future<dynamic> ShowCapturedWidget(
        BuildContext context, Uint8List capturedImage) async{
      if(capturedImage != null){
        print("found");
        final name = "ReceiptScreenshot" + DateTime.now()
            .toIso8601String()
            .replaceAll(".", "-");

        final result = await ImageGallerySaver.saveImage(capturedImage, name: name, quality: 90);
        print(result);
      }
      else{
        print("no image");
      }



      final directory = await getApplicationDocumentsDirectory();
      return showDialog(
          useSafeArea: false,
          context: context,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Receipt Screenshot", style: TextStyle(color: Colors.white),),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Center(
              child: capturedImage != null? Image.memory(capturedImage) : Container( child: Center(child: Text("Could Not get A screenshot, Please try again."),),),
            ),
          )
      );

    }


    Future _getStoragePermission() async{
      if(await Permission.storage.request().isGranted){
        print("permission granted");
        screenshotController.capture(delay: Duration( milliseconds: 10)).then((capturedImage) async{
          ShowCapturedWidget(context, capturedImage!);
        });
      }
      else{
        print("permission not granted");
      }
    }





    Future _shareReceipt() async{
      if(await Permission.storage.request().isGranted){
        print("permission granted");
        screenshotController.capture(delay: Duration( milliseconds: 10)).then((capturedImage) async{
          await ShareReceipt(context, capturedImage!);

          // Share.shareFiles([location + "shareReceipt.png"], text: "Payment Receipt");
        });
      }
      else{
        print("permission not granted");
      }

    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myPhoto();
  }
  @override
  Widget build(BuildContext context) {
      double deviceHeight = MediaQuery.of(context).size.width;
      double deviceWidth  = MediaQuery.of(context).size.width;
      return Scaffold(
          body: Container(
              width: double.infinity,
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back),),
                        )
                      ),
                    ),
                      Column(
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(47, 27, 86, .13),
                                            spreadRadius: 3,
                                            blurRadius: 23,
                                            offset: Offset(20, -30)
                                        )
                                    ]
                                ),
                                height: deviceWidth * .7,
                                width: deviceWidth * .7,
                                child: Center(
                                    child: InkWell(
                                        onTap: (){},
                                        splashColor: Colors.amber,
                                      child: avatarPhoto == null? CircularProgressIndicator.adaptive() : withPicture? PrettyQr(
                                          data: "{"+
                                          auth.currentUser!.uid
                                              +"}",
                                          size: deviceWidth * .55,
                                          roundEdges: true,
                                          elementColor: Theme.of(context).primaryColor,
                                        image: FileImage(File(avatarPhoto.toString(),),),
                                        errorCorrectLevel: QrErrorCorrectLevel.Q,

                                      ) :  PrettyQr(
                                        data: "{"+
                                            auth.currentUser!.uid
                                            +"}",
                                        size: deviceWidth * .55,
                                        roundEdges: true,
                                        elementColor: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32, left: 35, right: 35),
                            child: Text("QR codes can effectively let other users send money to you by scanning your code.", style: TextStyle(color: Colors.black)),

                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 65),
                        child: Container(
                            height: deviceHeight * .2,
                            width: deviceWidth * .90,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(onPressed: (){
                                setState(() {
                                  withPicture = !withPicture;
                                });
                              }, icon: Icon(withPicture? Icons.no_photography_outlined : Icons.photo, color: const Color.fromRGBO(47, 27, 86, 1), size: 24)),
                              IconButton(onPressed: () async{
                                debugPrint("Save qr code to gallery");
                                await _getStoragePermission();
                              }, icon: const Icon(Icons.save, color: Color.fromRGBO(47, 27, 86, 1), size: 24)),
                              IconButton(onPressed: () async{
                                await _shareReceipt();
                              }, icon: const Icon(Icons.share, color: Color.fromRGBO(47, 27, 86, 1), size: 24,)),
                            ],
                          ),
                        ),
                      ),

                  ],
              )
          ),
      );
  }

}
