import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'contact_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class MyContacts extends StatefulWidget {
    static const routeName = "/my_contacts";
    const MyContacts({Key? key}) : super(key: key);

    @override
    _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
    SlidableController slidableController = SlidableController();
    @override
    void initState() {
        // TODO: implement initState
        slidableController = SlidableController(
            onSlideAnimationChanged: handleSlideAnimationChanged,
            onSlideIsOpenChanged: handleSlideIsOpenChanged,
        );
        super.initState();
    }
    Animation<double>? _rotationAnimation;
    Color _fabColor = Colors.blue;

    void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
        setState(() {
            _rotationAnimation = slideAnimation;
        });
    }
    void handleSlideIsOpenChanged(bool? isOpen) {
        setState(() {
            _fabColor = isOpen! ? Colors.green : Colors.blue;
        });
    }

    @override
    Widget build(BuildContext context) {
        TextStyle textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color.fromRGBO(150, 150, 150, 1));
        TextStyle textStyleLight = TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white);
        TextStyle headingStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Color.fromRGBO(47, 27, 87, 1));
        double deviceWidth = MediaQuery.of(context).size.width;
        double deviceHeight= MediaQuery.of(context).size.height;
        Color themeColor = Color.fromRGBO(47, 27, 86, 1);
        return Scaffold(
            appBar: AppBar(
                title: Text("All Saved Contacts"),
                elevation: 10,
                backgroundColor: Color.fromRGBO(47, 27, 86, 1),
                brightness: Brightness.dark,
            ),
            body: ListView(
                children: [

                    const SizedBox(
                        height: 15,
                    ),
                    FutureBuilder<List<ContactModel>>(
                        future: DatabaseHelper.instance.getContacts(),
                        builder: (BuildContext context, AsyncSnapshot<List<ContactModel>> snapshot) {
                            if(!snapshot.hasData){
                                return Center(child: Padding(
                                    padding: EdgeInsets.only(top: 108),
                                    child: Lottie.asset("assets/search2.json",  height: 350, fit: BoxFit.contain,),
                                ),);
                            }
                            else{
                                return snapshot.data!.isEmpty? Center( child: Padding(
                                    padding: EdgeInsets.only(top: 108),
                                    child:  Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Text("No transactions yet", style: TextStyle(color: Colors.grey.withOpacity(0.7))),
                                            Lottie.asset("assets/nothing1.json", height: 350, fit: BoxFit.contain,),

                                        ],
                                    ),
                                ),) :
                                ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: snapshot.data!.map((tx) {

                                        return
                                            Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                    Slidable(
                                                        child: Text("Show This"),
                                                        actionPane: Text("Another Widget Here")
                                                    )
                                                ],
                                            );
                                    }).toList(),
                                );
                            }
                        },
                    )

                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    Navigator.pushNamed(context, AddContact.routeName).then((value) => {
                        setState(() {

                        })
                    });
                },
                elevation: 16,
                splashColor: themeColor,
                isExtended: true,
                tooltip: "Add new contact",
                child: Icon(Icons.person_add),
                backgroundColor: themeColor,
                heroTag: "heading",
            ),
        );
    }
}

class AddContact extends StatefulWidget {
    static const routeName = "/addContact";
    const AddContact({Key? key}) : super(key: key);

    @override
    _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
    final formKey = GlobalKey<FormState>();
    int? phone;
    String? username;
    String? name;
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar:AppBar(
                title: Hero(
                    tag: "heading",
                    child: Text("Add Contact"),
                ),
                brightness: Brightness.dark,
            ),
            body: Center(
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            SizedBox(
                                height: 75,
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Name or nickname",
                                        prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value){
                                        if(value == null || value.isEmpty)
                                            return "Enter a name or nickname";
                                        username = value;
                                        return null;
                                    },
                                ),
                            ),
                            SizedBox(
                                height: 75,
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextFormField(
                                    decoration:const InputDecoration(
                                        hintText: "Phone number",
                                        prefixIcon: Icon(Icons.phone),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    validator: (value){
                                        if(value == null || value.isEmpty || int.parse(value) < 599999999 || int.parse(value) > 700000000)
                                            return "Enter a valid number";
                                        phone = int.parse(value);
                                        return null;
                                    },
                                ),
                            ),
                            SizedBox(
                                height: 100,
                                width: double.infinity,
                            ),
                            SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width - 20,
                                child: Center(
                                    child: TextButton(child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        child: Text("Save Contact"),
                                    ),
                                        onPressed: () async{
                                            if(formKey.currentState!.validate()){
                                                await DatabaseHelper.instance.add(ContactModel(
                                                    phone: phone.toString(),
                                                    name: username!,
                                                    profile: "assets/people1.jpg",
                                                    imageSet: "true",
                                                )
                                                );
                                                print("username is $username and number is $phone");
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: const Text("Contact added successfully"), backgroundColor: Theme.of(context).primaryColor,)
                                                );
                                                Future.delayed( const Duration(seconds: 3)).then((value) => {
                                                    Navigator.pop(context, true)
                                                });
                                            }
                                        },),
                                ),
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}
