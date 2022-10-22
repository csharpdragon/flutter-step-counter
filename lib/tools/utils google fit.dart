// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chips_choice/chips_choice.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_countdown_timer/current_remaining_time.dart';
// import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:health/health.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:package_info/package_info.dart';
// import 'package:permission_handler/permission_handler.dart';
// import "package:kayou/tools/globals.dart" as globals;
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:map_launcher/map_launcher.dart' as map;
// import "package:flutter_feather_icons/flutter_feather_icons.dart";
// import 'package:app_settings/app_settings.dart';

// import '../detail-dealpage.dart';
// import '../detail-giftpage.dart';

// class Utils extends StatefulWidget {
//   UtilsState createState() => UtilsState();
// }

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTH_NOT_GRANTED
// }

// class UtilsState extends State<Utils> {
//   SharedPreferences _prefs;

//   globals.Level level;

//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   HealthFactory health = HealthFactory();

//   // define the types to get
//   List<HealthDataType> types = [
//     HealthDataType.STEPS,
//   ];

//   @override
//   void initState() {
//     globals.controller = PersistentTabController(
//       initialIndex: 0,
//     );

//     super.initState();

//     initMenus();
//   }

//   initTutorial() {
//     globals.targets = [];

//     globals.targets.add(TargetFocus(
//         identify: "Target1",
//         keyTarget: globals.keyButton1,
//         contents: [
//           TargetContent(
//               align: ContentAlign.bottom,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15, top: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Le chiffre correspond à votre nombre de pas quotidien. Il est réinitialisé tous les jours.",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));

//     globals.targets.add(TargetFocus(
//         identify: "Target2",
//         keyTarget: globals.keyButton2,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               padding: EdgeInsets.only(bottom: 80),
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Lorsque vous avez atteint le quota de pas par palier, pensez à valider vos pas pour gagner vos Kayous",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));

//     globals.targets.add(TargetFocus(
//         identify: "Target3",
//         keyTarget: globals.keyButton3,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Ce chiffre correspond à votre cagnotte de Kayous que vous pourrez utiliser chez les commerçants partenaire.",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));

//     globals.targets.add(TargetFocus(
//         identify: "Target4",
//         keyTarget: globals.keyButton4,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Ce chiffre correspond au nombre de Kayous que vous gagnez par jour. Il est réinitialisé tous les jours.",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));

//     globals.targets.add(TargetFocus(
//         identify: "Target5",
//         keyTarget: globals.keyButton5,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Ce chiffre est le nombre de pas que vous avez validé sur la journée",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));
//     globals.targets.add(TargetFocus(
//         identify: "Target6",
//         keyTarget: globals.keyBottomNavigation2,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Echangez vos Kayous contre des bons d'achats chez nos partenaires",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));
//     globals.targets.add(TargetFocus(
//         identify: "Target7",
//         keyTarget: globals.keyBottomNavigation3,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Rendez vous aux différents points d'intérêts, validez lorsque vous êtes dans le cercle vert et gagnez encore plus de Kayous",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));
//     globals.targets.add(TargetFocus(
//         identify: "Target8",
//         keyTarget: globals.keyBottomNavigation4,
//         contents: [
//           TargetContent(
//               align: ContentAlign.top,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Consommez chez nos partenaires et gagnez encore plus de Kayous",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));
//     globals.targets.add(TargetFocus(
//         identify: "Target9",
//         keyTarget: globals.keyButton6,
//         contents: [
//           TargetContent(
//               align: ContentAlign.bottom,
//               child: Container(
//                 margin: EdgeInsets.only(left: 15, right: 15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Pour accéder à votre espace personnel, cliquer sur cette icone",
//                       textAlign: TextAlign.justify,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ))
//         ]));
//   }

//   openMap(String merchand, String latitude, String longitude,
//       String description) async {
//     // print(merchand);
//     // print(description);
//     if (await map.MapLauncher.isMapAvailable(map.MapType.google)) {
//       await map.MapLauncher.showMarker(
//         mapType: map.MapType.google,
//         coords: map.Coords(double.parse(latitude), double.parse(longitude)),
//         title: merchand,
//         description: description,
//       );
//     } else if (await map.MapLauncher.isMapAvailable(map.MapType.apple)) {
//       await map.MapLauncher.showMarker(
//         mapType: map.MapType.apple,
//         coords: map.Coords(double.parse(latitude), double.parse(longitude)),
//         title: merchand,
//         description: description,
//       );
//     } else if (await map.MapLauncher.isMapAvailable(map.MapType.waze)) {
//       await map.MapLauncher.showMarker(
//         mapType: map.MapType.waze,
//         coords: map.Coords(double.parse(latitude), double.parse(longitude)),
//         title: merchand,
//         description: description,
//       );
//     }
//   }

//   updateHistorique(String uid, String type, String description, int total,
//       String date) async {
// // RCP = Recompense
// // CBK = Cashback
// // PAS = Compteur pas
// // KJR = Kayou gagné par jour
// // PUB = Kayou gagné en regardant une PUB
//     try {
//       var result;
//       List detail = [];
//       String dateTemp;
//       if (date.length > 0) {
//         dateTemp = date.substring(0, 4) +
//             "-" +
//             date.substring(4, 6) +
//             "-" +
//             date.substring(6, 8);
//       }

//       // print(dateTemp);

//       detail.add({
//         "date": date.length > 0
//             ? new DateFormat("yyyy-MM-dd").parse(dateTemp).toUtc()
//             : DateTime.now(),
//         "type": type,
//         "description": description,
//         "total": total
//       });

//       //On récupere le dernier historique de l'utilisateur
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .where("uid", isEqualTo: uid)
//           .limit(1)
//           .get();

//       var doc = data.docs.first;
//       if (doc.get("historical").length > 0) {
//         //On check si le tableau dépasse les 500 enregistrements
//         var historicalNow = await FirebaseFirestore.instance
//             .collection('historical')
//             .doc(doc.get("historical"))
//             .get();

//         result = historicalNow.data();

//         if (result["details"].length >= 500) {
//           //On ajout eun nouvel enregistrement
//           await FirebaseFirestore.instance
//               .collection('historical')
//               .add({"details": FieldValue.arrayUnion(detail), "uid": uid}).then(
//                   (value) async {
//             //On maj l'identifiant de l'historique sur la fiche utilisateur
//             await FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(doc.id)
//                 .update({"historical": value.id});
//           });
//         } else {
//           //On maj l'historique en cours

//           await FirebaseFirestore.instance
//               .collection('historical')
//               .doc(doc.get("historical"))
//               .update({"details": FieldValue.arrayUnion(detail)});
//         }
//       } else {
//         await FirebaseFirestore.instance
//             .collection('historical')
//             .add({"details": FieldValue.arrayUnion(detail), "uid": uid}).then(
//                 (value) async {
//           //On maj l'identifiant de l'historique sur la fiche utilisateur
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(doc.id)
//               .update({"historical": value.id});
//         }).catchError((error) {
//           print(error.toString());
//         });
//       }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   setPoints(int points, bool ads) async {
//     int pointsBDD;
//     int nbAds = 0;

//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .get();

//       if (data.exists) {
//         pointsBDD = data.get("points");
//         if (data.data().containsKey('todayAds')) {
//           nbAds = data.get("todayAds");
//         }

