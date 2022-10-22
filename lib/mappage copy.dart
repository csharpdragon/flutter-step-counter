// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:chips_choice/chips_choice.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:kayou/tools/globals.dart' as globals;
// import 'package:kayou/tools/utils.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';

// import 'package:loading_animations/loading_animations.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'detail-dealpage.dart';

// class MapPage extends StatefulWidget {
//   MapPageState createState() => MapPageState();
// }

// class MapPageState extends State<MapPage> {
//   int _index = 0;
//   int indexMarker;
//   ValueNotifier valueNotifier;

//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   final initialPage = (.161251195141521521142025 // :)
//           *
//           1e6)
//       .round();

//   List<C2Choice<globals.ChipMap>> choiceItems;
//   List<C2Choice<globals.ChipMap>> choiceItemsSave;
//   C2Choice<globals.ChipMap> choiceItemsTemp;
//   List<globals.ChipMap> chipsValue;

//   globals.ChipMap chipMap;

//   LatLng newPosition;
//   CameraPosition newCameraPosition =
//       CameraPosition(target: LatLng(36.6993, 3.1755), zoom: 10);

//   GoogleMapController mapController;
//   Set<Marker> markers = {};

//   Set<Circle> circlesSave = {};

//   static List<MarkersModel> markersList = [];
//   static List<MarkersModel> markersListSave = [];

//   List<dynamic> pointsOfInterestSave = [];

//   Position position;

//   int nbPosition;

//   bool isLocationActive = false;

//   var myFuture;

//   UtilsState utils;
//   LatLng _center;

//   void initState() {
//     utils = new UtilsState();
//     utils.initState();
//     super.initState();

//     // indexMarker = 1;

//     valueNotifier = ValueNotifier(indexMarker);

//     _center = const LatLng(-22.27178294211219, 166.43859106720822);

//     myFuture = getCategoriesDeals(globals.categoriesDealMap.length == 0);
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;

//     setState(() {});

//     // mapController.animateCamera(CameraUpdate.newLatLngBounds(
//     //     LatLngBounds(
//     //         southwest: LatLng(-22.903346978494355, 162.94251556555986),
//     //         northeast: LatLng(-19.4095698967684, 168.8513048483849)),
//     //     100));
//   }

//   //******* getMarkers */
//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
//         .buffer
//         .asUint8List();
//   }

//   Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

//   getPointsOfInterest() async {
//     pointsOfInterestSave = [];
//     circlesSave = {};

//     var data = await FirebaseFirestore.instance
//         .collection('map')
//         .where("published", isEqualTo: true)
//         .orderBy("name")
//         .get();

//     data.docs.forEach((value) {
//       if (!globals.validatePointsOfInterest.contains(value.id)) {
//         circlesSave.add(Circle(
//             fillColor: Colors.green[700].withOpacity(0.4),
//             strokeColor: Colors.green[700],
//             circleId: CircleId(value.id),
//             radius: double.parse(value.get("radius").toString()),
//             strokeWidth: 3,
//             center: LatLng(
//               double.parse(value.get("latitude")),
//               double.parse(value.get("longitude")),
//             ),
//             visible: true));
//         pointsOfInterestSave.add(value);
//       }
//     });

//     globals.circles = circlesSave;
//     globals.pointsOfInterest = pointsOfInterestSave;
//   }

//   getCategoriesDeals(bool force) async {
//     if (force) {
//       await utils.getUserPoints();
//       nbPosition = 1;

//       markersListSave = [];

//       await _requestLocationPermissions();

//       setState(() {
//         chipsValue = [];
//       });

//       await getPointsOfInterest();

//       var data = await FirebaseFirestore.instance
//           .collection('categories')
//           .where("type", isEqualTo: "5")
//           .orderBy("name")
//           .get();

//       fetchDeals(data);

//       await getMarkers();
//     }
//     return await callAsyncFetch();
//   }

//   fetchDeals(QuerySnapshot collection) async {
//     choiceItemsSave = [];
//     globals.categoriesSaveMap = [];

//     if (globals.pointsOfInterest.length > 0) {
//       chipMap = new globals.ChipMap(
//           "PI999999999999999999999999999999999999999999999999999999",
//           "Points d'intérêt",
//           "interest");

