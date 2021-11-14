// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:shapshapcoins/add_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_account.dart';
import 'otp_screen.dart';

class Signup extends StatefulWidget {
  static const routeName = "/startup";
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();


  @override
  void dispose(){
    phoneController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationCode = "";

  holdUser(String number) async{

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    if(number.length != 9){
      print("wrong number");
    }
      number = "+237 $number";
    prefs.setString("number", number);

    print("$number");


    await auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 70),
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          debugPrint("verification ID is: $verificationId");
          debugPrint("Verification Code is: $verificationCode");
          verificationCode = verificationId;
        },);
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential).then((value) async => {
          if(value != null){
            print("user is logged in \n user is  $value"),
            await _firestore.collection("users").doc(auth.currentUser!.uid).set({
              'phone': "+237 " + phoneController.text.trim(),
        },
        SetOptions(merge: true)
        ).then((value) => {
          setState((){
            Navigator.pushNamed(context, AddName.routeName);// User has been registered

          })
            })
          }
          else{
            print("user is NOT Logged In!!!!")
        }
        }).catchError((onError) => {
          debugPrint("error saving user: ${onError.toString()}")
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        setState(() {
          verificationCode = verificationId;
        });

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: verificationCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },


    );
    setState(() {
      isOTP = true;
    });

  }
  Future<void> nextScreen() async{
      Navigator.pushNamed(context, OtpScreen.routeName).then((value) => {
        setState((){
        })
      });

  }
  final _codeController = TextEditingController();