//         if (ads) {
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(globals.user?.uid)
//               .update(
//                   {"points": (pointsBDD + points), "todayAds": (nbAds + 1)});

//           if (((nbAds + 1) % 4) == 0) {
//             globals.ads = false;
//             setTimer();
//           } else {
//             onTimerEnd();
//           }
//         } else {
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(globals.user?.uid)
//               .update({
//             "points": (pointsBDD + points),
//           });
//         }

//         globals.profitUser = (pointsBDD + points);

//         if (ads) {
//           globals.todayAds = (nbAds + 1);
//         }
//       }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   updatePointOfInterest(String id, int points) async {
//     int pointsBDD;
//     int pointsToday;

//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .get();

//       // if (data.exists) {
//       pointsBDD = data.get("points");
//       pointsToday = getValue(data, "todayPoints", "int");
//       // if (data.data().containsKey('todayPoints')) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .update({
//         "points": (pointsBDD + points),
//         "todayPoints": (pointsToday + points),
//         "todayMap": FieldValue.arrayUnion([id])
//       }).then((value) async {
//         globals.validatePointsOfInterest.add(id);

//         for (var i = globals.circles.length - 1; i >= 0; i--) {
//           if (globals.circles.elementAt(i).circleId == CircleId(id)) {
//             globals.circles.remove(globals.circles.elementAt(i));
//           }
//         }
//         globals.profitUser = (pointsBDD + points);
//         globals.dayWin = (pointsToday + points);
//       });

//       // }
//       // else{

//       // }
//       // }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   updatePoints(int points, String palier, bool ads) async {
//     int pointsBDD;
//     int pointsToday;
//     int nbAds = 0;

//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .get();

//       if (data.exists) {
//         pointsBDD = data.get("points");
//         pointsToday = getValue(data, "todayPoints", "int");
//         if (data.data().containsKey('todayAds')) {
//           nbAds = data.get("todayAds");
//         }

//         if (ads) {
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(globals.user?.uid)
//               .update({
//             "points": (pointsBDD + points),
//             "todayAds": (nbAds + 1),
//             "todayPoints": (pointsToday + points)
//           });

//           //On maj maintenant l'historique de l'utilisateur
//           await updateHistorique(
//               globals.uidParrainage, "PUB", data.get("merchand"), 1, "");

//           if (((nbAds + 1) % 4) == 0) {
//             globals.ads = false;
//             setTimer();
//           } else {
//             onTimerEnd();
//           }
//         } else {
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(globals.user?.uid)
//               .update({
//             "points": (pointsBDD + points),
//             'todayFeet.' + palier: true,
//             "todayPoints": (pointsToday + points)
//           });
//         }

//         globals.profitUser = (pointsBDD + points);

//         globals.dayWin = (pointsToday + points);

//         if (ads) {
//           globals.todayAds = (nbAds + 1);
//         }
//       }

