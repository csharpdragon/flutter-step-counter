import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'dart:isolate';
import 'dart:typed_data';
// import 'package:background_fetch/background_fetch.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_share/flutter_share.dart';
// import 'package:kayou/mappage.dart';
import 'package:kayou/profilpage.dart';
import 'package:kayou/smspage.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tuto/tuto-activity.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'admobpage.dart';
import 'buypage.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:health/health.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';


Stream<StepCount>? _stepCountStream1;
Stream<PedestrianStatus>? _pedestrianStatusStream1;
StreamSubscription<StepCount>? _streamSubscription1;
var pedometerworking=false;
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // if (Platform.isIOS) {
  //   await flutterLocalNotificationsPlugin.initialize(
  //     const InitializationSettings(
  //       iOS: IOSInitializationSettings(),
  //     ),
  //   );
  // }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  // service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  UtilsState? utils1;
  utils1 = new UtilsState();
  utils1!.initState();
  getTodaySteps1(StepCount event) async {
    if (globals.init) {
      globals.savedStepsCount = event.steps;

      utils1!.setIntValue("savedStepsCountKey", globals.savedStepsCount);

      utils1!.setInit(false);
    } else {
      if (event.steps == 0) {
        //On est au début du pédometre (redémarrage du téléphone ou nouvelle installation de l'app)
        globals.savedStepsCount = 0;
        utils1!.setIntValue("savedStepsCountKey", globals.savedStepsCount);
      } else if (event.steps < globals.savedStepsCount) {
        globals.savedStepsCount = 0;

        utils1!.setIntValue("savedStepsCountKey", globals.savedStepsCount);
      }
    }
    globals.todaySteps= event.steps - globals.savedStepsCount;

    // print(event.steps);
    await utils1!.checkDay(event.steps, globals.todaySteps);

    utils1!.setIntValue('todaySteps', globals.todaySteps);
  }

  void onStepCountError(error) {
    print(error);
  }
  
  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  setALLforRefresh() async{
    SharedPreferences preferences1 = await SharedPreferences.getInstance();
    await preferences1.setInt("uf-getSteps", utils1!.getSteps1(globals.todaySteps));
    await preferences1.setInt("g-todaySteps",globals.todaySteps);
    await preferences1.setInt("g-dayFeetValidate",globals.dayFeetValidate);
    await preferences1.setInt("g-dayWin",globals.dayWin);
  }
  _pedestrianStatusStream1 = await Pedometer.pedestrianStatusStream;
  _stepCountStream1 =await Pedometer.stepCountStream;
  _stepCountStream1?.listen(getTodaySteps1).onError(onStepCountError);

  Timer.periodic(const Duration(minutes: 1), (timer) async {
      _pedestrianStatusStream1 = await Pedometer.pedestrianStatusStream;
      _stepCountStream1 =await Pedometer.stepCountStream;
      _stepCountStream1?.listen(getTodaySteps1).onError(onStepCountError);
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    globals.todaySteps++;
    await utils1!.checkChangeDate();
  });
  // bring to foreground
   Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${globals.todaySteps} ${globals.lastDay} ${DateFormat('yyyyMMdd').format(DateTime.now())}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        // service.setForegroundNotificationInfo(
        //   title: "My App Service",
        //   content: "Updated at ${DateTime.now()}",
        // );
      }
    }

    await setALLforRefresh();
    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": globals.todaySteps.toString(),
        "device": device,
      },
    );
  });
}


class ActivityPage extends StatefulWidget {
  final _callback;

  ActivityPage({required void setStateCallback()})
      : _callback = setStateCallback;

