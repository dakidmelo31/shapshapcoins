// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_element, non_constant_identifier_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../history_model.dart';
import 'qr_send.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;


class SendFunds extends StatefulWidget {
    static const routeName = "/sendMoney";

    const SendFunds({Key? key}) : super(key: key);

    @override
    _SendFundsState createState() => _SendFundsState();
}

class _SendFundsState extends State<SendFunds> {
    dynamic reason = "";
    final _formKey = GlobalKey<FormState>();
    TextEditingController numberController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    int switchUsage = 0;

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        double deviceHeight= MediaQuery.of(context).size.height;
        Color themeColor = const Color.fromRGBO(47, 27, 86, 1);

        String recipientNumber = "";
        Widget? _currentScreen;
        Future<void> setValues(int recipient) async{
            Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
            final prefs = await _prefs;
            prefs.setInt("recipient", recipient);
            print("$recipient has been selected for the send");
            prefs.setString("reason", reasonController.text);
            // Navigator.pushNamed(context, EnterAmount.routeName);
            final userReason = reason.toString();
        }


        markNumber(int recipient) async{

            recipientNumber = "+237$recipient";
            print(recipientNumber);
            var result = await firestore.collection("users").where("phone", isEqualTo: recipientNumber).get();
            if(result.size > 0){
                setValues(recipient);

                print("found a user");

                numberController.clear();
            }
            else{
                print("User not found.");
                setState(() {
                    _currentScreen;
                });
            }

        }

