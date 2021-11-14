// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class MyImageCache extends ImageCache{
  @override
  void clear(){
    print("clearing cache");
    super.clear();
  }
}
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
  String? name, phone;

  @override
  ImageCache createImageCache() => MyImageCache();

  Widget avatarPhoto = CircularProgressIndicator.adaptive();
  XFile? image;
  Dio dio = Dio();
  bool loading = false;
  _checkProfile() async{
    final prefs = await SharedPreferences.getInstance();
    if( prefs.containsKey("avatarPhoto")){
      final picPath = prefs.getString("avatarPhoto");
      print("Your avatar path is $avatarPhoto");
      PaintingBinding.instance!.imageCache!.clear();
      setState(() {
        avatarPhoto = Image.file(File(picPath!), fit: BoxFit.cover, width: 40, height: 40, alignment: Alignment.topCenter, filterQuality: FilterQuality.high, colorBlendMode: BlendMode.lighten,);
      });    }
    else{
      downloadPicture('https://firebasestorage.googleapis.com/v0/b/shapshapcoins.appspot.com/o/kid-geb536f5ae_640.png?alt=media&token=da3aeaee-a4dc-4ff8-a07d-29f3b9b7cc55');
    }

  }

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
          });

        }).then((value) {
          setState(() {
            debugPrint("show user profile path " + saveImg.path);
            avatarPhoto = Image.file(File(saveImg.path), fit: BoxFit.cover, width: 40, height: 40,);
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



  _getUserInfo() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final prefs = await _prefs;

    User? user = auth.currentUser;
    _firestore.collection("users")
        .doc(user!.uid)
        .snapshots()
        .listen((userData) {
      if(!userData.exists)
        return;

      setState(() {
        phone = userData.data()!['phone'];
        name = userData.data()!['name'];

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkProfile();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 20,
            snap: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.pink,
            ),
            automaticallyImplyLeading: true,
            backwardsCompatibility: true,
            centerTitle: true,
            stretch: true,
            excludeHeaderSemantics: true,
            stretchTriggerOffset: 50,
            expandedHeight: 250,
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
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    avatarPhoto as Widget,
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.6),
                            Theme.of(context).primaryColor.withOpacity(0.9)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      ),
                    )
                  ],
                ),
              ),
              title: Text(phone.toString()),
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
