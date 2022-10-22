import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:kayou/tools/globals.dart' as globals;
import 'package:kayou/tools/utils.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:loading_animations/loading_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'detail-dealpage.dart';
import 'tuto/tuto-map.dart';

class MapPage extends StatefulWidget {
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  int _index = 0;
  int indexMarker = 0;
  ValueNotifier? valueNotifier;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  final initialPage = (.161251195141521521142025 // :)
          *
          1e6)
      .round();

  List<C2Choice<globals.ChipMap>> choiceItems = [];
  List<C2Choice<globals.ChipMap>> choiceItemsSave = [];
  C2Choice<globals.ChipMap>? choiceItemsTemp;
  List<globals.ChipMap> chipsValue = [];

  globals.ChipMap? chipMap;

  LatLng? newPosition;
  CameraPosition newCameraPosition =
      CameraPosition(target: LatLng(36.6993, 3.1755), zoom: 10);

  GoogleMapController? mapController;

  Set<Circle> circlesSave = {};
  Set<Marker> markersSave = {};

  static List<dynamic> markersList = [];
  static List<MarkersModel> markersListPoints = [];
  static List<dynamic> markersListSave = [];
  static List<MarkersModel> markersListPointsSave = [];
  List<dynamic> merchandsMapItemsSave = [];
  List<dynamic> pointsOfInterestSave = [];

  Position? position;

  int? nbPosition;

  bool isLocationActive = false;

  var myFuture;

  UtilsState? utils;
  LatLng? _center;

  void initState() {
    utils = new UtilsState();
    utils!.initState();
    super.initState();

    // indexMarker = 1;

    valueNotifier = ValueNotifier(indexMarker);

    // myFuture = getCategoriesDeals(globals.pointsOfInterest.length == 0);
    myFuture = getPointsOfInterest(globals.pointsOfInterest.length == 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {});

    // mapController.animateCamera(CameraUpdate.newLatLngBounds(
    //     LatLngBounds(
    //         southwest: LatLng(-22.903346978494355, 162.94251556555986),
    //         northeast: LatLng(-19.4095698967684, 168.8513048483849)),
    //     100));
  }

