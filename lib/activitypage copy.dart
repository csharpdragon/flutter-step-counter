// import 'dart:io';
// import 'dart:isolate';
// import 'dart:typed_data';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:external_path/external_path.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_countdown_timer/current_remaining_time.dart';
// import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:kayou/mappage.dart';
// import 'package:kayou/profilpage.dart';
// import 'package:kayou/tools/globals.dart' as globals;
// import 'package:kayou/tools/utils.dart';
// import 'package:motion_toast/motion_toast.dart';
// import 'package:motion_toast/resources/arrays.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'dart:async';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'admobpage.dart';
// import 'buypage.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:intl/intl.dart';
// import 'package:package_info/package_info.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:intl/intl.dart';
// import 'package:health/health.dart';

// class ActivityPage extends StatefulWidget {
//   final _callback;

//   ActivityPage({required void setStateCallback()})
//       : _callback = setStateCallback;

//   ActivityPageState createState() => ActivityPageState();
// }

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTH_NOT_GRANTED
// }

// class ActivityPageState extends State<ActivityPage> implements TaskHandler {
//   PackageInfo? packageInfo;

//   Pedometer? _pedometer;
//   StreamSubscription<int>? _subscription;

//   Stream<StepCount>? _stepCountStream;
//   Stream<PedestrianStatus>? _pedestrianStatusStream;
//   StreamSubscription<StepCount>? _streamSubscription;

//   // int todaySteps;

//   HealthFactory health = HealthFactory();

//   // define the types to get
//   List<HealthDataType> types = [
//     HealthDataType.STEPS,
//   ];

//   var refreshKey = GlobalKey<RefreshIndicatorState>();

//   ScreenshotController screenshotController = ScreenshotController();

//   String _status = '0', _steps = '0';
//   int line = 1;
//   UtilsState? utils;

//   List<HealthDataPoint> _healthDataList = [];
//   AppState _state = AppState.DATA_NOT_FETCHED;

//   ReceivePort? receivePort;
//   String source = "";

//   var colorPoint = Colors.amber[300];

//   var image = "assets/images/Cagou.png";

//   @override
//   void initState() {
//     utils = new UtilsState();
//     utils.initState();

//     super.initState();

//     checkAutorisation();
//   }

//   @override
//   void dispose() {
//     // stopListening();
//     super.dispose();
//   }

//   void stopListening() {
//     // _subscription.cancel();
//   }

//   checkAutorisation() async {
//     packageInfo = await PackageInfo.fromPlatform();

//     if (globals.autorisationPodometer) {
//       // print(globals.showTutorial);
//       if (globals.showTutorial) {
//         await showTutorial();
//       }
//       initPlatformState();
//     }

//     return false;
//   }

//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     // print(event);
//     _status = event.status;
//     if (_status == "walking") {
//       // image = "assets/images/activite.gif";
//     } else {
//       // image = "assets/images/Cagou.png";
//     }

//     if (mounted) {
//       // setState(() {});
//     }
//   }

//   void onPedestrianStatusError(error) {
//     // print('onPedestrianStatusError: $error');
//     setState(() {
//       _status = 'Pedestrian Status not available';
//     });
//     // print(_status);
//   }

//   Future getTodayStepsIOS(StepCount event) async {
//     if (globals.init) {
//       utils!.setInit(false);
//     }
//     if (globals.lastDay != DateFormat('yyyyMMdd').format(DateTime.now())) {
//       globals.todaySteps = 0;
//       globals.lastDayWin = globals.dayWin;
//       // globals.dayWin = 0;
//       //   await utils.checkDay(0, globals.todaySteps);
//     }
//     //else {
//     await utils!.checkDay(0, globals.todaySteps);

//     // get everything from midnight until now
//     DateTime startDate = DateTime(
//         int.parse(DateFormat('yyyy').format(DateTime.now())),
//         int.parse(DateFormat('MM').format(DateTime.now())),
//         int.parse(DateFormat('dd').format(DateTime.now())),
//         0,
//         0,
//         0);
//     DateTime endDate = DateTime(
//         int.parse(DateFormat('yyyy').format(DateTime.now())),
//         int.parse(DateFormat('MM').format(DateTime.now())),
//         int.parse(DateFormat('dd').format(DateTime.now())),
//         23,
//         59,
//         59);

//     int steps = 0;

//     globals.todaySteps = 0;

//     if (globals.autorisationPodometer) {
//       try {
//         // fetch new data

//         _healthDataList = [];
//         List<HealthDataPoint> healthData =
//             await health.getHealthDataFromTypes(startDate, endDate, types);

//         // save all the new data points
//         _healthDataList.addAll(healthData);
//       } catch (e) {}

//       _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

//       // print the results
//       _healthDataList.forEach((x) {
//         if (Platform.isAndroid) {
//           source = globals.androidInfo!.model;
//         } else {
//           source = globals.iosInfo!.name;
//         }

//         if (x.sourceName == source &&
//             x.dateFrom.year.toString() +
//                     x.dateFrom.month.toString().padLeft(2, '0') +
//                     x.dateFrom.day.toString().padLeft(2, '0') ==
//                 DateFormat('yyyyMMdd').format(DateTime.now())) {
//           // steps += x.value.round();
//         }
//       });

