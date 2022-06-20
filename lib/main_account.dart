// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shapshapcoins/receive_money/request_money.dart';
import 'package:shapshapcoins/send_money/qr_send.dart';

import 'my_points.dart';
import 'receive_money/receive_money_model.dart';

import 'send_money/send_funds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_contacts.dart';

import 'settings/app_settings.dart';
import 'signup.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class MainAccount extends StatefulWidget {
  static const routeName = "/";

  const MainAccount({Key? key}) : super(key: key);

  @override
  _MainAccountState createState() => _MainAccountState();
}

class _MainAccountState extends State<MainAccount> {
  Widget  lastT = LinearProgressIndicator(backgroundColor: Colors.white, minHeight: 6,);

  _userInfo() async{
    Stream userDocument = _firestore.collection("users").doc(auth.currentUser!.uid).snapshots();

  }
  XFile? image;
  Dio dio = Dio();
  bool loading = false;

  Future<bool> saveLocally(String url, String filename) async{
    Directory? dir;
    try{
      if(Platform.isAndroid){
        if( await Permission.storage.isGranted){
          dir = await getExternalStorageDirectory();
          debugPrint("directory path is: " + dir!.path);
          String newPath = "";
          int? tmp;
          newPath = dir.path.split("/Android")[0];
          newPath = newPath + "/ShapshapCoins";
          dir = Directory(newPath);
          debugPrint(dir.path);

        }

      }
      else{
        if(await Permission.photos.isGranted){
          dir = await getTemporaryDirectory();
        }

      }
      if(!await dir!.exists()){
        await dir.create(recursive: true);
      }
      if(await dir.exists()){
        debugPrint("reached this place");
        File saveImg = File(dir.path +"/$filename");
        final prefs = await SharedPreferences.getInstance();
        await dio.download(url, saveImg.path, onReceiveProgress: (currentSize, totalSize){
          setState(() {
            prefs.setString("avatarPhoto", saveImg.path);
            debugPrint("avatar photo location saved to shared preferences");
          });

        }).then((value) {
          setState(() {
            debugPrint("show user profile path " + saveImg.path);
            avatarPhoto = Image.file(File(saveImg.path), fit: BoxFit.cover, width: 40, height: 40,);
          });

        });
        if(Platform.isIOS){
          await ImageGallerySaver.saveFile(saveImg.path, isReturnPathOfIOS: true);
        }
        return true;
      }


    } catch(e){
      print("error met: " + e.toString());
    }

    return false;
  }

  downloadPicture(String url) async{
    setState(() {
      loading = true;
    });

    bool downloaded = await saveLocally(url, "avatar.png");
    if(downloaded){
      debugPrint("profile downloaded successfully");
    }
    else{
      debugPrint("Error met downloading the file");
    }
    setState(() {
      loading = false;
    });

  }