bool isOTP = false;
  bool hideResend = false;
  @override
  Widget build(BuildContext context) {
int endTime =  DateTime.now().millisecondsSinceEpoch +
    Duration(seconds: 70).inMilliseconds;
CountdownTimerController countdownTimerController = CountdownTimerController(endTime: endTime, onEnd: (){debugPrint("timer ended");});
    Color themeColor = Theme.of(context).primaryColor;

    if (isOTP) {
      return Scaffold(
      backgroundColor: themeColor,
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeColor,
                  // image: DecorationImage(
                  //     image: AssetImage("assets/people11.jpg"),
                  //     fit: BoxFit.cover,
                  //     alignment: Alignment.centerLeft,
                  //     repeat: ImageRepeat.noRepeat
                  // ),

                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeColor,
                  image: const DecorationImage(
                      image: AssetImage("assets/gradient3.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center
                  ),

                  gradient: LinearGradient(
                      end: Alignment.topRight,
                      begin: Alignment.bottomLeft,
                      colors: [themeColor, themeColor.withOpacity(0.66), themeColor.withOpacity(0), ]
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 100,),
                          child:   Text(
                            "Let's Know It's You", style: TextStyle(color: Colors.white, fontSize: 25),),

                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20,),
                          child:   Text(
                            "Enter the OTP sent to your number.", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w300),),
                        ),
                        CountdownTimer(
                          endTime: 270,
                          textStyle: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                          onEnd: (){
                            debugPrint("countdown has ended");
                            setState(() {
                              hideResend = !hideResend;
                            });
                          },
                          widgetBuilder: (_, CurrentRemainingTime? time){
                            if(time == null){
                              return  TextButton(onPressed: () async{
                                auth.signInWithPhoneNumber("+237" + phoneController.text.toString());
                              }, child: Text("Resend Code"),);
                            }
                            int seconds = (time.min == null? 0 : time.min! * 60) + (time.sec == null? 0 : time.sec!);
                            return Text("${seconds}s till next retry is available", style: TextStyle(color: Colors.white),);
                          },
                          controller: countdownTimerController,
                        ),
                        hideResend? TextButton(onPressed: () async{
                          auth.signInWithPhoneNumber("+237" + phoneController.text.toString());
                        }, child: Text("Resend Code"),): SizedBox(height: 0, width: 0)

                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width -80,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: TextFormField(
                                    controller: _codeController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: "Verification Code",
                                      hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(width: 2, color: Colors.transparent),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(width: 2, color: Colors.transparent),
                                      ),
                                      focusColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(width: 2, color: Colors.transparent),
                                      ),
                                      contentPadding: EdgeInsets.only(left: 20, top: 15),
                                      prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,),
                                    ),
                                    validator: (value) {
                                      if( value!.length <=5 ){
                                        return "Please enter valid OTP Number";
                                      }
                                      else{
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              setState(() {
                                isOTP = false;
                                // auth.signInWithPhoneNumber(phoneController.text.toString());
                              });
                            },
                            child: Text("Resend Code?")
                        ),
                      ],
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width -80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),

                          Hero(
                            tag: "btn",
                            child: Card(
                              margin: EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: (){
                                  if(_formKey.currentState!.validate()){
                                    auth.signInWithCredential(
                                      PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: _codeController.text.toString())
                                    ).then((value) async => {
                                      if(value != null){
                                        await _firestore.collection("users").doc(auth.currentUser!.uid)
                                            .set({
                                          'phone': "+237 " + phoneController.text.toString(),
                                            }, SetOptions(merge: true)).then((value) => {
                                        Navigator.pushNamed(context, AddName.routeName)// User has been registered
                                        })
                                      }
                                    }).catchError((onError) =>{
                                      debugPrint("Error was found ${onError.toString()}")
                                    }).then((value) => {
                                      debugPrint("ended")
                                    });

                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Confirm Code", style: TextStyle(fontSize: 18, color: themeColor, fontWeight: FontWeight.w500),),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              elevation: 7,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Have an account?", style: TextStyle(color: Colors.white),),
                              TextButton(onPressed: (){
                                nextScreen();
                              }, child: Text("Login Here!"))
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              )
            ],
          )
        ],
      ),
    );
    } else {
      return Scaffold(
      backgroundColor: themeColor,
      body: ListView(
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeColor,
                  // image: DecorationImage(
                  //     image: AssetImage("assets/people11.jpg"),
                  //     fit: BoxFit.cover,
                  //     alignment: Alignment.centerLeft,
                  //     repeat: ImageRepeat.noRepeat
                  // ),

                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeColor,
                  image: const DecorationImage(
                      image: AssetImage("assets/gradient3.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center
                  ),

                  gradient: LinearGradient(
                      end: Alignment.topRight,
                      begin: Alignment.bottomLeft,
                      colors: [themeColor, themeColor.withOpacity(0.66), themeColor.withOpacity(0), ]
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 100,),
                          child:   Text(
                            "Create new Account", style: TextStyle(color: Colors.white, fontSize: 25),),

                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20,),
                          child:   Text(
                            "Let's start with your Phone Number", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w300),),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width -80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: "Phone",
                                  hintText: "E.g 671222333",
                                  hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                                  ),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(width: 2, color: Colors.transparent),
                                  ),
                                  contentPadding: EdgeInsets.only(left: 20, top: 15),
                                  prefixIcon: Icon(Icons.phone, color: Colors.lightBlueAccent,),
                                ),
                                validator: (value) {
                                  if( value == null || value.isEmpty || int.parse(value) <= 599999999 || int.parse(value) >=700000000){
                                    return "Please enter valid Number";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width -80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width -80,
                            height: 80,
                            child: Text("By signing up, you fully agree to use our platform as outlined in our privacy policy and end user terms and conditions.",
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w200),),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Hero(
                            tag: "btn",
                            child: Card(
                              margin: EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: (){
                                  if(_formKey.currentState!.validate()){
                                    holdUser(phoneController.text);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Verify Number", style: TextStyle(fontSize: 16, color: themeColor, fontWeight: FontWeight.w500),),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16),
                                      ),
                                      const Icon(Icons.arrow_forward_rounded, )

                                    ],
                                  ),
                                ),
                              ),
                              elevation: 10,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Have an account?", style: TextStyle(color: Colors.white),),
                              TextButton(onPressed: (){
                                nextScreen();
                              }, child: Text("Here!"))
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              )
            ],
          )
        ],
      ),
    );
    }
  }
}
