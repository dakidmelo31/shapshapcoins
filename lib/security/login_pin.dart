// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../main_account.dart';
import 'confirm_pin.dart';


class LoginPin extends StatefulWidget {
  static const routeName = "/loginPin";
  const LoginPin({Key? key}) : super(key: key);

  @override
  _LoginPinState createState() => _LoginPinState();
}

class _LoginPinState extends State<LoginPin> {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cursor = 0;
    _pin    = "";
    Color checkedColor = Colors.white;
  }
  void createPin(String val) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setString("pin", val);
    prefs.setString("number", "650981130");
    print("Pin is now: " + prefs.getString("pin")!);


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
      setState(() {
        Navigator.of(context).popUntil(ModalRoute.withName(MainAccount.routeName));
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(
                      "assets/people11.jpg"
                  ),
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                )
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(47, 27, 86, .71),
                        Color.fromRGBO(47, 27, 86, .71),
                      ],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                      tileMode: TileMode.clamp
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height < 600? 0 : 20
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text("Welcome back", style: TextStyle(fontSize: 36, color: Colors.white),)
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
                        width: _one == Colors.blue || _one == Colors.amber || _one == Colors.green || _one == Colors.red? 20 : 35,
                        height: _one == Colors.blue || _one == Colors.amber || _one == Colors.green || _one == Colors.grey? 20 : 35,
                        decoration: BoxDecoration(
                          color: _one,
                          border: Border.all(color: _four == Colors.white? Color.fromRGBO(47, 27, 86, 1) : Colors.white, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: _two == Colors.blue || _two == Colors.amber || _two == Colors.green || _two == Colors.grey? 20 : 35,
                        height: _two == Colors.blue || _two == Colors.amber || _two == Colors.green || _two == Colors.grey? 20 : 35,
                        decoration: BoxDecoration(
                          color: _two,
                          border: Border.all(color: _four == Colors.white? Color.fromRGBO(47, 27, 86, 1) : Colors.white, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
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
                        width: _three == Colors.blue ||_three == Colors.amber || _three == Colors.green ||_three == Colors.grey? 20 : 35,
                        height: _three == Colors.blue ||_three == Colors.amber || _three == Colors.green ||_three == Colors.grey? 20 : 35,
                        decoration: BoxDecoration(
                          color: _three,
                          border: Border.all(color: _four == Colors.white? Color.fromRGBO(47, 27, 86, 1) : Colors.white, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
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
                        width: _four == Colors.blue ||_four == Colors.amber ||_four == Colors.green ||_four == Colors.grey? 20 : 35,
                        height: _four == Colors.blue ||_four == Colors.amber ||_four == Colors.green ||_four == Colors.grey? 20 : 35,
                        decoration: BoxDecoration(
                          color: _four,
                          border: Border.all(color: _four == Colors.white? Color.fromRGBO(47, 27, 86, 1) : Colors.white, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
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
                            return index <=9?TextButton(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(index == 0? "1" :index == 9? "0" : "${index + 1}", style: TextStyle(fontSize: 20, color: Colors.white)),
                                ),
                              ),
                              onPressed: (){
                                setState(() {

                                  if(_cursor <=3){
                                    _cursor += 1;
                                    _pin = _pin + (index == 0? "1" :index == 9? "0" : "${index + 1}");
                                    print(_pin);
                                    pins = _pin.split("");
                                    switch(_cursor){
                                      case 1:
                                        _one = Colors.grey;
                                        _two = _three = _four = Colors.green.withOpacity(0.09);
                                        break;
                                      case 2:
                                        _one = _two = Colors.amber;
                                        _three = _four =  Colors.purple.withOpacity(0.2);
                                        break;
                                      case 3:
                                        _one = _two = _three = Colors.red;
                                        _four =  Colors.pink.withOpacity(0.2);
                                        break;
                                      case 4:
                                        _one = _two = _three = _four = Colors.greenAccent;
                                        break;
                                      default:
                                        _one = _two = _three = _four =  Colors.amber.withOpacity(0.2);
                                    }

                                    if(_cursor >3){
                                      setState(() {
                                        checkedColor = Colors.white;
                                      });
                                    }
                                    else{
                                      setState(() {
                                        checkedColor = Colors.transparent;
                                      });
                                    }

                                  }
                                  else{

                                  }
                                });

                              },
                            ) :index<=10?
                            InkWell(
                              child: Container(
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
                                        _one = Colors.white;
                                        _two = _three = _four = Colors.purple.withOpacity(0);
                                        break;
                                      case 2:
                                        _one = _two = Colors.red;
                                        _three = _four =  Colors.purple.withOpacity(0);
                                        break;
                                      case 3:
                                        _one = _two = _three = Colors.black;
                                        _four =  Colors.purple.withOpacity(0);
                                        break;
                                      case 4:
                                        _one = _two = _three = _four = Colors.purple.withOpacity(0);
                                        break;
                                      default:
                                        _one = _two = _three = _four =  Colors.purple.withOpacity(0);
                                    }
                                    _four = Colors.white;
                                  }
                                  else{
                                    _cursor = 0;
                                    _pin    = "";
                                    print("pin is $_pin");
                                  }
                                  setState(() {
                                    checkedColor = Colors.transparent;
                                  });

                                });
                              },
                            ):
                            InkWell(
                              child: Container(
                                width: 50,
                                height: 50,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.check_sharp,
                                    color: checkedColor,
                                  ),
                                ),
                              ),
                              onTap: () async{
                                if(_pin.length <4) return;
                                confirmPin(_pin);
                                checkedColor = Colors.transparent;
                              },
                            );
                          }),
                        ),
                      )
                    ],
                  )



                ],
              ),
            ),
          )
        ),
        onWillPop: () async => false);
  }
}