  _checkProfile() async{
    final prefs = await SharedPreferences.getInstance();
    if( prefs.containsKey("avatarPhoto")){
      final picPath = prefs.getString("avatarPhoto");
      print("Your avatar path is $picPath");
setState(() {
  avatarPhoto = Image.file(File(picPath!), fit: BoxFit.cover, width: 40, height: 40,);
});    }
    else{
      downloadPicture('https://firebasestorage.googleapis.com/v0/b/shapshapcoins.appspot.com/o/kid-geb536f5ae_640.png?alt=media&token=da3aeaee-a4dc-4ff8-a07d-29f3b9b7cc55');
    }

  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection("users")
      .snapshots(includeMetadataChanges: true);

  @override
  void initState() {

    super.initState();
    _checkProfile();
    _getUserInfo();
  }

  var currentBalance = 0;
  FirebaseAuth _user = FirebaseAuth.instance;

  Widget? avatarPhoto;
  Widget? balance = CircularProgressIndicator();
  _getUserInfo() async {
    User? user = auth.currentUser;

    _firestore
        .collection("users")
        .doc(user!.uid)
        .snapshots()
        .listen((userData) {
      if (!userData.exists) return;
      Future<QuerySnapshot<Map<String, dynamic>>> lastTransaction = _firestore
          .collection("users")
          .doc(user.uid).collection("transactionHistory")
          .snapshots().last;
      if(lastTransaction != null){
        debugPrint(lastTransaction.toString());
        lastTransaction;
      }
      setState(() {
        final amount = userData.data()!["balance"];
          balance = Text(
            NumberFormat.currency(
                decimalDigits: 0,
                symbol: "XAF",
                customPattern: '#,### \u00a4')
                .format(userData.data()!["balance"]),
            style: TextStyle(
              fontSize: amount < 99999? 40: 25,
              color: Colors.white,
              fontWeight: amount < 99999? FontWeight.w700 : FontWeight.w300
            ),
          );

      });
    });
  }
//Get Profile Path
  Future<File> file(String filename) async{
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = join(dir.path, filename);
    return File(pathName);
  }
  //profile picture

  @override
  Widget build(BuildContext context) {
    Stream collectionStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    Stream documentStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.currentUser?.uid)
        .snapshots();

    TextStyle textStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(150, 150, 150, 1));
    TextStyle textStyleLight = const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white);
    double deviceWidth = MediaQuery.of(context).size.width;
    Color themeColor = const Color.fromRGBO(47, 27, 86, 1);
    return  Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/white-bg4.jpg"),
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
                alignment: Alignment.center)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.white,
            Colors.white,
            Colors.white.withOpacity(0.4),
            Colors.white,
            Colors.white.withOpacity(0.2),
            Colors.white,
          ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
          child: ListView(
            children: [
              SizedBox(
                width: deviceWidth,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, AppSettings.routeName);
                          },
                          child: ClipOval(
                            child: avatarPhoto,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            onPressed: () {
                            },
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: themeColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: deviceWidth - 80,
                height: 200,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/gradient1.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(0.25),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Available Balance",
                      style: textStyleLight,
                    ),
                    balance as Widget,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: false? lastT :Text(
                            "Last Payment: 300 F",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "9 April, 2021",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 20,
                width: 100,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(150, 150, 150, 1)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: themeColor,
                      ),
                      onPressed: () {
                        print("should move to next page");
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 20,
                    shadowColor: Colors.lightGreen.withOpacity(0.3),
                    child: OpenContainer(
                      closedElevation: 0,
                      openElevation: 30,
                      transitionDuration: Duration(seconds: 1),
                      closedColor: Colors.white,
                      middleColor: Colors.orangeAccent,
                      openBuilder: (context, _) => SendFunds(),
                      closedBuilder: (context, VoidCallback openContainer) => InkWell(
                          onTap: openContainer,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/pay2.png",
                                  width: 54,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Make Payment",
                                  style: textStyle,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  Card(
                    elevation: 20,
                    shadowColor: Colors.lightGreen.withOpacity(0.3),
                    child: OpenContainer(
                      closedElevation: 0,
                      openElevation: 30,
                      transitionDuration: Duration(seconds: 1),
                      closedColor: Colors.white,
                      middleColor: Colors.orangeAccent,
                      openBuilder: (context, _) => RequestMoney(),
                      closedBuilder: (context, VoidCallback openContainer)  => InkWell(
                          onTap: openContainer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/receive1.jpg",
                                  width: 54,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  height: 5 * 2,
                                ),
                                Text(
                                  "Collect Money",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 20,
                    shadowColor: Colors.deepOrange.withOpacity(0.3),
                    child: OpenContainer(
                      closedElevation: 0,
                      openElevation: 30,
                      transitionDuration: Duration(seconds: 1),
                      closedColor: Colors.white,
                      middleColor: Colors.orangeAccent,

                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (context, _) => ShowCode(),
                      closedBuilder:(context, VoidCallback openContainer) => InkWell(
                          onTap: openContainer,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.qr_code,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      "fast",
                                      style: textStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 100,
                                ),
                                Text(
                                  "Show Code",
                                  style: textStyle,
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  Card(
                    semanticContainer: true,
                    shadowColor: Colors.blue.withOpacity(0.3),
                    elevation: 20,
                    child: OpenContainer(
                      closedElevation: 0,
                      middleColor: themeColor,
                      transitionDuration: Duration(seconds: 1),
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedBuilder: (context, VoidCallback openContainer) => InkWell(
                          onTap: openContainer,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.camera_outlined,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      "scan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          color: themeColor),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5 * 2,
                                  width: 100,
                                ),
                                Text(
                                  "Scan Code",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          )),
                      openBuilder: (context, _) =>QRSend(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 20,
                    shadowColor: Colors.blue.withOpacity(0.3),
                    child: OpenContainer(
                      openBuilder: (contex, _) => MyContacts(),
                      closedBuilder: (context, VoidCallback openContainer) => InkWell(
                          onTap: openContainer,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.contacts_outlined,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      "11",
                                      style: textStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 100,
                                ),
                                Text(
                                  "My Contacts",
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                      ),
                      transitionDuration: Duration(seconds: 1),
                      transitionType: ContainerTransitionType.fadeThrough,
                      middleColor: Colors.blue,
                      closedElevation: 0,
                    ),
                  ),
                  Card(
                    semanticContainer: true,
                    shadowColor: Colors.purpleAccent.withOpacity(0.3),
                    elevation: 20,
                    child: OpenContainer(
                      transitionDuration: Duration(seconds: 1),
                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (context, _) => MyPoints(),
                      closedBuilder:(context, VoidCallback openContainer) => InkWell(
                          onTap: openContainer,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.add_circle_sharp,
                                      size: 40,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      "18 Points",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          color: themeColor),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5 * 2,
                                  width: 100,
                                ),
                                Text(
                                  "My Points",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
