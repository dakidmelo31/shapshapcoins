// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../receive_money_widget.dart';
import '../send_money_model.dart';

class SendWithQR extends StatefulWidget {
  static const routeName = "/sendWithQR";

  const SendWithQR({Key? key}) : super(key: key);

  @override
  _SendWithQRState createState() => _SendWithQRState();
}

class _SendWithQRState extends State<SendWithQR> {
  int switchUsage = 0;
  Widget _Usage = SendMoneyForm();

  @override
void initState() {
    // TODO: implement initState
    super.initState();
    switchUsage = 0;
    _Usage = SendMoneyForm();
  }
  void _changeView() {
    setState(() {
          _Usage = WithQRCode();

      _Usage = AnimatedSwitcher(
        switchInCurve: Curves.easeInOutQuad,
        switchOutCurve: Curves.easeInOut,
        duration: Duration(milliseconds: 1000),
        child: _Usage,
      );

    });
  }
  void _changeView2() {
    setState(() {
      _Usage = WithQRCode();

      _Usage = AnimatedSwitcher(
        switchInCurve: Curves.easeInOutQuad,
        switchOutCurve: Curves.easeInOut,
        duration: Duration(milliseconds: 700),
        child: _Usage,
      );

    });
  }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(150, 150, 150, 1));
    TextStyle textStyleLight = TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white);
    TextStyle headingStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color.fromRGBO(75, 0, 255, 1));
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight= MediaQuery.of(context).size.height;
    Color themeColor = Color.fromRGBO(47, 27, 86, 1);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.qr_code))
            ],
            backgroundColor: themeColor,
            pinned: true,
            floating: true,
            elevation: 20,
            expandedHeight: 130,
            shadowColor: themeColor.withOpacity(0.7),
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                opacity: 0.25,
                child: Image.asset("assets/curves.png", fit: BoxFit.contain, width: 60, alignment: Alignment.topRight,),
              ),
              title: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Add recipient", style: TextStyle(fontSize: 20),),
              ),
              titlePadding: EdgeInsets.only(left: 20, bottom: 20),

            ),
          ),
          SliverList(delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 25,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                  boxShadow:[
                    BoxShadow(
                      color: themeColor.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 10,
                    ),
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                        ],
                      ) ,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Recent Contacts", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),),
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child:IconButton(
                            icon: Icon(Icons.menu_outlined, size: 20, color: Colors.grey,),
                            onPressed: (){},
                            splashColor: Colors.purple,
                            focusColor: Colors.purple,
                            highlightColor: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: 100,
                          child: Text("No recent contacts found", style: TextStyle(fontSize: 16, color: Colors.grey),),
                        ),
                      ),
                    ),


                    WithQRCode(),

                    SizedBox(
                      height: 100,
                    )

                  ],

                ),
              ),
            ]
          ))
        ],
      ),
    );
  }
}