  //******* getMarkers */
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  getPointsOfInterest(bool force) async {
    if (force) {
      await _requestLocationPermissions();
      utils!.getUserPoints();
      nbPosition = 1;

      pointsOfInterestSave = [];
      circlesSave = {};

      var data = await FirebaseFirestore.instance
          .collection('map')
          .where("published", isEqualTo: true)
          .orderBy("name")
          .get();

      data.docs.forEach((value) {
        // print(value.get("name"));
        if (!globals.validatePointsOfInterest.contains(value.id)) {
          circlesSave.add(Circle(
              fillColor: Colors.cyan[700]!.withOpacity(0.4),
              strokeColor: Colors.cyan[700]!,
              circleId: CircleId(value.id),
              radius: double.parse(value.get("radius").toString()),
              strokeWidth: 3,
              consumeTapEvents: true,
              onTap: () async {
                EasyLoading.show(
                    status: "Veuillez patienter s\il vous plait...");

                Position userPosition = await Geolocator.getCurrentPosition();

                if (Geolocator.distanceBetween(
                        double.parse(value.get("latitude").toString()),
                        double.parse(value.get("longitude").toString()),
                        userPosition.latitude,
                        userPosition.longitude) >
                    double.parse(value.get("radius").toString())) {
                  EasyLoading.dismiss();
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    closeIcon: Container(),
                    title: "",
                    desc: "Vous n'êtes pas dans la zone",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Fermer",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                    ],
                  ).show().then((value) {
                    // setState(() {});
                  });
                } else {
                  if (await utils!
                      .updatePointOfInterest(value.id, value.get("points"))) {
                    //On maj maintenant l'historique de l'utilisateur
                    await utils!.updateHistorique(globals.uidParrainage, "MAP",
                        value.get("name"), value.get("points"), "");

                    var popupText1 = "Félicitations!";
                    var popupText2 = "Vous venez de gagner " +
                        value.get("points").toString() +
                        "Ꝃ";

                    var index = 999999;

                    for (var i = 0; i < markersListPoints.length; i++) {
                      if (markersListPoints[i].id == value.id) {
                        index = i;
                      }
                    }

                    if (index != 999999) {
                      markersListPoints.removeAt(index);
                    }
                    // globals.circles.remove(value)

                    EasyLoading.dismiss();
                    utils!
                        .openPopupSuccess(context, popupText1, popupText2)
                        .then((value) {
                      setState(() {});
                    });
                  } else {
                    EasyLoading.dismiss();

                    Alert(
                      context: context,
                      type: AlertType.warning,
                      closeIcon: Container(),
                      title: "",
                      desc:
                          "Erreur survenue lors de la validation du point d'intérêt.",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Fermer",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                      ],
                    ).show().then((value) {
                      setState(() {});
                    });
                  }
                }
              },
              center: LatLng(
                double.parse(value.get("latitude")),
                double.parse(value.get("longitude")),
              ),
              visible: true));
          pointsOfInterestSave.add(value);
        }
      });

      globals.circles = circlesSave;
      globals.pointsOfInterest = pointsOfInterestSave;

      globals.pointsOfInterest.forEach((element) {
        if (element.get("latitude").toString().length > 0 &&
            element.get("longitude").toString().length > 0) {
          markersListPointsSave.add(MarkersModel(
              element.id,
              nbPosition!,
              element.get("name"),
              "",
              "",
              element.get("points"),
              0,
              element.get("latitude"),
              element.get("longitude"),
              element.get("image"),
              "interest",
              element.get("radius")));
        }
        nbPosition = nbPosition! + 1;
      });

      globals.merchandsMapItems = merchandsMapItemsSave;

      // await getMarkers();

      markersListPoints = markersListPointsSave;
    }