//       choiceItemsTemp = new C2Choice<globals.ChipMap>(
//           label: "Points d'intérêt",
//           value: chipMap,
//           disabled: false,
//           selected: false);

//       choiceItemsSave.add(choiceItemsTemp);
//     }

//     collection.docs.forEach((value) {
//       List<dynamic> dealsDynamicTemp = value["deals"];

//       List<dynamic> listDeals = [];
//       if (dealsDynamicTemp.length > 0) {
//         for (var indiceDeal = 0;
//             indiceDeal < dealsDynamicTemp.length;
//             indiceDeal++) {
//           if (dealsDynamicTemp[indiceDeal]["latitude"].length > 0 &&
//               dealsDynamicTemp[indiceDeal]["longitude"].length > 0) {
//             if (!globals.validatePointsOfInterest
//                 .contains(dealsDynamicTemp[indiceDeal]["id"])) {
//               markersListSave.add(MarkersModel(
//                   dealsDynamicTemp[indiceDeal]["id"],
//                   nbPosition,
//                   dealsDynamicTemp[indiceDeal]["merchand"],
//                   dealsDynamicTemp[indiceDeal]["title"],
//                   dealsDynamicTemp[indiceDeal]["subtitle"],
//                   dealsDynamicTemp[indiceDeal]["price"],
//                   dealsDynamicTemp[indiceDeal]["priceDeal"],
//                   dealsDynamicTemp[indiceDeal]["latitude"],
//                   dealsDynamicTemp[indiceDeal]["longitude"],
//                   dealsDynamicTemp[indiceDeal]["merchandLogo"],
//                   "merchand",
//                   0));

//               nbPosition++;
//             }
//           }
//         }

//         int nbDeals;

//         dealsDynamicTemp.sort((a, b) {
//           var orderA; //before -> var adate = a.expiry;
//           var orderB; //var bdate = b.expiry;

//           orderA = a['price'];
//           orderB = b['price'];
//           return orderA.compareTo(orderB);
//         });

//         globals.Category category = new globals.Category(
//             value.id,
//             value["name"],
//             value["type"],
//             dealsDynamicTemp.length,
//             listDeals,
//             dealsDynamicTemp,
//             value.id);

//         globals.categoriesSaveMap.add(category);

//         chipMap = new globals.ChipMap(value.id, value["name"], "merchand");

//         choiceItemsTemp = new C2Choice<globals.ChipMap>(
//             label: value["name"].toString(),
//             value: chipMap,
//             activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//             disabled: false,
//             selected: false);

//         choiceItemsSave.add(choiceItemsTemp);
//       }
//     });

//     globals.categoriesDealMap = globals.categoriesSaveMap;

//     globals.pointsOfInterest.forEach((element) {
//       if (element["latitude"] != null && element["longitude"] != null) {
//         markersListSave.add(MarkersModel(
//             element.id,
//             nbPosition,
//             element["name"],
//             "",
//             "",
//             element["points"],
//             0,
//             element["latitude"],
//             element["longitude"],
//             element["image"],
//             "interest",
//             element["radius"]));
//       }
//       nbPosition++;
//     });

//     globals.choiceItemsMap = choiceItemsSave;
//     markersList = markersListSave;
//   }

//   getMarkers() async {
//     final Uint8List userMarkerIcon =
//         await getBytesFromAsset('assets/images/normalPin.png', 75);

//     final Uint8List selectedMarkerIcon =
//         await getBytesFromAsset('assets/images/selectedPin.png', 100);

//     markers = {};

//     markersList.forEach((element) {
//       if (element.latitude != null &&
//           element.longitude != null &&
//           element.type == "merchand") {
//         if (element.position == indexMarker) {
//           markers.add(Marker(
//             draggable: false,
//             markerId: MarkerId(element.latitude + element.longitude),
//             position: LatLng(
//               double.tryParse(element.latitude),
//               double.tryParse(element.longitude),
//             ),
//             icon: BitmapDescriptor.fromBytes(selectedMarkerIcon),
//             infoWindow: InfoWindow(title: element.name),
//             onTap: () {
//               setState(() {
//                 _index = element.position;
//               });
//             },
//           ));
//         } else {
//           markers.add(Marker(
//             draggable: false,
//             markerId: MarkerId(element.latitude + element.longitude),
//             position: LatLng(
//               double.tryParse(element.latitude),
//               double.tryParse(element.longitude),
//             ),
//             icon: BitmapDescriptor.fromBytes(userMarkerIcon),
//             infoWindow: InfoWindow(title: element.name),
//             onTap: () {
//               setState(() {
//                 _index = element.position;
//               });
//             },
//           ));
//         }
//       }
//     });