//       print(globals.dayWin);

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   updatePointsPaliers(int points, List<String> palier) async {
//     int pointsBDD;
//     int pointsToday;

//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .get();

//       if (data.exists) {
//         pointsBDD = data.get("points");
//         pointsToday = getValue(data, "todayPoints", "int");

//         Map<String, Object> palierTemp = {};
//         palierTemp.addAll({"points": (pointsBDD + points)});
//         palierTemp.addAll({"todayPoints": (pointsToday + points)});
//         palier.forEach((element) {
//           palierTemp.addAll({'todayFeet.' + element: true});
//         });

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(globals.user?.uid)
//             .update(palierTemp);

//         //On maj l'historique

//         updateHistorique(globals.uidParrainage, "PJR", "", points, "");

//         globals.profitUser = (pointsBDD + points);

//         globals.dayWin = (pointsToday + points);
//       }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   updatePub(int points, String description) async {
//     int pointsBDD;
//     int pointsToday;
//     int nbAds = 0;

//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .get();

//       if (data.exists) {
//         pointsBDD = data.get("points");
//         pointsToday = getValue(data, "todayPoints", "int");
//         if (data.data().containsKey('todayAds')) {
//           nbAds = data.get("todayAds");
//         }

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(globals.user?.uid)
//             .update({
//           "points": (pointsBDD + points),
//           "todayAds": (nbAds + 1),
//           "todayPoints": (pointsToday + points)
//         });

//         //On maj maintenant l'historique de l'utilisateur
//         await updateHistorique(
//             globals.uidParrainage, "PUB", description, 1, "");

//         if (((nbAds + 1) % 4) == 0) {
//           globals.ads = false;
//           setTimer();
//         } else {
//           onTimerEnd();
//         }

//         globals.profitUser = (pointsBDD + points);

//         globals.dayWin = (pointsToday + points);

//         globals.todayAds = (nbAds + 1);
//       }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   usePoints(int points) async {
//     int pointsBDD;

//     try {
//       var data = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .get();

//       if (data.exists) {
//         pointsBDD = data.get("points");

//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(globals.user?.uid)
//             .update({"points": (pointsBDD - points)});

//         globals.profitUser = (pointsBDD - points);
//       }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   initMenus() {
//     globals.Menu menu;

//     C2Choice<String> choiceItemsTemp;

//     globals.menusGifts = [];
//     // globals.menusDeals = [];
//     globals.choiceItemsMenuGifts = [];

//     menu = new globals.Menu("Bons d'achats", "1", []);
//     globals.menusGifts.add(menu);

//     choiceItemsTemp = new C2Choice<String>(
//       label: "Bons d'achats",
//       value: "1",
//       activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//       disabled: false,
//       selected: true,
//     );

//     globals.choiceItemsMenuGifts.add(choiceItemsTemp);

//     menu = new globals.Menu("Cadeaux", "2", []);
//     globals.menusGifts.add(menu);

//     choiceItemsTemp = new C2Choice<String>(
//         label: "Cadeaux",
//         value: "2",
//         activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//         disabled: false,
//         selected: false);

//     globals.choiceItemsMenuGifts.add(choiceItemsTemp);

//     // menu = new globals.Menu("Donations", "3", []);
//     // globals.menusGifts.add(menu);

//     // choiceItemsTemp = new C2Choice<String>(
//     //     label: "Donations",
//     //     value: "3",
//     //     activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//     //     disabled: false,
//     //     selected: false);

//     // globals.choiceItemsMenuGifts.add(choiceItemsTemp);

//     menu = new globals.Menu("Versements", "4", []);
//     globals.menusGifts.add(menu);

//     choiceItemsTemp = new C2Choice<String>(
//         label: "Versements",
//         value: "4",
//         activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//         disabled: false,
//         selected: false);

//     globals.choiceItemsMenuGifts.add(choiceItemsTemp);

//     menu = new globals.Menu("Bons plans", "5", []);
//     // globals.menusDeals.add(menu);

//     globals.selectedMenuGifts = new globals.Menu("Récompenses", "1", []);
//     globals.selectedMenuWinGifts = new globals.Menu("Cadeaux", "2", []);
//     globals.selectedMenuTransfers = new globals.Menu("Versements", "4", []);
//   }

//   String addSeparateurMillier(String price) {
//     int indiceLetter = 0;
//     String priceAndCurrency = "";

//     for (var i = price.length - 1; i >= 0; i--) {
//       if (indiceLetter == 3) {
//         indiceLetter = 0;
//         priceAndCurrency = " " + priceAndCurrency;
//       }

//       priceAndCurrency = price[i] + priceAndCurrency;
//       indiceLetter++;
//     }

//     return priceAndCurrency;
//   }

//   Widget getCountDownTimer(BuildContext context) {
//     double fontSizeTimer = 36;
//     double widthTimer = 40;
//     double heightTimer = 55;

//     return CountdownTimer(
//       // endWidget: Text(""),

//       endTime: globals.endTime,
//       widgetBuilder: (_, CurrentRemainingTime time) {
//         if (time == null) {
//           globals.endTimer = true;
//         }
//         return Container(
//           child: Row(
//             children: [
//               Container(
//                   width: widthTimer,
//                   height: heightTimer,
//                   color: Colors.red[400],
//                   child: Center(
//                       child: Text(
//                     (time == null)
//                         ? "0"
//                         : (time.hours == null)
//                             ? "0"
//                             : time.hours.toString().substring(0, 1),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSizeTimer,
//                         fontWeight: FontWeight.bold),
//                   ))),
//               SizedBox(
//                 width: 2,
//               ),
//               Container(
//                   width: widthTimer,
//                   height: heightTimer,
//                   color: Colors.red[400],
//                   child: Center(
//                       child: Text(
//                     (time == null)
//                         ? "0"
//                         : (time.hours == null)
//                             ? "0"
//                             : time.hours.toString().substring(1),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSizeTimer,
//                         fontWeight: FontWeight.bold),
//                   ))),
//               SizedBox(
//                 width: 5,
//               ),
//               Container(
//                   width: widthTimer,
//                   height: heightTimer,
//                   color: Colors.red[400],
//                   child: Center(
//                       child: Text(
//                     (time == null)
//                         ? "0"
//                         : (time.min == null)
//                             ? "0"
//                             : time.min
//                                 .toString()
//                                 .padLeft(2, '0')
//                                 .substring(0, 1),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSizeTimer,
//                         fontWeight: FontWeight.bold),
//                   ))),
//               SizedBox(
//                 width: 2,
//               ),
//               Container(
//                   width: widthTimer,
//                   height: heightTimer,
//                   color: Colors.red[400],
//                   child: Center(
//                       child: Text(
//                     (time == null)
//                         ? "0"
//                         : (time.min == null)
//                             ? "0"
//                             : time.min.toString().padLeft(2, '0').substring(1),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSizeTimer,
//                         fontWeight: FontWeight.bold),
//                   ))),
//               SizedBox(
//                 width: 5,
//               ),
//               Container(
//                   width: widthTimer,
//                   height: heightTimer,
//                   color: Colors.red[400],
//                   child: Center(
//                       child: Text(
//                     (time == null)
//                         ? "0"
//                         : (time.sec == null)
//                             ? "0"
//                             : time.sec
//                                 .toString()
//                                 .padLeft(2, '0')
//                                 .substring(0, 1),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSizeTimer,
//                         fontWeight: FontWeight.bold),
//                   ))),
//               SizedBox(
//                 width: 2,
//               ),
//               Container(
//                   width: widthTimer,
//                   height: heightTimer,
//                   color: Colors.red[400],
//                   child: Center(
//                       child: Text(
//                     (time == null)
//                         ? "0"
//                         : (time.sec == null)
//                             ? "0"
//                             : time.sec.toString().padLeft(2, '0').substring(1),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: fontSizeTimer,
//                         fontWeight: FontWeight.bold),
//                   ))),
//             ],
//           ),
//         );
//         // 'min: [ ${time.min} ], sec: [ ${time.sec} ]');
//       },
//     );
//   }

//   validateSteps() async {
//     try {
//       // globals.todaySteps = 10000;
//       int lastStep = 0;

//       int validatePoints = 0;

//       bool isValid = false;
//       List<String> palier = [];
//       int points = 0;

//       // if (!globals.isValidate) {
//       // globals.dayFeetValidate = globals.todaySteps;
//       // setFeet('dayFeetValidate', globals.dayFeetValidate);

//       // globals.dayWin = 0;

//       for (var i = 0; i < globals.levels!.length; i++) {
//         if (!globals.levels![i].isChecked) {
//           if (globals.todaySteps >= globals.levels![i].level) {
//             //On maj maintenant la fiche utilisateur
//             validatePoints += globals.levels![i].profit - lastStep;
//             palier.add("p" + (i + 1).toString());
//             points += globals.levels![i].profit - lastStep;
//           }
//         }
//         // else {
//         //   globals.dayWin += globals.levels![i].profit - lastStep;
//         // }
//         lastStep = globals.levels![i].profit;
//       }

//       if (palier.length > 0) {
//         if (await updatePointsPaliers(points, palier)) {
//           isValid = true;
//           palier.forEach((element) {
//             //On maj le palier
//             switch (element) {
//               case 'p1':
//                 {
//                   globals.levels![0].isChecked = true;
//                   globals.palier1000 = true;

//                   break;
//                 }
//               case 'p2':
//                 {
//                   globals.levels![1].isChecked = true;
//                   globals.palier3000 = true;

//                   break;
//                 }
//               case 'p3':
//                 {
//                   globals.levels![2].isChecked = true;
//                   globals.palier6000 = true;
//                   break;
//                 }
//               case 'p4':
//                 {
//                   globals.levels![3].isChecked = true;
//                   globals.palier10000 = true;
//                   break;
//                 }
//               case 'p5':
//                 {
//                   globals.levels![4].isChecked = true;
//                   globals.palier15000 = true;
//                   break;
//                 }
//               case 'p6':
//                 {
//                   globals.levels![5].isChecked = true;
//                   globals.palier20000 = true;
//                   break;
//                 }
//             }
//           });
//         }

//         if (isValid) {
//           globals.dayFeetValidate = globals.todaySteps;
//           setFeet('dayFeetValidate', globals.dayFeetValidate);
//         }
//       } else {
//         globals.dayFeetValidate = globals.todaySteps;
//         setFeet('dayFeetValidate', globals.dayFeetValidate);
//       }

//       globals.isValidate = false;

//       return [true, validatePoints];
//     } catch (e) {
//       print(e.toString());
//       globals.isValidate = false;
//       return [false, 0];
//     }
//   }

//   countPalier() {
//     int lastStep = 0;

//     int palierWin = 0;

//     for (var i = 0; i < globals.levels!.length; i++) {
//       if (globals.levels![i].isChecked) {
//         palierWin += globals.levels![i].profit - lastStep;
//       }
//       lastStep = globals.levels![i].profit;
//     }

//     // globals.dayWin += palierWin;
//   }

//   showPopupWarning(BuildContext context, String alert) {
//     Alert(
//       context: context,
//       type: AlertType.warning,
//       closeIcon: Container(),
//       title: "",
//       desc: alert,
//       buttons: [
//         DialogButton(
//           child: Text(
//             "Fermer",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           onPressed: () => Navigator.pop(context),
//           color: Color.fromRGBO(0, 179, 134, 1.0),
//         ),
//       ],
//     ).show();
//   }

//   showPopupOK(BuildContext context) {
//     Alert(
//       context: context,
//       type: AlertType.success,
//       closeIcon: Container(),
//       title: "",
//       desc: "Mise à jour effectuée",
//       buttons: [
//         DialogButton(
//           child: Text(
//             "Fermer",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           onPressed: () => Navigator.pop(context, "OK"),
//           color: Color.fromRGBO(0, 179, 134, 1.0),
//         ),
//       ],
//     ).show();
//   }

//   initLevels() async {
//     //On met à jour les paliers
//     globals.levels! = [];
//     level = new globals.Level(1000, 1, globals.palier1000);
//     globals.levels!.add(level);
//     level = new globals.Level(3000, 3, globals.palier3000);
//     globals.levels!.add(level);
//     level = new globals.Level(6000, 6, globals.palier6000);
//     globals.levels!.add(level);
//     level = new globals.Level(10000, 10, globals.palier10000);
//     globals.levels!.add(level);
//     level = new globals.Level(15000, 15, globals.palier15000);
//     globals.levels!.add(level);
//     level = new globals.Level(20000, 20, globals.palier20000);
//     globals.levels!.add(level);

//     // await countPalier();
//   }

//   getDate() {
//     var today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     DateFormat dateFormatDay = DateFormat("EEEE");
//     DateFormat dateFormatYear = DateFormat("yyyy");
//     DateFormat dateFormatJour = DateFormat("dd");
//     DateFormat dateFormatFirebase = DateFormat("yyyy-MM-dd");
//     DateFormat dateFormatMois =
//         DateFormat(globals.dictionnary["dateDayFormat"]);

//     String date = globals.dictionnary[dateFormatDay
//             .format(dateFormatFirebase.parse(today))
//             .toLowerCase()
//             .toString()] +
//         " " +
//         dateFormatJour.format(dateFormatFirebase.parse(today)) +
//         " " +
//         globals.dictionnary[dateFormatMois
//             .format(dateFormatFirebase.parse(today))
//             .toLowerCase()
//             .toString()] +
//         " " +
//         dateFormatYear.format(dateFormatFirebase.parse(today));

//     return date;
//   }

//   getUserPoints() async {
//     var data = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(globals.user?.uid)
//         .get();

//     if (!data.exists) {
//       globals.profitUser = 0;
//       globals.dayWin = 0;
//     } else {
//       globals.profitUser = data.get('points');
//       globals.dayWin = getValue(data, 'todayPoints', "int");
//     }
//   }

//   getAge(DateTime birthDate) {
//     DateTime currentDate = DateTime.now();
//     int age = currentDate.year - birthDate.year;
//     int month1 = currentDate.month;
//     int month2 = birthDate.month;
//     if (month2 > month1) {
//       age--;
//     } else if (month1 == month2) {
//       int day1 = currentDate.day;
//       int day2 = birthDate.day;
//       if (day2 > day1) {
//         age--;
//       }
//     }

//     // print("age = " + age.toString());
//     return age;
//   }

//   checkAndCreateAccount(User user) async {
//     var today = DateFormat('yyyyMMdd').format(DateTime.now());

//     globals.palier1000 = false;
//     globals.palier2000 = false;
//     globals.palier3000 = false;
//     globals.palier4000 = false;
//     globals.palier5000 = false;
//     globals.palier6000 = false;
//     globals.palier7000 = false;
//     globals.palier8000 = false;
//     globals.palier9000 = false;
//     globals.palier10000 = false;
//     globals.palier11000 = false;
//     globals.palier12000 = false;
//     globals.palier13000 = false;
//     globals.palier14000 = false;
//     globals.palier15000 = false;
//     globals.palier16000 = false;
//     globals.palier17000 = false;
//     globals.palier18000 = false;
//     globals.palier19000 = false;
//     globals.palier20000 = false;

//     var data = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     //On créé la fiche utilisateur car il est nouveau
//     if (!data.exists) {
//       var uidUser = "";
//       uidUser = globals.user?.uid.substring(0, 4) +
//           globals.user?.uid.substring(
//               globals.user?.uid.length - 4, globals.user?.uid.length);

//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'email': user.email == null ? "" : user.email,
//         'points': 50,
//         'tel': '',
//         'adress': '',
//         'name': '',
//         'uid': uidUser,
//         'pseudo': 'Guest-' + uidUser,
//         'parrain': '',
//         'codeParrain': '',
//         'historical': '',
//         'todayAds': 0,
//         'birth': '',
//         'height': 0,
//         'weight': 0,
//         'sex': '',
//         'todayMap': [],
//         'todayPoints': 0,
//         'lastDay': today,
//         'todayFeet': {
//           "p1": false,
//           "p2": false,
//           "p3": false,
//           "p4": false,
//           "p5": false,
//           "p6": false,
//           "p7": false,
//           "p8": false,
//           "p9": false,
//           "p10": false,
//           "p11": false,
//           "p12": false,
//           "p13": false,
//           "p14": false,
//           "p15": false,
//           "p16": false,
//           "p17": false,
//           "p18": false,
//           "p19": false,
//           "p20": false,
//         }
//       });

//       globals.profitUser = 50;
//       globals.email = user.email == null ? "" : user.email;
//       globals.tel = "";
//       globals.adress = "";
//       globals.name = "";
//       globals.pseudo = 'Guest-' + uidUser;
//       globals.uidParrainage = uidUser;
//       globals.parrain = '';
//       globals.codeParrain = '';
//       globals.dateNaissance = '';
//       globals.taille = 0;
//       globals.poids = 0;
//       globals.sexe = '';
//       globals.todayAds = 0;
//       globals.validatePointsOfInterest = [];
//     } else {
//       globals.profitUser = data.get('points');

//       globals.email = data.get('email');
//       globals.tel = data.get('tel');
//       globals.adress = data.get('adress');
//       globals.name = data.get('name');
//       globals.uidParrainage = data.get('uid');
//       globals.pseudo = data.get('pseudo');
//       globals.codeParrain = data.get('codeParrain');
//       globals.parrain = data.get('parrain');
//       globals.todayAds = getValue(data, "todayAds", "int");
//       globals.todayFeet = getValue(data, "todayFeet", "map");
//       globals.dayWin = getValue(data, "todayPoints", "int");

//       globals.dateNaissance = getValue(data, "birth", "String");
//       globals.taille = getValue(data, "height", "int");
//       globals.poids = getValue(data, "weight", "int");
//       globals.sexe = getValue(data, "sex", "String");
//       globals.validatePointsOfInterest = getValue(data, "todayMap", "array");

//       if (globals.dateNaissance.length > 0) {
//         getAge(DateTime.parse(globals.dateNaissance.substring(6, 10) +
//             '-' +
//             globals.dateNaissance.substring(3, 5) +
//             '-' +
//             globals.dateNaissance.substring(0, 2) +
//             ' 00:00:00'));
//       }

//       if (globals.todayFeet.isNotEmpty) {
//         globals.palier1000 = globals.todayFeet["p1"];
//         globals.palier2000 = globals.todayFeet["p2"];
//         globals.palier3000 = globals.todayFeet["p3"];
//         globals.palier4000 = globals.todayFeet["p4"];
//         globals.palier5000 = globals.todayFeet["p5"];
//         globals.palier6000 = globals.todayFeet["p6"];
//         globals.palier7000 = globals.todayFeet["p7"];
//         globals.palier8000 = globals.todayFeet["p8"];
//         globals.palier9000 = globals.todayFeet["p9"];
//         globals.palier10000 = globals.todayFeet["p10"];
//         globals.palier11000 = globals.todayFeet["p11"];
//         globals.palier12000 = globals.todayFeet["p12"];
//         globals.palier13000 = globals.todayFeet["p13"];
//         globals.palier14000 = globals.todayFeet["p14"];
//         globals.palier15000 = globals.todayFeet["p15"];
//         globals.palier16000 = globals.todayFeet["p16"];
//         globals.palier17000 = globals.todayFeet["p17"];
//         globals.palier18000 = globals.todayFeet["p18"];
//         globals.palier19000 = globals.todayFeet["p19"];
//         globals.palier20000 = globals.todayFeet["p20"];
//       }

//       if ((globals.todayAds % 4) == 0 && globals.todayAds > 0 && globals.init) {
//         globals.ads = false;
//         if (!globals.setTimer) {
//           await setTimer();
//         }
//       } else {
//         // print("NOpe");
//         // print(globals.endTime);
//         globals.endTime > 0 ? globals.ads = false : globals.ads = true;
//       }
//     }

//     await initLevels();

//     return true;
//   }

//   onTimerEnd() {
//     globals.setTimer = false;
//     globals.endTime = 0;
//     setBoolValue('setTimer', false);
//     setIntValue('timer', 0);
//     globals.ads = true;
//   }

//   setTimer() async {
//     // (globals.setTimer)
//     //     ? globals.endTime = getIntValue('timer')
//     //     :
//     globals.endTime = DateTime.now().millisecondsSinceEpoch + 3600000;
//     globals.setTimer = true;

//     setIntValue('timer', globals.endTime);

//     setBoolValue('setTimer', true);
//   }

//   getValue(
//       DocumentSnapshot<Map<String, dynamic>> doc, String key, String type) {
//     if (doc.data().containsKey(key)) {
//       return doc.get(key);
//     } else {
//       switch (type) {
//         case "String":
//           return "";
//           break;

//         case "array":
//           return [];
//           break;

//         case "int":
//           return 0;
//           break;

//         case "bool":
//           return false;
//           break;

//         case "map":
//           return {};
//           break;
//         default:
//       }
//     }
//   }

//   Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
//     return showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return new WillPopScope(
//               onWillPop: () async => false,
//               child: SimpleDialog(
//                   key: key,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   // backgroundColor: Colors.black54,
//                   children: <Widget>[
//                     Center(
//                       child: Column(children: [
//                         CircularProgressIndicator(
//                           backgroundColor: Colors.orange[700],
//                           valueColor:
//                               new AlwaysStoppedAnimation<Color>(Colors.black),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           globals.dictionnary["WaitingLib"],
//                           style: TextStyle(color: Colors.orange[700]),
//                         )
//                       ]),
//                     )
//                   ]));
//         });
//   }

//   updateAds(String uid) async {
//     int nbViews = 0;
//     try {
//       var data =
//           await FirebaseFirestore.instance.collection('ads').doc(uid).get();

//       if (data.exists) {
//         nbViews = data.get("views");

//         await FirebaseFirestore.instance
//             .collection('ads')
//             .doc(uid)
//             .update({"views": (nbViews + 1)});
//       }

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   Future<bool> sendEmail(
//       BuildContext context, String email, String subject, String body) async {
//     String username = 'noreply@kayou.nc';
//     String password = 'Dbg9tfykVeVGk9Mn';

//     final smtpServer = SmtpServer('ssl0.ovh.net',
//         username: username, password: password, port: 587);

//     // Create our email message.
//     final message = Message()
//       ..from = Address(username)
//       ..recipients.add(email) //recipent email
//       ..subject = subject
//       ..text = body; //body of the email
//     // print("Envoi de l'OTP4");
//     try {
//       final sendReport = await send(message, smtpServer);
//       // print("Envoi de l'OTP");

//       return true;
//     } on MailerException catch (e) {
//       print(e.toString());
//       // print("Erreur Envoi de l'OTP");

//       return false;
//       // e.toString() will show why the email is not sending
//     }
//   }

//   Future<void> makePhoneCall(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   signOut() async {
//     await FirebaseAuth.instance.signOut().whenComplete(() {
//       globals.user = null;
//       globals.profitUser = 0;
//       globals.email = "";
//       globals.tel = "";
//       globals.adress = "";
//       globals.name = "";
//       globals.pseudo = "";
//       globals.uidParrainage = "";
//       globals.parrain = "";
//       globals.codeParrain = "";
//     });

//     return true;
//   }

//   setInit(bool init) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.setBool('init', init);
//     globals.init = init;
//   }

//   setPalier(String key, bool value) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.setBool(key, value);
//   }

//   setFeet(String key, int steps) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.setInt(key, steps);
//   }

//   checkDay(int steps, int todaySteps) async {
//     int stepsDay = todaySteps;
//     int stepsHealth = 0;

//     String yesterday = globals.lastDay;
//     //On vérifie la derniere date enregistré
//     if (globals.lastDay != DateFormat('yyyyMMdd').format(DateTime.now())) {
//       // if (Platform.isIOS) {
//       List<HealthDataPoint> _healthDataListYesterday = [];
// // get everything from midnight until now
//       DateTime startDate = DateTime(
//           int.parse(globals.lastDay.substring(0, 4)),
//           int.parse(globals.lastDay.substring(4, 6)),
//           int.parse(globals.lastDay.substring(6, 8)),
//           0,
//           0,
//           0);
//       DateTime endDate = DateTime(
//           int.parse(globals.lastDay.substring(0, 4)),
//           int.parse(globals.lastDay.substring(4, 6)),
//           int.parse(globals.lastDay.substring(6, 8)),
//           23,
//           59,
//           59);

//       if (globals.autorisationPodometer) {
//         try {
//           _healthDataListYesterday = [];

//           List<HealthDataPoint> healthData =
//               await health.getHealthDataFromTypes(startDate, endDate, types);

//           _healthDataListYesterday.addAll(healthData);
//         } catch (e) {}

//         // filter out duplicates
//         _healthDataListYesterday =
//             HealthFactory.removeDuplicates(_healthDataListYesterday);

//         // print the results
//         _healthDataListYesterday.forEach((x) {
//           // print("Data point: $x");
//           // stepsHealth += x.value.round();
//         });

//         stepsDay = stepsHealth;
//       }
//       // }

//       _prefs = await SharedPreferences.getInstance();

//       if (await initUserInfos()) {
//         //On change de jour
//         _prefs.setString(
//             'lastDay', DateFormat('yyyyMMdd').format(DateTime.now()));
//         _prefs.setInt('lastDayWin', globals.lastDayWin);
//         globals.lastFeet = stepsDay;

//         // if (Platform.isAndroid) {
//         // }

//         globals.savedStepsCount = steps;

// //On réinit les pas maintenant

//         // globals.todaySteps = steps - globals.savedStepsCount;
//         globals.todaySteps = 0;

//         // print(_prefs.getInt('savedStepsCountKey'));

//         globals.isValidate = false;

//         globals.dayFeetValidate = 0;
//         globals.dayWin = 0;
//         globals.todaySteps = 0;
//         await _prefs.setInt("todaySteps", globals.todaySteps);
//         await _prefs.setInt("dayFeetValidate", globals.todaySteps);
//         await _prefs.setInt("savedStepsCountKey", steps);
//         globals.lastDay = DateFormat('yyyyMMdd').format(DateTime.now());
//         initLevels();

//         // print("last day = " + globals.lastDay);

//         setFeet('lastFeet', todaySteps);

//         //On créé l'historique pour les pas
//         if (await addFeetDB(yesterday, globals.lastFeet)) {
//           checkUpdateFeetDB();
//         }
//       }
//     }
//   }

//   initDB() async {
//     globals.db = await openDatabase('kayou.db');

//     //On créé maintenant la table feet
//     await globals.db.execute(
//         'CREATE TABLE IF NOT EXISTS FEET (DATE TEXT PRIMARY KEY, TOTAL INTEGER, DATEMAJ INTEGER)');

//     // await addFeetDB("20200501", 1000);
//     // await addFeetDB("20200502", 2000);
//     // await addFeetDB("20200503", 3000);
//     // await addFeetDB("20200504", 4000);
//     // await addFeetDB("20200505", 5000);
//     // await addFeetDB("20200506", 6000);
//     // await addFeetDB("20200507", 7000);

//     await getFeetDB();

//     deleteFeetDB();
//   }

//   getFeetDB() async {
//     List<Map> maps = await globals.db.query(
//       "FEET",
//       columns: ["DATE", "TOTAL", "DATEMAJ"],
//     );

//     if (maps.length > 0) {
//       for (var i = 0; i < maps.length; i++) {
//         // print(maps[i]["DATE"].toString() +
//         //     " = " +
//         //     maps[i]["TOTAL"].toString() +
//         //     " ===> " +
//         //     maps[i]["DATEMAJ"].toString());
//       }
//     }
//   }

//   deleteFeetDB() async {
//     DateTime dateTemp = DateTime.now();

//     // dateTemp.subtract(Duration(days: 2));

//     List<Map> maps = await globals.db.query("FEET",
//         columns: ["DATE", "TOTAL", "DATEMAJ"],
//         where: '"DATEMAJ" <= ?',
//         whereArgs: [int.parse(DateFormat('yyyyMMdd').format(dateTemp))]);

//     if (maps.length > 0) {
//       for (var i = 0; i < maps.length; i++) {
//         await globals.db.transaction((txn) async {
//           var batch = txn.batch();

//           batch.delete('FEET',
//               where: 'DATE = ?',
//               whereArgs: [int.parse(maps[i]["DATE"].toString())]);

//           batch.commit();
//         });
//       }
//     }
//   }

//   checkUpdateFeetDB() async {
//     List<Map> maps = await globals.db.query("FEET",
//         columns: ["DATE", "TOTAL", "DATEMAJ"],
//         where: '"DATEMAJ" = ?',
//         whereArgs: [0]);

//     if (maps.length > 0) {
//       for (var i = 0; i < maps.length; i++) {
//         //On maj les pas non mis à jour
//         if (await updateHistorique(globals.uidParrainage, "PAS", "",
//             maps[i]["TOTAL"], maps[i]["DATE"].toString())) {
//           //On maj la base locale
//           await globals.db.transaction((txn) async {
//             var batch = txn.batch();

//             batch.update(
//                 'FEET',
//                 {
//                   'DATEMAJ':
//                       int.parse(DateFormat('yyyyMMdd').format(DateTime.now()))
//                 },
//                 where: 'DATE = ?',
//                 whereArgs: [maps[i]["DATE"].toString()]);

//             batch.commit();
//           });
//         }
//       }
//     }
//   }

//   addFeetDB(String date, int feet) async {
//     try {
//       await globals.db.transaction((txn) async {
//         var batch = txn.batch();

//         batch.insert('FEET', {
//           'DATE': date,
//           'TOTAL': feet,
//           'DATEMAJ': 0,
//         });

//         batch.commit();
//       });

//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   initUserInfos() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(globals.user?.uid)
//           .update({
//         'todayFeet.p1': false,
//         'todayFeet.p2': false,
//         'todayFeet.p3': false,
//         'todayFeet.p4': false,
//         'todayFeet.p5': false,
//         'todayFeet.p6': false,
//         'todayAds': 0,
//         'todayPoints': 0,
//         'todayMap': []
//       });

//       //On recalcul maintenant les paliers pour le nombre de pas car le compteur inclu l'ensemble des kayous gagnés (pub, cashback, parrainage, etc...)
//       int lastStep = 0;

//       int palierWin = 0;

//       for (var i = 0; i < globals.levels!.length; i++) {
//         if (globals.levels![i].isChecked) {
//           palierWin += globals.levels![i].profit - lastStep;
//         }
//         lastStep = globals.levels![i].profit;
//       }

//       globals.palier1000 = false;
//       globals.palier3000 = false;
//       globals.palier6000 = false;
//       globals.palier10000 = false;
//       globals.palier15000 = false;
//       globals.palier20000 = false;
//       globals.ads = true;
//       globals.lastDayWin = palierWin;
//       globals.dayWin = 0;
//       globals.validatePointsOfInterest = [];

//       await initLevels();

//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }

//   getIntValue(String key) async {
//     _prefs = await SharedPreferences.getInstance();
//     // print((_prefs.getInt(key) ?? 0));
//     return (_prefs.getInt(key) ?? 0);
//   }

//   setIntValue(String key, int value) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.setInt(key, value);
//   }

//   setBoolValue(String key, bool value) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.setBool(key, value);
//   }

//   getBoolValue(String key) async {
//     _prefs = await SharedPreferences.getInstance();
//     // print((_prefs.getString(key) ?? ""));
//     return (_prefs.getBool(key) ?? false);
//   }

//   getStringValue(String key) async {
//     _prefs = await SharedPreferences.getInstance();
//     // print((_prefs.getString(key) ?? ""));
//     return (_prefs.getString(key) ?? "");
//   }

//   setStringValue(String key, String value) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.setString(key, value);
//   }

//   getFeet(String key) async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefs.getInt(key);
//   }

//   checkActivityAutorisation() async {
//     // if (Platform.isAndroid) {
//     //   if (await Permission.activityRecognition.request().isGranted) {
//     //     globals.autorisationPodometer = true;
//     //   } else {
//     //     globals.autorisationPodometer = false;
//     //   }
//     // } else {
//     // you MUST request access to the data types before reading them
//     PermissionStatus status = await Permission.activityRecognition.request();
//     bool hasHealthAccess = await health.requestAuthorization(types);

//     if (status.isGranted && hasHealthAccess) {
//       globals.autorisationPodometer = true;
//     } else {
//       globals.autorisationPodometer = false;
//     }

//     try {
//       DateTime startDate = DateTime(
//           int.parse(DateFormat('yyyy').format(DateTime.now())) - 1,
//           01,
//           01,
//           0,
//           0,
//           0);
//       DateTime endDate = DateTime.now();

//       List<HealthDataPoint> healthData =
//           await health.getHealthDataFromTypes(startDate, endDate, types);

//       // print(healthData);

//       if (healthData.length == 0) {
//         globals.todaySteps = 0;
//       }
//     } catch (e) {
//       globals.autorisationPodometer = false;
//       globals.todaySteps = 0;
//     }
//     // }

//     // print(globals.autorisationAndroid);
//   }

//   openPopupPromo(BuildContext context, String merchand, String codePromo) {
//     showGeneralDialog(
//         barrierColor: Colors.black.withOpacity(0.5),
//         transitionBuilder: (context, a1, a2, widget) {
//           final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
//           return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaleFactor: 1.0,
//               ),
//               child: Transform(
//                 transform:
//                     Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//                 child: Opacity(
//                   opacity: a1.value,
//                   child: AlertDialog(
//                     insetPadding: EdgeInsets.zero,
//                     contentPadding: EdgeInsets.zero,
//                     shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.0)),
//                     content: Container(
//                       alignment: Alignment.center,
//                       height: 200,
//                       width: 40,
//                       padding: EdgeInsets.zero,
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               height: 70,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(16),
//                                       topRight: Radius.circular(16)),
//                                   color: Colors.grey[600]),
//                               child: Text(merchand,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18)),
//                             ),
//                             SizedBox(height: 30),
//                             Container(
//                                 margin: EdgeInsets.only(left: 20, right: 20),
//                                 child: Text("Ci-dessous votre code promo : ",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(fontSize: 13))),
//                             SizedBox(height: 30),
//                             Container(
//                                 margin: EdgeInsets.only(left: 20, right: 20),
//                                 child: Text(codePromo,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold))),
//                             SizedBox(height: 30),
//                             Container(
//                                 margin: EdgeInsets.only(left: 20, right: 20),
//                                 child: Column(children: [
//                                   Text("Un email vous sera également envoyé.",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 13)),
//                                   Text(
//                                       "Si vous le perdez avant de l'avoir utilisé, n'hésitez pas à contacter le support.",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 13))
//                                 ])),
//                             SizedBox(height: 30),
//                           ]),
//                     ),
//                   ),
//                 ),
//               ));
//         },
//         transitionDuration: Duration(milliseconds: 200),
//         barrierDismissible: true,
//         barrierLabel: '',
//         context: context,
//         pageBuilder: (context, animation1, animation2) {});
//   }

//   openPopupMerchand(BuildContext context, dynamic element) {
//     var rcp;
//     var cbk;

//     if (element.get("activeDeal")) {
//       cbk = Container(
//           // margin: EdgeInsets.only(left: 10, right: 10),
//           child: Column(children: [
//         Container(
//             width: MediaQuery.of(context).size.width,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   primary: Colors.transparent, elevation: 0),
//               onPressed: () {
//                 pushNewScreen(context,
//                     screen: DetailGiftPage(element.id, "1"),
//                     withNavBar: true,
//                     pageTransitionAnimation: PageTransitionAnimation.cupertino);
//               },
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Icon(CupertinoIcons.tag),
//                     Text(
//                         addSeparateurMillier(
//                                 element.get("deal")["price"].toString()) +
//                             " Ꝃ",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green[700])),
//                     Text(" par "),
//                     Text(
//                         addSeparateurMillier(
//                                 element.get("deal")["priceDeal"].toString()) +
//                             " XPF",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green[700])),
//                     Text(" dépensés"),
//                     Icon(Icons.arrow_forward_ios_rounded,
//                         color: Colors.grey[400])
//                   ]),
//             )),
//         Container(
//             margin: EdgeInsets.only(left: 10, right: 10),
//             child: Divider(
//               height: 1,
//               color: Colors.grey[300],
//             ))
//       ]));
//     } else {
//       cbk = Container();
//     }

//     if (element.get("activeGift")) {
//       rcp = Container(
//           // margin: EdgeInsets.only(left: 10, right: 10),
//           child: Column(children: [
//         Container(
//             width: MediaQuery.of(context).size.width,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   primary: Colors.transparent, elevation: 0),
//               onPressed: () {
//                 pushNewScreen(context,
//                     screen: DetailGiftPage(element.id, "1"),
//                     withNavBar: true,
//                     pageTransitionAnimation: PageTransitionAnimation.cupertino);
//               },
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Icon(CupertinoIcons.gift),
//                     Text(element.get("gift")["title"],
//                         style: TextStyle(color: Colors.deepOrange[900])),
//                     Icon(Icons.arrow_forward_ios_rounded,
//                         color: Colors.grey[400])
//                   ]),
//             )),
//         Container(
//             margin: EdgeInsets.only(left: 10, right: 10),
//             child: Divider(
//               height: 1,
//               color: Colors.grey[300],
//             ))
//       ]));
//     } else {
//       rcp = Container();
//     }

//     showGeneralDialog(
//         barrierColor: Colors.black.withOpacity(0.5),
//         transitionBuilder: (context, a1, a2, widget) {
//           final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
//           return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaleFactor: 1.0,
//               ),
//               child: Transform(
//                 transform:
//                     Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//                 child: Opacity(
//                   opacity: a1.value,
//                   child: AlertDialog(
//                     insetPadding: EdgeInsets.zero,
//                     contentPadding: EdgeInsets.zero,
//                     shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.0)),
//                     content: Container(
//                       // alignment: Alignment.center,
//                       height: 250,
//                       width: 40,
//                       padding: EdgeInsets.zero,
//                       child: Column(
//                           // mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               // alignment: Alignment.center,
//                               height: 70,
//                               margin:
//                                   EdgeInsets.only(left: 10, right: 10, top: 5),
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(16),
//                                     topRight: Radius.circular(16)),
//                               ),
//                               child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CachedNetworkImage(
//                                       imageUrl: element.get("logo"),
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                         width: 60,
//                                         height: 60,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(60),
//                                           image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       placeholder: (context, url) => Container(
//                                           height: 60,
//                                           width: 60,
//                                           child: Center(
//                                               child: Container(
//                                                   height: 20,
//                                                   width: 20,
//                                                   child:
//                                                       CircularProgressIndicator(
//                                                     valueColor:
//                                                         new AlwaysStoppedAnimation<
//                                                                 Color>(
//                                                             Colors.grey[400]),
//                                                   )))),
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                     Container(
//                                         width:
//                                             MediaQuery.of(context).size.width -
//                                                 200,
//                                         alignment: Alignment.center,
//                                         child: Text(element.get("name"),
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18)))
//                                   ]),
//                             ),
//                             Container(
//                                 margin: EdgeInsets.only(
//                                   left: 10,
//                                   right: 10,
//                                 ),
//                                 child: Divider(
//                                   color: Colors.black,
//                                 )),
//                             rcp,
//                             cbk,
//                             SizedBox(height: 10),
//                             Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Container(
//                                     margin: EdgeInsets.only(
//                                       left: 10,
//                                       right: 10,
//                                     ),
//                                     width: 120,
//                                     child: ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                             alignment: Alignment.centerRight,
//                                             primary: Colors.transparent,
//                                             elevation: 0,
//                                             onSurface: Colors.transparent,
//                                             padding: EdgeInsets.zero,
//                                             shadowColor: Colors.transparent),
//                                         onPressed: () {
//                                           openMap(
//                                               element.get("name"),
//                                               element.get("latitude"),
//                                               element.get("longitude"),
//                                               "");
//                                         },
//                                         child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Text("Itinéraire",
//                                                   style: TextStyle(
//                                                       color: Colors
//                                                           .lightBlue[300])),
//                                               SizedBox(width: 5),
//                                               Icon(FeatherIcons.navigation,
//                                                   color: Colors.lightBlue[300]),
//                                             ]))))
//                           ]),
//                     ),
//                   ),
//                 ),
//               ));
//         },
//         transitionDuration: Duration(milliseconds: 200),
//         barrierDismissible: true,
//         barrierLabel: '',
//         context: context,
//         pageBuilder: (context, animation1, animation2) {});
//   }

