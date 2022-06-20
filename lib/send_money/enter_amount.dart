import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shapshapcoins/contact_model.dart';
import 'package:shapshapcoins/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

import 'sent_successfully.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class EnterAmount extends StatefulWidget {
  static const routeName = "/enterAmountToSend";

  const EnterAmount({Key? key}) : super(key: key);

  @override
  _EnterAmountState createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  String currentAmount = "0";
  String currentCommission = "0";
  int realBalance = 901;
  int balance = 901;
  Color errorColor = Colors.white;
  int temp = 0;
  String? userID;
  String? userAvatar;
  String? recipientName;
  String? recipientNumber;

  _getBalance() async {
    User? user = auth.currentUser;
    firestore.collection("users").doc(user!.uid).snapshots().listen((userData) {
      if (!userData.exists) return;

      setState(() {
        balance = userData.data()!["balance"];
        realBalance = balance;
      });
    });
  }

  calculateAmount(String amount) {
    setState(() {
      if (amount == "-") {
        if (currentAmount.length <= 1) {
          currentAmount = "0"
              "";
        } else {
          currentAmount = currentAmount.substring(0, currentAmount.length - 1);
          debugPrint(currentAmount);
        }
      } else {
        if (currentAmount == "0.0" || currentAmount == "0") {
          currentAmount = "0";
        }

        if (currentAmount.length >= 7) {
          debugPrint("reduce it?? $currentAmount");
        } else {
          if (currentAmount == "0") {
            currentAmount = amount;
          } else {
            currentAmount += amount;
          }
          debugPrint("keep typing $currentAmount");

          if (currentAmount.length > 2) {
            currentCommission = "5";
          }
        }
      }

      balance = realBalance - int.parse(currentAmount);
      balance < 0 ? errorColor = Colors.red : errorColor = Colors.white;
      currentAmount.length >= 3
          ? currentCommission = "5"
          : currentCommission = "0";
    });
  }

  String userNumber = "";
  String recipientUID = "";
  var result;

  getNumber() async {
    debugPrint("pass through this place");
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    userNumber = !prefs.containsKey("recipient")
        ? ""
        : prefs.getInt("recipient")!.toString();
    this.recipientNumber = "+237$userNumber";

    if (prefs.containsKey("recipientUID")) {
      recipientUID = prefs.getString("recipientUID").toString();
      debugPrint("found recipient UID");
      debugPrint("Found a number");
      result = await firestore
          .collection("users")
          .doc(recipientUID)
          .get()
          .then((value) => {
                if (value.exists)
                  {
                    setState(() {
                      recipientName = value.data()!["name"];
                      this.recipientNumber = value.data()!["phone"];
                      userAvatar = value.data()!["profile"];
                      debugPrint(
                          'user name: $recipientName, recipient number: $recipientNumber, user Avatar: $userAvatar');
                    })
                  }
                else
                  {debugPrint("didn't fine any user")}
              });
      prefs.remove("recipientUID");

      var system = await firestore.collection("system").doc("systemcash").get();
      systemBalance = system.data()!['balance'];

      setState(() {
        List<String> segments = [];
        segments.add(userNumber.substring(0, 3));
        segments.add(userNumber.substring(3, 6));
        segments.add(userNumber.substring(6, 9));
        userNumber =
            "+237 " + segments[0] + " - " + segments[1] + " - " + segments[2];
      });
    } else {
      debugPrint("didn't find recipient UID so trying out phone number");
      result = await firestore
          .collection("users")
          .where("phone", isEqualTo: recipientNumber)
          .get();

      if (result.size > 0) {
        debugPrint("Found a number");
        result.docs.forEach((element) {
          setState(() {
            recipientName = element.data()["name"];
            userAvatar = element.data()["profile"];
            recipientNumber = element.data()["phone"];
          });
        });
      } else {
        debugPrint("User not found.");
        setState(() {});
      }

      var system = await firestore.collection("system").doc("systemcash").get();
      systemBalance = system.data()!['balance'];

      setState(() {
        List<String> segments = [];
        segments.add(userNumber.substring(0, 3));
        segments.add(userNumber.substring(3, 6));
        segments.add(userNumber.substring(6, 9));
        userNumber =
            "+237 " + segments[0] + " - " + segments[1] + " - " + segments[2];
      });
    }
  }

  var systemBalance;

  makePayment(int amount) async {
    Future<SharedPreferences> _myPrefs = SharedPreferences.getInstance();
    final prefs = await _myPrefs;
    prefs.setInt("amount_to_send", amount);
    prefs.setInt("transactionFee", int.parse(currentCommission));
    prefs.setString("recipientName", recipientName!);
    prefs.setString("transactionID", "AASDKLFE33239343");
    String? reason = prefs.getString("reason");
    String? myName = prefs.getString("name").toString();

    var result = await firestore
        .collection("users")
        .where("phone", isEqualTo: recipientNumber)
        .get();
    var newBalance, recipientBalance, recipientID;

    recipientID = result.docs.first.id;
    if (result.size > 0) {
      debugPrint("Found a number");
      result.docs.forEach((element) {
        setState(() {
          recipientBalance = element.data()["balance"] + amount;
          newBalance = realBalance - amount - 5;

          firestore
              .collection("users")
              .doc(recipientID)
              .update({
                "balance": recipientBalance,
              })
              .then((value) => {
                debugPrint("now i'm writing the transaction details to my account's collection"),
               setState(() {
                  firestore.collection("users").doc(auth.currentUser!.uid).collection("userTransactionHistory").add({
                    "recipient": recipientName,
                    "recipientID" : recipientID,
                    "amount" : amount,
                    "charges" : currentCommission,
                    "message" : reason.toString(),
                    "transactionTime" : FieldValue.serverTimestamp()
                  }).whenComplete(() => {
                    debugPrint('successfully registered user information to database, now for the user\'s own history to be created'),


                  firestore.collection("users").doc(recipientID).collection("userTransactionHistory").add({
                  "sender": myName,
                  "senderID" : auth.currentUser!.uid,
                  "amount" : amount,
                  "message" : reason.toString(),
                  "transactionTime" : FieldValue.serverTimestamp()
                  }).whenComplete(() => {
                  debugPrint('successfully registered all transaction information to database'),
                     DatabaseHelper.instance.add(HistoryItem(name: recipientName.toString(), amount: amount.toString(), number: recipientID, message: reason.toString(), transactionTime: FieldValue.serverTimestamp().toString(), avatar: userAvatar.toString(), charges: currentCommission)),
                    ContactDatabaseHelper.instance.add(ContactModel(name: recipientName.toString(), phone: recipientID, profile: userAvatar.toString(), imageSet: true.toString()))
                  })

                  });
                }),
                    debugPrint(
                        "User has been paid, we can now send SMS notification and push notifications"),
                    firestore
                        .collection("users")
                        .doc(auth.currentUser!.uid)
                        .update({
                          "balance": newBalance,
                        })
                        .then((value) => {

                              debugPrint(
                                  "Your own balance has been reflected now. You can continue working"),
                              firestore
                                  .collection("system")
                                  .doc("systemcash")
                                  .update({
                                    "balance": systemBalance + 5,
                                  })
                                  .then((value) => {
                                        debugPrint(
                                            "The system balance has been added successfully")
                                      })
                                  .catchError((onError) => debugPrint(
                                      "failed to make payment because of the following: ${onError.toString()}"))
                            })
                        .catchError((onError) => debugPrint(
                            "failed to make payment because of the following: ${onError.toString()}"))
                  })
              .catchError((onError) => debugPrint(
                  "failed to make payment because of the following: ${onError.toString()}"));
        });
      });
    } else {
      debugPrint("User not found.");
      setState(() {});
    }

    setState(() {
      //Move user to the receipt screen
      Navigator.pushNamed(context, SentSuccessfully.routeName);
    });

    // setState(() {
    // });
  }

  Color themeColor = const Color.fromRGBO(47, 27, 86, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNumber();
    _getBalance();
  }

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    );

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    TextStyle numberStyle = const TextStyle(
        fontSize: 20, color: Colors.white, fontWeight: FontWeight.w200);
    return Material(
      child: Container(
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/gradient3.png"), fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 29, sigmaY: 29),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: deviceHeight * .08,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Transferring",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        NumberFormat.currency(
                                decimalDigits: 0,
                                symbol: "XAF",
                                customPattern: '#,### \u00a4')
                            .format(balance),
                        style: TextStyle(color: errorColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              ClipOval(
                  child: Image.network(
                          userAvatar.toString(),
                          width: deviceHeight * .1,
                          height: deviceHeight * .1,
                          fit: BoxFit.cover,
                    loadingBuilder:
                        (BuildContext context,
                        Widget child,
                        ImageChunkEvent?
                        loadingProgress) {
                      if (loadingProgress == null)
                        return child;
                      return Center(
                          child:
                          CircularProgressIndicator(
                            color: const Color.fromRGBO(47, 27, 86, 1),
                            value: loadingProgress
                                .expectedTotalBytes !=
                                null
                                ? loadingProgress
                                .cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ));
                    },
                  )),
              SizedBox(
                height: deviceHeight * .06,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    recipientName == null
                        ? const LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.amber,
                            minHeight: 2,
                          )
                        : Text(
                            recipientName.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                    Text(
                      userNumber,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * .01,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: deviceWidth - 20,
                    height: deviceHeight * 0.08,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              child: Text(
                                " $currentAmount F",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 8),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                " Commission: $currentCommission F",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SliderButton(
                    height: deviceHeight * .11,
                    radius: 0,
                    width: double.infinity,
                    alignLabel: Alignment.center,
                    action: () {

                      if (int.parse(currentAmount) <= realBalance) {
                        makePayment(int.parse(currentAmount));
                      } else {
                        debugPrint(
                            "Cannot Confirm payment since we have a negative balance");
                        const mySnack = SnackBar(
                            duration: Duration(milliseconds: 1800),
                            elevation: 20,
                            backgroundColor: Colors.white,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            dismissDirection: DismissDirection.horizontal,

                            content: Center(
                                child: Text(
                                  "Sorry, your balance is smaller than the amount you are trying to pay.", style: TextStyle(color: Color.fromRGBO(47, 27, 86, 1)),)));
                        ScaffoldMessenger.of(context).showSnackBar(mySnack);

                      }
                    },
                    dismissThresholds: 0.7,
                    icon: const Icon(
                      Icons.arrow_right_alt_sharp,
                      size: 32,
                      color: Colors.black,
                    ),
                    highlightedColor: Colors.amber,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    baseColor: Colors.white,
                    shimmer: true,
                    vibrationFlag: true,
                    buttonColor: Colors.white,
                    label: const Text("Slide to Send"),
                    boxShadow: const BoxShadow(
                        blurRadius: 5, spreadRadius: 1, color: Colors.white),
                  ),
                  SizedBox(
                    height: deviceHeight * .02,
                  ),
                  SizedBox(
                    height: deviceHeight * .135,
                    width: deviceWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("1");
                            },
                            child: Text(
                              "1",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("2");
                            },
                            child: Text(
                              "2",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("3");
                            },
                            child: Text(
                              "3",
                              style: numberStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * .135,
                    width: deviceWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("4");
                            },
                            child: Text(
                              "4",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("5");
                            },
                            child: Text(
                              "5",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("6");
                            },
                            child: Text(
                              "6",
                              style: numberStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * .135,
                    width: deviceWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("7");
                            },
                            child: Text(
                              "7",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("8");
                            },
                            child: Text(
                              "8",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("9");
                            },
                            child: Text(
                              "9",
                              style: numberStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * .135,
                    width: deviceWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: const Icon(Icons.check, color: Colors.blue),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("0");
                            },
                            child: Text(
                              "0",
                              style: numberStyle,
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              calculateAmount("-");
                            },
                            child: const Icon(
                              Icons.backspace,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

          ],
          ),
        ),
      ),
    );
  }
}
