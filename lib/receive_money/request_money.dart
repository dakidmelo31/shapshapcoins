// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_element, non_constant_identifier_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../history_model.dart';
import '../send_money_model.dart';
import 'receive_money_model.dart';

class RequestMoney extends StatefulWidget {
    static const routeName = "/requestMoney";

    const RequestMoney({Key? key}) : super(key: key);

    @override
    _RequestMoneyState createState() => _RequestMoneyState();
}

class _RequestMoneyState extends State<RequestMoney> {
    int switchUsage = 0;
    Widget _Usage = RequestMoneyForm();


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
                    child: ShowCode(),
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

    @override
    Widget build(BuildContext context) {

        double deviceHeight= MediaQuery.of(context).size.height;
        Color themeColor = const Color.fromRGBO(47, 27, 86, 1);
        return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: CustomScrollView(
                slivers: [
                    SliverList(delegate: SliverChildListDelegate(
                        [
                            Container(
                                padding: const  EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
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
                                        _Usage,
                                        Padding(
                                            padding: EdgeInsets.only( top: 36),
                                        ),
                                        SizedBox(
                                            height: 15,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Text("Sender should scan this code", style: TextStyle(color: Colors.red, fontSize: 15)),
                                        ),
                                        TextLiquidFill(
                                            text: "Alternatively",
                                            waveColor: Colors.pink,
                                            boxBackgroundColor: Colors.white,
                                            textStyle: TextStyle(
                                                fontSize: 41.0,
                                                fontWeight: FontWeight.bold,
                                            ),
                                            boxHeight: 100.0,
                                        ),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                                const Padding(
                                                    padding: EdgeInsets.only(left: 15),
                                                    child: Text("Choose from your contacts", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                                                ),

                                                Padding(
                                                    padding: const  EdgeInsets.only(right: 15),
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
                                                                                ],
                                                                            );
                                                                    }).toList(),
                                                                );
                                                            }
                                                        },
                                                    )
                                                ),
                                            ),
                                        ),
                                        const SizedBox(
                                            height: 100,
                                        )

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