//   openPopupAutorisationIOS(BuildContext context) {
//     showGeneralDialog(
//         barrierColor: Colors.black.withOpacity(0.5),
//         transitionBuilder: (context, a1, a2, widget) {
//           final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
//           return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaleFactor: 1.0,
//               ),
//               child: Transform(
//                 transform:
//                     Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//                 child: Opacity(
//                   opacity: a1.value,
//                   child: AlertDialog(
//                     insetPadding: EdgeInsets.zero,
//                     contentPadding: EdgeInsets.zero,
//                     shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.0)),
//                     content: Container(
//                       alignment: Alignment.center,
//                       height: 320,
//                       width: 40,
//                       padding: EdgeInsets.zero,
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               height: 70,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(16),
//                                       topRight: Radius.circular(16)),
//                                   color: Colors.grey[600]),
//                               child: Text("Erreur de récupération des données",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18)),
//                             ),
//                             SizedBox(height: 30),
//                             Container(
//                                 margin: EdgeInsets.only(left: 20, right: 20),
//                                 child: Column(children: [
//                                   Text("Impossible de récupérer vos pas.",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 13)),
//                                   Text(
//                                       "Merci d'aller dans les réglages pour donner les autorisations sur l'application Santé.",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 13)),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       onPrimary: Colors.transparent,
//                                       elevation: 0,
//                                       onSurface: Colors.transparent,
//                                       primary: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                     ),
//                                     child: Text("Ouvrir les réglages",
//                                         style: TextStyle(color: Colors.blue)),
//                                     onPressed: () {
//                                       AppSettings.openDeviceSettings();
//                                     },
//                                   ),
//                                 ])),
//                             SizedBox(height: 10),
//                             Container(
//                                 margin: EdgeInsets.only(left: 20, right: 20),
//                                 child: Column(children: [
//                                   Text(
//                                       "Une fois les autorisations données, merci de cliquer de nouveau sur \"Commencer à gagner des Kayous\"",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(fontSize: 13)),
//                                 ])),
//                             SizedBox(height: 30),
//                           ]),
//                     ),
//                   ),
//                 ),
//               ));
//         },
//         transitionDuration: Duration(milliseconds: 200),
//         barrierDismissible: true,
//         barrierLabel: '',
//         context: context,
//         pageBuilder: (context, animation1, animation2) {});
//   }