  ActivityPageState createState() => ActivityPageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class ActivityPageState extends State<ActivityPage> implements TaskHandler {
  PackageInfo? packageInfo;

  Pedometer? _pedometer;
  StreamSubscription<int>? _subscription;

  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  StreamSubscription<StepCount>? _streamSubscription;

  // int todaySteps;

  HealthFactory health = HealthFactory();

  String source = "";

  // define the types to get
  List<HealthDataType> types = [
    HealthDataType.STEPS,
  ];

  double? maxStepsHour;

  List<_HealthData> data = [
    new _HealthData('0 H', 0),
    new _HealthData('1 H', 0),
    new _HealthData('2 H', 0),
    new _HealthData('3 H', 0),
    new _HealthData('4 H', 0),
    new _HealthData('5 H', 0),
    new _HealthData('6 H', 0),
    new _HealthData('7 H', 0),
    new _HealthData('8 H', 0),
    new _HealthData('9 H', 0),
    new _HealthData('10 H', 0),
    new _HealthData('11 H', 0),
    new _HealthData('12 H', 0),
    new _HealthData('13 H', 0),
    new _HealthData('14 H', 0),
    new _HealthData('15 H', 0),
    new _HealthData('16 H', 0),
    new _HealthData('17 H', 0),
    new _HealthData('18 H', 0),
    new _HealthData('19 H', 0),
    new _HealthData('20 H', 0),
    new _HealthData('21 H', 0),
    new _HealthData('22 H', 0),
    new _HealthData('23H', 0),
  ];

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  ScreenshotController screenshotController = ScreenshotController();

  String _status = '0', _steps = '0';
  int line = 1;
  UtilsState? utils;

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  var colorPoint = Colors.amber[300];

  var image = "assets/images/Cagou.png";

  SharedPreferences? preferences2;
  int uf_getSteps = 0;
  int g_todaySteps  = 0;
  int g_dayFeetValidate  = 0;
  int g_dayWin  = 0;

  @override
  void initState() {
    maxStepsHour = 0;
    utils = new UtilsState();
    utils!.initState();

    super.initState();

    checkAutorisation();
    initService();
  }

  initService() async{
    WidgetsFlutterBinding.ensureInitialized();
    await initializeService();

    Timer.periodic(const Duration(microseconds: 100), (timer) async {
      getAllSharedValues();
    });
  }
  void stopListening() {
    // _subscription.cancel();
  }
  checkAutorisation() async {
    packageInfo = await PackageInfo.fromPlatform();

    if (globals.autorisationPodometer) {
      // print(globals.showTutorial);
      if (globals.showTutorial) {
        await pushNewScreen(
          context,
          screen: TutoActivityPage(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) {
          globals.showTutorial = false;
          utils!.setBoolValue("showTutorial", false);
        });
      } else {
        await utils!.showGoogleFit(context);
      }
      initPlatformState();
    }

    return false;
  }

  getMaxDatasHour() {
    maxStepsHour = 0;

    for (var i = 0; i < data.length; i++) {
      if (data[i].steps.toDouble() > maxStepsHour!) {
        maxStepsHour = data[i].steps.toDouble() + 200;
      }
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    // print(event);
    _status = event.status;
    if (_status == "walking") {
      // image = "assets/images/activite.gif";
    } else {
      // image = "assets/images/Cagou.png";
    }

    if (mounted) {
      // setState(() {});
    }
  }

  void onPedestrianStatusError(error) {
    // print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    // print(_status);
  }

  countSteps() async {
    if (Platform.isAndroid && !globals.isInstalledGoogleFit) {
    } else {
      if (globals.init) {
        utils!.setInit(false);
      }
      if (globals.lastDay != DateFormat('yyyyMMdd').format(DateTime.now())) {
        globals.todaySteps = 0;
        globals.lastDayWin = globals.dayWin;
        // globals.dayWin = 0;
        //   await utils.checkDay(0, globals.todaySteps);
      }
      //else {
      await utils!.checkDay(0, globals.todaySteps);

      // get everything from midnight until now
      DateTime startDate = DateTime(
          int.parse(DateFormat('yyyy').format(DateTime.now())),
          int.parse(DateFormat('MM').format(DateTime.now())),
          int.parse(DateFormat('dd').format(DateTime.now())),
          0,
          0,
          1);
      DateTime endDate = DateTime(
          int.parse(DateFormat('yyyy').format(DateTime.now())),
          int.parse(DateFormat('MM').format(DateTime.now())),
          int.parse(DateFormat('dd').format(DateTime.now())),
          23,
          59,
          59);

      int? steps = 0;

      if (globals.autorisationPodometer) {
        try {
          steps =
              await health.getTotalStepsInInterval(startDate, endDate) == null
                  ? 0
                  : await health.getTotalStepsInInterval(startDate, endDate);

          data = [
            new _HealthData('0 H', 0),
            new _HealthData('1 H', 0),
            new _HealthData('2 H', 0),
            new _HealthData('3 H', 0),
            new _HealthData('4 H', 0),
            new _HealthData('5 H', 0),
            new _HealthData('6 H', 0),
            new _HealthData('7 H', 0),
            new _HealthData('8 H', 0),
            new _HealthData('9 H', 0),
            new _HealthData('10 H', 0),
            new _HealthData('11 H', 0),
            new _HealthData('12 H', 0),
            new _HealthData('13 H', 0),
            new _HealthData('14 H', 0),
            new _HealthData('15 H', 0),
            new _HealthData('16 H', 0),
            new _HealthData('17 H', 0),
            new _HealthData('18 H', 0),
            new _HealthData('19 H', 0),
            new _HealthData('20 H', 0),
            new _HealthData('21 H', 0),
            new _HealthData('22 H', 0),
            new _HealthData('23 H', 0),
          ];

          List<HealthDataPoint> healthData =
              await health.getHealthDataFromTypes(startDate, endDate, types);

          // save all the new data points
          _healthDataList.addAll(healthData);

          _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

          // print the results
          _healthDataList.forEach((x) {
            if (x.dateFrom.year.toString() +
                    x.dateFrom.month.toString().padLeft(2, '0') +
                    x.dateFrom.day.toString().padLeft(2, '0') ==
                DateFormat('yyyyMMdd').format(DateTime.now())) {
              data[x.dateFrom.hour].steps += double.parse(x.value.toString());
            }
          });
        } catch (e) {}

        globals.todaySteps = steps!;

        utils!.setIntValue('todaySteps', globals.todaySteps);
      } else {
        globals.todaySteps = 0;
      }
      // }
      await getMaxDatasHour();
    }

    // if (mounted) {
    setState(() {});
    // }
  }

  Future getTodayStepsHealth(StepCount event) async {
    countSteps();
  }

  getTodaySteps(StepCount event) async {
    if (globals.init) {
      globals.savedStepsCount = event.steps;

      utils!.setIntValue("savedStepsCountKey", globals.savedStepsCount);

      utils!.setInit(false);
    } else {
      if (event.steps == 0) {
        //On est au début du pédometre (redémarrage du téléphone ou nouvelle installation de l'app)

        globals.savedStepsCount = 0;

        utils!.setIntValue("savedStepsCountKey", globals.savedStepsCount);
      } else if (event.steps < globals.savedStepsCount) {
        globals.savedStepsCount = 0;

        utils!.setIntValue("savedStepsCountKey", globals.savedStepsCount);
      }
    }

    globals.todaySteps = event.steps - globals.savedStepsCount;

    // print(event.steps);
    await utils!.checkDay(event.steps, globals.todaySteps);

    utils!.setIntValue('todaySteps', globals.todaySteps);

    setState(() {});
  }

  Future<String> findLocalPath() async {
    final directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);

    return directory;
  }

  Future<String> findLocalPathIos() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> shareImage(Uint8List uint8list) async {
    //On check les permissions
    if (await Permission.storage.request().isGranted) {
      String directory;
      Platform.isAndroid
          ? directory =
              (await findLocalPath()) + Platform.pathSeparator + "kayou.jpg"
          : directory =
              (await findLocalPathIos()) + Platform.pathSeparator + "kayou.jpg";

      final image = await File(directory).writeAsBytes(uint8list);
      // print(await image.exists());
      // await image.writeAsBytes(uint8list, mode: FileMode.write, flush: true);
      await FlutterShare.shareFile(
        filePath: image.path,
        title: 'Pas du jour',
      );
    }
  }

  _callback() {
    widget._callback();
  }

  void onStepCountError(error) {
    // print('onStepCountError: $error');
    // setState(() {
    //   _steps = 'Step Count not available';
    // });
  }

  Future<void> initPlatformState() async {
   

    if (Platform.isAndroid) {
      // if (Platform.isAndroid && !globals.isInstalledGoogleFit) {
      //   print('google fit');
      //   _stepCountStream!.listen(getTodaySteps).onError(onStepCountError);
      // } else {
      //   print('google no fit');
      //   _stepCountStream!.listen(getTodayStepsHealth).onError(onStepCountError);
      // }
    } else {
      print('this is not android platfrom');
       _pedestrianStatusStream =await Pedometer.pedestrianStatusStream;
        _pedestrianStatusStream!
            .listen(onPedestrianStatusChanged)
            .onError(onPedestrianStatusError);

        _stepCountStream =await Pedometer.stepCountStream;
      _pedestrianStatusStream =await Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream!
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream =await Pedometer.stepCountStream;

      _stepCountStream!.listen(getTodayStepsHealth).onError(onStepCountError);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<Null> refreshList() async {
    await Future.delayed(new Duration(seconds: 1));
    if (Platform.isIOS ||
        (Platform.isAndroid && globals.isInstalledGoogleFit)) {
      countSteps();
    }
    await utils!.getUserPoints();
    return null;
  }

  showTutorial() async {
    await utils!.initTutorial();
    // TutorialCoachMark tutorial = TutorialCoachMark(context,
    //     targets: globals.targets, // List<TargetFocus>
    //     colorShadow: Colors.black, // DEFAULT Colors.black
    //     // alignSkip: Alignment.bottomRight,
    //     textSkip: "Passer le tutoriel",
    //     alignSkip: Alignment.topLeft,
    //     // paddingFocus: 10,
    //     // focusAnimationDuration: Duration(milliseconds: 500),
    //     // pulseAnimationDuration: Duration(milliseconds: 500),
    //     // pulseVariation: Tween(begin: 1.0, end: 0.99),
    //     onFinish: () async {
    //       if (globals.showTutorial) {
    //         await utils!.showGoogleFit(context);
    //       }
    //       globals.showTutorial = false;
    //       utils!.setBoolValue("showTutorial", false);
    //     },
    //     onClickTarget: (target) {},
    //     onClickOverlay: (p0) {},
    //     onSkip: () async {
    //       if (globals.showTutorial) {
    //         await utils!.showGoogleFit(context);
    //       }
    //       globals.showTutorial = false;
    //       utils!.setBoolValue("showTutorial", false);
    //     })
    //   ..show();
  }

  
  void getAllSharedValues() async{
    preferences2 = await SharedPreferences.getInstance();
    await preferences2!.reload();
    uf_getSteps = preferences2!.getInt("uf-getSteps") ?? 0;
    g_todaySteps = preferences2!.getInt("g-todaySteps") ?? 0;
    g_dayFeetValidate = preferences2!.getInt("g-dayFeetValidate") ?? 0;
    g_dayWin = preferences2!.getInt("g-dayWin") ?? 0;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent),
          elevation: 0,
          toolbarHeight: 50,
          centerTitle: true,
          // leading: Container(),
          leadingWidth: 100,
          leading: Container(
              // key: globals.keyButton,
              // margin: EdgeInsets.only(left: 13, top: 10, bottom: 10, right: 13),
              // alignment: Alignment.center,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     color: Colors.orange[700]),
              // child: Text(globals.profitUser.toString() + " Ꝃ",
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 14))
              ),
          title: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Text("Activité",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18))),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       screenshotController
            //           .capture(delay: Duration(milliseconds: 10))
            //           .then((capturedImage) async {
            //         await shareImage(capturedImage);
            //       }).catchError((onError) {
            //         print(onError);
            //       });
            //     },
            //     icon: Icon(CupertinoIcons.share)),
            IconButton(
                key: globals.keyButton6,
                onPressed: () {
                  pushNewScreen(context,
                      screen: ProfilPage(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                icon: Icon(CupertinoIcons.gear_alt)),
            // IconButton(
            //   icon: Icon(CupertinoIcons.info),
            //   onPressed: () {
            //     showTutorial();
            //   },
            // )
            SizedBox(width: 5),
            Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                // padding: EdgeInsets.only(left: 10),
                // height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.transparent,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ElevatedButton(
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: TutoActivityPage(),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      enableFeedback: false,
                      splashFactory: NoSplash.splashFactory,
                      animationDuration: Duration(seconds: 0),
                      shadowColor: Colors.transparent,
                      primary: Colors.transparent,
                      elevation: 0,
                      onSurface: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    child: Container(
                        child: Image.asset(
                      "assets/images/tuto_icon.png",
                      height: 32,
                      width: 32,
                      fit: BoxFit.fill,
                    ))))
          ],
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 10),
              Screenshot(
                  controller: screenshotController,
                  child: Column(children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Text("Objectif du " + utils!.getDate(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))),
                    SizedBox(height: 15),
                    Container(
                        height: 85,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(40, 157, 210, 1)),
                        child: Row(children: [
                          Container(
                              height: 70,
                              width: 70,
                              margin:
                                  EdgeInsets.only(left: 15, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage('assets/images/trophy.png'),
                                height: 38,
                              )),
                          SizedBox(width: 20),
                          Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(
                                    "Paliers : " +
                                        uf_getSteps.toString() +
                                        " / 20",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                uf_getSteps < 20
                                    ? Row(children: [
                                        Text("Encore ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                        Text(
                                            (((uf_getSteps - 1) * 1000) <=
                                                        g_todaySteps &&
                                                    (uf_getSteps *
                                                            1000) >=
                                                        g_todaySteps)
                                                ? utils!.addSeparateurMillier(
                                                    ((uf_getSteps *
                                                                1000) -
                                                            g_todaySteps)
                                                        .toString())
                                                : (g_todaySteps >=
                                                        (uf_getSteps *
                                                            1000))
                                                    ? "0"
                                                    : "1 000",
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                        Text(" pas pour valider le palier",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14))
                                      ])
                                    : Container(),
                                uf_getSteps < 20
                                    ? Row(children: [
                                        Text("Récompense à obtenir : ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                        Text(" 1Ꝃ",
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      ])
                                    : Container(),
                                uf_getSteps == 20
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                130,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Félicitations! ",
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14)),
                                              Text(
                                                  "Vous avez validé tous les paliers de la journée",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14))
                                            ]))
                                    : Container(),
                              ]))
                        ])),
                    SizedBox(height: 15),
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        // height: 400,
                        child: Column(
                            key: globals.keyButton1,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  utils!.addSeparateurMillier(
                                      g_todaySteps.toString()),
                                  style: TextStyle(
                                      color: Color.fromRGBO(54, 91, 109, 1),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold)),
                              // SizedBox(height: 10),
                              Text("pas effectués",
                                  style: TextStyle(color: Colors.black)),
                            ])),
                    Container(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        color: Colors.white,
                        child: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.loose,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 70,
                                child: SfLinearGauge(
                                  minimum: 0.0,
                                  maximum: 20000.0,
                                  orientation:
                                      LinearGaugeOrientation.horizontal,
                                  interval: 20000,

                                  labelOffset: 15,
                                  ranges: <LinearGaugeRange>[
                                    LinearGaugeRange(
                                        position: LinearElementPosition.cross,
                                        startValue: 0,
                                        endValue: g_todaySteps.toDouble(),
                                        endWidth: 7,
                                        startWidth: 7,
                                        color: Color.fromRGBO(54, 91, 109, 1)),
                                  ],

                                  markerPointers: [
                                    LinearWidgetPointer(
                                      // value: 10000,

                                      child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: Color.fromRGBO(
                                                  54, 91, 109, 1)),
                                          child: Icon(
                                            Icons.directions_walk_outlined,
                                            color: Colors.white,
                                          )),
                                      value:
                                          g_todaySteps.toDouble() >= 20000
                                              ? 20000
                                              : g_todaySteps.toDouble(),
                                    ),
                                    LinearWidgetPointer(
                                      // value: 10000,
                                      child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: Color.fromRGBO(
                                                  54, 91, 109, 1)),
                                          child: Icon(
                                            Icons.directions_walk_outlined,
                                            color: Colors.white,
                                          )),
                                      value:
                                          g_todaySteps.toDouble() >= 20000
                                              ? 20000
                                              : g_todaySteps.toDouble(),
                                    ),
                                  ],

                                  // majorTickStyle: LinearTickStyle(length: 20),
                                  // showLabels: false,
                                  showTicks: false,
                                  axisLabelStyle: TextStyle(
                                      fontSize: 11.0, color: Colors.black),
                                  // axisTrackStyle: LinearAxisTrackStyle(
                                  //     color: Colors.cyan,
                                  //     edgeStyle: LinearEdgeStyle.bothFlat,
                                  //     thickness: 15.0,
                                  //     borderColor: Colors.grey)),
                                ),
                                // child: SfRadialGauge(
                                //   backgroundColor: Colors.transparent,
                                //   axes: <RadialAxis>[
                                //     RadialAxis(
                                //         startAngle: 190,
                                //         endAngle: 170,
                                //         maximumLabels: 0,
                                //         ranges: <GaugeRange>[
                                //           GaugeRange(
                                //               startValue: 0,
                                //               endValue: g_todaySteps
                                //                   .toDouble(),
                                //               endWidth: 14,
                                //               startWidth: 14,
                                //               color: Color.fromRGBO(
                                //                   54, 91, 109, 1)),
                                //         ],
                                //         pointers: [
                                //           //Les points

                                //           // MarkerPointer(
                                //           //   value: 1000,
                                //           //   textStyle: GaugeTextStyle(
                                //           //       fontSize: 19,
                                //           //       color: Colors.black),
                                //           //   color: colorPoint,
                                //           //   markerType: MarkerType.circle,
                                //           // ),
                                //           // MarkerPointer(
                                //           //   value: 3000,
                                //           //   textStyle: GaugeTextStyle(
                                //           //       fontSize: 19,
                                //           //       color: Colors.black),
                                //           //   color: colorPoint,
                                //           //   markerType: MarkerType.circle,
                                //           // ),
                                //           // MarkerPointer(
                                //           //   value: 6000,
                                //           //   textStyle: GaugeTextStyle(
                                //           //       fontSize: 19,
                                //           //       color: Colors.black),
                                //           //   color: colorPoint,
                                //           //   markerType: MarkerType.circle,
                                //           // ),
                                //           // MarkerPointer(
                                //           //   value: 10000,
                                //           //   textStyle: GaugeTextStyle(
                                //           //       fontSize: 19,
                                //           //       color: Colors.black),
                                //           //   color: colorPoint,
                                //           //   markerType: MarkerType.circle,
                                //           // ),
                                //           // MarkerPointer(
                                //           //   value: 15000,
                                //           //   textStyle: GaugeTextStyle(
                                //           //       fontSize: 19,
                                //           //       color: Colors.black),
                                //           //   color: colorPoint,
                                //           //   markerType: MarkerType.circle,
                                //           // ),
                                //           // MarkerPointer(
                                //           //   value: 20000,
                                //           //   textStyle: GaugeTextStyle(
                                //           //       fontSize: 19,
                                //           //       color: Colors.black),
                                //           //   color: colorPoint,
                                //           //   markerType: MarkerType.circle,
                                //           // ),

                                //           //Les tirets
                                //           MarkerPointer(
                                //             value: 30,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 15,
                                //             markerHeight: 3,
                                //             markerOffset: 14,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 1000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 2000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 3000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 4000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 5000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 15,
                                //             markerHeight: 3,
                                //             markerOffset: 14,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 6000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 7000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 8000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 9000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 10000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 15,
                                //             markerHeight: 3,
                                //             markerOffset: 14,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 11000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 12000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 13000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 14000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 15000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 15,
                                //             markerHeight: 3,
                                //             markerOffset: 15,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 16000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 17000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 18000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 19000,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 10,
                                //             markerHeight: 1,
                                //             markerOffset: 12,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           MarkerPointer(
                                //             value: 19955,
                                //             textStyle: GaugeTextStyle(
                                //                 fontSize: 19,
                                //                 color: Colors.black),
                                //             color: Colors.grey[600],
                                //             markerWidth: 14,
                                //             markerHeight: 3,
                                //             markerOffset: 14,
                                //             markerType: MarkerType.rectangle,
                                //           ),
                                //           WidgetPointer(
                                //               child: Container(
                                //                   height: 30,
                                //                   width: 30,
                                //                   decoration: BoxDecoration(
                                //                       borderRadius:
                                //                           BorderRadius
                                //                               .circular(40),
                                //                       color: Color.fromRGBO(
                                //                           54, 91, 109, 1)),
                                //                   child: Icon(
                                //                     Icons
                                //                         .directions_walk_outlined,
                                //                     color: Colors.white,
                                //                   )),
                                //               value: g_todaySteps
                                //                           .toDouble() >=
                                //                       20000
                                //                   ? 20000
                                //                   : g_todaySteps
                                //                       .toDouble()),
                                //         ],
                                //         annotations: [
                                //           //Valeurs
                                //           GaugeAnnotation(
                                //             axisValue: 500,
                                //             horizontalAlignment:
                                //                 GaugeAlignment.far,
                                //             verticalAlignment:
                                //                 GaugeAlignment.near,
                                //             positionFactor: 0.78,
                                //             widget: Container(
                                //                 // padding: EdgeInsets.only(
                                //                 //     bottom: 15),
                                //                 child: Text('0',
                                //                     style: TextStyle(
                                //                         fontSize: 14,
                                //                         color:
                                //                             Colors.black))),
                                //           ),
                                //           GaugeAnnotation(
                                //             axisValue: 5000,
                                //             horizontalAlignment:
                                //                 GaugeAlignment.center,
                                //             positionFactor: 0.7,
                                //             widget: Container(
                                //                 child: Text('5000',
                                //                     style: TextStyle(
                                //                         fontSize: 14,
                                //                         color:
                                //                             Colors.black))),
                                //           ),
                                //           GaugeAnnotation(
                                //             axisValue: 10000,
                                //             horizontalAlignment:
                                //                 GaugeAlignment.center,
                                //             positionFactor: 0.7,
                                //             widget: Container(
                                //                 child: Text('10000',
                                //                     style: TextStyle(
                                //                         fontSize: 14,
                                //                         color:
                                //                             Colors.black))),
                                //           ),
                                //           GaugeAnnotation(
                                //             axisValue: 15000,
                                //             horizontalAlignment:
                                //                 GaugeAlignment.center,
                                //             positionFactor: 0.7,
                                //             widget: Container(
                                //                 child: Text('15000',
                                //                     style: TextStyle(
                                //                         fontSize: 14,
                                //                         color:
                                //                             Colors.black))),
                                //           ),
                                //           GaugeAnnotation(
                                //             axisValue: 20000,
                                //             horizontalAlignment:
                                //                 GaugeAlignment.far,
                                //             verticalAlignment:
                                //                 GaugeAlignment.near,
                                //             positionFactor: 0.53,
                                //             widget: Container(
                                //                 // padding:
                                //                 // EdgeInsets.only(top: 8),
                                //                 child: Text('20000',
                                //                     style: TextStyle(
                                //                         fontSize: 14,
                                //                         color:
                                //                             Colors.black))),
                                //           ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 3000,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.near,
                                //           //   positionFactor: 0.8,
                                //           //   widget: Container(
                                //           //       child: Text('3000',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 6000,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.near,
                                //           //   positionFactor: 0.8,
                                //           //   widget: Container(
                                //           //       child: Text('6000',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 10000,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.center,
                                //           //   positionFactor: 0.7,
                                //           //   widget: Container(
                                //           //       child: Text('10000',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 15000,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.far,
                                //           //   positionFactor: 0.8,
                                //           //   widget: Container(
                                //           //       child: Text('15000',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 19500,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.far,
                                //           //   positionFactor: 0.5,
                                //           //   widget: Container(
                                //           //       child: Text('20000',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),

                                //           //Les gains
                                //           // GaugeAnnotation(
                                //           //   axisValue: 500,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.center,
                                //           //   positionFactor: 0.98,
                                //           //   widget: Container(
                                //           //       width: 100,
                                //           //       height: 20,
                                //           //       child: Text('1Ꝃ',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 2800,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.center,
                                //           //   positionFactor: 0.92,
                                //           //   widget: Container(
                                //           //       width: 100,
                                //           //       height: 20,
                                //           //       child: Text('3Ꝃ',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 6500,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.center,
                                //           //   positionFactor: 0.95,
                                //           //   widget: Container(
                                //           //       width: 100,
                                //           //       height: 20,
                                //           //       child: Text('6Ꝃ',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 9660,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.near,
                                //           //   positionFactor: 1,
                                //           //   widget: Container(
                                //           //       height: 60,
                                //           //       child: Text('10Ꝃ',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 14800,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.near,
                                //           //   positionFactor: 1,
                                //           //   widget: Container(
                                //           //       padding: EdgeInsets.only(
                                //           //         left: 15,
                                //           //       ),
                                //           //       child: Text('15Ꝃ',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //           // GaugeAnnotation(
                                //           //   axisValue: 22000,
                                //           //   horizontalAlignment:
                                //           //       GaugeAlignment.near,
                                //           //   positionFactor: 1,
                                //           //   widget: Container(
                                //           //       padding: EdgeInsets.only(
                                //           //         top: 40,
                                //           //         left: 5,
                                //           //       ),
                                //           //       height: 60,
                                //           //       child: Text('20Ꝃ',
                                //           //           style: TextStyle(
                                //           //               fontSize: 14,
                                //           //               color:
                                //           //                   Colors.black))),
                                //           // ),
                                //         ],
                                //         minimum: 0,
                                //         maximum: 20000,
                                //         axisLineStyle: AxisLineStyle(
                                //             color: Colors.grey[400],
                                //             thicknessUnit:
                                //                 GaugeSizeUnit.factor,
                                //             thickness: 0.1),
                                //         majorTickStyle: MajorTickStyle(
                                //             length: 0,
                                //             thickness: 1,
                                //             color: Colors.black),
                                //         minorTickStyle: MinorTickStyle(
                                //             length: 6,
                                //             thickness: 1,
                                //             color: Colors.black),
                                //         axisLabelStyle: GaugeTextStyle(
                                //             color: Colors.white,
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 0))
                                //   ],
                                // )
                              ),

                              // Container(
                              //   height: 120,
                              //   width: 120,
                              //   child: ElevatedButton(
                              //       style: ElevatedButton.styleFrom(
                              //         primary: Colors.transparent,
                              //         onPrimary: Colors.transparent,
                              //         onSurface: Colors.transparent,
                              //         shadowColor: Colors.transparent,
                              //         elevation: 0,
                              //         splashFactory: NoSplash.splashFactory,
                              //       ),
                              //       onPressed: () {
                              //         setState(() {
                              //           line = 1;
                              //           globals.messageCagou = true;
                              //         });
                              //       },
                              //       child: Image.asset(
                              //         image,
                              //         height: 120,
                              //         width: 120,
                              //         fit: BoxFit.cover,
                              //       )),
                              //   padding: EdgeInsets.only(left: 0),
                              // ))

                              // globals.messageCagou
                              //     ? Positioned(
                              //         top: 50,
                              //         child: Container(
                              //             alignment: Alignment.topCenter,
                              //             width: MediaQuery.of(context).size.width,
                              //             height: 400,
                              //             child: Container(
                              //                 alignment: Alignment.topCenter,
                              //                 height: 80,
                              //                 width: 200,
                              //                 padding: EdgeInsets.only(
                              //                     left: 5, right: 5),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(10),
                              //                     color: Colors.white,
                              //                     border: Border.all(
                              //                         color: Colors.black,
                              //                         width: 1,
                              //                         style: BorderStyle.solid)),
                              //                 child: Column(children: [
                              //                   AnimatedTextKit(
                              //                     totalRepeatCount: 1,
                              //                     // onFinished: () {
                              //                     //   setState(() {
                              //                     //     globals.messageCagou = false;
                              //                     //   });
                              //                     // },

                              //                     animatedTexts: [
                              //                       TyperAnimatedText(
                              //                           'Bonjour, moi c\'est Kayafou... et je suis ton partenaire de marche!',
                              //                           textStyle: TextStyle(
                              //                               color: Colors.black),
                              //                           speed: Duration(
                              //                               milliseconds: 80)),
                              //                     ],
                              //                     onTap: () {
                              //                       setState(() {
                              //                         globals.messageCagou = false;
                              //                       });
                              //                     },
                              //                   ),
                              //                 ]))),
                              //       )
                              //     : Container()
                            ]))
                  ])),
              !globals.autorisationPodometer
                  ? ElevatedButton(
                      onPressed: () async {
                        await utils!.checkActivityAutorisation();

                        if (globals.autorisationPodometer) {
                          initPlatformState();
                          setState(() {});
                        } else {
                          if (Platform.isIOS) {
                            utils!.openPopupAutorisationIOS(context);
                          }
                        }
                      },
                      child: Text("Commencer à gagner des Kayous",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    )
                  : Column(children: [
                      // Container(
                      //     alignment: Alignment.center,
                      //     height: 57,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(40),
                      //         color: Colors.orange[700]),
                      //     margin: EdgeInsets.only(left: 100, right: 100),
                      //     child: Text(
                      //         "Total : " + globals.profitUser.toString() + " Ꝃ",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 18))),
                      g_dayFeetValidate > 20000
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color.fromRGBO(65, 193, 186, 1)),
                              margin: EdgeInsets.only(left: 60, right: 60),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40))),
                                  ),
                                  onPressed: () async {
                                    if (await utils!.isConnectedToInternet()) {
                                      if (!globals.isValidate) {
                                        if (int.parse(globals.lastDay) <=
                                            int.parse(DateFormat('yyyyMMdd')
                                                .format(DateTime.now()))) {
                                          //Validation en cours
                                          globals.isValidate = true;
                                          // utils.getDate();
                                          // await countSteps();

                                          var returnValues =
                                              await utils!.validateSteps();

                                          if (returnValues[0]) {
                                            if (returnValues[1] > 0) {
                                              Alert(
                                                context: context,
                                                type: AlertType.success,
                                                closeIcon: Container(),
                                                title: "",
                                                desc:
                                                    "Félicitations! Vous venez de gagner " +
                                                        returnValues[1]
                                                            .toString() +
                                                        "Ꝃ",
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      "Fermer",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    color: Color.fromRGBO(
                                                        0, 179, 134, 1.0),
                                                  ),
                                                ],
                                              ).show();
                                            }
                                          }
                                        }
                                      }
                                      setState(() {});
                                    } else {
                                      utils!.showInternetConnectionDialog(
                                          context);
                                    }
                                  },
                                  child: Row(children: [
                                    Container(
                                        height: 50,
                                        width: 50,
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white),
                                        alignment: Alignment.center,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/pas.png'),
                                          height: 26,
                                        )),
                                    Container(
                                        width: 185,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                  utils!.addSeparateurMillier(
                                                          (g_todaySteps -
                                                                          globals
                                                                              .dayFeetValidate <
                                                                      0
                                                                  ? 0
                                                                  : globals
                                                                          .todaySteps -
                                                                      globals
                                                                          .dayFeetValidate)
                                                              .toString()) +
                                                      " pas à valider",
                                                  key: globals.keyButton2,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18)),
                                              Text("Cliquez pour valider",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10)),
                                            ])),
                                  ]))),
                      SizedBox(height: 10),
                      Platform.isIOS ||
                              (Platform.isAndroid &&
                                  globals.isInstalledGoogleFit)
                          // ? charts.BarChart(
                          //     seriesList,

                          //     /// Assign a custom style for the measure axis.
                          //     ///
                          //     /// The NoneRenderSpec only draws an axis line (and even that can be hidden
                          //     /// with showAxisLine=false).
                          //     primaryMeasureAxis: new charts.NumericAxisSpec(
                          //         renderSpec: new charts.NoneRenderSpec()),

                          //     /// This is an OrdinalAxisSpec to match up with BarChart's default
                          //     /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
                          //     /// other charts).
                          //     domainAxis: new charts.OrdinalAxisSpec(
                          //         // Make sure that we draw the domain axis line.
                          //         showAxisLine: true,
                          //         // But don't draw anything else.
                          //         renderSpec: new charts.NoneRenderSpec()),

                          //     // With a spark chart we likely don't want large chart margins.
                          //     // 1px is the smallest we can make each margin.
                          //     layoutConfig: new charts.LayoutConfig(
                          //         leftMarginSpec: new charts.MarginSpec.fixedPixel(0),
                          //         topMarginSpec: new charts.MarginSpec.fixedPixel(0),
                          //         rightMarginSpec: new charts.MarginSpec.fixedPixel(0),
                          //         bottomMarginSpec:
                          //             new charts.MarginSpec.fixedPixel(0)),
                          //   )
                          ? Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              color: Colors.white,
                              height: 250,
                              child: SfCartesianChart(
                                  title: ChartTitle(
                                      text:
                                          "Statistiques du jour (pas / heure)",
                                      textStyle: TextStyle(fontSize: 12)),
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(
                                      minimum: 0,
                                      maximum: maxStepsHour! < 500
                                          ? 500
                                          : maxStepsHour,
                                      interval: 500,
                                      placeLabelsNearAxisLine: false),
                                  series: <ChartSeries<_HealthData, String>>[
                                    ColumnSeries<_HealthData, String>(
                                        dataSource: data,
                                        xValueMapper: (_HealthData data, _) =>
                                            data.hour,
                                        yValueMapper: (_HealthData data, _) =>
                                            data.steps.toDouble(),
                                        name: '',
                                        markerSettings:
                                            MarkerSettings(isVisible: false),
                                        color: Color.fromRGBO(65, 193, 186, 1))
                                  ]))
                          : Container(),
                    ]),
              SizedBox(height: 5),
              Container(
                  color: Colors.grey[50],
                  height: 130,
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Row(children: [
                        Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width - 90) / 3,
                            child: Column(children: [
                              ElevatedButton(
                                  key: globals.keyButton3,
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    primary: Colors.transparent,
                                    onPrimary: Colors.black,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                  ),
                                  child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) /
                                              3,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!, width: 1),
                                      ),
                                      padding: EdgeInsets.zero,
                                      child: Column(children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Nombre total",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            // letterSpacing: 1
                                          ),
                                        ),
                                        Text(
                                          "de Kayous",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                              // letterSpacing: 1
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          utils!.addSeparateurMillier(globals
                                                  .profitUser
                                                  .toString()) +
                                              " Ꝃ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  Color.fromRGBO(54, 91, 109, 1)
                                              // letterSpacing: 1
                                              ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                            margin: EdgeInsets.only(right: 10),
                                            alignment: Alignment.centerRight,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/moneybox_icon.png'),
                                              height: 26,
                                            ))
                                      ]))),
                            ])),
                        SizedBox(width: 10),
                        Container(
                            width: (MediaQuery.of(context).size.width - 90) / 3,
                            child: Column(children: [
                              ElevatedButton(
                                  key: globals.keyButton4,
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    primary: Colors.transparent,
                                    onPrimary: Colors.black,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                  ),
                                  child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) /
                                              3,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!, width: 1),
                                      ),
                                      padding: EdgeInsets.zero,
                                      child: Column(children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Kayous gagnés",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            // letterSpacing: 1
                                          ),
                                        ),
                                        Text(
                                          "aujourd'hui",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                              // letterSpacing: 1
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          g_dayWin.toString() + " Ꝃ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue[900]
                                              // letterSpacing: 1
                                              ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                            margin: EdgeInsets.only(right: 10),
                                            alignment: Alignment.centerRight,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/medal_icon.png'),
                                              height: 26,
                                            ))
                                      ]))),
                            ])),
                        SizedBox(width: 10),
                        Container(
                            width: (MediaQuery.of(context).size.width - 90) / 3,
                            child: Column(children: [
                              ElevatedButton(
                                  key: globals.keyButton5,
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    primary: Colors.transparent,
                                    onPrimary: Colors.black,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                  ),
                                  child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  40) /
                                              3,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[300]!, width: 1),
                                      ),
                                      padding: EdgeInsets.zero,
                                      child: Column(children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Pas validés",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            // letterSpacing: 1
                                          ),
                                        ),
                                        Text(
                                          "aujourd'hui",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                              // letterSpacing: 1
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          utils!.addSeparateurMillier(globals
                                                  .dayFeetValidate
                                                  .toString()) +
                                              " pas",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.cyan[700]
                                              // letterSpacing: 1
                                              ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                            margin: EdgeInsets.only(right: 10),
                                            alignment: Alignment.centerRight,
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/foot_icon.png'),
                                              height: 26,
                                            ))
                                      ]))),
                            ]))
                      ]))),
              SizedBox(height: 18),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Obtenez des Kayous supplémentaires",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      // letterSpacing: 1
                    ),
                  )),
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () async {
                        pushNewScreen(
                          context,
                          screen: SmsPage(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          padding: EdgeInsets.zero,
                          child: Row(children: [
                            SizedBox(height: 8),
                            Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  bottom: 5,
                                ),
                                height: 55,
                                child: ClipRRect(
                                    // borderRadius:
                                    //     BorderRadius.circular(50),
                                    child: Image.asset(
                                  'assets/images/logo_sms.png',
                                  fit: BoxFit.fitWidth,
                                ))),
                            SizedBox(width: 25),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Jouez à un jeu SMS",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  // SizedBox(height: 8),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("De ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            )),
                                        Text("5 à 20",
                                            style: TextStyle(
                                                color: Colors.cyan[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(" Ꝃ",
                                            style: TextStyle(
                                                color: Colors.cyan[700],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(" par jeu SMS joué",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ))
                                      ]),
                                  // SizedBox(height: 8),
                                  Text("50 Ꝃ bonus tous les 5 SMS envoyés",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic
                                          // fontWeight: FontWeight.bold
                                          )),
                                ])
                          ])))),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () async {
                        globals.pubOK = false;
                        pushNewScreen(
                          context,
                          screen: AdMobPage(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        ).then((value) {
                          if (globals.pubOK) {
                            utils!.openPopupSuccess(context, "Félicitations!",
                                "Vous venez de gagner 1Ꝃ");
                          } else {}

                          globals.pubOK = false;
                          globals.isValidatePub = true;
                          // }
                        });

                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          padding: EdgeInsets.zero,
                          child: Row(children: [
                            SizedBox(height: 8),
                            Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  bottom: 5,
                                ),
                                height: 60,
                                child: ClipRRect(
                                    // borderRadius:
                                    //     BorderRadius.circular(50),
                                    child: Image.asset(
                                  'assets/images/logo_ads.png',
                                  fit: BoxFit.fitWidth,
                                ))),
                            SizedBox(width: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Visionnez une publicité",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  globals.ads
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              Text("1",
                                                  style: TextStyle(
                                                      color: Colors.cyan[700],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(" Ꝃ",
                                                  style: TextStyle(
                                                      color: Colors.cyan[700],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(" par publicité",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ))
                                            ])
                                      : CountdownTimer(
                                          // endWidget: Text(""),

                                          endTime: globals.endTime,
                                          widgetBuilder:
                                              (_, CurrentRemainingTime? time) {
                                            if (time == null) {
                                              utils!.onTimerEnd();
                                              return Container();
                                            } else {
                                              // print(time);
                                              var timer = ((time.hours == null)
                                                      ? "00"
                                                      : time.hours.toString()) +
                                                  ":" +
                                                  ((time.min == null)
                                                      ? "00"
                                                      : time.min! < 10
                                                          ? "0" +
                                                              time.min
                                                                  .toString()
                                                          : time.min
                                                              .toString()) +
                                                  ":" +
                                                  ((time.sec == null)
                                                      ? "00"
                                                      : time.sec! < 10
                                                          ? "0" +
                                                              time.sec
                                                                  .toString()
                                                          : time.sec
                                                              .toString());

                                              return Text(
                                                  "Gagnez des Kayous dans " +
                                                      timer,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          Colors.orange[700]));
                                            }
                                          }),
                                  SizedBox(height: 8),
                                ])
                          ])))),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () async {
                        globals.currentIndex = 1;
                        globals.bottomNavIndex = 1;
                        globals.chipsValue = "5";
                        widget._callback();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          padding: EdgeInsets.zero,
                          child: Row(children: [
                            SizedBox(height: 8),
                            Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  bottom: 5,
                                ),
                                height: 60,
                                child: ClipRRect(
                                    // borderRadius:
                                    //     BorderRadius.circular(50),
                                    child: Image.asset(
                                  'assets/images/logo_cashback.png',
                                  fit: BoxFit.fitWidth,
                                ))),
                            SizedBox(width: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Consommez chez les partenaires",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text("Bénéficiez du cashback",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      )),
                                  SizedBox(height: 8),
                                ])
                          ])))),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () async {
                        globals.currentIndex = 3;
                        globals.bottomNavIndex = 3;
                        widget._callback();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onPrimary: Colors.white,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          padding: EdgeInsets.zero,
                          child: Row(children: [
                            SizedBox(height: 8),
                            Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                  top: 5,
                                  bottom: 5,
                                ),
                                height: 60,
                                child: ClipRRect(
                                    // borderRadius:
                                    //     BorderRadius.circular(50),
                                    child: Image.asset(
                                  'assets/images/logo_map.png',
                                  fit: BoxFit.fitWidth,
                                ))),
                            SizedBox(width: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Validez un point d'intérêt",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text("Parcourez la carte",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      )),
                                  SizedBox(height: 8),
                                ])
                          ])))),
              SizedBox(height: 50)
            ]))));
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onEvent
    throw UnimplementedError();
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onStart
    throw UnimplementedError();
  }

  @override
  void onButtonPressed(String id) {
    // TODO: implement onButtonPressed
  }

  @override
  void onNotificationPressed() {
    // TODO: implement onNotificationPressed
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onDestroy
    throw UnimplementedError();
  }
}

class _HealthData {
  _HealthData(this.hour, this.steps);

  String hour;
  double steps;
}

   

