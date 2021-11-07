import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../history_model.dart';
import '../receive_money_widget.dart';
import '../send_money_model.dart';

class PhoneNumber extends StatefulWidget {
  static const routeName = "/phoneNumber";

  const PhoneNumber({Key? key}) : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  int switchUsage = 0;
  Widget _usage = const SendMoneyForm();

  @override
void initState() {
    // TODO: implement initState
    super.initState();
    switchUsage = 0;
    _usage = const Center(child: Text("Show this there"));
  }
  void _changeView() {
    setState(() {
          _usage = const SendMoneyForm();

      _usage = AnimatedSwitcher(
        switchInCurve: Curves.easeInOutQuad,
        switchOutCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 1000),
        child: _usage,
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = const Color.fromRGBO(47, 27, 86, 1);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
              title: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Send & Receive Money", style: TextStyle(fontSize: 20),),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 20),

            ),
          ),
          SliverList(delegate: SliverChildListDelegate(
            [
              const SizedBox(
                height: 25,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: _changeView,
                            child: Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: const BorderRadius.all(Radius.circular(20)
                                ),

                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.mobile_screen_share, color: Colors.white, size: 16,),
                                    Text("Mobile", style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(20),
                              ),
                              border: Border.all(color: Colors.black),

                            ),
                            child: InkWell(
                              onTap: (){

                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.qr_code_scanner_outlined, color: Colors.black, size: 16,),
                                    Text("QR Code", style: TextStyle(color: Colors.black),)
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ) ,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text("Recent Contacts", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, fontFamily: "Radish"),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child:IconButton(
                            icon: const Icon(Icons.menu_outlined, size: 20, color: Colors.grey,),
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
                          child: FutureBuilder<List<HistoryItem>>(
                            future: DatabaseHelper.instance.allHistory(),
                            builder: (BuildContext context, AsyncSnapshot<List<HistoryItem>> snapshot) {
                              if(!snapshot.hasData){
                                return Center(child: Padding(
                                  padding: EdgeInsets.only(top: 108),
                                  child: Lottie.asset("assets/search2.json",  height: 350, fit: BoxFit.contain,),
                                ),);
                              }
                              else{
                                return snapshot.data!.isEmpty? Center( child: Padding(
                                  padding: EdgeInsets.only(top: 108),
                                  child:  ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: false,
                                    children: [
                                      Text("No transactions yet", style: TextStyle(color: Colors.grey.withOpacity(0.7))),
                                      Lottie.asset("assets/nothing1.json", height: 350, fit: BoxFit.contain,),

                                    ],
                                  ),
                                ),) :
                                ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: snapshot.data!.map((tx) {

                                    var transactionTime = DateFormat().add_yMMMMEEEEd().format(DateTime.now());
                                    return
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Card(
                                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            elevation: 20,
                                            shadowColor: Colors.black12,
                                            child: InkWell(
                                              onTap: (){
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                                                    child: ClipOval(
                                                      child: Hero(
                                                        tag: "hero",
                                                        child: Image.asset(tx.avatar, width: 54, height: 54, fit: BoxFit.cover,),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                          tx.name,
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w600)
                                                      ),
                                                      Text(transactionTime, style: TextStyle(
                                                          color: Colors.grey.withOpacity(0.6),
                                                          height: 1.5
                                                      ),),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(int.parse(tx.charges) > 0? "- " : "+ ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:int.parse(tx.charges) > 0?  Colors.red: Color.fromRGBO(75, 0, 255, 1))),
                                                      Text(tx.amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:int.parse(tx.charges) > 0?  Colors.red: Color.fromRGBO(75, 0, 255, 1))),
                                                      Text(" F", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey.withOpacity(0.3))),
                                                    ],
                                                  )
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
                          )
                          ,
                        ),
                      ),
                    ),


                    _usage,

                    const SizedBox(
                      height: 100,
                    )

                  ],

                ),
              ),
            ]
          )
          )
        ],
      ),
    );
  }
}