//       globals.todaySteps = steps;

//       utils!.setIntValue('todaySteps', globals.todaySteps);
//     } else {
//       globals.todaySteps = 0;
//     }

//     setState(() {});
//   }

//   getTodayStepsOld(StepCount event) async {
//     if (globals.init) {
//       globals.savedStepsCount = event.steps;

//       utils!.setIntValue("savedStepsCountKey", globals.savedStepsCount);

//       utils!.setInit(false);
//     } else {
//       if (event.steps == 0) {
//         //On est au début du pédometre (redémarrage du téléphone ou nouvelle installation de l'app)

//         globals.savedStepsCount = 0;

//         utils!.setIntValue("savedStepsCountKey", globals.savedStepsCount);
//       } else if (event.steps < globals.savedStepsCount) {
//         globals.savedStepsCount = 0;

//         utils!.setIntValue("savedStepsCountKey", globals.savedStepsCount);
//       }
//     }

//     globals.todaySteps = event.steps - globals.savedStepsCount;

//     await utils!.checkDay(event.steps, globals.todaySteps);

//     utils!.setIntValue('todaySteps', globals.todaySteps);

//     setState(() {});
//   }

//   Future<String> findLocalPath() async {
//     final directory = await ExternalPath.getExternalStoragePublicDirectory(
//         ExternalPath.DIRECTORY_DOWNLOADS);

//     return directory;
//   }

//   Future<String> findLocalPathIos() async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<void> shareImage(Uint8List uint8list) async {
//     //On check les permissions
//     if (await Permission.storage.request().isGranted) {
//       String directory;
//       Platform.isAndroid
//           ? directory =
//               (await findLocalPath()) + Platform.pathSeparator + "screen.jpg"
//           : directory = (await findLocalPathIos()) +
//               Platform.pathSeparator +
//               "screen.jpg";

//       final image = await File(directory).writeAsBytes(uint8list);
//       // print(await image.exists());
//       // await image.writeAsBytes(uint8list, mode: FileMode.write, flush: true);
//       await FlutterShare.shareFile(
//         filePath: image.path,
//         title: 'Pas du jour',
//       );
//     }
//   }

//   _callback() {
//     widget._callback();
//   }

//   void onStepCountError(error) {
//     // print('onStepCountError: $error');
//     // setState(() {
//     //   _steps = 'Step Count not available';
//     // });
//   }

//   void initPlatformState() {
//     _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
//     _pedestrianStatusStream!
//         .listen(onPedestrianStatusChanged)
//         .onError(onPedestrianStatusError);

//     _stepCountStream = Pedometer.stepCountStream;

//     // if (Platform.isAndroid) {
//     //   _stepCountStream.listen(getTodaySteps).onError(onStepCountError);
//     // } else {
//     _stepCountStream!.listen(getTodayStepsIOS).onError(onStepCountError);
//     // }

//     if (!mounted) return;
//   }

//   showTutorial() async {
//     await utils!.initTutorial();
//     TutorialCoachMark tutorial = TutorialCoachMark(context,
//         targets: globals.targets, // List<TargetFocus>
//         colorShadow: Colors.black, // DEFAULT Colors.black
//         // alignSkip: Alignment.bottomRight,
//         textSkip: "Passer le tutoriel",
//         alignSkip: Alignment.topLeft,
//         // paddingFocus: 10,
//         // focusAnimationDuration: Duration(milliseconds: 500),
//         // pulseAnimationDuration: Duration(milliseconds: 500),
//         // pulseVariation: Tween(begin: 1.0, end: 0.99),
//         onFinish: () {
//           globals.showTutorial = false;
//           utils!.setBoolValue("showTutorial", false);
//         },
//         onClickTarget: (target) {},
//         onClickOverlay: (p0) {},
//         onSkip: () {
//           globals.showTutorial = false;
//           utils!.setBoolValue("showTutorial", false);
//         })
//       ..show();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey[200],
//           systemOverlayStyle: SystemUiOverlayStyle(
//               statusBarBrightness: Brightness.light,
//               statusBarIconBrightness: Brightness.dark,
//               statusBarColor: Colors.transparent,
//               systemNavigationBarColor: Colors.transparent,
//               systemNavigationBarDividerColor: Colors.transparent),
//           elevation: 0,
//           toolbarHeight: 50,
//           centerTitle: true,
//           // leading: Container(),
//           leadingWidth: 100,
//           leading: Container(
//               // key: globals.keyButton,
//               // margin: EdgeInsets.only(left: 13, top: 10, bottom: 10, right: 13),
//               // alignment: Alignment.center,
//               // decoration: BoxDecoration(
//               //     borderRadius: BorderRadius.circular(20),
//               //     color: Colors.orange[700]),
//               // child: Text(globals.profitUser.toString() + " Ꝃ",
//               //     style: TextStyle(
//               //         color: Colors.white,
//               //         fontWeight: FontWeight.bold,
//               //         fontSize: 14))
//               ),
//           title: Container(
//               margin: EdgeInsets.only(top: 5, bottom: 5),
//               child: Text("Activité",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18))),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   screenshotController
//                       .capture(delay: Duration(milliseconds: 10))
//                       .then((capturedImage) async {
//                     await shareImage(capturedImage!);
//                   }).catchError((onError) {
//                     print(onError);
//                   });
//                 },
//                 icon: Icon(CupertinoIcons.share)),
//             IconButton(
//                 key: globals.keyButton6,
//                 onPressed: () {
//                   pushNewScreen(context,
//                       screen: ProfilPage(),
//                       withNavBar: true,
//                       pageTransitionAnimation:
//                           PageTransitionAnimation.cupertino);
//                 },
//                 icon: Icon(CupertinoIcons.gear_alt))
//           ],
//         ),
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//             child: Column(children: [
//           SizedBox(height: 10),
//           Screenshot(
//               controller: screenshotController,
//               child: Column(children: [
//                 Container(
//                     width: MediaQuery.of(context).size.width,
//                     alignment: Alignment.center,
//                     color: Colors.white,
//                     child: Text(utils!.getDate(),
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16))),
//                 SizedBox(height: 30),
//                 Container(
//                     padding: EdgeInsets.only(left: 40, right: 40),
//                     color: Colors.white,
//                     child: Stack(
//                         alignment: Alignment.center,
//                         fit: StackFit.loose,
//                         children: [
//                           Container(
//                               width: MediaQuery.of(context).size.width,
//                               height: 300,
//                               child: SfRadialGauge(
//                                 backgroundColor: Colors.transparent,
//                                 axes: <RadialAxis>[
//                                   RadialAxis(
//                                       maximumLabels: 10,
//                                       ranges: <GaugeRange>[
//                                         GaugeRange(
//                                             startValue: 0,
//                                             endValue:
//                                                 globals.todaySteps.toDouble(),
//                                             endWidth: 14,
//                                             startWidth: 14,
//                                             color: Colors.cyan[600]),
//                                       ],
//                                       pointers: [
//                                         //Les points

