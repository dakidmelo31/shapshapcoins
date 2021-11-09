// ignore_for_file: prefer_const_constructors, prefer_void_to_null, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:shapshapcoins/settings/app_settings.dart';
import 'package:shapshapcoins/signup.dart';

import 'add_name.dart';
import 'push_notifications.dart';
import 'scan_qr_code.dart';
import 'send_money/send_with_qr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_balance_details.dart';
import 'my_contacts.dart';
import 'receive_money/request_money.dart';
import 'send_money/phone_number.dart';
import 'send_money/receive_funds.dart';
import 'security/pin_screen.dart';
import 'send_money/qr_scan_screen.dart';
import 'send_money/send_funds.dart';
import 'send_money/sent_successfully.dart';

import 'startup.dart';
import 'transaction_details.dart';
import 'transaction_history.dart';
import 'package:flutter/services.dart';
import 'add_balance.dart';
import 'main_account.dart';
import 'otp_screen.dart';
import 'security/change_pin.dart';
import 'security/confirm_new_pin.dart';
import 'security/confirm_pin.dart';
import 'security/create_new_pin.dart';
import 'security/create_pin.dart';
import 'security/login_pin.dart';
import 'send_money/enter_amount.dart';
import 'settings/general_information.dart';
import 'settings/security_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> requestPermission() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:  Color.fromRGBO(47, 27, 86, 1),
        systemNavigationBarColor: Color.fromRGBO(47, 27, 86, 1),
      ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot){
      if(snapshot.hasError){
        print("${snapshot.error}");
        return MaterialApp(
          home: Scaffold(
            body: Center(child: Text("Error Loading App")),
          ),
        );

      }
      if(snapshot.connectionState == ConnectionState.done){
        return NavFramework();
      }
      return CircularProgressIndicator.adaptive();
    },
  )
  );

}




class NavFramework extends StatefulWidget {
  const NavFramework({Key? key}) : super(key: key);

  @override
  State createState() {

    return _NavFrameworkState();
  }
}
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class _NavFrameworkState extends State {

  void didChangeAppLifecycleState( AppLifecycleState state){
    setState(() {

    });
  }
  void resetPin() async{
    Future<SharedPreferences> _reset = SharedPreferences.getInstance();
    final hold = await _reset;
    hold.remove("login");
  }
  @override
  Widget build(context) {
    // Build a simple container that switches content based of off the selected navigation item
    requestPermission();


    return MaterialApp(
      locale: const Locale("es", ""),
      title: "ShapShap",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color.fromRGBO(47, 27, 87, 1),
        bottomAppBarColor: Colors.pinkAccent,
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),

        canvasColor: const Color.fromRGBO(0, 0,0, 0.71),
        visualDensity: VisualDensity.comfortable,
        fontFamily: "Raleway",
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        Home.routeName: (context) => const Home(),
        Signup.routeName: (context) => const Signup(),
        RequestMoney.routeName: (context) => const RequestMoney(),
        SentSuccessfully.routeName: (context) => const SentSuccessfully(),
        SendWithQR.routeName: (context) => const SendWithQR(),
        EnterAmount.routeName: (context) => const EnterAmount(),
        JustScan.routeName: (context) => const JustScan(),

        QRScanScreen.routeName: (context) => const QRScanScreen(),
        TransactionHistory.routeName: (context) => TransactionHistory(),
        TransactionDetails.routeName: (context) => TransactionDetails(id: 0),
        AddBalance.routeName: (context) => const AddBalance(),
        AppSettings.routeName: (context) => AppSettings(),
        GeneralInformation.routeName: (context) => const GeneralInformation(),
        SecuritySettings.routeName: (context) => const SecuritySettings(),
        SendFunds.routeName: (context) => const SendFunds(),
        PhoneNumber.routeName: (context) => const SendFunds(),
        ReceiveFunds.routeName: (context) => const ReceiveFunds(),

        PaymentMethod.routeName: (context) => const PaymentMethod(),
        PinScreen.routeName: (context) => const PinScreen(),
        CreatePin.routeName: (context) => const CreatePin(),
        ConfirmPin.routeName: (context) => const ConfirmPin(),
        ChangePin.routeName: (context) => const ChangePin(),
        CreateNewPin.routeName: (context) => const CreateNewPin(),
        ConfirmNewPin.routeName: (context) => const ConfirmNewPin(),
        LoginPin.routeName: (context) => const LoginPin(),
        MyContacts.routeName: (context) => const MyContacts(),
        WithBuilder.routeName: (context) => WithBuilder(),
        AddContact.routeName: (context) => const AddContact(),
        OtpScreen.routeName: (context) => const OtpScreen(),
        AddName.routeName: (context) => const AddName(),

      },
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(0, size.height- 90);
    // path.quadraticBezierTo(0, size.height, 150, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

 @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class Home extends StatefulWidget {
  static const routeName = "/";
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget? _child;

  @override
  void initState() {
      _child = const MainAccount();
      PushNotificationsManager().init();
    super.initState();
    checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _child,
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: Icons.home,
              backgroundColor: const Color.fromRGBO(75, 0, 255, 0.15),
              extras: {"label": "home"}),
          FluidNavBarIcon(
            icon: Icons.notifications,
            extras: {"label": "Send or Receive Funds"}),
          FluidNavBarIcon(
              icon: Icons.add,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,

              backgroundColor: Colors.pink,
              extras: {"label": "Add Funds To Account"}),
          FluidNavBarIcon(
              icon: Icons.history,
              extras: {"label": "transaction history"}),
          FluidNavBarIcon(
              icon: Icons.person,
              extras: {"label": "conference"}),
        ],
        onChange: _handleNavigationChange,
        style: FluidNavBarStyle(
          iconSelectedForegroundColor: const Color.fromRGBO(157, 0, 255, 1.0),
          iconUnselectedForegroundColor: Colors.black.withOpacity(0.26),
          barBackgroundColor: Colors.white,
          iconBackgroundColor: Colors.white,

        ),
        scaleFactor: 5,
        defaultIndex: 0,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras!["label"],
          child: item,
        ),
      ),
    );
  }
  Future<Null> checkIsLogin() async {
    bool _token;
    bool _pin;
    bool _logged_in;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.containsKey("startup");
    _pin   = prefs.containsKey("pin");
    _logged_in = prefs.containsKey("logged_in");
    if (_token) {
      print("Has taken tour already");

      if(_pin){
        print("Pin is set");
        if(_logged_in){
          Navigator.pushNamed(context, MainAccount.routeName);
        }
        else{
          Navigator.pushNamed(context, LoginPin.routeName);
        }
      }
      else{

        print("Checking if user has a pin or not");
        Navigator.pushNamed(
            context,
            Signup.routeName
        );

      }
      //your home page is loaded
    }
    else
    {//User has just opened the app for first time
      print("Show Startup");
      //replace it with the login page
      Navigator.pushNamed(
          context,
          WithBuilder.routeName
      );
    }
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = const MainAccount();
          break;
        case 1:
          _child = const SendFunds();
          break;
        case 2:
          _child = const AddBalance();
          break;
        case 3:
          _child = TransactionHistory();
          break;
        case 4:
          _child = const AppSettings();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeInCirc,
        switchOutCurve: Curves.easeOutBack,
        duration: const Duration(milliseconds: 300),
        child: _child,
      );
    });
  }
}

