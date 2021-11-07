import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Class to hold data for itembuilder in Withbuilder app.
class ItemData {
  final Color color;
  final String image;
  final String text1;
  final String text2;
  final String text3;
  bool   condition = false;

  ItemData(this.color, this.image, this.text1, this.text2, this.text3, this.condition);
}

/// Example of LiquidSwipe with itemBuilder
class WithBuilder extends StatefulWidget {
  static const routeName = "/mainAccount/startup";
  @override
  _WithBuilder createState() => _WithBuilder();
}

class _WithBuilder extends State<WithBuilder> {

  void sharedPrefsInit() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("startup", true);
  }
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;
  List<ItemData> data = [
    ItemData(Colors.black, "assets/animation1.json", "Super", "Fast", "Payments", true),
    ItemData(Colors.green, "assets/ecommerce.json", "Work", "More", "Efficiently!", false),
    ItemData(Colors.pink, "assets/qrcode.json", "Seamless", "Swift", "Transfer", false),
    ItemData(Colors.amber, "assets/reload.json", "Reload", "Within", "Minutes", false),
    ItemData(Colors.red, "assets/checked.json", "Let's", "", "Go", true),
  ];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();

  }
  Widget  images(String image, bool condition){
    if(true){
      return Lottie.asset(
        image,
        height: 100,
        fit: BoxFit.contain,
      );
    }
    // else{
    //   return Image.asset(
    //     image,
    //     height: 400,
    //     fit: BoxFit.contain
    //   );
    // }
  }
  Widget texts(bool condition, String text1, String text2, String text3){
    if(!condition){
      return Column(

          children: [
            Text(
              text1,
              style: style,
            ),
            Text(
              text2,
              style: style,
            ),
            Text(
              text3,
              style: style,
            ),

          ]
      );
    }
    else{
      return Column(

          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            Text(
              text3,
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),

          ]
      );

    }
  }
  Widget _buildDot(int index) {
    if(page == null){
      page = 0;
    }
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  color: data[index].color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      images(data[index].image, data[index].condition),
                      texts(data[index].condition, data[index].text1, data[index].text2, data[index].text3)
                    ],
                  ),
                );
              },
              positionSlideIcon: 0.8,
              slideIconWidget: Icon(Icons.chevron_right_sharp),
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              fullTransitionValue: 880,
              enableSideReveal: false,
              enableLoop: false,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(data.length, _buildDot),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    liquidController.animateToPage(
                        page: data.length - 1, duration: 700);
                  },
                  child: Text("Skip"),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    if(page >=4){
                      sharedPrefsInit();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Signup()));
                    }
                    else{
                      liquidController.jumpToPage(
                          page: liquidController.currentPage + 1 > data.length - 1
                              ? 0
                              : liquidController.currentPage + 1);

                    }

                  },
                  child: Text("Next"),
                  color: Colors.white.withOpacity(0.01),
                ),
              ),
            )
          ],
        ),
      );
    ;
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
  static final style = const TextStyle(
    fontSize: 30,
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

}
