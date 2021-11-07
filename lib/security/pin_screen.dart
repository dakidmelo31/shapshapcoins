// ignore_for_file: prefer_const_constructors, avoid_print, duplicate_ignore

import 'package:flutter/material.dart';


class PinScreen extends StatefulWidget {
  static const routeName = "/pinScreen";
  const PinScreen({Key? key}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  int _cursor = 0;
  String _pin    = "";
  List<String>?  pins;
  String test = "1234";
  String _one = "";
  String _two = "";
  String _three="";
  String _four ="";
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
            child: Text("Login With Pin".toUpperCase(), style: TextStyle(color: Colors.grey.withOpacity(0.8)),),
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
              if( _pin == test){
                Navigator.pop(context);
              }
              else{
                print("Wrong Password " + test);
                _one = _two = _three = _four = "";
                _cursor = 0;
                _pin    = "";
                pins    = null;
              }

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
                          // ignore: avoid_print
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
