// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AppSettings extends StatefulWidget {
  static const routeName = "/settings";
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _AppSettingsState extends State<AppSettings> {
  String? name, phone, avatarPhoto;

//Get Profile Path
  Future<File> file(String filename) async{
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = join(dir.path, filename);
    return File(pathName);
  }
  //profile picture
  var myProfile;
  setProfile() async{
    myProfile = await file("assets/people3.jpg");
  }

  _getUserInfo() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    if( !prefs.containsKey("avatarPhoto")){
      avatarPhoto = null;
    }
    User? user = auth.currentUser;
    _firestore.collection("users")
        .doc(user!.uid)
        .snapshots()
        .listen((userData) {
      if(!userData.exists)
        return;

      setState(() {
        phone = userData.data()!['email'];
        name = userData.data()!['username'];

        if(userData.data()!['profile'] != "avatar.png"){
          avatarPhoto = userData.data()!['profile'];
        }

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 30,
            expandedHeight: 200,
            floating: true,
            pinned: true,
            title: Text(""),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.add_a_photo_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.share)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: "image",
                child: Image(
                  image: NetworkToFileImage(
                    file: myProfile,
                    url: avatarPhoto != null? avatarPhoto.toString() : "https://firebasestorage.googleapis.com/v0/b/shapshapcoins.appspot.com/o/user%2Fprofile%2Fyy0sBlQ1VXaEZC8tor2YhWEIESg2?alt=media&token=805713aa-42de-4148-82fb-93730527c5cc",
                    debug: true
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,

                ),
              ),
              title: Text("650-981-130"),
            ),
          ),
          SliverList(delegate:
          SliverChildListDelegate(
            [
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("General Information", style: TextStyle(color: Colors.black),),
                subtitle: Text("Change name, email, username", style: TextStyle(fontSize: 14),),
                trailing: Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.pushNamed(context, "/settings/GeneralInformation");
                },
                enabled: true,
                contentPadding: EdgeInsets.all(15),
              ),
              ListTile(
                leading: Icon(Icons.verified_user_outlined),
                title: Text("Security settings", style: TextStyle(color: Colors.black, fontSize: 18),),
                subtitle: Text("change password, Pin, phone number", style: TextStyle(fontSize: 14),),
                trailing: Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.pushNamed(context, "/settings/SecuritySettings");
                },
                enabled: true,
                contentPadding: EdgeInsets.all(15),
              ),
              ListTile(
                hoverColor: Theme.of(context).primaryColor,
                leading: Icon(Icons.history),
                title: Text("Archived Transactions", style: TextStyle(color: Colors.black, fontSize: 18),),
                subtitle: Text("See all your archived transactions", style: TextStyle(fontSize: 14),),
                trailing: Icon(Icons.chevron_right),
                onTap: (){},
                enabled: true,
                contentPadding: EdgeInsets.all(15),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text("Help", style: TextStyle(color: Colors.black, fontSize: 18),),
                subtitle: Text("Help Center, Contact us, Privacy policy", style: TextStyle(fontSize: 14),),
                trailing: Icon(Icons.chevron_right),
                onTap: (){},
                enabled: true,
                contentPadding: EdgeInsets.all(15),
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner_outlined, color: Colors.grey,),
                title: Text("Share App", style: TextStyle(color: Theme.of(context).primaryColor),),
                trailing: Icon(Icons.add, color: Colors.grey,),
                onTap: (){},
                enabled: true,
                contentPadding: EdgeInsets.all(15),
              ),
              TextButton(onPressed: (){
                showAboutDialog(context: context,
                applicationIcon: Image.asset("assets/logo.png"),
                  applicationName: "ShapShap",
                  applicationVersion:"1.0",

                );
              },
                  child: Text("More about us")
              ),
              SizedBox(
                height: 70,
              ),

            ]
          ))
        ],
      ),
    );
  }
}