//                                         MarkerPointer(
//                                           value: 1000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: colorPoint,
//                                           markerType: MarkerType.circle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 3000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: colorPoint,
//                                           markerType: MarkerType.circle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 6000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: colorPoint,
//                                           markerType: MarkerType.circle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 10000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: colorPoint,
//                                           markerType: MarkerType.circle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 15000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: colorPoint,
//                                           markerType: MarkerType.circle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 20000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: colorPoint,
//                                           markerType: MarkerType.circle,
//                                         ),

//                                         //Les tirets

//                                         MarkerPointer(
//                                           value: 1000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: Colors.grey[600],
//                                           markerWidth: 15,
//                                           markerHeight: 3,
//                                           markerOffset: 15,
//                                           markerType: MarkerType.rectangle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 3000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: Colors.grey[600],
//                                           markerWidth: 15,
//                                           markerHeight: 3,
//                                           markerOffset: 15,
//                                           markerType: MarkerType.rectangle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 6000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: Colors.grey[600],
//                                           markerWidth: 15,
//                                           markerHeight: 3,
//                                           markerOffset: 15,
//                                           markerType: MarkerType.rectangle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 10000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: Colors.grey[600],
//                                           markerWidth: 15,
//                                           markerHeight: 3,
//                                           markerOffset: 15,
//                                           markerType: MarkerType.rectangle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 15000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: Colors.grey[600],
//                                           markerWidth: 15,
//                                           markerHeight: 3,
//                                           markerOffset: 15,
//                                           markerType: MarkerType.rectangle,
//                                         ),
//                                         MarkerPointer(
//                                           value: 20000,
//                                           textStyle: GaugeTextStyle(
//                                               fontSize: 19,
//                                               color: Colors.black),
//                                           color: Colors.grey[600],
//                                           markerWidth: 15,
//                                           markerHeight: 3,
//                                           markerOffset: 15,
//                                           markerType: MarkerType.rectangle,
//                                         ),
//                                       ],
//                                       annotations: [
//                                         // Platform.isAndroid
//                                         //     ? globals.autorisationPodometer
//                                         //         ? GaugeAnnotation(
//                                         //             horizontalAlignment:
//                                         //                 GaugeAlignment.center,
//                                         //             verticalAlignment:
//                                         //                 GaugeAlignment.near,
//                                         //             positionFactor: 0,
//                                         //             widget: Container(
//                                         //                 padding:
//                                         //                     EdgeInsets.only(
//                                         //                         left: 10,
//                                         //                         top: 145),
//                                         //                 child: Column(
//                                         //                     crossAxisAlignment:
//                                         //                         CrossAxisAlignment
//                                         //                             .center,
//                                         //                     children: [
//                                         //                       Text(
//                                         //                           // globals
//                                         //                           //     .dayFeet
//                                         //                           //     .toString(),
//                                         //                           globals.todaySteps
//                                         //                                   ?.toString() ??
//                                         //                               '0',
//                                         //                           style: TextStyle(
//                                         //                               color: Colors
//                                         //                                   .black,
//                                         //                               fontSize:
//                                         //                                   40,
//                                         //                               fontWeight:
//                                         //                                   FontWeight
//                                         //                                       .bold)),
//                                         //                       // SizedBox(height: 10),
//                                         //                       Text(
//                                         //                           "pas effectués",
//                                         //                           style: TextStyle(
//                                         //                               color: Colors
//                                         //                                   .black)),
//                                         //                     ])),
//                                         //           )
//                                         //         : GaugeAnnotation(
//                                         //             horizontalAlignment:
//                                         //                 GaugeAlignment.center,
//                                         //             verticalAlignment:
//                                         //                 GaugeAlignment.near,
//                                         //             positionFactor: 0,
//                                         //             widget: Container(),
//                                         //           )
//                                         //     : GaugeAnnotation(
//                                         //         horizontalAlignment:
//                                         //             GaugeAlignment.center,
//                                         //         verticalAlignment:
//                                         //             GaugeAlignment.near,
//                                         //         positionFactor: 0,
//                                         //         widget: Container(
//                                         //             padding: EdgeInsets.only(
//                                         //                 left: 10, top: 170),
//                                         //             child: Column(
//                                         //                 crossAxisAlignment:
//                                         //                     CrossAxisAlignment
//                                         //                         .center,
//                                         //                 children: [
//                                         //                   Text(
//                                         //                       globals.todaySteps
//                                         //                           .toString(),
//                                         //                       style: TextStyle(
//                                         //                           color: Colors
//                                         //                               .black,
//                                         //                           fontSize: 40,
//                                         //                           fontWeight:
//                                         //                               FontWeight
//                                         //                                   .bold)),
//                                         //                   // SizedBox(height: 10),
//                                         //                   Text("pas effectués",
//                                         //                       style: TextStyle(
//                                         //                           color: Colors
//                                         //                               .black)),
//                                         //                 ])),
//                                         //       ),