//     valueNotifier.value = indexMarker; // we will need it soon

//     return await callAsyncFetch();
//   }

//   static Future<void> showPopupDialog(
//       BuildContext context, String merchandId) async {
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
//                           child: Column(children: [
//                             Text(
//                               merchandId,
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                           ])),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                         height: 40,
//                         margin: EdgeInsets.only(left: 60, right: 60),
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               primary: Colors.black,
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
//                             child: Text("FERMER")))
//                   ]));
//         });
//   }

//   Future<Null> applyFilters(List<globals.ChipMap> filters) async {
//     globals.categoriesDealMap = globals.categoriesSaveMap;
//     markersList = markersListSave;

//     List<globals.Category> categoriesTemp = [];
//     List<MarkersModel> markersTemp = [];

//     int nbPositionTemp = 1;
//     // print(filters);
//     for (int i = 0; i < filters.length; i++) {
//       if (filters[i].type == "merchand") {
//         for (int j = 0; j < globals.categoriesDealMap.length; j++) {
//           if (globals.categoriesDealMap[j].id == filters[i].id) {
//             for (var k = 0;
//                 k < globals.categoriesDealMap[j].listsAll.length;
//                 k++) {
//               if (globals.categoriesDealMap[j].listsAll[k]["latitude"].length >
//                       0 &&
//                   globals.categoriesDealMap[j].listsAll[k]["longitude"].length >
//                       0) {
//                 markersTemp.add(MarkersModel(
//                     globals.categoriesDealMap[j].listsAll[k]["id"],
//                     nbPositionTemp,
//                     globals.categoriesDealMap[j].listsAll[k]["merchand"],
//                     globals.categoriesDealMap[j].listsAll[k]["title"],
//                     globals.categoriesDealMap[j].listsAll[k]["subtitle"],
//                     globals.categoriesDealMap[j].listsAll[k]["price"],
//                     globals.categoriesDealMap[j].listsAll[k]["priceDeal"],
//                     globals.categoriesDealMap[j].listsAll[k]["latitude"],
//                     globals.categoriesDealMap[j].listsAll[k]["longitude"],
//                     globals.categoriesDealMap[j].listsAll[k]["merchandLogo"],
//                     "merchand",
//                     0));
//                 nbPositionTemp++;
//               }
//             }
//             categoriesTemp.add(globals.categoriesDealMap[j]);
//           }
//         }
//       } else {
//         for (int j = 0; j < globals.pointsOfInterest.length; j++) {
//           if (globals.pointsOfInterest[j]["latitude"].length > 0 &&
//               globals.pointsOfInterest[j]["longitude"].length > 0) {
//             markersTemp.add(MarkersModel(
//                 globals.pointsOfInterest[j].id,
//                 nbPositionTemp,
//                 globals.pointsOfInterest[j]["name"],
//                 "",
//                 "",
//                 globals.pointsOfInterest[j]["points"],
//                 0,
//                 globals.pointsOfInterest[j]["latitude"],
//                 globals.pointsOfInterest[j]["longitude"],
//                 globals.pointsOfInterest[j]["image"],
//                 "interest",
//                 globals.pointsOfInterest[j]["radius"]));
//             nbPositionTemp++;
//           }
//         }
//       }
//     }
//     if (markersTemp.length > 0) {
//       globals.categoriesDealMap = categoriesTemp;
//       markersList = markersTemp;
//     }
//   }

//   Future<Null> refreshList() async {
//     await Future.delayed(new Duration(seconds: 1));

//     setState(() {
//       myFuture = getCategoriesDeals(true);
//     });

//     return null;
//   }

//   void _getCurrentLocation() async {
//     Position res = await Geolocator.getCurrentPosition();
//     setState(() {
//       position = res;
//     });
//   }

