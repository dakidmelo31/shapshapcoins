// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shapshapcoins/receive_money/request_money.dart';

import 'my_points.dart';
import 'receive_money/receive_money_model.dart';
import 'scan_qr_code.dart';

import 'send_money/send_funds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_contacts.dart';

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
  _checkProfile() async{
    final prefs = await SharedPreferences.getInstance();
    if( prefs.containsKey("avatarPhoto")){
      avatarPhoto = prefs.getString("avatarPhoto");
      print("Your avatar is $avatarPhoto");
    }
    avatarPhoto = null;
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

  String? avatarPhoto;
  Widget? balance = CircularProgressIndicator();

  _getUserInfo() async {
    User? user = auth.currentUser;
    _firestore
        .collection("users")
        .doc(user!.uid)
        .snapshots()
        .listen((userData) {
      if (!userData.exists) return;

      setState(() {
        final amount = userData.data()!["balance"];
          balance = Text(
            NumberFormat.currency(
                decimalDigits: 0,
                symbol: "XAF",
                customPattern: '#,### \u00a4')
                .format(userData.data()!["balance"]),
            style: TextStyle(
              fontSize: amount > 99999? 40: 25,
              color: Colors.white,
              fontWeight: amount > 99999? FontWeight.w700 : FontWeight.w300
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
 var myProfile;
  setProfile() async{
    myProfile = await file("assets/people3.jpg");
  }

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
    return Scaffold(
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
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(avatarPhoto != null? avatarPhoto.toString() : "assets/people5.jpg"),
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          // child: avatarPhoto != null
                          //     ? Image.network(
                          //         avatarPhoto.toString(),
                          //         fit: BoxFit.cover,
                          //         width: 40,
                          //         height: 40,
                          //       )
                          //     : Lottie.asset(
                          //         "assets/download2.json",
                          //         fit: BoxFit.cover,
                          //         width: 40,
                          //         height: 40,
                          //       ),
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
                              Navigator.pushNamed(context, Signup.routeName);
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
                          child: Text(
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
                      middleColor: Colors.amberAccent,
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
                      openBuilder: (context, _) =>JustScan(),
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