//                                         //Valeurs
//                                         GaugeAnnotation(
//                                           axisValue: 1000,
//                                           horizontalAlignment:
//                                               GaugeAlignment.near,
//                                           positionFactor: 0.8,
//                                           widget: Container(
//                                               child: Text('1000',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 3000,
//                                           horizontalAlignment:
//                                               GaugeAlignment.near,
//                                           positionFactor: 0.8,
//                                           widget: Container(
//                                               child: Text('3000',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 6000,
//                                           horizontalAlignment:
//                                               GaugeAlignment.near,
//                                           positionFactor: 0.8,
//                                           widget: Container(
//                                               child: Text('6000',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 10000,
//                                           horizontalAlignment:
//                                               GaugeAlignment.center,
//                                           positionFactor: 0.7,
//                                           widget: Container(
//                                               child: Text('10000',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 15000,
//                                           horizontalAlignment:
//                                               GaugeAlignment.far,
//                                           positionFactor: 0.8,
//                                           widget: Container(
//                                               child: Text('15000',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 19500,
//                                           horizontalAlignment:
//                                               GaugeAlignment.far,
//                                           positionFactor: 0.8,
//                                           widget: Container(
//                                               child: Text('20000',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),

//                                         //Les gains
//                                         GaugeAnnotation(
//                                           axisValue: 500,
//                                           horizontalAlignment:
//                                               GaugeAlignment.center,
//                                           positionFactor: 0.98,
//                                           widget: Container(
//                                               width: 100,
//                                               height: 20,
//                                               child: Text('1Ꝃ',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 2800,
//                                           horizontalAlignment:
//                                               GaugeAlignment.center,
//                                           positionFactor: 0.92,
//                                           widget: Container(
//                                               width: 100,
//                                               height: 20,
//                                               child: Text('3Ꝃ',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 6500,
//                                           horizontalAlignment:
//                                               GaugeAlignment.center,
//                                           positionFactor: 0.95,
//                                           widget: Container(
//                                               width: 100,
//                                               height: 20,
//                                               child: Text('6Ꝃ',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 9660,
//                                           horizontalAlignment:
//                                               GaugeAlignment.near,
//                                           positionFactor: 1,
//                                           widget: Container(
//                                               height: 60,
//                                               child: Text('10Ꝃ',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 14800,
//                                           horizontalAlignment:
//                                               GaugeAlignment.near,
//                                           positionFactor: 1,
//                                           widget: Container(
//                                               padding: EdgeInsets.only(
//                                                 left: 15,
//                                               ),
//                                               child: Text('15Ꝃ',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                         GaugeAnnotation(
//                                           axisValue: 22000,
//                                           horizontalAlignment:
//                                               GaugeAlignment.near,
//                                           positionFactor: 1,
//                                           widget: Container(
//                                               padding: EdgeInsets.only(
//                                                 top: 40,
//                                                 left: 5,
//                                               ),
//                                               height: 60,
//                                               child: Text('20Ꝃ',
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors.black))),
//                                         ),
//                                       ],
//                                       minimum: 0,
//                                       maximum: 20000,
//                                       axisLineStyle: AxisLineStyle(
//                                           color: Colors.grey[400],
//                                           thicknessUnit: GaugeSizeUnit.factor,
//                                           thickness: 0.1),
//                                       majorTickStyle: MajorTickStyle(
//                                           length: 0,
//                                           thickness: 1,
//                                           color: Colors.black),
//                                       minorTickStyle: MinorTickStyle(
//                                           length: 6,
//                                           thickness: 1,
//                                           color: Colors.black),
//                                       axisLabelStyle: GaugeTextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 0))
//                                 ],
//                               )),
//                           Container(
//                               alignment: Alignment.center,
//                               width: MediaQuery.of(context).size.width,
//                               // height: 400,
//                               child: Column(
//                                   key: globals.keyButton1,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                         utils!.addSeparateurMillier(
//                                             globals.todaySteps.toString()),
//                                         style: TextStyle(
//                                             color: Colors.cyan[600],
//                                             fontSize: 40,
//                                             fontWeight: FontWeight.bold)),
//                                     // SizedBox(height: 10),
//                                     Text("pas effectués",
//                                         style: TextStyle(color: Colors.black)),
//                                   ]))
//                           // Container(
//                           //   height: 120,
//                           //   width: 120,
//                           //   child: ElevatedButton(
//                           //       style: ElevatedButton.styleFrom(
//                           //         primary: Colors.transparent,
//                           //         onPrimary: Colors.transparent,
//                           //         onSurface: Colors.transparent,
//                           //         shadowColor: Colors.transparent,
//                           //         elevation: 0,
//                           //         splashFactory: NoSplash.splashFactory,
//                           //       ),
//                           //       onPressed: () {
//                           //         setState(() {
//                           //           line = 1;
//                           //           globals.messageCagou = true;
//                           //         });
//                           //       },
//                           //       child: Image.asset(
//                           //         image,
//                           //         height: 120,
//                           //         width: 120,
//                           //         fit: BoxFit.cover,
//                           //       )),
//                           //   padding: EdgeInsets.only(left: 0),
//                           // ))
//                           ,
//                           // globals.messageCagou
//                           //     ? Positioned(
//                           //         top: 50,
//                           //         child: Container(
//                           //             alignment: Alignment.topCenter,
//                           //             width: MediaQuery.of(context).size.width,
//                           //             height: 400,
//                           //             child: Container(
//                           //                 alignment: Alignment.topCenter,
//                           //                 height: 80,
//                           //                 width: 200,
//                           //                 padding: EdgeInsets.only(
//                           //                     left: 5, right: 5),
//                           //                 decoration: BoxDecoration(
//                           //                     borderRadius:
//                           //                         BorderRadius.circular(10),
//                           //                     color: Colors.white,
//                           //                     border: Border.all(
//                           //                         color: Colors.black,
//                           //                         width: 1,
//                           //                         style: BorderStyle.solid)),
//                           //                 child: Column(children: [
//                           //                   AnimatedTextKit(
//                           //                     totalRepeatCount: 1,
//                           //                     // onFinished: () {
//                           //                     //   setState(() {
//                           //                     //     globals.messageCagou = false;
//                           //                     //   });
//                           //                     // },