//   Future<void> _requestLocationPermissions() async {
//     if (await Permission.location.request().isGranted) {
//       if (await Permission.locationAlways.request().isGranted) {
//         isLocationActive = true;
//         _getCurrentLocation();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: myFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Scaffold(
//                 body: Stack(
//               children: <Widget>[
//                 Positioned.fill(
//                   child: ValueListenableBuilder(
//                       valueListenable:
//                           valueNotifier, // that's the value we are listening to
//                       builder: (context, value, child) {
//                         return GoogleMap(
//                             padding: EdgeInsets.only(top: 80),
//                             zoomControlsEnabled: false,
//                             markers: markers,
//                             myLocationEnabled: true,
//                             myLocationButtonEnabled: true,
//                             onMapCreated: _onMapCreated,
//                             circles: globals.circles,
//                             initialCameraPosition: CameraPosition(
//                               target: _center,
//                               zoom: 15.0,
//                             ));
//                       }),
//                 ),
//                 Align(
//                     alignment: Alignment.topCenter,
//                     child: Column(children: [
//                       Container(
//                           alignment: Alignment.topCenter,
//                           padding: EdgeInsets.only(top: 30),
//                           child: ChipsChoice<globals.ChipMap>.multiple(
//                             choiceAvatarBuilder: (item) {
//                               if (item.value.type == "interest") {
//                                 //   return Container();
//                                 // } else {
//                                 return Icon(
//                                   Icons.add_location_alt_outlined,
//                                   color: Colors.green,
//                                 );
//                               }
//                             },
//                             placeholder: "",
//                             value: chipsValue,
//                             onChanged: (val) => setState(() {
//                               chipsValue = val;
//                               // print(value);
//                               applyFilters(chipsValue);
//                             }),
//                             choiceItems:
//                                 globals.choiceItemsMap.reversed.toList(),
//                             choiceStyle: C2ChoiceStyle(
//                               brightness: Brightness.light,
//                               showCheckmark: false,
//                             ),
//                             choiceActiveStyle: C2ChoiceStyle(
//                                 showCheckmark: false,
//                                 color: Colors.red,
//                                 borderColor: Colors.orange[700],
//                                 borderWidth: 1.5,
//                                 // padding: EdgeInsets.zero,
//                                 labelStyle: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     // backgroundColor: Colors.black,
//                                     color: Colors.orange[700])),
//                             wrapped: false,
//                             textDirection: TextDirection.rtl,
//                             direction: Axis.horizontal,
//                           )),
//                       SizedBox(height: 10),
//                       Container(
//                           height: 30,
//                           alignment: Alignment.topCenter,
//                           child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(30)))),
//                               onPressed: () async {
//                                 await refreshList();
//                               },
//                               child: Text("Recharger le plan",
//                                   style: TextStyle(
//                                       color: Colors.green[700],
//                                       fontWeight: FontWeight.w600)))),
//                       // Container(
//                       //     height: 50,
//                       //     width: 90,
//                       //     margin: EdgeInsets.only(right: 20),
//                       //     alignment: Alignment.topRight,
//                       //     child: ElevatedButton(
//                       //         style: ElevatedButton.styleFrom(
//                       //             primary: Colors.white,
//                       //             shape: RoundedRectangleBorder(
//                       //                 borderRadius: BorderRadius.all(
//                       //                     Radius.circular(40)))),
//                       //         onPressed: () async {
//                       //           await refreshList();
//                       //         },
//                       //         child: Icon(Icons.my_location_sharp)))
//                     ])),
//                 Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         bottom: Platform.isAndroid ? 50 : 68,
//                         right: 10,
//                       ),
//                       child: SizedBox(
//                         height: 80, // card height
//                         width: MediaQuery.of(context).size.width,

//                         child: PageView.builder(
//                           // itemCount: markersList.length,
//                           controller: PageController(
//                             viewportFraction: 0.75,
//                             initialPage: initialPage - 1,
//                           ),
//                           onPageChanged: (int index) {
//                             int indexScroll = index % markersList.length;

//                             setState(() => _index = indexScroll);

