// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'security/create_pin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddName extends StatefulWidget {
  static const routeName = "/addName";
  const AddName({Key? key}) : super(key: key);

  @override
  _AddNameState createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedUser;

  void updateUser(String name, String email, String username) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    try{
      final user = auth.currentUser;
      if(user != null){
        print("user exists and user is: " + user.uid +" user number is ${user.phoneNumber}");

        final prefs = await _prefs;
        prefs.setString("name", name);
        prefs.setString("email", email);
        prefs.setString("username", username);

        print("first step passed");

              await firestore.collection("users").doc(auth.currentUser!.uid)
                  .set({
                "name": name,
                'phone': user.phoneNumber,
                'balance': 0,
                'email' : email,
                'username' : username,
              }, SetOptions(merge: true)).then((value) => {
                print("everything worked out fine, sending the user to pin screen"),
                Navigator.pushNamed(context, CreatePin.routeName)
              });
    }
    }
      catch(e) {
      print(e);
    }

}
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  String phone = "";

  @override
  void dispose(){
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    CollectionReference users =FirebaseFirestore.instance.collection("users");
    Color themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: themeColor,
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeColor,
                  image: const DecorationImage(
                      image: AssetImage("assets/people11.jpg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                      repeat: ImageRepeat.noRepeat
                  ),

                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height ,
                decoration: BoxDecoration(
                  color: themeColor,
                  gradient: LinearGradient(
                      end: Alignment.topRight,
                      begin: Alignment.bottomCenter,
                      colors: [themeColor, themeColor.withOpacity(0.86),  themeColor.withOpacity(0), ]
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 90,),
                          child:   Text(
                            "Almost There...", style: TextStyle(color: Colors.white, fontSize: 25),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 60, right: 45),
                          child:   Text(
                            "It's about time we know your name", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w300),),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width -80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Hero(
                              tag: "otp",
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      hintText: "Enter your Name",
                                      hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                      ),
                                      focusColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                      ),
                                      contentPadding: const EdgeInsets.only(left: 20, top: 15),
                                      prefixIcon: const Icon(Icons.person, color: Colors.yellow,)
                                  ),
                                  validator: (value) {
                                    if( value == null || value.isEmpty){
                                      return "Please Enter a valid name";
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                    hintText: "Enter Username (optional)",
                                    hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                    ),
                                    contentPadding: const EdgeInsets.only(left: 20, top: 15),
                                    prefixIcon: const Icon(Icons.person_add_alt, color: Colors.redAccent,)
                                ),
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    hintText: "Email Address (also optional)",
                                    hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.2),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                    ),
                                    focusColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(width: 2, color: Colors.transparent),
                                    ),
                                    contentPadding: const EdgeInsets.only(left: 20, top: 15),
                                    prefixIcon: const Icon(Icons.email, color: Colors.lightGreen,)
                                ),
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width -80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),

                          Hero(
                            tag: "btn",
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                              child: InkWell(
                                onTap: (){
                                  if(_formKey.currentState!.validate()){
                                    if(usernameController.text.isEmpty){
                                      usernameController.text = "";
                                    }
                                    updateUser(nameController.text, emailController.text, usernameController.text);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Next", style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              elevation: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),

              )
            ],
          )
        ],
      ),
    );
  }
}
