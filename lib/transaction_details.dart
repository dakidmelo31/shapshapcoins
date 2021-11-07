// ignore_for_file: avoid_print, prefer_const_constructors, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'history_model.dart';



class TransactionDetails extends StatefulWidget {
  static const routeName = "/transactionDetails";
  final int id;
  const TransactionDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
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



    return showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Receipt Screenshot", style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Center(
            child: capturedImage != null? Image.memory(capturedImage) : Center(child: Text("Could Not get A screenshot, Please try again."),),
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
  String reason = "";
  String transactionID = "";
  DateTime transactionTime = DateTime.now();
  int selectedId = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(onPressed: () async{
                  await _getStoragePermission();

                }, icon: const Icon(Icons.download, color: Color.fromRGBO(47, 27, 145, 1), size: 26)),
                IconButton(onPressed: (){}, icon: Icon(Icons.visibility_off_outlined, color: Colors.pink,)
                ),
                IconButton(icon:const Icon(Icons.share, color: Colors.blue, size: 26), onPressed: () async{
                  await _shareReceipt();
                },),

              ],
              pinned: true,
              floating: true,
              expandedHeight: 250,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: "hero",
                  child: Image.asset("assets/header.png", fit: BoxFit.cover),
                ),
                title: Text("More Details", style: TextStyle(color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([
              Screenshot(

                controller: screenshotController,
                child: Container(
                  width: double.infinity,
                  child: Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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

                                FutureBuilder<List<HistoryItem>>(
                                  future: DatabaseHelper.instance.selectHistory(widget.id),
                                  builder: (BuildContext context, AsyncSnapshot<List<HistoryItem>> snapshot) {
                                    if(!snapshot.hasData){
                                      return Center(child: Padding(
                                        padding: EdgeInsets.only(top: 108),
                                        child: Lottie.asset("assets/search2.json",  height: 350, fit: BoxFit.contain,),
                                      ),);
                                    }
                                    else{
                                      return snapshot.data!.isEmpty? Center( child: Padding(
                                        padding: EdgeInsets.only(top: 108),
                                        child:  Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("No transactions yet", style: TextStyle(color: Colors.grey.withOpacity(0.7))),
                                            Lottie.asset("assets/nothing1.json", height: 350, fit: BoxFit.contain,),

                                          ],
                                        ),
                                      ),) :
                                      ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: snapshot.data!.map((tx) {

                                          return
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                PrettyQr(
                                                    data: "{"
                                                        "'name': ${tx.name}"
                                                        "'transactionTime': ${tx.transactionTime}"
                                                        "'amount': ${tx.amount}"
                                                        "'phone': ${tx.number}"
                                                        "'transactionId': ${tx.id}"
                                                        "}",
                                                  elementColor: Theme.of(context).primaryColor,
                                                  roundEdges: true,
                                                  size: 100,
                                                  errorCorrectLevel: QrErrorCorrectLevel.L,
                                                  image: AssetImage(tx.avatar),
                                                ),
                                                const SizedBox(
                                                  height: 35,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text("13", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor)),
                                                      Text(" min", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),

                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Divider(
                                                    height: 3,
                                                    color: int.parse(tx.charges) < 0? Colors.pink : const Color.fromRGBO(75, 0, 255, 1),
                                                    endIndent: 15,
                                                    indent: 15,
                                                    thickness: 3,
                                                  ),
                                                ),
                                                Text(DateFormat().add_MMMMEEEEd().format(DateTime.now())),
                                                const SizedBox(
                                                  height: 10
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(int.parse(tx.charges) > 0?  "Sent To" : "Received From", style: const TextStyle( color: Colors.grey),),
                                                        Text(tx.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                                      ],
                                                    ),
                                                  ),

                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(int.parse(tx.charges) > 0?  "Amount Sent" : "Amount Received", style: TextStyle( color: Colors.grey),),
                                                        Text("${tx.amount} F", style: const TextStyle(fontWeight: FontWeight.w700)),
                                                      ],
                                                    ),
                                                  ),

                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(int.parse(tx.charges) > 0?  "Charges" : "", style: TextStyle( color: Colors.grey),),
                                                        Text(int.parse(tx.charges) > 0? tx.amount + " F": "", style: TextStyle(fontWeight: FontWeight.w700)),
                                                      ],
                                                    ),
                                                  ),

                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text("Transaction Number", style: TextStyle( color: Colors.grey),),
                                                        Text(tx.id.toString(), style: TextStyle(fontWeight: FontWeight.w700)),
                                                      ],
                                                    ),
                                                  ),

                                                ),

                                              ],
                                            );
                                        }).toList(),
                                      );
                                    }
                                  },
                                ),

                                Image.asset("assets/logo.png")

                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration:const BoxDecoration(
                    image:  DecorationImage(
                        image: AssetImage("assets/gradient4.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