//                             indexMarker = markersList[indexScroll].position;
//                             if (markersList[indexScroll].latitude != null &&
//                                 markersList[indexScroll].longitude != null) {
//                               newPosition = LatLng(
//                                   double.tryParse(
//                                       markersList[indexScroll].latitude),
//                                   double.tryParse(
//                                       markersList[indexScroll].longitude));
//                               newCameraPosition = CameraPosition(
//                                   target: newPosition,
//                                   zoom: markersList[indexScroll].type ==
//                                           "merchand"
//                                       ? 15
//                                       : 17);
//                             }
//                             getMarkers();
//                             mapController
//                                 .animateCamera(CameraUpdate.newCameraPosition(
//                                     newCameraPosition))
//                                 .then((val) {
//                               setState(() {});
//                             });
//                           },
//                           itemBuilder: (_, i) {
//                             int indexScroll = i % markersList.length;
//                             if (markersList[indexScroll].position !=
//                                 999999999) {
//                               if (markersList[indexScroll].type == "merchand") {
//                                 return Container(
//                                   width: 100,
//                                   margin: EdgeInsets.only(
//                                     right: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xffffffff),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         offset: Offset(0, 0),
//                                         color: Colors.transparent,
//                                         blurRadius: 20,
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(10.00),
//                                   ),
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         onPrimary: Colors.transparent,
//                                         onSurface: Colors.transparent,
//                                         elevation: 0,
//                                         shadowColor: Colors.transparent,
//                                         primary: Colors.transparent,
//                                       ),
//                                       onPressed: () {
//                                         pushNewScreen(context,
//                                             screen: DetailDealPage(
//                                                 markersList[indexScroll].id),
//                                             withNavBar: true,
//                                             pageTransitionAnimation:
//                                                 PageTransitionAnimation
//                                                     .cupertino);
//                                       },
//                                       child: Row(
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(),
//                                             child: Container(
//                                               height: 60,
//                                               width: 60,
//                                               decoration: BoxDecoration(
//                                                 image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage(
//                                                       markersList[indexScroll]
//                                                           .image),
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(60),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: <Widget>[
//                                               Text(
//                                                 markersList[indexScroll].name,
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 5),
//                                               Text(
//                                                   markersList[indexScroll]
//                                                       .subtitle,
//                                                   textAlign: TextAlign.left,
//                                                   style: TextStyle(
//                                                       fontSize: 12,
//                                                       fontStyle:
//                                                           FontStyle.italic,
//                                                       color: Colors
//                                                           .deepOrange[900])),
//                                               SizedBox(height: 5),
//                                               Container(
//                                                 width: 160,
//                                                 child: Text(
//                                                     utils.addSeparateurMillier(
//                                                             markersList[
//                                                                     indexScroll]
//                                                                 .price
//                                                                 .toString()) +
//                                                         " Ꝃ par " +
//                                                         utils.addSeparateurMillier(
//                                                             markersList[
//                                                                     indexScroll]
//                                                                 .priceDeal
//                                                                 .toString()) +
//                                                         " XPF dépensés",
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 11)),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       )),
//                                 );
//                               } else {
//                                 return Container(
//                                   width: 100,
//                                   margin: EdgeInsets.only(
//                                     right: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.green, width: 2),
//                                     color: Color(0xffffffff),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         offset: Offset(0, 0),
//                                         color: Colors.transparent,
//                                         blurRadius: 20,
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(10.00),
//                                   ),
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         onPrimary: Colors.transparent,
//                                         onSurface: Colors.transparent,
//                                         elevation: 0,
//                                         shadowColor: Colors.transparent,
//                                         primary: Colors.transparent,
//                                       ),
//                                       onPressed: () async {
//                                         utils.showLoadingDialog(
//                                             context, _keyLoader);

//                                         Position userPosition = await Geolocator
//                                             .getCurrentPosition();

