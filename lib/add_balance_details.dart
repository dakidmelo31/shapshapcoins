// ignore_for_file: deprecated_member_use, prefer_const_constructors, unnecessary_new

import 'add_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class PaymentMethod extends StatefulWidget {
  static const routeName = "/addBalance/paymentMethodDetails/";
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final selected = ModalRoute.of(context)!.settings.arguments as PaymentSelected;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.dark,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            elevation: 20,
            expandedHeight: 180,
            pinned: true,
            floating: true,
            backgroundColor: selected.name == "mtn"? Colors.amber : Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: "pic",
                child: Image.asset(selected.name == "mtn"? "assets/mtn-bg.jpg" : "assets/orange-bg.jpg", fit: BoxFit.cover, width: double.infinity,),
                transitionOnUserGestures: true,
              ),
              title: Text(selected.name, style: TextStyle(color: selected.name == "mtn"? Colors.white : Colors.white),),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(
            [
              const SizedBox(
                height: 100,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width  - 60,
                      child: Material(
                        animationDuration: const Duration(milliseconds: 1000),
                        elevation: 20,
                        shadowColor: Colors.black12,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              enabledBorder: InputBorder.none,
                              prefixIcon:Icon(Icons.phone),
                              filled: true,
                              hintText: "Recharge amount",
                              hintStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 17, letterSpacing: 5)
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return "Please enter your recharge amount";
                            }
                            else{
                              if(int.parse(value) < 100){
                                return "minimum amount is 105 F";
                              }
                              else{
                                showDialog(context: context, builder: (context)=> const Dialog(
                                  child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                                        child: Text("Complete the cash in by dialing *126# and entering your mobile pin"),
                                      ),
                                  ),
                                  elevation: 30,
                                ));
                                return null;

                              }
                            }
                          },
                        ),
                        color: Colors.white.withOpacity(0),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      elevation: 15,
                      color: Color.fromRGBO(75, 0, 255, 1),
                      shadowColor: Colors.black.withOpacity(0.5),

                      child: InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Waiting for your confirmation"),
                                elevation: 20,
                                backgroundColor: Color.fromRGBO(75, 0, 255, 0.51),
                                padding: EdgeInsets.all(20),
                                )
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Confirm", style: TextStyle(fontSize: 20, color: Colors.white),),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                              ),
                              Transform(
                                alignment: FractionalOffset.center,
                                transform: new Matrix4.identity()..rotateZ(-20 * 3.1415 / 180),
                                child: Icon(Icons.send, color: Colors.white, size: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )

            ]
          ))
        ],
      ),
    );
  }
}
