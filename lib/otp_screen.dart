// ignore_for_file: avoid_print, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_name.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = "/otpscreen";
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();


  @override
  void dispose(){
    _codeController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  holdUser(String code) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    final test  = prefs.getString("number");
    if(code == test ){
      print("code is the same");
    }

    print("Signup Successful");
    Navigator.pushNamed(context, AddName.routeName);
  }
  nextScreen() {
    Navigator.pushNamed(context, AddName.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: themeColor,
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height- 50,
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
                height: MediaQuery.of(context).size.height - 50,
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
                height: MediaQuery.of(context).size.height - 50,
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
                            height: 10,
                          ),

                          Hero(
                            tag: "btn",
                            child: Card(
                              margin: EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: (){
                                  if(_formKey.currentState!.validate()){
                                    holdUser(_codeController.text);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Verify Number", style: TextStyle(fontSize: 18, color: themeColor, fontWeight: FontWeight.w500),),
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