//   Future<dynamic> openPopupSuccess(
//       BuildContext context, String desc1, String desc2) {
//     return Alert(
//       context: context,
//       // type: AlertType.success,
//       closeIcon: Container(),
//       title: "",

//       image: Icon(
//         Icons.check_circle_outline_outlined,
//         size: 100,
//         color: Colors.green[800],
//       ),
//       // desc: "Félicitations! Vous venez de gagner 1Ꝃ",
//       content: Column(children: [
//         desc1.length > 0
//             ? Text(
//                 desc1,
//                 textAlign: TextAlign.center,
//               )
//             : Container(),
//         desc2.length > 0
//             ? Text(
//                 desc2,
//                 textAlign: TextAlign.center,
//               )
//             : Container()
//       ]),
//       buttons: [
//         DialogButton(
//           child: Text(
//             "Fermer",
//             style: TextStyle(
//                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           onPressed: () => Navigator.pop(context),
//           color: Color(0xFF2E7D32),
//         ),
//       ],
//     ).show();
//   }

//   openQRCode(BuildContext context) {
//     showGeneralDialog(
//         barrierColor: Colors.black.withOpacity(0.5),
//         transitionBuilder: (context, a1, a2, widget) {
//           final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
//           return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaleFactor: 1.0,
//               ),
//               child: Transform(
//                 transform:
//                     Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//                 child: Opacity(
//                   opacity: a1.value,
//                   child: AlertDialog(
//                     insetPadding: EdgeInsets.zero,
//                     contentPadding: EdgeInsets.zero,
//                     shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.0)),
//                     content: Container(
//                       alignment: Alignment.center,
//                       height: 400,
//                       width: 40,
//                       padding: EdgeInsets.zero,
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                                 alignment: Alignment.center,
//                                 height: 70,
//                                 width: MediaQuery.of(context).size.width,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(16),
//                                         topRight: Radius.circular(16)),
//                                     color: Colors.grey[600]),
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text("Vous avez actuellement ",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold)),
//                                       SizedBox(height: 8),
//                                       Text(globals.profitUser.toString() + " Ꝃ",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold))
//                                     ])),
//                             SizedBox(height: 30),
//                             QrImage(
//                               data: globals.uidParrainage,
//                               size: 155,
//                             ),
//                             SizedBox(height: 5),
//                             Text("Votre identifiant : " + globals.uidParrainage,
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontSize: 13)),
//                             SizedBox(height: 30),
//                             Container(
//                                 margin: EdgeInsets.only(left: 40, right: 40),
//                                 child: Text(
//                                     "Faites scanner votre code-barres par un de nos partenaires pour bénéficier de vos avantages.",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(fontSize: 13))),
//                           ]),
//                     ),
//                   ),
//                 ),
//               ));
//         },
//         transitionDuration: Duration(milliseconds: 200),
//         barrierDismissible: true,
//         barrierLabel: '',
//         context: context,
//         pageBuilder: (context, animation1, animation2) {});
//   }

