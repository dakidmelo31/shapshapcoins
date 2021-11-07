// ignore_for_file: prefer_const_constructors, unused_local_variable, duplicate_ignore

import 'add_balance_details.dart';
import 'package:flutter/material.dart';



class AddBalance extends StatelessWidget {
  static const routeName = "/addBalance";

  const AddBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: const Color.fromRGBO(150, 150, 150, 1));
    TextStyle headingStyle = const TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color.fromRGBO(47, 27, 87, 1));
    // ignore: unused_local_variable
    double deviceHeight= MediaQuery.of(context).size.height;
    Color themeColor = Color.fromRGBO(47, 27, 86, 1);

    return  Scaffold(
      body: ListView(
        children: [
          ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              width: double.infinity,
              height: 320,
              color: themeColor,
              child: Column(
                children: const [
                  SizedBox(
                    height: 80,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text("6,500 F", style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 20),),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 35,
            child: Align(
              alignment: Alignment.center,
              child: Text("Choose Recharge Option", style: headingStyle,),
            ) ,
          ),
          GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: List.generate(2, (index) {
                return Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 150,
                  child: index == 1? TextButton(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset("assets/orange.png", height: 65, fit: BoxFit.contain),
                      Text("MTN MoMo", style: TextStyle(color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.w700),),
                    ],
                  ), onPressed: (){

                    Navigator.pushNamed(
                      context,
                      PaymentMethod.routeName,
                      arguments: PaymentSelected("orange")
                    );
                  },) : TextButton(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Hero(
                        tag: "pic",
                        child: Image.asset("assets/mtn.jpg", height: 65, fit: BoxFit.contain),
                      ),
                      Text("MTN MoMo", style: TextStyle(color: Colors.amberAccent, fontSize: 20, fontWeight: FontWeight.w700),),
                    ],
                  ), onPressed: (){
                    Navigator.pushNamed(
                        context,
                        PaymentMethod.routeName,
                        arguments: PaymentSelected("mtn")
                    );
                  },),
                );
              }),
          ),

        ],
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    var path = Path();
    path.lineTo(0, 200);
    path.quadraticBezierTo(100, 50, size.width,  300);
    path.lineTo(size.width * 1, size.height - 70);
    path.lineTo(size.width , 200);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
class PaymentSelected {
  final String name;
  PaymentSelected(this.name);
}