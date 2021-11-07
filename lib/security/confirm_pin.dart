// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../main_account.dart';


class ConfirmPin extends StatefulWidget {
  static const routeName = "/confirmPin";
  const ConfirmPin({Key? key}) : super(key: key);

  @override
  _ConfirmPinState createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  int _cursor = 0;
  String _pin    = "";
  List<String>?  pins;
  String test = "1234";
  Color _one = Colors.purple.withOpacity(0.2);
  Color _two = Colors.purple.withOpacity(0.2);
  Color _three = Colors.purple.withOpacity(0.2);
  Color _four = Colors.purple.withOpacity(0.2);
  Color checkedColor = Colors.white;
  Color themeColor   = const Color.fromRGBO(47, 27, 86, 1);
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cursor = 0;
    _pin    = "";
    Color checkedColor = Colors.white;
  }
  
  void updateUser() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    try{
      final user = auth.currentUser;
      if(user != null){
        print("user exists and user is: " + user.uid +" user number is ${user.phoneNumber}");

        final prefs = await _prefs;
        String? name = prefs.getString("name");
        String? email = prefs.getString("email");
        String? username = prefs.getString("username");
        String? pin = prefs.getString("pin");

        await firestore.collection("users").doc(auth.currentUser!.uid)
            .set({
          "name": name,
          'phone': user.phoneNumber,
          'balance': 0,
          'email' : email,
          'username' : username,
          'pin' : pin,
          'profile' : 'avatar.png',
          'created' : FieldValue.serverTimestamp()

        }, SetOptions(merge: true)).then((value) => {
          print("everything worked out fine, sending the user to pin screen"),
          setState(() {
        Navigator.of(context).popUntil(ModalRoute.withName(MainAccount.routeName));
        })
        });
      }
    }
    catch(e) {
      print(e);
    }

  }

  confirmPin(String val) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var pin = prefs.getString("pin");
    print("pin is: $pin and test is $val");
    if(pin != val){
      if(await Vibration.hasVibrator()){
        Vibration.vibrate( amplitude: 1000, duration: 100);
        await Future.delayed(Duration(milliseconds: 200));
        Vibration.vibrate(amplitude: 2000, duration: 100);
        setState(() {
          _one = _two = _three = _four = Colors.amber.withOpacity(0.2);
          _cursor = 0;
          _pin = "";
        });
      }

    }
    else{
      updateUser();
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height < 600? 0 : 20
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 50, bottom: 10),
              child: Text("Confirm Pin".toUpperCase(), style: TextStyle(fontSize: 26, color: Theme.of(context).primaryColor),),
            ),
            // Text("$_pin"),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  width: _one == Colors.blue? 20 : 45,
                  height: _one == Colors.blue? 20 : 60,
                  decoration: BoxDecoration(
                    color: _one,
                    border: Border.all(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _two == Colors.blue? 20 : 45,
                  height: _two == Colors.blue? 20 : 60,
                  decoration: BoxDecoration(
                    color: _two,
                    border: Border.all(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _three == Colors.blue? 20 : 45,
                  height: _three == Colors.blue? 20 : 60,
                  decoration: BoxDecoration(
                    color: _three,
                    border: Border.all(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _four == Colors.blue? 20 : 45,
                  height: _four == Colors.blue? 20 : 60,
                  decoration: BoxDecoration(
                    color: _four,
                    border: Border.all(color: Colors.white, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25),
            ),
            Column(

              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.1,
                    dragStartBehavior: DragStartBehavior.down,
                    shrinkWrap: true,
                    children:List.generate(12, (index){
                      return index <=9?InkWell(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(index == 0? "1" :index == 9? "0" : "${index + 1}", style: TextStyle(fontSize: 20,)),
                          ),
                        ),
                        onTap: (){
                          setState(() {

                            if(_cursor <=3){
                              _cursor += 1;
                              _pin = _pin + (index == 0? "1" :index == 9? "0" : "${index + 1}");
                              print(_pin);
                              pins = _pin.split("");
                              switch(_cursor){
                                case 1:
                                  _one = Colors.blue;
                                  _two = _three = _four = Colors.green.withOpacity(0.09);
                                  break;
                                case 2:
                                  _one = _two = Colors.blue;
                                  _three = _four =  Colors.purple.withOpacity(0.2);
                                  break;
                                case 3:
                                  _one = _two = _three = Colors.blue;
                                  _four =  Colors.purple.withOpacity(0.2);
                                  break;
                                case 4:
                                  _one = _two = _three = _four = Colors.blue;
                                  break;
                                default:
                                  _one = _two = _three = _four =  Colors.purple.withOpacity(0);
                              }

                              if(_cursor >3){
                                setState(() {
                                  checkedColor = Color.fromRGBO(47, 27, 86, 1);
                                });
                              }
                              else{
                                setState(() {
                                  checkedColor = Colors.white;
                                });
                              }

                            }
                            else{

                            }
                          });

                        },
                      ) :index<=10?
                      InkWell(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.backspace_outlined, color: Colors.red,),
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            if(_cursor > 0){
                              _cursor -=1;
                              _pin = _pin.substring(0, _pin.length - 1);
                              print(_pin);
                              switch(_cursor){
                                case 1:
                                  _one = Colors.blue;
                                  _two = _three = _four = Colors.purple.withOpacity(0);
                                  break;
                                case 2:
                                  _one = _two = Colors.blue;
                                  _three = _four =  Colors.purple.withOpacity(0);
                                  break;
                                case 3:
                                  _one = _two = _three = Colors.blue;
                                  _four =  Colors.purple.withOpacity(0);
                                  break;
                                case 4:
                                  _one = _two = _three = _four = Colors.purple.withOpacity(0);
                                  break;
                                default:
                                  _one = _two = _three = _four =  Colors.purple.withOpacity(0);
                              }
                            }
                            else{
                              _cursor = 0;
                              _pin    = "";
                              print("pin is $_pin");
                            }
                            setState(() {
                              checkedColor = Colors.white;
                            });

                          });
                        },
                      ):
                      InkWell(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.check, color: checkedColor,),
                          ),
                        ),
                        onTap: () async{
                          if(_pin.length <4) return;
                          confirmPin(_pin);
                        },
                      );
                    }),
                  ),
                )
              ],
            )



          ],
        )
    );
  }
}
