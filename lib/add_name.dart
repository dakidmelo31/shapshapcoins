// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late User loggedUser;
  double downloaded = 0;
  double totalSize = 0;


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
        if(prefs.containsKey("avatarPhoto")){
          final picPath = prefs.getString("avatarPhoto");
          if(await File(picPath!).exists()){
            debugPrint("user has set image");
          }
          else{
            debugPrint("User has not set image and so we have to set ours");
            downloadPicture("https://firebasestorage.googleapis.com/v0/b/shapshapcoins.appspot.com/o/kid-geb536f5ae_640.png?alt=media&token=da3aeaee-a4dc-4ff8-a07d-29f3b9b7cc55");
            photoURL = 'https://firebasestorage.googleapis.com/v0/b/shapshapcoins.appspot.com/o/kid-geb536f5ae_640.png?alt=media&token=da3aeaee-a4dc-4ff8-a07d-29f3b9b7cc55';
          }
        }

        print("first step passed");

              await _firestore.collection("users").doc(auth.currentUser!.uid)
                  .set({
                "name": name,
                'phone': user.phoneNumber,
                'balance': 0,
                'email' : email,
                'username' : username,
                'profile' : photoURL,
              }, SetOptions(merge: true)).then((value) => {
                print("everything worked out fine, sending the user to pin screen"),
              }).then((value) => {
                Navigator.pushNamed(context, CreatePin.routeName),
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
  String? avatarPhoto;
  final Dio dio = Dio();





  Future<void> _setProfilePath(path) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;

    prefs.setString("profile", path);
  }
  _userInfo() async{
    Stream userDocument = _firestore.collection("users").doc(auth.currentUser!.uid).snapshots();

  }
  XFile? image;

  bool loading = false;

  Future<bool> saveLocally(String url, String filename) async{
    Directory? dir;
    try{
      if(Platform.isAndroid){
        if( await Permission.storage.isGranted){
          dir = await getExternalStorageDirectory();
          debugPrint("directory path is: " + dir!.path);
          String newPath = "";
          int? tmp;
          newPath = dir.path.split("/Android")[0];
          newPath = newPath + "/ShapshapCoins";
          dir = Directory(newPath);
          debugPrint(dir.path);

        }

      }
      else{
        if(await Permission.photos.isGranted){
          dir = await getTemporaryDirectory();
        }

      }
      if(!await dir!.exists()){
        await dir.create(recursive: true);
      }
      if(await dir.exists()){
        debugPrint("reached this place");
        File saveImg = File(dir.path +"/$filename");
        final prefs = await SharedPreferences.getInstance();
        await dio.download(url, saveImg.path, onReceiveProgress: (currentSize, totalSize){
          setState(() {
            prefs.setString("avatarPhoto", saveImg.path);
            debugPrint("avatar photo location saved to shared preferences");
                downloaded = currentSize / totalSize;
          });

        }).then((value) {
          setState(() {
            debugPrint("show user profile path " + saveImg.path);
            profilePic = Image.file(File(saveImg.path), fit: BoxFit.cover, width: 170, height: 170,);
          });

        });
        if(Platform.isIOS){
          await ImageGallerySaver.saveFile(saveImg.path, isReturnPathOfIOS: true);
        }
        return true;
      }


    } catch(e){
      print("error met: " + e.toString());
    }

    return false;
  }

  downloadPicture(String url) async{
    setState(() {
      loading = true;
    });

    bool downloaded = await saveLocally(url, "avatar.png");
    if(downloaded){
      debugPrint("profile downloaded successfully");
    }
    else{
      debugPrint("Error met downloading the file");
    }
    setState(() {
      loading = false;
    });

  }
  String? photoURL;
  _imageFromGallery() async{
    if(await _getStoragePermission()){
      image = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 40
      );
    }
    setState(() {
      profilePic = CircularProgressIndicator.adaptive(strokeWidth: 6, backgroundColor: Colors.amber, value: downloaded, );
    });
    var storageRef = _firebaseStorage.ref().child("user/profile/${auth.currentUser!.uid}").putFile(File(image!.path)).then((p0) => {

      p0.ref.getDownloadURL().then((value) async=> {
        await _setProfilePath(value.toString()),
        print(value.toString() + " is the avatar Photo url"),
        downloadPicture(value),
        photoURL = value,
    setState(() {
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
Widget profilePic  = const Icon(Icons.add_photo_alternate, color: Colors.grey, size: 44,);

@override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    CollectionReference users =FirebaseFirestore.instance.collection("users");
    Color themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: themeColor,
      body: ListView(
        physics: ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            height: deviceHeight,
            width: deviceWidth,
            child: Stack(
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
                  height: deviceHeight,
                  width: deviceWidth,
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
                  height: deviceHeight,
                  width: deviceWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: deviceHeight * .2,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  "Almost There...", style: TextStyle(color: Colors.white, fontSize: 35),),
                                Text(
                                  "Add your face and a name to your account", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, fontWeight: FontWeight.w300),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * .2,
                        width: deviceWidth,
                        child:Stack(
                          fit: StackFit.expand,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipOval(
                                child: Container(
                                    color: Colors.white,
                                    width: deviceHeight * .18,
                                    height: deviceHeight * .18,
                                    child: InkWell(
                                      onTap: (){
                                        print("show this");
                                        _imageFromGallery();
                                      },
                                        splashColor: themeColor.withOpacity(0.5),
                                        child: profilePic)),
                              ),
                            ),
                            loading?Align(
                              alignment: Alignment.bottomCenter,
                              child: LinearProgressIndicator(value: downloaded, minHeight: 10, ),
                            ): SizedBox(height: 0, width: 0)
                          ],
                        )
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
            ),
          )
        ],
      ),
    );
  }
}