//   openLink(String link) async {
//     if (await canLaunch(link)) {
//       await launch(link);
//     }
//   }

//   showInternetConnectionDialog(BuildContext context) async {
//     return showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return new WillPopScope(
//               onWillPop: () async => false,
//               child: SimpleDialog(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   // backgroundColor: Colors.black54,
//                   children: <Widget>[
//                     Center(
//                       child: Padding(
//                           padding: EdgeInsets.only(left: 20, right: 20),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Vous n'êtes pas connecté à Internet",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Text(
//                                   "Vérifiez votre connexion internet s'il vous plait",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(color: Colors.black),
//                                 )
//                               ])),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                         height: 40,
//                         margin: EdgeInsets.only(left: 60, right: 60),
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.orange[700],
//                               onPrimary: Colors.white,
//                               onSurface: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10))),
//                             ),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text(globals.dictionnary["Close"])))
//                   ]));
//         });
//   }

//   Future<bool> isConnectedToInternet() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       // I am connected to a mobile network, make sure there is actually a net connection.
//       if (await DataConnectionChecker().hasConnection) {
//         // Mobile data detected & internet connection confirmed.
//         return true;
//       } else {
//         // Mobile data detected but no internet connection found.
//         return false;
//       }
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       // I am connected to a WIFI network, make sure there is actually a net connection.
//       if (await DataConnectionChecker().hasConnection) {
//         // Wifi detected & internet connection confirmed.
//         return true;
//       } else {
//         // Wifi detected but no internet connection found.
//         return false;
//       }
//     } else {
//       // Neither mobile data or WIFI detected, not internet connection found.
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