//                           //                     animatedTexts: [
//                           //                       TyperAnimatedText(
//                           //                           'Bonjour, moi c\'est Kayafou... et je suis ton partenaire de marche!',
//                           //                           textStyle: TextStyle(
//                           //                               color: Colors.black),
//                           //                           speed: Duration(
//                           //                               milliseconds: 80)),
//                           //                     ],
//                           //                     onTap: () {
//                           //                       setState(() {
//                           //                         globals.messageCagou = false;
//                           //                       });
//                           //                     },
//                           //                   ),
//                           //                 ]))),
//                           //       )
//                           //     : Container()
//                         ]))
//               ])),
//           globals.autorisationPodometer
//               ? Column(children: [
//                   // Container(
//                   //     alignment: Alignment.center,
//                   //     height: 57,
//                   //     width: MediaQuery.of(context).size.width,
//                   //     decoration: BoxDecoration(
//                   //         borderRadius: BorderRadius.circular(40),
//                   //         color: Colors.orange[700]),
//                   //     margin: EdgeInsets.only(left: 100, right: 100),
//                   //     child: Text(
//                   //         "Total : " + globals.profitUser.toString() + " Ꝃ",
//                   //         style: TextStyle(
//                   //             color: Colors.white,
//                   //             fontWeight: FontWeight.w600,
//                   //             fontSize: 18))),
//                   Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 57,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(40),
//                           color: Colors.orange[700]),
//                       margin: EdgeInsets.only(left: 100, right: 100),
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.transparent,
//                             onSurface: Colors.transparent,
//                             shadowColor: Colors.transparent,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(40))),
//                           ),
//                           onPressed: () async {
//                             if (await utils.isConnectedToInternet()) {
//                               if (!globals.isValidate) {
//                                 //Validation en cours
//                                 globals.isValidate = true;

//                                 var returnValues = await utils.validateSteps();

