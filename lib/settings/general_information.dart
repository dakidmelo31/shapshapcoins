// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, deprecated_member_use, avoid_print, empty_statements, unused_field

import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

class GeneralInformation extends StatefulWidget {
  static const routeName = "/settings/GeneralInformation";
  const GeneralInformation({Key? key}) : super(key: key);

  @override
  _GeneralInformationState createState() => _GeneralInformationState();
}

class _GeneralInformationState extends State<GeneralInformation> {
  static String? whichSheet;

  final formKey = GlobalKey<FormState>();
  String? userID;
  String? name;
  String? username;
  String? email;
  int? balance;
  String? profile;
  String? pin;
  String? oldVal;
  String? avatarPhoto;
  bool network = false;

  setValues(String type, String val) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    prefs.setString(type, val);
    setState(() {
      // Rebuild screen;
    });
  }
  getDetails() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    if(prefs.containsKey("avatarPhoto")){
      avatarPhoto = prefs.getString("avatarPhoto");
    }
    else{
      avatarPhoto = null;
    }
    // name = prefs.containsKey("name")? prefs.getString("name") : "";
    // username = prefs.containsKey("username")? prefs.getString("username") : "";
    // email = prefs.containsKey("email")? prefs.getString("email") : "";

    setState(() {

    });
  }
  _getUserInfo() async{
    User? user = auth.currentUser;
    _firestore.collection("users")
    .doc(user!.uid)
    .snapshots()
    .listen((userData) {
      if(!userData.exists)
        return;

      setState(() {
        userID = userData.data()!['uid'];
        pin = userData.data()!['pin'];
        name = userData.data()!['name'];
        email = userData.data()!['email'];
        username = userData.data()!['username'];
        balance = userData.data()!['balance'];

        if(userData.data()!['profile'] != "avatar.png"){
          if(avatarPhoto == null)
          avatarPhoto = userData.data()!['profile'];
          network  = true;
        }

      });
    });
  }
  Future<void> _setProfilePath(path) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;

    prefs.setString("profile", path);
  }
  _userInfo() async{
    Stream userDocument = _firestore.collection("users").doc(auth.currentUser!.uid).snapshots();

  }
  XFile? image;
  _imageFromGallery() async{
    if(await _getStoragePermission()){
       image = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );

    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("avatarPhoto", image!.path);
    var storageRef = _firebaseStorage.ref().child("user/profile/${auth.currentUser!.uid}").putFile(File(image!.path)).then((p0) => {

      p0.ref.getDownloadURL().then((value) async=> {
        await _setProfilePath(value.toString()),
        print(value.toString() + " is the avatar Photo url"),

        _updateUserInfo("profile", value.toString()),

      setState(() {
          avatarPhoto = value.toString();
      })
      })
    });
  }

  _imageFromCamera() async{
    if(await _getCameraPermission())
      {
        XFile? image = await ImagePicker().pickImage(
            source: ImageSource.camera, imageQuality: 50
        );

      }
    setState(() {

    });
  }


  // profile picture picker
  void _showPicker(context) async{
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Open Gallery"),
              onTap: (){
                _imageFromGallery();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text("Camera"),
              onTap: (){
                _imageFromCamera();
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    });

  }

  Future<bool> _getCameraPermission() async{
    if(await Permission.camera.request().isGranted){
      print("Camera permission granted");
      return true;
    }
    else{
      print("Camera permission not granted");
    }
    return false;
  }
  Future<bool> _getStoragePermission() async{
    if(await Permission.storage.request().isGranted){
      print("permission granted");
      return true;
    }
    else{
      print("permission not granted");
    }
    return false;
  }

  _updateUserInfo(String type, String value) async{
    switch(type){
      case "name":
        name = value;
        break;
      case "email":
        email = value;
        break;
      case "username":
        username = value;
        break;
      case "profile":
        profile = value;
        break;
      default:
        print("didn't get the type listed");
    }

    await _getUserInfo();
    await _firestore.collection("users").doc(auth.currentUser!.uid)
        .set({
      "name": name,
      'phone': auth.currentUser!.phoneNumber,
      'balance': balance,
      'email' : email,
      'username' : username,
      'pin' : pin,
      'profile' : avatarPhoto,
      'updated' : FieldValue.serverTimestamp()
    }, SetOptions(merge: true)).then((value) => {
      print("everything worked out fine, sending the user to pin screen"),
      setState(() {
        network = true;
        Navigator.of(context).popUntil(ModalRoute.withName(GeneralInformation.routeName));
      })
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
      appBar: AppBar(
        title: Text("Profile Information"),
        brightness: Brightness.dark,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 170,
            height: 170,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipOval(
                    child:network? Image.network(avatarPhoto.toString(), width: 170, height: 170, fit: BoxFit.cover,) : avatarPhoto != null? Hero(
                      tag: 'image',
                      child: Image.asset(avatarPhoto.toString(), width: 170, height: 170, fit: BoxFit.cover, ),
                    )  :image == null? Hero(
                      tag: 'image',
                      child: Lottie.asset("assets/avatar-animation.json", width: 170, height: 170, fit: BoxFit.cover,),
                    ) : Hero(
                      tag: "image",
                      child: Image.asset(image!.path.toString()),
                    ),
                  ),
                )
,
                Positioned(
                  top: 135,
                  left: 235,
                  child: IconButton(
                      onPressed: (){
                        _showPicker(context);
                        debugPrint("Open bottomSheet");
                      },
                      icon: Icon(Icons.add_a_photo_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 25)),
                ),

              ],
            ),
          ),
          ListTile(
            onTap: (){
              oldVal = name!;
              _openSheet(name!, "name").then((value){
                if(value != null){
                  setState(() {
                    getDetails();
                  });
                }
              });
             ;
            },
            leading: Icon(Icons.person),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text("Name", style: TextStyle(color: Colors.grey, fontSize: 18),),
            subtitle: Text(name!, style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20, fontWeight: FontWeight.w700),),
            trailing: Icon(Icons.edit_outlined),
          ),
          ListTile(
            onTap: () {
              _openSheet(username!, "username").then((value){
                if(value){
                  setState(() {
                    getDetails();
                  });
                }
              });
            },
            leading: Icon(Icons.alternate_email_outlined),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text("Username", style: TextStyle(color: Colors.grey, fontSize: 18),),
            subtitle: Text(username!, style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18, fontWeight: FontWeight.w700),),
            trailing: Icon(Icons.edit_outlined),
          ),
          ListTile(
            onTap: () {
              _openSheet(email!, "email").then((value){
                if(value){
                  setState(() {
                    getDetails();
                  });
                }
              });
            },
            leading: Icon(Icons.person_add_alt),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text("Email", style: TextStyle(color: Colors.grey, fontSize: 18),),
            subtitle: Text(email!, style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18, fontWeight: FontWeight.w700),),
            trailing: Icon(Icons.edit_outlined),
          ),

        ],
      ),

    );
  }
_openSheet(String initialValue, String type) async{
    String? newValue;
    return await showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Enter your $type"),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "enter $type"
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty)
                        return "Enter valid name";
                      newValue = value;
                      return null;
                    },
                    initialValue: initialValue,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child:Text("Cancel")
              ),
              TextButton(onPressed: (){
                if(formKey.currentState!.validate()){
                  setValue(type, newValue!);
                  Navigator.of(context, rootNavigator: true).pop(true);
                }
                else{
                  print("form is empty");
                }
              }, child:Text("Save")
              ),
            ],
          );
        });
}
setValue(String type, String value) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;
    super.setState(() {
      _updateUserInfo(type, value);
    });
    setState(() {
_getUserInfo();
    });
}

}


