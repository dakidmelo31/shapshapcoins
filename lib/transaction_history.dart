import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shapshapcoins/history_model.dart';
import 'package:shapshapcoins/transaction_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class TransactionHistory extends StatefulWidget {
  static const routeName = "/transactionHistory";
  TransactionHistory({Key? key}) : super(key: key);
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {

  int display = 1;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    display = 1;
  }
  int payouts = 0;
  int received= 0;
  bool pendingTransactions = true, failedTransactions = true, successfulTransactions = true, cancelledTransactions = true;

Future<void> setSelected(int id) async{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final prefs = await _prefs;
  prefs.setInt("selectedID", id);
  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetails(id: id)));
}
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: const Color.fromRGBO(47, 27, 86, 1),
              actions: <Widget>[
                IconButton(
                  onPressed: (){
                    setState(() {
                      if(display == 0){
                        display = 1;
                      }
                      else{
                        display = 0;
                      }

                    });
                    print(display);
                  },
                  icon: const Icon(Icons.filter_alt_rounded),
                  iconSize: 22,
                )
              ],
              expandedHeight: 190,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("All Transactions", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
                background: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child:Image.asset("assets/gradient1.jpg", fit: BoxFit.cover,) ,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  color: Colors.amberAccent,
                                  elevation: 30,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child:Text("Payouts".toUpperCase(), style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                                  child:Text(payouts.toString() + " F", style: TextStyle(fontSize: 14, color: Colors.white),),
                                ),
                              ]
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                Card(
                                  color: Colors.greenAccent,
                                  elevation: 30,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child:Text("Received".toUpperCase(), style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                                  child:Text(received.toString() + " F", style: TextStyle(fontSize: 14, color: Colors.white),),
                                ),
                              ]
                          ),

                        ],
                      ),
                    )
                ]
                ),
              ),
              pinned: true,
              floating: true,
            ),
            SliverList(delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<List<HistoryItem>>(
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
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
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
                            if(true){
                              payouts += 257;
                            }
                            if(true){
                              received += 593;
                            }

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
                                        setSelected(tx.id!);
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
                ]
            )
            )
          ]
      ),
      bottomSheet: display == 0? BottomSheetWidget(title: "Filter Transactions", onClickedConfirm: (){
        setState(() {
          display = 1;
        });
      }, onClickedClose: (){
        setState(() {
          display = 1;
        });

      },
      ): null,
    );
}
}

class BottomSheetWidget extends StatefulWidget {
  final String title;
  final VoidCallback onClickedConfirm;
  final VoidCallback onClickedClose;

  const BottomSheetWidget({Key? key,
  required this.title,
  required this.onClickedConfirm,
  required this.onClickedClose}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  bool pendingTransactions = true, failedTransactions = true, successfulTransactions = true, cancelledTransactions = true;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth  = MediaQuery.of(context).size.width;
    return Container(
      foregroundDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0)
      ),
      height: deviceHeight,
      width: deviceWidth,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          Text("Filter Transactions", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white,)),
          SizedBox(
            height: 120,
          ),
          SwitchListTile(
            title: Text("Successful Transactions", style: TextStyle(color: Colors.white),),
            selectedTileColor: Color.fromRGBO(75, 0, 255, 1),
            value: successfulTransactions,
            dense: false,
            activeColor: Colors.lightGreen,
            onChanged: null,
            secondary: Icon(Icons.check, color: Colors.blue,),
          ),
          SwitchListTile(
            title: Text("Pending Transactions", style: TextStyle(color: Colors.white),),
            selectedTileColor: Color.fromRGBO(75, 0, 255, 1),
            value: pendingTransactions,
            dense: false,
            activeColor: Colors.lightGreen,
            onChanged: null,
            secondary: const Icon(Icons.refresh, color: Colors.deepOrangeAccent,),
            
          ),
          SwitchListTile(
            title: const Text("Failed Transactions", style: TextStyle(color: Colors.white),),
            selectedTileColor: Color.fromRGBO(75, 0, 255, 1),
            value: failedTransactions,
            dense: false,
            activeColor: Colors.lightGreen,
            onChanged: null,
            secondary: Icon(Icons.close, color: Colors.red,),
          ),
          SwitchListTile(
            title: Text("Cancelled Transactions", style: TextStyle(color: Colors.white),),
            selectedTileColor: Colors.lightGreen,
            value: cancelledTransactions,
            dense: false,
            activeColor: Colors.lightGreen,
            onChanged: null,
            secondary: Icon(Icons.restore_from_trash, color: Colors.red,),
          ),

          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton.icon(
                onPressed: widget.onClickedClose,
                icon: Icon(Icons.close),
                label: Text("Close Filter", style: TextStyle(color: Colors.deepOrange),),),
              ElevatedButton.icon(
                onPressed: widget.onClickedClose,
                icon: Icon(Icons.check, color: Colors.blue, size: 25,),
                label: Text("Apply Filter"),
              ),
            ],
          )

        ],
      ),
    );
  }
void  updateUI(String type) {
    switch(type){
      case "pending":
        pendingTransactions = !pendingTransactions;
        break;
      case "cancelled":
        cancelledTransactions = !cancelledTransactions;
        break;
      case "failed":
        failedTransactions = !failedTransactions;
        break;
      case "successful":
        successfulTransactions = !successfulTransactions;
        break;
    }
  }
}
