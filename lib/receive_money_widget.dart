// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
class WithQRCode extends StatefulWidget {
  const WithQRCode({Key? key}) : super(key: key);

  @override
  _WithQRCodeState createState() => _WithQRCodeState();
}

class _WithQRCodeState extends State<WithQRCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 25, bottom: 25),
            ),
            Text("Receive Money With QR Code", style: TextStyle(color: Color.fromRGBO(75, 0, 255, 1), fontWeight: FontWeight.w700, fontSize: 22),),
            Container(
              height: 300,
              child: BarcodeWidget(
                data: "{name:'Dakid Melo',number:'650981130',amount:'500'",
                barcode: Barcode.qrCode(),
                color: Colors.black,
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.lightGreen,),
                Text("Show this qr code to sender."),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Problem with your qr code? call support", style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),),
                TextButton(onPressed: (){}, child: Text("Here",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(75, 0, 255, 1),
                    fontWeight: FontWeight.w700
                  ),
                ),
                ),

              ],
            )


          ],
        ),
    );
  }
}
