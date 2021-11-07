// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../history_model.dart';
import '../send_money_model.dart';

class SendFunds extends StatefulWidget {
    static const routeName = "/sendFunds";

    const SendFunds({Key? key}) : super(key: key);

    @override
    _SendFundsState createState() => _SendFundsState();
}

class _SendFundsState extends State<SendFunds> {
    int switchUsage = 0;
    Widget _Usage = SendMoneyForm();


    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        switchUsage = 0;
    }
    void _changeView() {
        setState(() {
            if(switchUsage == 0){
                _Usage = Container(
                    height: 300,
                    width: double.infinity,
                    child: ScanCode(),
                );
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) =>ScanCode())
                // );
                print('switching to scan code');
                switchUsage = 1;
            }
            else{
                print("switching to send money form");
                _Usage = SendMoneyForm();
            }

            _Usage = AnimatedSwitcher(
                switchInCurve: Curves.easeInOutQuad,
                switchOutCurve: Curves.easeInOut,
                duration: Duration(milliseconds: 1000),
                child: _Usage,
            );

        });
    }
    bool showContacts = false;
    @override
    Widget build(BuildContext context) {
        double deviceHeight= MediaQuery.of(context).size.height;
        Color themeColor = const Color.fromRGBO(47, 27, 86, 1);
        showContacts = deviceHeight > 599? true : false;

        final Widget chooseFromContacts = showContacts? AnimatedContainer(
            duration: Duration(microseconds: 300),
            color: Colors.grey.withOpacity(0.12),
            height: deviceHeight *.9 * .24,
          child: Column(
              children: [
                  Container(
                      height: deviceHeight *.9 * .24 *.3,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text("Choose from your contacts", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                              ),

                              Padding(
                                  padding: const  EdgeInsets.only(right: 4),
                                  child:IconButton(
                                      icon:  const Icon(Icons.person_add_alt, size: 20, color: Colors.grey,),
                                      onPressed: (){},
                                      splashColor: Colors.purple,
                                      focusColor: Colors.purple,
                                      highlightColor: Colors.purple,
                                  ),
                              ),
                          ],
                      ),
                  ),
                  Container(
                      height: deviceHeight *.9 * .24 *.7,
                      child: FutureBuilder<List<HistoryItem>>(
                          future: DatabaseHelper.instance.allHistory(),
                          builder: (BuildContext context, AsyncSnapshot<List<HistoryItem>> snapshot) {
                              if(!snapshot.hasData){
                                  return Center(child: Lottie.asset("assets/search2.json",  height: 350, fit: BoxFit.contain,),);
                              }
                              else{
                                  return snapshot.data!.isEmpty? Center( child:
                                          Text("No transactions yet", style: TextStyle(color: Colors.grey.withOpacity(0.7)
                                            )
                                          ),
                                  ) :
                                  ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: snapshot.data!.map((tx) {

                                          var transactionTime = DateFormat().add_yMMMMEEEEd().format(DateTime.now());
                                          return
                                              Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                      Container(
                                                        height: deviceHeight *.9 * .24 *.7 * .9,
                                                        width: 70,
                                                        margin: EdgeInsets.only(right: 5),
                                                        color: Colors.white.withOpacity(0.5),
                                                        child: SizedBox(
                                                            height: double.infinity,
                                                          width: double.infinity,
                                                          child: InkWell(
                                                              onTap: (){
                                                              },
                                                              splashColor: Colors.amberAccent,
                                                              highlightColor: themeColor.withOpacity(0.4),
                                                              child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                      Padding(
                                                                          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
                                                                          child: ClipOval(
                                                                              child: Hero(
                                                                                  tag: "hero",
                                                                                  child: Image.asset(tx.avatar, width: 40, height: 40, fit: BoxFit.cover,),
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
                                                      ),
                                                  ],
                                              );
                                      }).toList(),
                                  );
                              }
                          },
                      )
                  ),
              ],
          ),
        ): Container();



        return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                    SliverList(delegate: SliverChildListDelegate(
                        [
                            Container(
                                height: deviceHeight * .90,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
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
                                        Container(
                                            color: Colors.red,
                                        height: (deviceHeight * .90) * .08,
                                          child: Center(
                                            child: Text("Transfer Money".toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: themeColor),),
                                          ),
                                        ),
                                        chooseFromContacts,
                                        _Usage,
                                    ],

                                ),
                            ),
                        ]
                    )),


                    SliverAppBar(

                        actions: [
                            IconButton(onPressed: (){
                                print("switch to qr code scanner");
                                _changeView();
                            }, icon: const Icon(Icons.qr_code))
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
                        ),
                    ),

                ],
            ),
        );
    }
}
