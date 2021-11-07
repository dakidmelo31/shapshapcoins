// ignore_for_file: prefer_const_constructors, avoid_print, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:shapshapcoins/settings/security_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';



class ConfirmNewPin extends StatefulWidget {
  static const routeName = "/confirmNewPin";
  const ConfirmNewPin({Key? key}) : super(key: key);

  @override
  _ConfirmNewPinState createState() => _ConfirmNewPinState();
}

class _ConfirmNewPinState extends State<ConfirmNewPin> {
  int _cursor = 0;
  String _pin    = "";
  List<String>?  pins;
  String test = "";
  String _one = "";
  String _two = "";
  String _three="";
  String _four ="";
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
          _one = _two = _three = _four = "";
          _cursor = 0;
          _pin = "";
        });
      }

    }
    else{
      setState(() {
        Navigator.of(context).popUntil(ModalRoute.withName(SecuritySettings.routeName));
      });
    }

  }

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
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, top: 50, bottom: 10),
            child: Text("Confirm Pin".toUpperCase(), style: TextStyle(color: Colors.grey.withOpacity(0.8)),),
          ),
          Text(_pin),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 45,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(_one, style: TextStyle(fontSize: 34, color: Theme.of(context).primaryColor),),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Container(
                width: 45,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(_two, style: TextStyle(fontSize: 34, color: Theme.of(context).primaryColor),),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Container(
                width: 45,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(_three, style: TextStyle(fontSize: 34, color: Theme.of(context).primaryColor),),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Container(
                width: 45,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 0.0),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(_four, style: TextStyle(fontSize: 34, color: Theme.of(context).primaryColor),),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 25),
          ),
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                shrinkWrap: true,
                children:List.generate(11, (index){
                  return index <=9?InkWell(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("$index", style: TextStyle(fontSize: 20,)),
                      ),
                    ),
                    onTap: (){
        setState(() {
          if(_cursor <=3){
            _cursor += 1;
            _pin = _pin + index.toString();
            pins = _pin.split("");
            switch(_cursor){
              case 1:
                _one = "*";
                _two = _three = _four = "";
                break;
              case 2:
                _one = _two = "*";
                _three = _four = "";
                break;
              case 3:
                _one = _two = _three = "*";
                _four = "";
                break;
              case 4:
                _one = _two = _three = _four ="*";
                break;
              default:
                _one = _two = _three = _four = "";
            }

            if(_cursor >3){
              confirmPin(_pin);

            }

          }
          else{

          }
        });

    },
                  ) : InkWell(
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
                              _one = "*";
                              _two = _three = _four = "";
                              break;
                            case 2:
                              _one = _two = "*";
                              _three = _four = "";
                              break;
                            case 3:
                              _one = _two = _three = "*";
                              _four = "";
                              break;
                            case 4:
                              _one = _two = _three = _four ="*";
                              break;
                            default:
                              _one = _two = _three = _four = "";
                          }
                        }
                        else{
                          _cursor = 0;
                          _pin    = "";
                          print("pin is $_pin");

                        }
                      });
                    },
                  );
                }),
              ),
            ),
          )



        ],
      )
    );
  }
}
