import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kayou/tools/utils.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'tools/globals.dart' as globals;

import 'dart:ui' as ui;

class DetailDealPage extends StatefulWidget {
  final String merchandId;

  DetailDealPage(this.merchandId);

  DetailDealPageState createState() => DetailDealPageState();
}

class DetailDealPageState extends State<DetailDealPage> {
  UtilsState? utils;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  final CarouselController _controller = CarouselController();

  int _currentImage = 0;

  var detail;

  bool isSiteWeb = false;
  bool isFacebook = false;
  bool isTel = false;
  bool isAdress = false;
  bool isHours = false;
  bool isEmail = false;
  bool isMap = false;

  Uint8List? selectedMarkerIcon;
  GoogleMapController? mapController;

  List<String> images = [];

  var myFuture;

  @override
  void initState() {
    utils = new UtilsState();
    utils!.initState();

    super.initState();
    myFuture = getDeal();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getDeal() async {
    var data = await FirebaseFirestore.instance
        .collection('merchands')
        .doc(widget.merchandId)
        .get();

    detail = data.data();
    images = [];
    for (var i = 0; i < detail["deal"]["imageDescription"].length; i++) {
      if (detail["deal"]["imageDescription"][i] != "NA") {
        images.add(detail["deal"]["imageDescription"][i]);
      }
    }

    if (detail["latitude"].length > 0 && detail["longitude"].length > 0) {
      isMap = true;
    }

    if (detail["website"].length > 0) {
      isSiteWeb = true;
    }

    if (detail["facebook"].length > 0) {
      isFacebook = true;
    }

    if (detail["telApp"].length > 0) {
      isTel = true;
    }

    if (detail["emailApp"].length > 0) {
      isEmail = true;
    }

    if (detail["adress"].length > 0) {
      isAdress = true;
    }

    if (detail["mondayHour"] != "FERME" ||
        detail["tuesdayHour"] != "FERME" ||
        detail["wednesdayHour"] != "FERME" ||
        detail["thursdayHour"] != "FERME" ||
        detail["fridayHour"] != "FERME" ||
        detail["saturdayHour"] != "FERME" ||
        detail["sundayHour"] != "FERME") {
      isHours = true;
    }

    selectedMarkerIcon =
        await getBytesFromAsset('assets/images/selectedPin.png', 100);

    return await callAsyncFetch();
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  Future<Null> refreshList() async {
    await Future.delayed(new Duration(seconds: 1));

    setState(() {
      myFuture = getDeal();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WillPopScope(
                onWillPop: () async => true,
                child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarIconBrightness: Brightness.light,
                              statusBarBrightness: Brightness.dark,
                              systemNavigationBarIconBrightness:
                                  Brightness.dark,
                              statusBarColor: Colors.transparent,
                              systemNavigationBarColor: Colors.transparent,
                              systemNavigationBarDividerColor:
                                  Colors.transparent),
                          toolbarHeight: 90,
                          elevation: 0,
                          leadingWidth: 65,
                          leading: Container(
                              margin: EdgeInsets.only(
                                  top: 25, left: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                              height: 20,
                              width: 20,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back,
                                    size: 36, color: Colors.cyan[700]!),
                                color: Colors.transparent,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )),
                        ),
                        extendBodyBehindAppBar: true,
                        backgroundColor: Colors.white,
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerFloat,
                        floatingActionButton: Container(
                            margin:
                                EdgeInsets.only(bottom: 5, left: 25, right: 25),
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.cyan[700]!,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                onPressed: () {
                                  utils!.openQRCode(context);
                                },
                                child: Container(
                                    child: Text(
                                        "Acheter chez " + detail["name"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))))),
                        body: RefreshIndicator(
                            key: refreshKey,
                            onRefresh: refreshList,
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                  Container(
                                      child: Column(children: [
                                    CarouselSlider(
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                          viewportFraction: 1,
                                          enlargeCenterPage: true,
                                          aspectRatio: 1.4,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _currentImage = index;
                                            });
                                          }),
                                      items: images
                                          .map((item) => CachedNetworkImage(
                                                imageUrl: item,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 500,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                        child: Center(
                                                            child: Container(
                                                                height: 20,
                                                                width: 20,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor: new AlwaysStoppedAnimation<
                                                                      Color>(Colors
                                                                          .grey[
                                                                      400]!),
                                                                )))),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ))
                                          .toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          images.asMap().entries.map((entry) {
                                        return GestureDetector(
                                          onTap: () => _controller
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 4.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .withOpacity(
                                                        _currentImage ==
                                                                entry.key
                                                            ? 0.9
                                                            : 0.2)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ])),
                                  SizedBox(height: 10),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          detail["name"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20))),
                                                  SizedBox(height: 2),
                                                  Text(
                                                      detail["deal"]
                                                          ["subcategoryName"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.grey)),
                                                  SizedBox(height: 15),
                                                  Container(
                                                      child: Row(children: [
                                                    Text(
                                                        utils!.addSeparateurMillier(
                                                                detail["deal"][
                                                                        "price"]
                                                                    .toString()) +
                                                            " Ꝃ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .cyan[700])),
                                                    Text(" par "),
                                                    Text(
                                                        utils!.addSeparateurMillier(
                                                                detail["deal"][
                                                                        "priceDeal"]
                                                                    .toString()) +
                                                            " XPF",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .cyan[700])),
                                                    Text(" dépensés")
                                                  ]))
                                                ]),
                                            CachedNetworkImage(
                                              imageUrl: detail["logo"],
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(
                                                      height: 60,
                                                      width: 60,
                                                      child: Center(
                                                          child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    new AlwaysStoppedAnimation<
                                                                        Color>(Colors
                                                                            .grey[
                                                                        400]!),
                                                              )))),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )
                                          ])),
                                  SizedBox(height: 10),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 7, right: 7, bottom: 0),
                                      child: Html(
                                        data: detail["deal"]["description"],
                                      )

                                      // Text(detail["gift"]["description"],
                                      //     textAlign: TextAlign.justify,
                                      //     style: TextStyle(fontSize: 15))
                                      ),
                                  (isTel || isSiteWeb || isFacebook || isEmail)
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: Divider(
                                              height: 2,
                                              thickness: 1,
                                              color: Colors.grey[400]))
                                      : Container(),
                                  (isTel || isSiteWeb || isFacebook || isEmail)
                                      ? SizedBox(height: 10)
                                      : Container(),
                                  (isTel || isSiteWeb || isFacebook || isEmail)
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: 40, right: 40),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                isTel
                                                    ? Column(children: [
                                                        Container(
                                                            height: 43,
                                                            width: 43,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border: Border.all(
                                                                    color: Colors
                                                                            .lightBlue[
                                                                        200]!,
                                                                    width: 1)),
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      utils!.makePhoneCall(
                                                                          'tel:' +
                                                                              detail["telApp"]);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                1),
                                                                        primary: Colors
                                                                            .transparent,
                                                                        onPrimary: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            0,
                                                                        onSurface:
                                                                            Colors.transparent,
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                        shadowColor: Colors.transparent),
                                                                    child: Icon(CupertinoIcons.phone, color: Colors.lightBlue[300]))),
                                                        SizedBox(height: 5),
                                                        Text("Appeler",
                                                            style: TextStyle(
                                                                color: Colors
                                                                        .lightBlue[
                                                                    400]))
                                                      ])
                                                    : Container(),
                                                isTel
                                                    ? SizedBox(width: 25)
                                                    : Container(),
                                                isEmail
                                                    ? Column(children: [
                                                        Container(
                                                            height: 43,
                                                            width: 43,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border: Border.all(
                                                                    color: Colors
                                                                            .lightBlue[
                                                                        200]!,
                                                                    width: 1)),
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      utils!.makePhoneCall(
                                                                          'mailto:' +
                                                                              detail["emailApp"]);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                1),
                                                                        primary: Colors
                                                                            .transparent,
                                                                        onPrimary: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            0,
                                                                        onSurface:
                                                                            Colors.transparent,
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                        shadowColor: Colors.transparent),
                                                                    child: Icon(CupertinoIcons.mail, color: Colors.lightBlue[300]))),
                                                        SizedBox(height: 5),
                                                        Text("Email",
                                                            style: TextStyle(
                                                                color: Colors
                                                                        .lightBlue[
                                                                    400]))
                                                      ])
                                                    : Container(),
                                                isEmail
                                                    ? SizedBox(width: 25)
                                                    : Container(),
                                                isSiteWeb
                                                    ? Column(children: [
                                                        Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 45,
                                                            width: 45,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border: Border.all(
                                                                    color: Colors
                                                                            .lightBlue[
                                                                        200]!,
                                                                    width: 1)),
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      utils!.openLink(
                                                                          detail[
                                                                              "website"]);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                0),
                                                                        primary: Colors
                                                                            .transparent,
                                                                        onPrimary:
                                                                            Colors.transparent,
                                                                        elevation: 0,
                                                                        onSurface: Colors.transparent,
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                        shadowColor: Colors.transparent),
                                                                    child: Icon(CupertinoIcons.globe, color: Colors.lightBlue[300]))),
                                                        SizedBox(height: 5),
                                                        Text("Site web",
                                                            style: TextStyle(
                                                                color: Colors
                                                                        .lightBlue[
                                                                    400]))
                                                      ])
                                                    : Container(),
                                                isSiteWeb
                                                    ? SizedBox(width: 25)
                                                    : Container(),
                                                isFacebook
                                                    ? Column(children: [
                                                        Container(
                                                            height: 45,
                                                            width: 45,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                border: Border.all(
                                                                    color: Colors
                                                                            .lightBlue[
                                                                        200]!,
                                                                    width: 1)),
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      utils!.openLink(
                                                                          detail[
                                                                              "facebook"]);
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                1),
                                                                        primary: Colors
                                                                            .transparent,
                                                                        onPrimary: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            0,
                                                                        onSurface:
                                                                            Colors.transparent,
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                        shadowColor: Colors.transparent),
                                                                    child: Icon(Icons.facebook, color: Colors.lightBlue[300]))),
                                                        SizedBox(height: 5),
                                                        Text("Facebook",
                                                            style: TextStyle(
                                                                color: Colors
                                                                        .lightBlue[
                                                                    400]))
                                                      ])
                                                    : Container(),
                                              ]))
                                      : Container(),
                                  isAdress ? SizedBox(height: 10) : Container(),
                                  isAdress
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: Divider(
                                              height: 2,
                                              thickness: 1,
                                              color: Colors.grey[400]))
                                      : Container(),
                                  isAdress ? SizedBox(height: 10) : Container(),
                                  isAdress
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.transparent,
                                                  elevation: 0,
                                                  onSurface: Colors.transparent,
                                                  padding: EdgeInsets.zero,
                                                  shadowColor:
                                                      Colors.transparent),
                                              onPressed: () {
                                                if (detail["latitude"].length >
                                                        0 &&
                                                    detail["longitude"].length >
                                                        0) {
                                                  utils!.openMap(
                                                      detail["name"],
                                                      detail["latitude"],
                                                      detail["longitude"],
                                                      utils!.addSeparateurMillier(
                                                              detail["deal"]
                                                                      ["price"]
                                                                  .toString()) +
                                                          " Ꝃ par " +
                                                          utils!.addSeparateurMillier(
                                                              detail["deal"][
                                                                      "priceDeal"]
                                                                  .toString()) +
                                                          " XPF");
                                                }
                                              },
                                              child: Row(children: [
                                                Icon(CupertinoIcons.location,
                                                    color:
                                                        Colors.lightBlue[300]),
                                                SizedBox(width: 10),
                                                Text(detail["adress"])
                                              ])))
                                      : Container(),
                                  isMap ? SizedBox(height: 10) : Container(),
                                  isMap
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: Divider(
                                              height: 2,
                                              thickness: 1,
                                              color: Colors.grey[400]))
                                      : Container(),
                                  isMap ? SizedBox(height: 10) : Container(),
                                  isMap
                                      ? Container(
                                          height: 200,
                                          margin: EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: GoogleMap(
                                              padding: EdgeInsets.only(top: 80),
                                              zoomControlsEnabled: false,
                                              markers: {
                                                Marker(
                                                  draggable: false,
                                                  markerId: MarkerId(
                                                      detail["latitude"] +
                                                          detail["longitude"]),
                                                  position: LatLng(
                                                      double.parse(
                                                          detail["latitude"]),
                                                      double.parse(
                                                          detail["longitude"])),
                                                  icon: BitmapDescriptor
                                                      .fromBytes(
                                                          selectedMarkerIcon!),
                                                  infoWindow: InfoWindow(
                                                      title: detail["name"]),
                                                )
                                              },
                                              zoomGesturesEnabled: false,
                                              scrollGesturesEnabled: false,
                                              myLocationEnabled: false,
                                              myLocationButtonEnabled: false,
                                              onMapCreated: _onMapCreated,
                                              tiltGesturesEnabled: false,
                                              onTap: (argument) {
                                                if (detail["latitude"].length >
                                                        0 &&
                                                    detail["longitude"].length >
                                                        0) {
                                                  utils!.openMap(
                                                      detail["name"],
                                                      detail["latitude"],
                                                      detail["longitude"],
                                                      utils!.addSeparateurMillier(
                                                              detail["deal"]
                                                                      ["price"]
                                                                  .toString()) +
                                                          " Ꝃ par " +
                                                          utils!.addSeparateurMillier(
                                                              detail["deal"][
                                                                      "priceDeal"]
                                                                  .toString()) +
                                                          " XPF");
                                                }
                                              },
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                    double.parse(
                                                        detail["latitude"]),
                                                    double.parse(
                                                        detail["longitude"])),
                                                zoom: 17.0,
                                              )))
                                      : Container(),
                                  isHours ? SizedBox(height: 10) : Container(),
                                  !isHours
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: Divider(
                                              height: 2,
                                              thickness: 1,
                                              color: Colors.grey[400])),
                                  !isHours ? Container() : SizedBox(height: 10),
                                  !isHours
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Heures d'ouverture",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text("Lundi : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(detail["mondayHour"] ==
                                                          "FERME"
                                                      ? "Fermé"
                                                      : detail["mondayHour"]),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text("Mardi : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(detail["tuesdayHour"] ==
                                                          "FERME"
                                                      ? "Fermé"
                                                      : detail["tuesdayHour"])
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text("Mercredi : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      detail["wednesdayHour"] ==
                                                              "FERME"
                                                          ? "Fermé"
                                                          : detail[
                                                              "wednesdayHour"]),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text("Jeudi : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(detail["thursdayHour"] ==
                                                          "FERME"
                                                      ? "Fermé"
                                                      : detail["thursdayHour"])
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(children: [
                                                Text("Vendredi : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(detail["fridayHour"] ==
                                                        "FERME"
                                                    ? "Fermé"
                                                    : detail["fridayHour"]),
                                              ]),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text("Samedi : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(detail["saturdayHour"] ==
                                                          "FERME"
                                                      ? "Fermé"
                                                      : detail["saturdayHour"])
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(children: [
                                                Text("Dimanche : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(detail["sundayHour"] ==
                                                        "FERME"
                                                    ? "Fermé"
                                                    : detail["sundayHour"]),
                                              ]),
                                            ],
                                          )),
                                  SizedBox(height: 10),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 15, right: 15, bottom: 0),
                                      child: Divider(
                                          height: 2,
                                          thickness: 1,
                                          color: Colors.grey[400])),
                                  SizedBox(height: 10),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 7, right: 7, bottom: 0),
                                      child: Html(
                                        data: detail["deal"]["condition"],
                                      )),
                                  SizedBox(
                                      height: Platform.isAndroid ? 130 : 140)
                                ]))))));
          } else {
            return Scaffold(
                body: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Center(
                      child: LoadingBouncingGrid.square(
                    size: 80,
                    backgroundColor: Colors.cyan[700]!,
                  )),
                ]));
          }
        });
  }
}
