import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main_account.dart';



class SentSuccessfully extends StatefulWidget {
  static const routeName = "/sendMoney/confirmRecipient/sentSuccessfully";
  const SentSuccessfully({Key? key}) : super(key: key);

  @override
  State<SentSuccessfully> createState() => _SentSuccessfullyState();
}

class _SentSuccessfullyState extends State<SentSuccessfully> {
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

  Future ShareReceipt(
      BuildContext context, Uint8List capturedImage) async{
    final directory = await getApplicationDocumentsDirectory();
    final image     = File('${directory.path}/receipt.png');
    image.writeAsBytesSync(capturedImage);
    
    await Share.shareFiles([image.path], text: "Share your Receipt");

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
  String recipient_number = "";
  String recipient_name = "";
  int amount = 0;
  int transactionFee = 0;
  String tel = "";
  String reason = "";
  String transactionID = "";
  DateTime transactionTime = DateTime.now();
  getValues() async{
    Future<SharedPreferences> _myPrefs = SharedPreferences.getInstance();
    final prefs = await _myPrefs;
    setState(() {
      amount = prefs.getInt("amount_to_send")!;
      recipient_number = prefs.getInt("recipient")!.toString();
      recipient_name = prefs.getString("recipientName")!;
      transactionFee = prefs.getInt("transactionFee")!;
      transactionID  = prefs.getString("transactionID")!;
      reason  = prefs.getString("reason")!;



      List<String> segments = [];
      segments.add(recipient_number.substring(0, 3));
      segments.add(recipient_number.substring(3, 6));
      segments.add(recipient_number.substring(6, 9));
      recipient_number = "+237 " + segments[0] + " - " + segments[1] + " - " + segments[2];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: true,
      systemStatusBarContrastEnforced: true,
      systemNavigationBarDividerColor: Colors.blue
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 250, 250, 250),
      body: SafeArea(
        top: true,
        maintainBottomViewPadding: true,

        child: Screenshot(
    controller: screenshotController,
    child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(

            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: IconButton(onPressed: () async{
                          await _getStoragePermission();

                        }, icon: const Icon(Icons.save, color: Colors.green, size: 26)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: IconButton(icon:const Icon(Icons.share, color: Colors.blue, size: 26), onPressed: () async{
                          await _shareReceipt();
                        },),
                      )
                    ],

                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height: MediaQuery.of(context).size.height - 220,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        gradient: LinearGradient(
                            colors:
                            [
                              Colors.white,
                              Color.fromRGBO(250, 250, 250, 0.3),
                              Color.fromRGBO(250, 250, 250, 1)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomCenter),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            color: Color.fromRGBO(2, 2, 2, 0.14),
                            blurRadius: 51,
                          )
                        ]

                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipOval(
                                child: Image.asset("assets/people9.jpg", width: 70, height: 70, fit: BoxFit.cover,),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(recipient_name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22),),
                              Text(recipient_number, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 10),),
                              const Text("Sent Successfully",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                              fontSize: 16
                                ),
                              ),


                            ],
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [

                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("You sent", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text("$amount", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text(" XAF", style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [

                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("They Recieved: ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text("$amount", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text(" XAF", style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [

                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text("Transaction Charges ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text("$transactionFee", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text(" XAF", style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 16),),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                                child: Wrap(
                                  children: [
                                    Text(reason, style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300
                                    ),)
                                  ],
                                )
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                            ],
                          ),

                          PrettyQr(
                            image: AssetImage("assets/people9.jpg"),
                            size: 100,
                            data: "{"
                                "name:'$recipient_name', "
                                "number: '$tel', "
                                "amount: '$amount', "
                                "charges: '$transactionFee', "
                                "transactionID: '$transactionID', "
                                "date: '$transactionTime'"
                                "}",
                            elementColor: Theme.of(context).primaryColor,
                            roundEdges: true,
                            errorCorrectLevel: QrErrorCorrectLevel.M,
                            typeNumber: 8,
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text("Transaction ID ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20, top: 10),
                                child: Text(transactionID, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),),
                              ),
                            ],
                          ),

                        ]
                    ),
                  ),
              ),

              Card(
                color: Colors.white,
                elevation: 30,
                margin: EdgeInsets.only(bottom: 20),
                shadowColor: Color.fromRGBO(245, 245, 245, 1),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).popUntil(ModalRoute.withName(MainAccount.routeName));
                  },
                  splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 15),
                    child: Text("Go to Dashboard"),
                  ),
                ),
              )
            ],
          ),
          decoration:const BoxDecoration(
            image:  DecorationImage(
            image: AssetImage("assets/gradient4.png"),
            fit: BoxFit.cover
          ),
          ),
        ),
        ),
      ),
    );
  }
}
