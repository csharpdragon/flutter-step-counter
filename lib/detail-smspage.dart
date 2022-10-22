import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';

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

class DetailSmsPage extends StatefulWidget {
  final dynamic sms;

  DetailSmsPage(this.sms);

  DetailSmsPageState createState() => DetailSmsPageState();
}

class DetailSmsPageState extends State<DetailSmsPage> {
  UtilsState? utils;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var myFuture;

  final CarouselController _controller = CarouselController();

  ScrollController? scrollController;

  @override
  void initState() {
    utils = new UtilsState();
    utils!.initState();

    super.initState();
    myFuture = callAsyncFetch();
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

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
                          statusBarBrightness: Brightness.light,
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarDividerColor: Colors.transparent),
                      // toolbarHeight: 90,
                      title: Text(widget.sms["datas"]["title"],
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      elevation: 0,
                      leadingWidth: 65,
                      leading: Container(
                          // margin:
                          //     EdgeInsets.only(top: 25, left: 10, bottom: 10),
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
                    extendBodyBehindAppBar: false,
                    backgroundColor: Colors.white,
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: Container(
                        margin: EdgeInsets.only(left: 25, right: 25),
                        height: 60,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onPressed: () async {
                              utils!.sendSMS(widget.sms["datas"]["noTel"],
                                  widget.sms["datas"]["code"]);
                            },
                            child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  textScaleFactor: 1.0,
                                ),
                                child: Container(
                                  child: Text("Jouez maintenant",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                )))),
                    body: SingleChildScrollView(
                        controller: scrollController,
                        child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaleFactor: 1.0,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Container(
                                  //     child: Column(children: [
                                  //   CarouselSlider(
                                  //     carouselController: _controller,
                                  //     options: CarouselOptions(
                                  //         viewportFraction: 1,
                                  //         enlargeCenterPage: true,
                                  //         aspectRatio: 1.4,
                                  //         scrollDirection: Axis.horizontal,
                                  //         onPageChanged: (index, reason) {
                                  //           setState(() {
                                  //             _currentImage = index;
                                  //           });
                                  //         }),
                                  //     items: images
                                  //         .map((item) => CachedNetworkImage(
                                  //               imageUrl: item,
                                  //               imageBuilder:
                                  //                   (context, imageProvider) =>
                                  //                       Container(
                                  //                 height: 500,
                                  //                 decoration: BoxDecoration(
                                  //                   image: DecorationImage(
                                  //                     image: imageProvider,
                                  //                     fit: BoxFit.cover,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //               placeholder: (context, url) =>
                                  //                   Container(
                                  //                       child: Center(
                                  //                           child: Container(
                                  //                               height: 20,
                                  //                               width: 20,
                                  //                               child:
                                  //                                   CircularProgressIndicator(
                                  //                                 valueColor: new AlwaysStoppedAnimation<
                                  //                                         Color>(
                                  //                                     Colors.grey[
                                  //                                         400]),
                                  //                               )))),
                                  //               errorWidget:
                                  //                   (context, url, error) =>
                                  //                       Icon(Icons.error),
                                  //             ))
                                  //         .toList(),
                                  //   ),
                                  //   Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children:
                                  //         images.asMap().entries.map((entry) {
                                  //       return GestureDetector(
                                  //         onTap: () => _controller
                                  //             .animateToPage(entry.key),
                                  //         child: Container(
                                  //           width: 8.0,
                                  //           height: 8.0,
                                  //           margin: EdgeInsets.symmetric(
                                  //               vertical: 8.0, horizontal: 4.0),
                                  //           decoration: BoxDecoration(
                                  //               shape: BoxShape.circle,
                                  //               color: (Theme.of(context)
                                  //                               .brightness ==
                                  //                           Brightness.dark
                                  //                       ? Colors.white
                                  //                       : Colors.black)
                                  //                   .withOpacity(
                                  //                       _currentImage ==
                                  //                               entry.key
                                  //                           ? 0.9
                                  //                           : 0.2)),
                                  //         ),
                                  //       );
                                  //     }).toList(),
                                  //   ),
                                  // ])),
                                  // SizedBox(height: 10),
                                  Container(
                                      // padding:
                                      //     EdgeInsets.only(left: 15, right: 15),
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
                                                height: 290,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.sms["datas"]
                                                      ["image"],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                          height: 190,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              200,
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
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      90,
                                                  child: Text(
                                                      "Coût du SMS : " +
                                                          utils!.addSeparateurMillier(
                                                              widget
                                                                  .sms["datas"]
                                                                      ["price"]
                                                                  .toString()) +
                                                          " XPF TTC",
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color:
                                                              Colors.deepOrange[
                                                                  900])))
                                            ]),

                                        // CachedNetworkImage(
                                        //   imageUrl: detail["logo"],
                                        //   imageBuilder:
                                        //       (context, imageProvider) =>
                                        //           Container(
                                        //     width: 60,
                                        //     height: 60,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(60),
                                        //       image: DecorationImage(
                                        //         image: imageProvider,
                                        //         fit: BoxFit.cover,
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   placeholder: (context, url) =>
                                        //       Container(
                                        //           height: 60,
                                        //           width: 60,
                                        //           child: Center(
                                        //               child: Container(
                                        //                   height: 20,
                                        //                   width: 20,
                                        //                   child:
                                        //                       CircularProgressIndicator(
                                        //                     valueColor:
                                        //                         new AlwaysStoppedAnimation<
                                        //                             Color>(Colors
                                        //                                 .grey[
                                        //                             400]),
                                        //                   )))),
                                        //   errorWidget:
                                        //       (context, url, error) =>
                                        //           Icon(Icons.error),
                                        // )
                                      ])),
                                  SizedBox(height: 15),

                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(children: [
                                        Text(
                                            widget.sms["datas"]["points"] > 1
                                                ? "Kayous gagnés : " +
                                                    utils!.addSeparateurMillier(
                                                        widget.sms["datas"]
                                                                ["points"]
                                                            .toString()) +
                                                    "Ꝃ"
                                                : "Kayou gagné : " +
                                                    utils!.addSeparateurMillier(
                                                        widget.sms["datas"]
                                                                ["points"]
                                                            .toString()) +
                                                    "Ꝃ",
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                color: Colors.cyan[700]!,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        // Text(
                                        //     " en jouant à ce jeu SMS via l'application",
                                        //     textScaleFactor: 1,
                                        //     style: TextStyle(
                                        //         color: Colors.black,
                                        //         // fontWeight: FontWeight.bold,
                                        //         fontSize: 16))
                                      ])),
                                  SizedBox(height: 15),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Text(
                                          "Pour recevoir vos Kayous, ne modifiez pas le contenu du SMS",
                                          // overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.red[900],
                                          ))),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 7, right: 7, bottom: 0),
                                    child: Html(
                                      data: widget.sms["datas"]["description"],
                                    ),

                                    // Text(detail["gift"]["description"],
                                    //     textAlign: TextAlign.justify,
                                    //     style: TextStyle(fontSize: 15))
                                  ),
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
                                        data: widget.sms["datas"]["condition"],
                                      )),
                                  SizedBox(height: Platform.isAndroid ? 50 : 60)
                                ])))));
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
