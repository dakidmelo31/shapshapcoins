// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../send_money_model.dart';
import 'enter_amount.dart';

class ReceiveFunds extends StatefulWidget {
  static const routeName = "/receiveFunds";

  const ReceiveFunds({Key? key}) : super(key: key);

  @override
  _ReceiveFundsState createState() => _ReceiveFundsState();
}

class _ReceiveFundsState extends State<ReceiveFunds> {
  int switchUsage = 0;
  Widget _Usage = SendMoneyForm();
Widget _requestType =Text("");

  @override
void initState() {
    // TODO: implement initState
    _requestType = const ReceiveWithQR();
    super.initState();
  }
  void switchWidget(){
    if(_requestType == ReceiveMoneyForm()){
      _requestType = ReceiveWithQR();
  }
    else{
      _requestType = ReceiveMoneyForm();
  }
  }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(150, 150, 150, 1));
    TextStyle textStyleLight = TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white);
    TextStyle headingStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color.fromRGBO(75, 0, 255, 1));
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight= MediaQuery.of(context).size.height;
    Color themeColor = Color.fromRGBO(47, 27, 86, 1);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/gradient4.png"),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          repeat: ImageRepeat.noRepeat
        )
      ),
      child: Scaffold(

        backgroundColor: Colors.transparent,
        body:ListView(
          children: [
            SizedBox(
              height: 70,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){},
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: (){},
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Expanded(child: Center(
                child: PrettyQr(
                  elementColor: Theme.of(context).primaryColor,
                  data: "my information",
                  image: AssetImage("assets/people2.jpg"),
                  size: 200,
                  roundEdges: true,
                ),
              )),
              padding: EdgeInsets.all(20),
              decoration:const  BoxDecoration(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "Or"
                ),
              )
            ),
            SendMoneyForm()
          ],
        ),
      ),
    );
  }
}


class ReceiveMoneyForm extends StatefulWidget  {
  const ReceiveMoneyForm({Key? key}) : super(key: key);

  @override
  _ReceiveMoneyFormState createState() => _ReceiveMoneyFormState();
}

class _ReceiveMoneyFormState extends State<ReceiveMoneyForm> {
  markNumber(int requestee) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    prefs.setInt("requestee", requestee);
    Navigator.pushNamed(context, EnterAmount.routeName);
    print("$requestee has been selected for the send");
    print("user's reason is: $reason");
    final userReason = reason.toString();
    prefs.setString("reason", reasonController.text);
  }
  dynamic reason = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose(){
    super.dispose();
    numberController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Color themeColor = const Color.fromRGBO(47, 27, 87, 1);
    themeColor = Colors.white;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25, bottom: 25),
              child: Text("Who do you want to ask?", style: TextStyle(color: Color.fromRGBO(47, 27, 87, 1), fontSize: 16, fontWeight: FontWeight.w300),),
            ),
            Material(
              color: Colors.white.withOpacity(0),
              elevation: 40,
              shadowColor: Colors.black.withOpacity(0.6),
              child: TextFormField(
                controller: numberController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please Valid number";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  enabledBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.white, width: 0.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(45)
                    ),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.white, width: 0.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(25)
                    ),
                  ),
                  disabledBorder:  OutlineInputBorder(
                    borderSide:  BorderSide(
                        color: Colors.white, width: 0.0
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(25)
                    ),

                  ),

                  prefixIcon: Icon(Icons.person_search, color: Color.fromRGBO(47, 27, 87, 1),),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(25)
                      ),
                      borderSide: BorderSide(
                          color: Colors.white, width: 3.0
                      )
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  focusColor: Color.fromRGBO(47, 27, 87, 1),
                  hoverColor: Color.fromRGBO(235, 235, 235, 1),
                  hintStyle: TextStyle(color: Color.fromRGBO(0,0,0,0.4)),
                  hintText: "Requestee's Number",
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              color: Colors.white.withOpacity(0),
              elevation: 40,
              shadowColor: Colors.black.withOpacity(0.6),
              child: TextFormField(
                controller: reasonController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    reason = value;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    enabledBorder:  OutlineInputBorder(
                      borderSide:  BorderSide(
                          color: Colors.white, width: 0.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(45)
                      ),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide:  BorderSide(
                          color: Colors.white, width: 0.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(1)
                      ),
                    ),
                    disabledBorder:  OutlineInputBorder(
                      borderSide:  BorderSide(
                          color: Colors.white, width: 0.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(1)
                      ),

                    ),

                    prefixIcon: Icon(Icons.message, color: Color.fromRGBO(47, 27, 87, 1),),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(4)
                        ),
                        borderSide: BorderSide(
                            color: Colors.white, width: 3.0
                        )
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    focusColor: Color.fromRGBO(47, 27, 87, 1),
                    hoverColor: Color.fromRGBO(235, 235, 235, 0.51),
                    hintStyle: TextStyle(color: Color.fromRGBO(0,0,0,0.4)),
                    hintText: "Reason for request (optional)",
                    contentPadding: EdgeInsets.only(top: 15)
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 30,
            ),

            Row(
              children: [
                SizedBox(
                  width: 60,
                  // color: Color.fromRGBO(47, 27, 87, 1),
                  // color: Colors.grey,
                  // margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    elevation: 20,
                    color: Colors.white.withOpacity(0.87),

                    child: Expanded(
                      child: InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            markNumber( int.parse(numberController.text));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.arrow_back, color: Colors.pink,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  // color: Color.fromRGBO(47, 27, 87, 1),
                  // color: Colors.grey,
                  // margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    elevation: 20,
                    color: Colors.green.withOpacity(0.87),

                    child: Expanded(
                      child: InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            markNumber( int.parse(numberController.text));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Request With Number ", style: TextStyle(fontSize: 16, color: themeColor),),
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                              ),
                              Icon(Icons.arrow_forward, color: themeColor, size: 16,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )

              ],
            )

          ],
        ),
      ),
    );
  }
}
class ReceiveWithQR extends StatelessWidget {
  const ReceiveWithQR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      ],
    );
  }
}
