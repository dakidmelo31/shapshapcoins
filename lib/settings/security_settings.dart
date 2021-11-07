// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shapshapcoins/security/change_pin.dart';

class SecuritySettings extends StatefulWidget {
  static const routeName = "/settings/SecuritySettings";
  const SecuritySettings({Key? key}) : super(key: key);

  @override
  _SecuritySettingsState createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Settings"),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 50,
          ),
          ListTile(
            onTap: (){
              Navigator.pushNamed(context, ChangePin.routeName);

            },
            leading: Icon(Icons.person),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text("Pin", style: TextStyle(color: Colors.black, fontSize: 20),),
            subtitle: Text("Change current pin", style: TextStyle(color: Colors.grey, fontSize: 18),),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.phone),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text("Phone Number", style: TextStyle(color: Colors.black, fontSize: 20),),
            subtitle: Text("Change Phone number", style: TextStyle(color: Colors.grey, fontSize: 18),),
            trailing: Icon(Icons.phone),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.password),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            title: Text("Password", style: TextStyle(color: Colors.black, fontSize: 20),),
            subtitle: Text("Change your Password", style: TextStyle(color: Colors.grey, fontSize: 18),),
            trailing: Icon(Icons.chevron_right),
          ),

        ],
      ),
    );
  }
}
