import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayou/activitypage.dart';
import 'package:kayou/offerspage.dart';
import 'package:kayou/goodspage.dart';
import 'package:kayou/mappage.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:kayou/tools/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math.dart' as math;

UtilsState utils = new UtilsState();

//Class pour le widget BottomNavigationBar
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var myFuture;

  GlobalKey globalKey = new GlobalKey();

  AnimationController? _animationController;
  Animation<double>? animation;
  CurvedAnimation? curve;

  // bool _hideNavBar;

  void initState() {
    myFuture = getConnectedUser();

    utils.initState();

    // _hideNavBar = false;
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 0),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController!,
      curve: Interval(
        0,
        0,
        curve: Curves.bounceIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve!);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController!.forward(),
    );
  }

  getConnectedUser() async {
    if (globals.user != null) {}

    // if (Platform.isAndroid) {
    await utils.checkActivityAutorisation();
    // }

    String str = await callAsyncFetch();
    return str;
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  List<Widget> _buildScreens() {
    return [
      ActivityPage(
        setStateCallback: _callback,
      ),
      OffersPage(),
      GoodsPage(),
      MapPage()
    ];
  }

  void onItemTapped(int index) {
    globals.currentIndex = index;
    setState(() {});
  }

  void _callback() {
    setState(() {
      globals.controller!.jumpToTab(globals.currentIndex);
      onItemTapped(globals.currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    utils.initState();

    List<Widget> screens = [
      ActivityPage(
        setStateCallback: _callback,
      ),
      OffersPage(),
      GoodsPage(),
      MapPage()
    ];

    final iconList = <IconData>[
      Icons.insert_chart_outlined_rounded,
      Linecons.shop,
      MdiIcons.trophyOutline,
      Icons.location_on_outlined,
    ];

    final textsMenu = <String>[
      "Activité",
      "Partenaires",
      "Récompenses",
      "Plan",
    ];

    final keys = <GlobalKey>[
      globals.keyBottomNavigation1,
      globals.keyBottomNavigation2,
      globals.keyBottomNavigation3,
      globals.keyBottomNavigation4,
    ];

    return new WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: Scaffold(
                    key: screens[globals.currentIndex].key,
                    body: screens[globals.currentIndex],
                    extendBody: false,
                    extendBodyBehindAppBar: false,
                    floatingActionButton: ScaleTransition(
                      scale: animation!,
                      child: FloatingActionButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        backgroundColor: Colors.grey[700],
                        child: Icon(
                          CupertinoIcons.barcode_viewfinder,
                          size: 44,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _animationController!.reset();
                          _animationController!.forward();
                          utils.openQRCode(context);
                        },
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    backgroundColor: Colors.white,
                    bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                      
                      notchMargin: 0,
                      leftCornerRadius: 50,
                      rightCornerRadius: 50,
                      itemCount: iconList.length,
                      tabBuilder: (int index, bool isActive) {
                        final color =
                            isActive ? Colors.cyan[700]! : Colors.grey;
                        return Column(
                          key: keys[index],
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              iconList[index],
                              size: 24,
                              color: color,
                            ),
                            const SizedBox(height: 4),
                            Text(textsMenu[index],
                                style: TextStyle(color: color, fontSize: 11))
                          ],
                        );
                      },
                      backgroundColor: Colors.white,
                      activeIndex: globals.bottomNavIndex,
                      splashColor: Colors.cyan[700]!,
                      notchAndCornersAnimation: animation,
                      splashSpeedInMilliseconds: 300,
                      notchSmoothness: NotchSmoothness.smoothEdge,
                      gapLocation: GapLocation.center,
                      onTap: (index) => setState(() {
                        globals.currentIndex = index;

                        globals.bottomNavIndex = index;
                      }),
                    ),
                  ));
            } else {
              return Scaffold(
                body: Center(
                  child: LoadingBouncingGrid.square(
                    size: 80,
                    backgroundColor: Colors.cyan[700]!,
                  ),
                ),
              );
            }
          },
        ));
  }
  // }
}
