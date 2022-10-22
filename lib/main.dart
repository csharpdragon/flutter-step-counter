import 'dart:io';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
// import 'package:background_fetch/background_fetch.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kayou/authentificationPage.dart';
import 'package:kayou/homepage.dart';
import 'package:kayou/services/push-notification-service.dart';
import 'package:kayou/tools/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tools/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'firebase_options.dart';

var home;

UtilsState utils = new UtilsState();
Future<void> main() async {

  //Initialisation de l'App
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  utils.initState();

  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);

  globals.user = FirebaseAuth.instance.currentUser;

  globals.isIpad = await utils.isIpad();


  globals.isInstalledGoogleFit = defaultTargetPlatform == TargetPlatform.android
      ? await DeviceApps.isAppInstalled('com.google.android.apps.fitness')
      : false;

  globals.validatePointsOfInterest = [];
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if(Platform.isAndroid){
    globals.androidInfo = await deviceInfo.androidInfo;
  }else{
    globals.iosInfo = await deviceInfo.iosInfo;
  }
  // if (defaultTargetPlatform == TargetPlatform.android) {

  //   globals.androidInfo = await deviceInfo.androidInfo;
  // } else if (defaultTargetPlatform == TargetPlatform.iOS)
  // {
  //   globals.iosInfo = await deviceInfo.iosInfo;
  // }

  globals.dayWin = 0;

  globals.setTimer = (prefs.getBool('setTimer') ?? false);
  globals.endTime = (prefs.getInt('timer') ?? 0);
  globals.isFirstLaunch = (prefs.getBool('isFirstLaunch') ?? true);
  globals.init = (prefs.getBool('init') ?? true);
  globals.showTutorial = (prefs.getBool('showTutorial') ?? true);
  globals.showTutorialGift = (prefs.getBool('showTutorialGift') ?? true);
  globals.showTutorialMap = (prefs.getBool('showTutorialMap') ?? true);
  globals.showTutorialDeal = (prefs.getBool('showTutorialDeal') ?? true);

  if (globals.user != null) {
    await utils.checkAndCreateAccount(globals.user!);
  }

  globals.lastFeet = (prefs.getInt('lastFeet') ?? 0);
  globals.dayFeetValidate = (prefs.getInt('dayFeetValidate') ?? 0);
  globals.lastDay = (prefs.getString('lastDay') ?? "0");
  globals.lastDayWin = (prefs.getInt('lastDayWin') ?? 0);
  globals.savedStepsCount = (prefs.getInt('savedStepsCountKey') ?? 0);
  globals.todaySteps = (prefs.getInt('todaySteps') ?? 0);

  if (globals.lastDay == "0") {
    print(DateFormat('yyyyMMdd').format(DateTime.now()));
    globals.lastDay = DateFormat('yyyyMMdd').format(DateTime.now());
    utils.setStringValue(
        'lastDay', DateFormat('yyyyMMdd').format(DateTime.now()));
  }

  if (globals.lastDay != DateFormat('yyyyMMdd').format(DateTime.now())) {
    if (int.parse(globals.lastDay) <=
        int.parse(DateFormat('yyyyMMdd').format(DateTime.now()))) {
      globals.todaySteps = 0;
      globals.palier1000 = false;
      globals.palier2000 = false;
      globals.palier3000 = false;
      globals.palier4000 = false;
      globals.palier5000 = false;
      globals.palier6000 = false;
      globals.palier7000 = false;
      globals.palier8000 = false;
      globals.palier9000 = false;
      globals.palier10000 = false;
      globals.palier11000 = false;
      globals.palier12000 = false;
      globals.palier13000 = false;
      globals.palier14000 = false;
      globals.palier15000 = false;
      globals.palier16000 = false;
      globals.palier17000 = false;
      globals.palier18000 = false;
      globals.palier19000 = false;
      globals.palier20000 = false;
      globals.ads = true;
    }
  }

  await utils.initLevels();

  await utils.initDB();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.getToken(vapidKey: "2BZ72C3N2C").then((token) {
    print('------------');
    print(token);
  });

  // messaging.getToken(vapidKey: "BD9ca67McRv2B-xKYmXUDkM0K8MX5MQnHa_nuRjikg4H4NJ6M-1c9Hb9_B7PUGd7mi2TNI7crmHvtOq5zkGfVsA")
  //   .then((token) {
  //     print('------------');
  //     print(token);
  //   });

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: true,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
    if (await Permission.notification.request().isGranted) {}
  }

  await PushNotificationService().setupInteractedMessage();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MyApp());

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }
}
class MyApp extends StatelessWidget {
  void _onAuthentification() {}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (globals.isFirstLaunch) {
      home = OnBoardingPage();
    } 
    else {
      if (globals.user == null) {
        home = AuthentificationPage(
          onInit: false,
          onSignedIn: _onAuthentification,
          onLaunch: true,
          index: 0,
        );
      } else {
        home = HomePage();
      }
    }
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en')],
      routes: {
        '/HomePage': (context) => HomePage(),
        '/OnBoardingPage': (context) => OnBoardingPage(),
      },
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Kayou',
      theme: ThemeData(
        // fontFamily: Platform.isAndroid ? '' : 'default',
        fontFamily: 'segoeuivf',
        splashColor: Colors.transparent,
        shadowColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primarySwatch: Colors.orange,
      ),
      home: home,
      builder: EasyLoading.init(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onAuthentification() {}
  _onIntroEnd(context) async {
    pushNewScreen(
      context,
      screen: AuthentificationRegisterPage(
        onInit: true,
        onSignedIn: _onAuthentification,
        onLaunch: true,
      ),
      withNavBar: false, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      contentMargin: EdgeInsets.zero,
      imagePadding: EdgeInsets.zero,
      imageFlex: 2,

      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      // imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          toolbarOpacity: 0,
          toolbarHeight: 0,
        ),
        backgroundColor: Colors.white,
        body:Container(
            color: Colors.white,
            child: IntroductionScreen(
              key: introKey,
              pages: [
                PageViewModel(
                    // title: "Fractional shares",

                    bodyWidget: Column(children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child:
                            // globals.language == "FR" ?
                            AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                    'assets/images/intro/Slide1.jpg',
                                    fit: BoxFit.cover)),
                        // : Image.asset('assets/images/Slide2US.jpg',
                        //     fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Text(globals.dictionnary["Slide1_L1"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26))),
                      SizedBox(height: 20),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Text(globals.dictionnary["Slide1_L2"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.grey))),
                    ]),

                    titleWidget: Container(),
                    decoration: pageDecoration,
                  ),
                
                PageViewModel(
                    // title: "Fractional shares",

                    bodyWidget: Container(
                        child: Column(children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child:
                            // globals.language == "FR" ?
                            AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                    'assets/images/intro/Slide2.jpg',
                                    fit: BoxFit.cover)),
                        // : Image.asset('assets/images/Slide2US.jpg',
                        //     fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Text(globals.dictionnary["Slide2_L1"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26))),
                      SizedBox(height: 20),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Text(globals.dictionnary["Slide2_L2"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.grey))),
                    ])),

                    titleWidget: Container(),
                    decoration: pageDecoration,
                  ),
                  
                PageViewModel(
                    // title: "Fractional shares",

                    bodyWidget: Container(
                        child: Column(children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        width: MediaQuery.of(context).size.width,
                        child:
                            // globals.language == "FR" ?
                            AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                    'assets/images/intro/Slide3.jpg',
                                    fit: BoxFit.cover)),
                        // : Image.asset('assets/images/Slide3US.jpg',
                        //     fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Text(globals.dictionnary["Slide3_L1"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26))),
                      SizedBox(height: 20),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Text(globals.dictionnary["Slide3_L2"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.grey))),
                    ])),

                    titleWidget: Container(),
                    decoration: pageDecoration,
                  ),
                
              ],
              onDone: () => _onIntroEnd(context),
              //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
              showSkipButton: true,
              nextFlex: 0,
              onChange: (value) {},

              skip: Text(globals.dictionnary["Skip"]!),
              next: const Icon(Icons.arrow_forward),
              done: Text(globals.dictionnary["Done"]!,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              dotsDecorator: const DotsDecorator(
                size: Size(18.0, 18.0),
                color: Color(0xFFBDBDBD),
                activeSize: Size(18.0, 18.0),
                activeColor: Colors.black,
                shape: CircleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2)),
                activeShape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.white, style: BorderStyle.solid, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
        ),
    );
  }

  changePage(int index) {
    return index;
  }
}