    return await callAsyncFetch();
  }

  getCategoriesDeals(bool force) async {
    if (force) {
      await _requestLocationPermissions();
      utils!.getUserPoints();
      nbPosition = 1;

      markersListSave = [];
      markersListPointsSave = [];

      // print(position.latitude);\

      setState(() {
        chipsValue = [];
      });

      await getPointsOfInterest(force);

      var data = await FirebaseFirestore.instance
          .collection('merchands')
          // .where("type", isEqualTo: "5")
          // .orderBy("name")
          .get();

      // await fetchDeals(data);
      // fetchDeals();

      // await getMarkers();
    }

    if (globals.showTutorialMap) {
      globals.tutoMap = true;
      await pushNewScreen(
        context,
        screen: TutoMapPage(),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ).then((value) {
        globals.showTutorialMap = false;
        utils!.setBoolValue("showTutorialMap", false);
        globals.tutoMap = false;
      });
    }

    return await callAsyncFetch();
  }

  getMarkers() async {
    markersSave = {};

    final Uint8List selectedMarkerIcon =
        await getBytesFromAsset('assets/images/selectedPin.png', 120);

    globals.merchandsMapItems.forEach((element) {
      if (element.get("activeDeal") || element.get("activeGift")) {
        if (element.get("latitude").toString().length > 0 &&
            element.get("longitude").toString().length > 0) {
          // if (element.position == indexMarker) {
          markersSave.add(Marker(
            draggable: false,
            markerId:
                MarkerId(element.get("latitude") + element.get("longitude")),
            position: LatLng(
              double.tryParse(element.get("latitude"))!,
              double.tryParse(element.get("longitude"))!,
            ),
            icon: BitmapDescriptor.fromBytes(selectedMarkerIcon),
            infoWindow: InfoWindow(
              title: "",
            ),
            onTap: () {
              utils!.openPopupMerchand(context, element);
            },
          ));
        }
      }
    });

    globals.markers = markersSave;

    if (mounted) {
      setState(() {});
    }
  }

  fetchDeals(QuerySnapshot collection) async {
    choiceItemsSave = [];
    markersSave = {};
    merchandsMapItemsSave = [];

    collection.docs.forEach((element) {
      merchandsMapItemsSave.add(element);
    });

    globals.pointsOfInterest.forEach((element) {
      if (element.get("latitude").toString().length > 0 &&
          element.get("longitude").toString().length > 0) {
        markersListPointsSave.add(MarkersModel(
            element.id,
            nbPosition!,
            element.get("name"),
            "",
            "",
            element.get("points"),
            0,
            element.get("latitude"),
            element.get("longitude"),
            element.get("image"),
            "interest",
            element.get("radius")));
      }
      nbPosition = nbPosition! + 1;
    });

    globals.merchandsMapItems = merchandsMapItemsSave;

    // await getMarkers();

    markersListPoints = markersListPointsSave;
  }

  Future<Null> refreshList() async {
    await Future.delayed(new Duration(seconds: 1));

    setState(() {
      myFuture = getPointsOfInterest(true);
    });

    return null;
  }

  Future<void> _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    // print(res);
    setState(() {
      position = res;
    });
  }

  Future<void> _requestLocationPermissions() async {
    var check = await Geolocator.checkPermission();

    if (await Permission.location.request().isGranted ||
        await Permission.locationAlways.request().isGranted ||
        check == LocationPermission.always ||
        check == LocationPermission.whileInUse) {
      isLocationActive = true;
      // await _getCurrentLocation();
    }

    // if (isLocationActive) {
    //   globals.center = new LatLng(position.latitude, position.longitude);
    // } else {
    globals.center = const LatLng(-22.27178294211219, 166.43859106720822);
    // }

    if (mounted) {
      setState(() {});
    }
  }

  showTutorialMap() async {
    await utils!.initTutorialMap();
    // TutorialCoachMark tutorial = TutorialCoachMark(context,
    //     targets: globals.targetsMap, // List<TargetFocus>
    //     colorShadow: Colors.black, // DEFAULT Colors.black
    //     // alignSkip: Alignment.bottomRight,
    //     textSkip: "Passer le tutoriel",
    //     alignSkip: Alignment.topLeft,
    //     onFinish: () {
    //       globals.showTutorialMap = false;
    //       utils!.setBoolValue("showTutorialMap", false);
    //       globals.tutoMap = false;
    //     },
    //     onClickTarget: (target) {},
    //     onClickOverlay: (p0) {},
    //     onSkip: () {
    //       globals.showTutorialMap = false;
    //       utils!.setBoolValue("showTutorialMap", false);
    //       globals.tutoMap = false;
    //     })
    //   ..show();
  }

  @override
  Widget build(BuildContext context) {
    getMarkers();
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: Stack(
              children: <Widget>[
                Container(
                    height: Platform.isAndroid
                        ? MediaQuery.of(context).size.height - 200
                        : MediaQuery.of(context).size.height - 270,
                    child: GoogleMap(
                        padding: EdgeInsets.only(top: 80),
                        zoomControlsEnabled: false,
                        markers: globals.markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onCameraMove: (position) {
                          globals.center = LatLng(position.target.latitude,
                              position.target.longitude);
                          globals.zoom = position.zoom;
                        },
                        onMapCreated: _onMapCreated,
                        circles: globals.circles,
                        initialCameraPosition: CameraPosition(
                          target: globals.center!,
                          zoom: globals.zoom,
                        ))),
                // ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(top: 50),
                      // alignment: Alignment.topCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)))),
                          onPressed: () async {
                            await refreshList();
                          },
                          child: Container(
                              // padding: EdgeInsets.only(right: 40),
                              alignment: Alignment.center,
                              child: Icon(Icons.refresh))

                          // Text("Recharger le plan",
                          //     style: TextStyle(
                          //         color: Colors.green[700],
                          //         fontWeight: FontWeight.w600))

                          )),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: EdgeInsets.only(top: 40, right: 25),
                        // padding: EdgeInsets.only(top: 10),
                        // height: 10,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              pushNewScreen(
                                context,
                                screen: TutoMapPage(),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                              // setState(() {
                              //   globals.tutoMap = true;
                              // });
                              // showTutorialMap();
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            child: Container(
                                child: Image.asset(
                              "assets/images/tuto_icon.png",
                              height: 32,
                              width: 32,
                              fit: BoxFit.fill,
                            ))))),
                Platform.isAndroid
                    ? Positioned(
                        top: 90,
                        right: 10,
                        child: Container(
                          // key: globals.keyButtonMap,

                          // padding: EdgeInsets.only(top: 10),
                          height: globals.tutoMap ? 40 : 1,
                          width: globals.tutoMap ? 40 : 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ))
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 23, right: 23),
                            // padding: EdgeInsets.only(top: 10),
                            height: globals.tutoMap ? 30 : 1,
                            width: globals.tutoMap ? 30 : 1,
                            child: Container(
                              // key: globals.keyButtonMap,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ))),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(1),
                          border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      height: 180,
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        child: Padding(
                      padding: EdgeInsets.only(
                        bottom: Platform.isAndroid ? 42 : 48,
                        right: 0,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Visitez les ",
                                      style: TextStyle(fontSize: 12)),
                                  Text("lieux ",
                                      style: TextStyle(
                                          color: Colors.cyan[700]!,
                                          fontSize: 12)),
                                  Text("référencés et soyez ",
                                      style: TextStyle(fontSize: 12)),
                                  Text("récompensé ",
                                      style: TextStyle(
                                          color: Colors.cyan[700]!,
                                          fontSize: 12)),
                                  Image(
                                    image:
                                        AssetImage('assets/images/trophy.png'),
                                    height: 20,
                                  )
                                ]),
                            SizedBox(height: 20),
                            Container(
                              // key: globals.keyButtonMap1,
                              height: 63, // card height
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.zero,
                              child: PageView.builder(
                                // itemCount: markersList.length,
                                controller: PageController(
                                  viewportFraction: 0.75,
                                  initialPage: initialPage - 1,
                                ),
                                onPageChanged: (int index) {
                                  int indexScroll =
                                      index % markersListPoints.length;

                                  setState(() => _index = indexScroll);

                                  indexMarker =
                                      markersListPoints[indexScroll].position;
                                  if (markersListPoints[indexScroll].latitude !=
                                          null &&
                                      markersListPoints[indexScroll]
                                              .longitude !=
                                          null) {
                                    newPosition = LatLng(
                                        double.tryParse(
                                            markersListPoints[indexScroll]
                                                .latitude)!,
                                        double.tryParse(
                                            markersListPoints[indexScroll]
                                                .longitude)!);
                                    newCameraPosition = CameraPosition(
                                        target: newPosition!,
                                        zoom: markersListPoints[indexScroll]
                                                    .type ==
                                                "merchand"
                                            ? 15
                                            : 17);
                                  }

                                  mapController!
                                      .animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              newCameraPosition))
                                      .then((val) {
                                    setState(() {});
                                  });
                                },
                                itemBuilder: (_, i) {
                                  int indexScroll =
                                      i % markersListPoints.length;
                                  if (markersListPoints[indexScroll].position !=
                                      999999999) {
                                    return Container(
                                      width: 100,
                                      margin: EdgeInsets.only(
                                        right: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                        color: Color(0xffffffff),
                                        borderRadius:
                                            BorderRadius.circular(80.00),
                                      ),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            onPrimary: Colors.transparent,
                                            onSurface: Colors.transparent,
                                            elevation: 0,
                                            padding: EdgeInsets.zero,
                                            shadowColor: Colors.transparent,
                                            primary: Colors.transparent,
                                          ),
                                          onPressed: () async {
                                            EasyLoading.show(
                                                status:
                                                    "Veuillez patienter s\'il vous plait...");

                                            Position userPosition =
                                                await Geolocator
                                                    .getCurrentPosition();

                                            if (Geolocator.distanceBetween(
                                                    double.parse(
                                                        markersListPoints[
                                                                indexScroll]
                                                            .latitude),
                                                    double.parse(
                                                        markersListPoints[
                                                                indexScroll]
                                                            .longitude),
                                                    userPosition.latitude,
                                                    userPosition.longitude) >
                                                markersListPoints[indexScroll]
                                                    .radius) {
                                              EasyLoading.dismiss();
                                              Alert(
                                                context: context,
                                                type: AlertType.warning,
                                                closeIcon: Container(),
                                                title: "",
                                                desc:
                                                    "Vous n'êtes pas dans la zone",
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
                                              ).show().then((value) {
                                                // setState(() {});
                                              });
                                            } else {
                                              if (await utils!
                                                  .updatePointOfInterest(
                                                      markersListPoints[
                                                              indexScroll]
                                                          .id,
                                                      markersListPoints[
                                                              indexScroll]
                                                          .price
                                                          .toInt())) {
                                                //On maj maintenant l'historique de l'utilisateur
                                                await utils!.updateHistorique(
                                                    globals.uidParrainage,
                                                    "MAP",
                                                    markersListPoints[
                                                            indexScroll]
                                                        .name,
                                                    markersListPoints[
                                                            indexScroll]
                                                        .price
                                                        .toInt(),
                                                    "");

                                                var popupText1 =
                                                    "Félicitations!";
                                                var popupText2 =
                                                    "Vous venez de gagner " +
                                                        markersListPoints[
                                                                indexScroll]
                                                            .price
                                                            .toString() +
                                                        "Ꝃ";

                                                markersListPoints.remove(
                                                    markersListPoints[
                                                        indexScroll]);
                                                EasyLoading.dismiss();
                                                utils!
                                                    .openPopupSuccess(context,
                                                        popupText1, popupText2)
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              } else {
                                                EasyLoading.dismiss();

                                                Alert(
                                                  context: context,
                                                  type: AlertType.warning,
                                                  closeIcon: Container(),
                                                  title: "",
                                                  desc:
                                                      "Erreur survenue lors de la validation du point d'intérêt.",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "Fermer",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      color: Color.fromRGBO(
                                                          0, 179, 134, 1.0),
                                                    ),
                                                  ],
                                                ).show().then((value) {
                                                  setState(() {});
                                                });
                                              }
                                            }
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(),
                                                child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          markersListPoints[
                                                                  indexScroll]
                                                              .image),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    markersListPoints[
                                                            indexScroll]
                                                        .name,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                    width: 168,
                                                    child: Row(children: [
                                                      Text(
                                                          utils!.addSeparateurMillier(
                                                                  markersListPoints[
                                                                          indexScroll]
                                                                      .price
                                                                      .toString()) +
                                                              " Ꝃ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .cyan[700],
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          " en validant le point d'intérêt",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 11)),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                                child: Text(
                                    "Défilez pour découvrir les autres lieux",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)))
                          ]),
                    )))
              ],
            ));
          } else {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: LoadingBouncingGrid.square(
                    size: 80,
                    backgroundColor: Colors.cyan[700]!,
                  )),
                ]);
          }
        });
  }
}

class MarkersModel {
  String id;
  int position;
  String name;
  String description;
  String subtitle;
  String latitude;
  String longitude;
  String image;
  num price;
  num priceDeal;
  String type;
  num radius;
  MarkersModel(
      this.id,
      this.position,
      this.name,
      this.description,
      this.subtitle,
      this.price,
      this.priceDeal,
      this.latitude,
      this.longitude,
      this.image,
      this.type,
      this.radius);
}
