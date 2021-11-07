// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
class Group extends StatelessWidget {
  const Group({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        color: Colors.white,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
        elevation: 20,
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: InkWell(
            onTap: (){},
            splashColor: Colors.black.withOpacity(.02),
            focusColor: Colors.purple,
            highlightColor: Colors.deepPurple.withOpacity(0.01),
            radius: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                  child: Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            print("tapped notification Bell");
                          },
                          child: Icon(Icons.notifications_outlined, color: Colors.purple ),
                        ),
                        Text("3", style: TextStyle(fontSize: 10,color: Colors.red),),
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.asset("assets/nice.jpg", width: 150, fit: BoxFit.contain,),
                  ),
                ),

                Text("Dakid Melo", style: TextStyle(fontSize: 30, color: Color.fromRGBO(200, 200, 200, 1)),),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text("My Balance", style: TextStyle(fontSize: 20, color: Color.fromRGBO(75, 0, 255, 1), fontWeight: FontWeight.w700),),
                Padding(padding: EdgeInsets.only(top: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Hero(
                      tag: "balance",
                      child: Text("32,900 ", style: TextStyle(fontSize: 20, color: Colors.black),),
                    ),
                    Text("F", style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, .21), fontWeight: FontWeight.bold),),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