        Widget formContainer = Container(
            width: double.infinity,
            height: deviceHeight * .9 * .57,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        SizedBox(
                            height: deviceHeight * .9 * .57 * .2,
                            child: Center(
                                child: Row(
                                    children: [
                                        IconButton(
                                            onPressed:(){
                                                Navigator.of(context).pop();
                                            },
                                            icon: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(Icons.arrow_back, color: themeColor)),),
                                        Center(
                                            child: Text("Transfer Your Cash", style: TextStyle(color: Color.fromRGBO(47, 27, 87, 1), fontSize: deviceHeight * .9 * .57 * .07, fontWeight: FontWeight.w500),)),

                                    ],
                                ),
                            )),
                        Material(
                            color: Colors.white.withOpacity(0),
                            elevation: 40,
                            shadowColor: Colors.black.withOpacity(0.6),
                            child: TextFormField(
                                controller: numberController,
                                validator: (value){
                                    print("input is $value");
                                    print("user phone number is: " + auth.currentUser!.phoneNumber.toString());

                                    int num = int.parse(value.toString());
                                    if(value!.length >9 || value.length < 9 || num > 699999999 || num < 611111111){
                                        numberController.clear();
                                        return "The number you entered is invalid.";
                                    }
                                    String p = auth.currentUser!.phoneNumber.toString();
                                    if(p.contains(value.toString())){
                                        numberController.clear();
                                        return "You can't send money to yourself.";
                                    }

                                    if( value.isEmpty ){
                                        return "You need a number for the transfer.";

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
                                    hoverColor: Colors.grey,
                                    hintStyle: TextStyle(color: Color.fromRGBO(0,0,0,0.4)),
                                    hintText: "Recipient Number",
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                            ),
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
                                            Radius.circular(15)
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
                                            Radius.circular(1)
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3.0
                                        )
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusColor: Color.fromRGBO(47, 27, 87, 1),
                                    hoverColor: Colors.grey,
                                    hintStyle: TextStyle(color: Color.fromRGBO(0,0,0,0.4)),
                                    hintText: "Reason (optional)",
                                    contentPadding: EdgeInsets.only(top: 15)
                                ),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                            ),
                        ),


                        Card(
                            elevation: 35,
                            color: themeColor,
                            shadowColor: Colors.green.withOpacity(0.5),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                        children: const [
                                            Text("Proceed to pay", style: TextStyle(fontSize: 16, color: Colors.white),),
                                            Padding(
                                                padding: EdgeInsets.only(left: 16),
                                            ),
                                            Icon(Icons.person_search_outlined, color: Colors.white, size: 16,)
                                        ],
                                    ),
                                ),
                            ),
                        )

                    ],
                ),
            ),
        );

        double deviceWidth =MediaQuery.of(context).size.width;

        return Scaffold(
            backgroundColor: Colors.pink, //Theme.of(context).primaryColor,
            body:ListView(
                children: [
                    Container(
                        height: deviceHeight * .9,
                        padding: const  EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            boxShadow:[
                                BoxShadow(
                                    color: themeColor.withOpacity(0.5),
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                ),
                            ]
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                formContainer,
                                TextLiquidFill(
                                    text: "Or Pick from friends List",
                                    waveColor: Colors.pink,
                                    boxBackgroundColor: Colors.white,
                                    textStyle: TextStyle(
                                        fontSize: deviceWidth * .9 * .06,
                                        fontWeight: FontWeight.bold,
                                    ),
                                    boxHeight: deviceHeight * .9 * .15,
                                ),
                                SizedBox(
                                    width: deviceWidth,
                                    height: deviceHeight * .9 * .2,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: FutureBuilder<List<HistoryItem>>(
                                            future: DatabaseHelper.instance.allHistory(),
                                            builder: (BuildContext context, AsyncSnapshot<List<HistoryItem>> snapshot) {
                                                if(!snapshot.hasData){
                                                    return Center(child: Lottie.asset("assets/search2.json",  height: 350, fit: BoxFit.contain,),);
                                                }
                                                else{
                                                    return snapshot.data!.isEmpty? Text("No transactions yet", style: TextStyle(color: Colors.grey.withOpacity(0.7))) :
                                                    ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                        children: snapshot.data!.map((tx) {
                                                            return
                                                                Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                        Card(
                                                                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                            elevation: 20,
                                                                            shadowColor: Colors.black12,
                                                                            child: InkWell(
                                                                                onTap: (){
                                                                                },
                                                                                child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                        Padding(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
                                                                                            child: ClipOval(
                                                                                                child: Hero(
                                                                                                    tag: "hero",
                                                                                                    child: Image.asset(
                                                                                                        tx.avatar,
                                                                                                        width:  (deviceHeight * .9 * .15) - 5,
                                                                                                        height: (deviceHeight * .9 * .15) - 5,
                                                                                                        fit: BoxFit.cover,),
                                                                                                ),
                                                                                            ),
                                                                                        ),
                                                                                        Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                                Text(
                                                                                                    tx.name.length > 8? tx.name.substring(0, tx.name.indexOf(" ")) : tx.name,
                                                                                                    style: const TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                        fontSize: 12,
                                                                                                    )
                                                                                                ),
                                                                                            ],
                                                                                        ),
                                                                                    ],
                                                                                ),
                                                                            ),
                                                                        ),
                                                                    ],
                                                                );
                                                        }).toList(),
                                                    );
                                                }
                                            },
                                        ),
                                    ),
                                ),
                            ],

                        ),
                    ),
                    OpenContainer(
                        openColor: Colors.transparent,
                        middleColor: Colors.pink,
                        closedColor: Colors.transparent,
                      closedElevation: 0,
                      openElevation: 0,

                      transitionDuration: Duration(seconds: 1),
                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (context, _) => QRSend(),
                      closedBuilder: (context, openContainer) => Container(
                          height: deviceHeight * .1,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                  image: AssetImage("assets/curves.png",),
                                  fit: BoxFit.contain,
                                  alignment: Alignment.topRight,
                              )
                          ),
                          child: Expanded(
                              child: TextButton.icon(onPressed: openContainer, icon: Icon(Icons.qr_code, color: Colors.white,), label: Text("Scan QR Code Instead", style: TextStyle( color: Colors.white)),),
                          ),
                      ),
                    ),
                ],
            )
        );
    }
}