//                                         if (Geolocator.distanceBetween(
//                                                 double.parse(
//                                                     markersList[indexScroll]
//                                                         .latitude),
//                                                 double.parse(
//                                                     markersList[indexScroll]
//                                                         .longitude),
//                                                 userPosition.latitude,
//                                                 userPosition.longitude) >
//                                             markersList[indexScroll].radius) {
//                                           Navigator.of(
//                                                   _keyLoader.currentContext,
//                                                   rootNavigator: true)
//                                               .pop();
//                                           Alert(
//                                             context: context,
//                                             type: AlertType.warning,
//                                             closeIcon: Container(),
//                                             title: "",
//                                             desc:
//                                                 "Vous n'êtes pas dans la zone",
//                                             buttons: [
//                                               DialogButton(
//                                                 child: Text(
//                                                   "Fermer",
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 18),
//                                                 ),
//                                                 onPressed: () =>
//                                                     Navigator.pop(context),
//                                                 color: Color.fromRGBO(
//                                                     0, 179, 134, 1.0),
//                                               ),
//                                             ],
//                                           ).show().then((value) {
//                                             // setState(() {});
//                                           });
//                                         } else {
//                                           if (await utils.updatePointOfInterest(
//                                               markersList[indexScroll].id,
//                                               markersList[indexScroll].price)) {
//                                             //On maj maintenant l'historique de l'utilisateur
//                                             await utils.updateHistorique(
//                                                 globals.uidParrainage,
//                                                 "MAP",
//                                                 markersList[indexScroll].name,
//                                                 markersList[indexScroll].price,
//                                                 "");

//                                             var popupText1 = "Félicitations!";
//                                             var popupText2 =
//                                                 "Vous venez de gagner " +
//                                                     markersList[indexScroll]
//                                                         .price
//                                                         .toString() +
//                                                     "Ꝃ";

//                                             markersList.remove(
//                                                 markersList[indexScroll]);
//                                             Navigator.of(
//                                                     _keyLoader.currentContext,
//                                                     rootNavigator: true)
//                                                 .pop();
//                                             utils
//                                                 .openPopupSuccess(context,
//                                                     popupText1, popupText2)
//                                                 .then((value) {});
//                                           } else {
//                                             Navigator.of(
//                                                     _keyLoader.currentContext,
//                                                     rootNavigator: true)
//                                                 .pop();

//                                             Alert(
//                                               context: context,
//                                               type: AlertType.warning,
//                                               closeIcon: Container(),
//                                               title: "",
//                                               desc:
//                                                   "Erreur survenue lors de la validation du point d'intérêt.",
//                                               buttons: [
//                                                 DialogButton(
//                                                   child: Text(
//                                                     "Fermer",
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 18),
//                                                   ),
//                                                   onPressed: () =>
//                                                       Navigator.pop(context),
//                                                   color: Color.fromRGBO(
//                                                       0, 179, 134, 1.0),
//                                                 ),
//                                               ],
//                                             ).show().then((value) {
//                                               setState(() {});
//                                             });
//                                           }
//                                         }
//                                       },
//                                       child: Row(
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(),
//                                             child: Container(
//                                               height: 60,
//                                               width: 60,
//                                               decoration: BoxDecoration(
//                                                 image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage(
//                                                       markersList[indexScroll]
//                                                           .image),
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(60),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: <Widget>[
//                                               Text(
//                                                 markersList[indexScroll].name,
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 5),
//                                               Container(
//                                                 width: 168,
//                                                 child: Row(children: [
//                                                   Text(
//                                                       utils.addSeparateurMillier(
//                                                               markersList[
//                                                                       indexScroll]
//                                                                   .price
//                                                                   .toString()) +
//                                                           " Ꝃ",
//                                                       style: TextStyle(
//                                                           color: Colors.green,
//                                                           fontSize: 11,
//                                                           fontWeight:
//                                                               FontWeight.bold)),
//                                                   Text(
//                                                       " en validant le point d'intérêt",
//                                                       style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 11)),
//                                                 ]),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       )),
//                                 );
//                               }
//                             }
//                           },
//                         ),
//                       ),
//                     ))
//               ],
//             ));
//           } else {
//             return Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                       child: LoadingBouncingGrid.square(
//                     size: 80,
//                     backgroundColor: Colors.cyan[700]!,
//                   )),
//                 ]);
//           }
//         });
//   }
// }

// class MarkersModel {
//   String id;
//   int position;
//   String name;
//   String description;
//   String subtitle;
//   String latitude;
//   String longitude;
//   String image;
//   num price;
//   num priceDeal;
//   String type;
//   num radius;
//   MarkersModel(
//       this.id,
//       this.position,
//       this.name,
//       this.description,
//       this.subtitle,
//       this.price,
//       this.priceDeal,
//       this.latitude,
//       this.longitude,
//       this.image,
//       this.type,
//       this.radius);
// }
