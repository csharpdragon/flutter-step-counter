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
import 'package:kayou/profil/change-profilemail.dart';
import 'package:kayou/tools/utils.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'tools/globals.dart' as globals;
import 'dart:ui' as ui;
import 'package:confirm_dialog/confirm_dialog.dart';

class DetailGiftPage extends StatefulWidget {
  final String merchandId;
  final String type;

  DetailGiftPage(this.merchandId, this.type);

  DetailGiftPageState createState() => DetailGiftPageState();
}

class DetailGiftPageState extends State<DetailGiftPage> {
  UtilsState? utils;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  bool isExpanded = false;
  bool isHours = false;

  final CarouselController _controller = CarouselController();

  int _currentImage = 0;

  var detail;

  List<String> images = [];

  var myFuture;
  bool isSiteWeb = false;
  bool isFacebook = false;
  bool isTel = false;
  bool isEmail = false;
  bool isAdress = false;
  bool isMap = false;

  GoogleMapController? mapController;

  ScrollController? scrollController;

  Uint8List? selectedMarkerIcon;

  String? type;

  @override
  void initState() {
    utils = new UtilsState();
    utils!.initState();

    super.initState();
    myFuture = getGift();
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

  getGift() async {
    var data = await FirebaseFirestore.instance
        .collection('merchands')
        .doc(widget.merchandId)
        .get();

    detail = data.data();
    images = [];
    switch (widget.type) {
      case "1":
        {
          for (var i = 0; i < detail["gift"]["imageDescription"].length; i++) {
            if (detail["gift"]["imageDescription"][i] != "NA") {
              images.add(detail["gift"]["imageDescription"][i]);
            }
          }
          type = "gift";
          break;
        }
      case "2":
        {
          for (var i = 0;
              i < detail["wingift"]["imageDescription"].length;
              i++) {
            if (detail["wingift"]["imageDescription"][i] != "NA") {
              images.add(detail["wingift"]["imageDescription"][i]);
            }
          }
          type = "wingift";
          break;
        }
      case "4":
        {
          for (var i = 0;
              i < detail["transfer"]["imageDescription"].length;
              i++) {
            if (detail["transfer"]["imageDescription"][i] != "NA") {
              images.add(detail["transfer"]["imageDescription"][i]);
            }
          }
          type = "transfer";
          break;
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
      myFuture = getGift();
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
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarBrightness: Brightness.dark,
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarDividerColor: Colors.transparent),
                      toolbarHeight: 90,
                      elevation: 0,
                      leadingWidth: 65,
                      leading: Container(
                          margin:
                              EdgeInsets.only(top: 25, left: 10, bottom: 10),
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
                    floatingActionButton: globals.profitUser <
                            detail[type]["price"]
                        ? Container(
                            margin:
                                EdgeInsets.only(bottom: 5, left: 25, right: 25),
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.cyan[700]!),
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                                alignment: Alignment.center,
                                child:
                                    Text("Il vous manque " + utils!.addSeparateurMillier((detail[type]["price"] - globals.profitUser).toString()) + " Ꝃ",
                                        style: TextStyle(
                                            color: Colors.cyan[100],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))))
                        : Container(
                            margin:
                                EdgeInsets.only(bottom: 5, left: 25, right: 25),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.cyan[700]!,
                                borderRadius: BorderRadius.circular(60)),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  onPrimary: Colors.transparent,
                                  onSurface: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  primary: Colors.cyan[700]!,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                onPressed: () async {
                                  if (await utils!.isConnectedToInternet()) {
                                    if (widget.type == "2") {
                                      utils!.makePhoneCall(
                                          'tel:' + detail["telApp"]);
                                    }
                                    //Cas ou on est dans une récompense et que le commercant utilise un code promo (Exemple boutique en ligne)
                                    else if (widget.type == "1" &&
                                        detail[type]["promoCode"].length > 0) {
                                      if (globals.email.length == 0) {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          closeIcon: Container(),
                                          title: "",
                                          desc:
                                              "Veuillez paramétrer une adresse email valide sur votre profil utilisateur",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "Modifier",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              onPressed: () {
                                                pushNewScreen(context,
                                                        screen:
                                                            ProfilEmailPage(),
                                                        withNavBar: true,
                                                        pageTransitionAnimation:
                                                            PageTransitionAnimation
                                                                .cupertino)
                                                    .then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              color: Color.fromRGBO(
                                                  0, 179, 134, 1.0),
                                            ),
                                          ],
                                        ).show();
                                      } else {
                                        if (await confirm(
                                          context,
                                          title: Text('Confirmation'),
                                          content: Text(
                                              'Voulez-vous vraiment utiliser vos kayous chez ce commerçant?'),
                                          textOK: Text('Oui'),
                                          textCancel: Text('Non'),
                                        )) {
                                          if (await utils!.usePoints(
                                              detail[type]["price"])) {
                                            //On envoi le mail + ouverture popup code promo
                                            utils!.sendEmail(
                                                context,
                                                globals.email,
                                                "Achat chez " + detail["name"],
                                                "Bonjour, \n\nVeuillez trouver ci-après le code promo à utiliser sur notre site internet.\n\n" +
                                                    detail[type]["promoCode"] +
                                                    "\n\n" +
                                                    detail["name"]);
                                            utils!.openPopupPromo(
                                                context,
                                                detail["name"],
                                                detail[type]["promoCode"]);
                                          }
                                        }
                                      }
                                    } else {
                                      utils!.openQRCode(context);
                                    }
                                  } else {
                                    utils!
                                        .showInternetConnectionDialog(context);
                                  }
                                },
                                child: MediaQuery(
                                    data: MediaQuery.of(context).copyWith(
                                      textScaleFactor: 1.0,
                                    ),
                                    child: Container(
                                        child: Text("Utiliser vos Kayous (Ꝃ)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))))),
                    body: RefreshIndicator(
                        key: refreshKey,
                        onRefresh: refreshList,
                        child: SingleChildScrollView(
                            controller: scrollController,
                            child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  textScaleFactor: 1.0,
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
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
                                                          textScaleFactor: 1,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20))),
                                                  SizedBox(height: 5),
                                                  Text(
                                                      detail[type]
                                                          ["subcategoryName"],
                                                      textScaleFactor: 1,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.grey)),
                                                  SizedBox(height: 10),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              90,
                                                      child: Text(
                                                          detail[type]["title"],
                                                          textScaleFactor: 1,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16,
                                                              color: Colors
                                                                      .deepOrange[
                                                                  900])))
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
                                  SizedBox(height: 15),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Text(
                                          "Prix : " +
                                              utils!.addSeparateurMillier(
                                                  detail[type]["price"]
                                                      .toString()) +
                                              " Ꝃ",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                              color: Colors.cyan[700]!,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18))),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 7, right: 7, bottom: 0),
                                    child: Html(
                                      data: detail[type]["description"],
                                    ),

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
                                                (isTel && widget.type != "2")
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
                                                      detail[type]["title"]);
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
                                  widget.type == "1" && isMap
                                      ? SizedBox(height: 10)
                                      : Container(),
                                  widget.type == "1" && isMap
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15, bottom: 0),
                                          child: Divider(
                                              height: 2,
                                              thickness: 1,
                                              color: Colors.grey[400]))
                                      : Container(),
                                  widget.type == "1" && isMap
                                      ? SizedBox(height: 10)
                                      : Container(),
                                  widget.type == "1" && isMap
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
                                                  infoWindow: InfoWindow.noText,
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
                                                      detail[type]["title"]);
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
                                        data: detail[type]["condition"],
                                      )),
                                  SizedBox(
                                      height: Platform.isAndroid ? 120 : 130)
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
