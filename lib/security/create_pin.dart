// ignore_for_file: unused_import, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, avoid_returning_null_for_void

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_account.dart';
import 'confirm_pin.dart';
void createPin(String val) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setString("pin", val);
  prefs.setString("number", "650981130");
  print("Pin is now: " + prefs.getString("pin")!);


}

class CreatePin extends StatefulWidget {
  static const routeName = "/createPin";
  const CreatePin({Key? key}) : super(key: key);

  @override
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
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
            child: Text("Create Your Pin".toUpperCase(), style: TextStyle(fontSize: 26, color: Theme.of(context).primaryColor),),
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
                      onTap: (){
                        if(_pin.length <4) return null;
                        createPin(_pin);
                        Navigator.pushNamed(
                            context,
                            ConfirmPin.routeName);
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