//                                 if (returnValues[0]) {
//                                   if (returnValues[1] > 0) {
//                                     Alert(
//                                       context: context,
//                                       type: AlertType.success,
//                                       closeIcon: Container(),
//                                       title: "",
//                                       desc:
//                                           "Félicitations! Vous venez de gagner " +
//                                               returnValues[1].toString() +
//                                               "Ꝃ",
//                                       buttons: [
//                                         DialogButton(
//                                           child: Text(
//                                             "Fermer",
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 18),
//                                           ),
//                                           onPressed: () =>
//                                               Navigator.pop(context),
//                                           color:
//                                               Color.fromRGBO(0, 179, 134, 1.0),
//                                         ),
//                                       ],
//                                     ).show();
//                                   }
//                                 }
//                               }
//                               setState(() {});
//                             } else {
//                               utils.showInternetConnectionDialog(context);
//                             }
//                           },
//                           child: Text("Valider mes pas",
//                               key: globals.keyButton2,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18)))),
//                   SizedBox(height: 25),
//                   Container(
//                       color: Colors.grey[50],
//                       height: 130,
//                       padding: EdgeInsets.only(top: 5),
//                       child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           margin: EdgeInsets.only(left: 35, right: 35),
//                           child: Row(children: [
//                             Container(
//                                 alignment: Alignment.center,
//                                 width:
//                                     (MediaQuery.of(context).size.width - 90) /
//                                         3,
//                                 child: Column(children: [
//                                   ElevatedButton(
//                                       key: globals.keyButton3,
//                                       onPressed: () async {},
//                                       style: ElevatedButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(20))),
//                                         primary: Colors.transparent,
//                                         onPrimary: Colors.black,
//                                         onSurface: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Container(
//                                           width: (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   40) /
//                                               3,
//                                           height: 120,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             color: Colors.white,
//                                             border: Border.all(
//                                                 color: Colors.grey[300],
//                                                 width: 1),
//                                           ),
//                                           padding: EdgeInsets.zero,
//                                           child: Column(children: [
//                                             SizedBox(height: 8),
//                                             Text(
//                                               "Nombre total",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w600,
//                                                 // letterSpacing: 1
//                                               ),
//                                             ),
//                                             Text(
//                                               "de Kayous",
//                                               style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.black
//                                                   // letterSpacing: 1
//                                                   ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               utils.addSeparateurMillier(globals
//                                                       .profitUser
//                                                       .toString()) +
//                                                   " Ꝃ",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.orange[700]
//                                                   // letterSpacing: 1
//                                                   ),
//                                             ),
//                                             SizedBox(height: 8),
//                                             Container(
//                                                 margin:
//                                                     EdgeInsets.only(right: 10),
//                                                 alignment:
//                                                     Alignment.centerRight,
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       'assets/images/moneybox_icon.png'),
//                                                   height: 26,
//                                                 ))
//                                           ]))),
//                                 ])),
//                             SizedBox(width: 10),
//                             Container(
//                                 width:
//                                     (MediaQuery.of(context).size.width - 90) /
//                                         3,
//                                 child: Column(children: [
//                                   ElevatedButton(
//                                       key: globals.keyButton4,
//                                       onPressed: () async {},
//                                       style: ElevatedButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(20))),
//                                         primary: Colors.transparent,
//                                         onPrimary: Colors.black,
//                                         onSurface: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Container(
//                                           width: (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   40) /
//                                               3,
//                                           height: 120,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             color: Colors.white,
//                                             border: Border.all(
//                                                 color: Colors.grey[300],
//                                                 width: 1),
//                                           ),
//                                           padding: EdgeInsets.zero,
//                                           child: Column(children: [
//                                             SizedBox(height: 8),
//                                             Text(
//                                               "Kayous gagnés",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w600,
//                                                 // letterSpacing: 1
//                                               ),
//                                             ),
//                                             Text(
//                                               "aujourd'hui",
//                                               style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.black
//                                                   // letterSpacing: 1
//                                                   ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               globals.dayWin.toString() + " Ꝃ",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.blue[900]
//                                                   // letterSpacing: 1
//                                                   ),
//                                             ),
//                                             SizedBox(height: 8),
//                                             Container(
//                                                 margin:
//                                                     EdgeInsets.only(right: 10),
//                                                 alignment:
//                                                     Alignment.centerRight,
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       'assets/images/medal_icon.png'),
//                                                   height: 26,
//                                                 ))
//                                           ]))),
//                                 ])),
//                             SizedBox(width: 10),
//                             Container(
//                                 width:
//                                     (MediaQuery.of(context).size.width - 90) /
//                                         3,
//                                 child: Column(children: [
//                                   ElevatedButton(
//                                       key: globals.keyButton5,
//                                       onPressed: () async {},
//                                       style: ElevatedButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(20))),
//                                         primary: Colors.transparent,
//                                         onPrimary: Colors.black,
//                                         onSurface: Colors.transparent,
//                                         shadowColor: Colors.transparent,
//                                         padding: EdgeInsets.zero,
//                                       ),
//                                       child: Container(
//                                           width: (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   40) /
//                                               3,
//                                           height: 120,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             color: Colors.white,
//                                             border: Border.all(
//                                                 color: Colors.grey[300],
//                                                 width: 1),
//                                           ),
//                                           padding: EdgeInsets.zero,
//                                           child: Column(children: [
//                                             SizedBox(height: 8),
//                                             Text(
//                                               "Pas validés",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w600,
//                                                 // letterSpacing: 1
//                                               ),
//                                             ),
//                                             Text(
//                                               "aujourd'hui",
//                                               style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.black
//                                                   // letterSpacing: 1
//                                                   ),
//                                             ),
//                                             SizedBox(height: 10),
//                                             Text(
//                                               utils.addSeparateurMillier(globals
//                                                       .dayFeetValidate
//                                                       .toString()) +
//                                                   " pas",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.cyan[600]
//                                                   // letterSpacing: 1
//                                                   ),
//                                             ),
//                                             SizedBox(height: 8),
//                                             Container(
//                                                 margin:
//                                                     EdgeInsets.only(right: 10),
//                                                 alignment:
//                                                     Alignment.centerRight,
//                                                 child: Image(
//                                                   image: AssetImage(
//                                                       'assets/images/foot_icon.png'),
//                                                   height: 26,
//                                                 ))
//                                           ]))),
//                                 ]))
//                           ]))),
//                   SizedBox(height: 10),
//                   Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.only(left: 20, right: 20),
//                       child: Text(
//                         "Gagner des Kayous bonus",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                           // letterSpacing: 1
//                         ),
//                       )),
//                   SizedBox(height: 20),
//                   Container(
//                       height: 225,
//                       alignment: Alignment.center,
//                       // color: Colors.red,r
//                       padding: EdgeInsets.zero,
//                       margin: EdgeInsets.only(left: 20, right: 20, top: 0),
//                       child: ListView.separated(
//                           separatorBuilder: (context, index) => Divider(
//                                 indent: 10,
//                               ),
//                           addAutomaticKeepAlives: false,
//                           addRepaintBoundaries: true,
//                           shrinkWrap: true,
//                           scrollDirection: Axis.horizontal,
//                           padding: EdgeInsets.zero,
//                           itemCount: 3,
//                           itemBuilder: (context, index) {
//                             switch (index) {
//                               case 0:
//                                 return Container(
//                                     height: 180,
//                                     width: 150,
//                                     child: Column(children: [
//                                       ElevatedButton(
//                                           onPressed: () async {
//                                             globals.pubOK = false;
//                                             pushNewScreen(
//                                               context,
//                                               screen: AdMobPage(),
//                                               withNavBar:
//                                                   false, // OPTIONAL VALUE. True by default.
//                                               pageTransitionAnimation:
//                                                   PageTransitionAnimation
//                                                       .cupertino,
//                                             ).then((value) {
//                                               if (globals.pubOK) {
//                                                 utils.openPopupSuccess(
//                                                     context,
//                                                     "Félicitations!",
//                                                     "Vous venez de gagner 1Ꝃ");
//                                               } else {}

//                                               globals.pubOK = false;
//                                               globals.isValidatePub = true;
//                                               // }
//                                             });

//                                             setState(() {});
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             primary: Colors.transparent,
//                                             onPrimary: Colors.white,
//                                             onSurface: Colors.transparent,
//                                             shadowColor: Colors.transparent,
//                                             padding: EdgeInsets.zero,
//                                           ),
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 color: Colors.white,
//                                                 border: Border.all(
//                                                     color: Colors.grey[300],
//                                                     width: 1),
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                               child: Column(children: [
//                                                 SizedBox(height: 8),
//                                                 Container(
//                                                     height: 100,
//                                                     child: ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20),
//                                                         child: Image.asset(
//                                                           'assets/images/logo_ads.png',
//                                                           fit: BoxFit.fitWidth,
//                                                         ))),
//                                                 SizedBox(height: 8),
//                                                 Text("Regardez",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 Text("une publicité",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 SizedBox(height: 8),
//                                                 Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Text("1",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .green[700],
//                                                               fontSize: 12,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold)),
//                                                       Text(" Ꝃ",
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .green[700],
//                                                               fontSize: 12,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold)),
//                                                       Text(" par publicité",
//                                                           style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 12,
//                                                           ))
//                                                     ]),
//                                                 SizedBox(height: 8),
//                                               ]))),
//                                       globals.ads
//                                           ? Container()
//                                           : CountdownTimer(
//                                               // endWidget: Text(""),

//                                               endTime: globals.endTime,
//                                               widgetBuilder: (_,
//                                                   CurrentRemainingTime time) {
//                                                 if (time == null) {
//                                                   utils.onTimerEnd();
//                                                   return Container();
//                                                 } else {
//                                                   // print(time);
//                                                   var timer = ((time.hours ==
//                                                               null)
//                                                           ? "00"
//                                                           : time.hours
//                                                               .toString()
//                                                               .substring(1)) +
//                                                       ":" +
//                                                       ((time.min == null)
//                                                           ? "00"
//                                                           : time.min < 10
//                                                               ? "0" +
//                                                                   time.min
//                                                                       .toString()
//                                                               : time.min
//                                                                   .toString()) +
//                                                       ":" +
//                                                       ((time.sec == null)
//                                                           ? "00"
//                                                           : time.sec < 10
//                                                               ? "0" +
//                                                                   time.sec
//                                                                       .toString()
//                                                               : time.sec
//                                                                   .toString());

//                                                   return Text(
//                                                       "Gagnez des Kayous dans " +
//                                                           timer,
//                                                       style: TextStyle(
//                                                           fontSize: 10,
//                                                           color: Colors
//                                                               .orange[700]));
//                                                 }
//                                               })
//                                     ]));

//                                 break;
//                               case 1:
//                                 return Container(
//                                     height: 180,
//                                     width: 160,
//                                     child: Column(children: [
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             globals.currentIndex = 2;
//                                             globals.bottomNavIndex = 2;
//                                             widget._callback();
//                                             setState(() {});
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             primary: Colors.transparent,
//                                             onPrimary: Colors.white,
//                                             onSurface: Colors.transparent,
//                                             shadowColor: Colors.transparent,
//                                             padding: EdgeInsets.zero,
//                                           ),
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 color: Colors.white,
//                                                 border: Border.all(
//                                                     color: Colors.grey[300],
//                                                     width: 1),
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                               child: Column(children: [
//                                                 SizedBox(height: 8),
//                                                 Container(
//                                                     height: 100,
//                                                     child: ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20),
//                                                         child: Image.asset(
//                                                           'assets/images/logo_map.png',
//                                                           fit: BoxFit.fitWidth,
//                                                         ))),
//                                                 SizedBox(height: 8),
//                                                 Text("Validez",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 Text("un point d'intérêt",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 SizedBox(height: 8),
//                                                 Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       // Text("1",
//                                                       //     style: TextStyle(
//                                                       //         color: Colors
//                                                       //             .green[700],
//                                                       //         fontSize: 12,
//                                                       //         fontWeight:
//                                                       //             FontWeight
//                                                       //                 .bold)),
//                                                       // Text(" Ꝃ",
//                                                       //     style: TextStyle(
//                                                       //         color: Colors
//                                                       //             .green[700],
//                                                       //         fontSize: 12,
//                                                       //         fontWeight:
//                                                       //             FontWeight
//                                                       //                 .bold)),
//                                                       Text("Parcourez la carte",
//                                                           style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 12,
//                                                           ))
//                                                     ]),
//                                                 SizedBox(height: 8),
//                                               ]))),
//                                     ]));

//                                 break;

//                               case 2:
//                                 return Container(
//                                     height: 180,
//                                     width: 160,
//                                     child: Column(children: [
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             globals.currentIndex = 3;
//                                             globals.bottomNavIndex = 3;
//                                             widget._callback();
//                                             setState(() {});
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             primary: Colors.transparent,
//                                             onPrimary: Colors.white,
//                                             onSurface: Colors.transparent,
//                                             shadowColor: Colors.transparent,
//                                             padding: EdgeInsets.zero,
//                                           ),
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 color: Colors.white,
//                                                 border: Border.all(
//                                                     color: Colors.grey[300],
//                                                     width: 1),
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                               child: Column(children: [
//                                                 SizedBox(height: 8),
//                                                 Container(
//                                                     height: 100,
//                                                     child: ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20),
//                                                         child: Image.asset(
//                                                           'assets/images/logo_cashback.png',
//                                                           fit: BoxFit.fitWidth,
//                                                         ))),
//                                                 SizedBox(height: 8),
//                                                 Text("Consommez",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 Text("chez les partenaires",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 SizedBox(height: 8),
//                                                 Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       // Text("1",
//                                                       //     style: TextStyle(
//                                                       //         color: Colors
//                                                       //             .green[700],
//                                                       //         fontSize: 12,
//                                                       //         fontWeight:
//                                                       //             FontWeight
//                                                       //                 .bold)),
//                                                       // Text(" Ꝃ",
//                                                       //     style: TextStyle(
//                                                       //         color: Colors
//                                                       //             .green[700],
//                                                       //         fontSize: 12,
//                                                       //         fontWeight:
//                                                       //             FontWeight
//                                                       //                 .bold)),
//                                                       Text(
//                                                           "Bénéficiez du cashback",
//                                                           style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontSize: 12,
//                                                           ))
//                                                     ]),
//                                                 SizedBox(height: 8),
//                                               ]))),
//                                     ]));

//                                 break;
//                             }
//                           })),
//                   SizedBox(height: 20)
//                 ])
//               : ElevatedButton(
//                   onPressed: () async {
//                     await utils.checkActivityAutorisation();

//                     if (globals.autorisationPodometer) {
//                       initPlatformState();
//                       setState(() {});
//                     } else {
//                       if (Platform.isIOS) {
//                         utils.openPopupAutorisationIOS(context);
//                       }
//                     }
//                   },
//                   child: Text("Commencer à gagner des Kayous",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600)),
//                 ),
//         ])));
//   }

//   Future<dynamic> ShowCapturedWidget(
//       BuildContext context, Uint8List capturedImage) {
//     return showDialog(
//       useSafeArea: false,
//       context: context,
//       builder: (context) => Scaffold(
//         appBar: AppBar(
//           title: Text("Captured widget screenshot"),
//         ),
//         body: Center(
//             child: capturedImage != null
//                 ? Image.memory(capturedImage)
//                 : Container()),
//       ),
//     );
//   }

//   @override
//   Future<void> onDestroy(DateTime timestamp) {
//     // TODO: implement onDestroy
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> onEvent(DateTime timestamp, SendPort sendPort) {
//     // TODO: implement onEvent
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> onStart(DateTime timestamp, SendPort sendPort) {
//     // TODO: implement onStart
//     throw UnimplementedError();
//   }
// }
