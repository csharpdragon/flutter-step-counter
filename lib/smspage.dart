import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:kayou/tools/utils.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'detail-smspage.dart';
import 'tools/globals.dart' as globals;

class SmsPage extends StatefulWidget {
  SmsPageState createState() => SmsPageState();
}

class SmsPageState extends State<SmsPage> {
  UtilsState? utils;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var myFuture;

  var items;

  @override
  void initState() {
    utils = new UtilsState();
    utils!.initState();

    super.initState();

    myFuture = getSmsGames(true);
  }

  getSmsGames(bool force) async {
    if (force) {
      List<dynamic> smsGamesTemp = [];
      var data = await FirebaseFirestore.instance
          .collection('sms-games')
          .where("isActive", isEqualTo: true)
          .get();

      data.docs.forEach((value) {
        smsGamesTemp.add({'id': value.id, 'datas': value.data()});
      });

      globals.smsGames = smsGamesTemp;
    }

    return await callAsyncFetch();
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  Future<Null> refreshList() async {
    await Future.delayed(new Duration(seconds: 1));
    // print(chipsValue);
    setState(() {
      myFuture = getSmsGames(true);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.grey[200],
                      elevation: 0,
                      leadingWidth: 120,
                      toolbarHeight: 50,
                      centerTitle: true,
                      title: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text("Jeux SMS",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18))),
                      leading: Container(
                          margin: EdgeInsets.only(
                              left: 0, top: 10, bottom: 10, right: 13),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Colors.transparent,
                                onPrimary: Colors.transparent,
                                onSurface: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Row(children: [
                                Icon(Icons.arrow_back,
                                    color: Colors.cyan[700]!),
                                Text("Retour",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.cyan[700]!))
                              ]))),
                      actions: [],
                    ),
                    backgroundColor: Colors.white,
                    // body: Container())));
                    body: RefreshIndicator(
                        key: refreshKey,
                        onRefresh: refreshList,
                        child: Container(
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 15);
                                },
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: true,
                                scrollDirection: Axis.vertical,
                                itemCount: globals.smsGames.length,
                                itemBuilder: (context, indexGame) {
                                  var raisedButton;

                                  raisedButton = ElevatedButton(
                                      onPressed: () async {
                                        pushNewScreen(context,
                                            screen: DetailSmsPage(
                                                globals.smsGames[indexGame]),
                                            withNavBar: true,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        onPrimary: Colors.black,
                                        onSurface: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding:
                                            EdgeInsets.only(left: 0, right: 0),
                                      ),
                                      child: Container(
                                          height: 400,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey[100],
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    height: 30,
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              globals.smsGames[
                                                                          indexGame][
                                                                          "datas"][
                                                                          "points"]
                                                                      .toString() +
                                                                  " Ꝃ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .cyan[
                                                                      700],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      14)),
                                                          Text(
                                                              " en jouant à ce jeu",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(width: 10),
                                                          Icon(
                                                              Iconic
                                                                  .arrow_curved,
                                                              color: Colors
                                                                  .cyan[700])
                                                        ])),
                                                Container(
                                                  height: 290,
                                                  child: CachedNetworkImage(
                                                    imageUrl: globals
                                                            .smsGames[indexGame]
                                                        ["datas"]["image"],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      //************************************* */
                                                      /* A DECOMMENTER POUR LE TAG DISPONIBLE / INDISPONIBLE*/
                                                      // child: Column(
                                                      //     children: [
                                                      //       Container(
                                                      //         margin:
                                                      //             EdgeInsets.all(15),
                                                      //         alignment:
                                                      //             Alignment.topRight,
                                                      //         padding:
                                                      //             EdgeInsets.all(5),
                                                      //         height:
                                                      //             30,
                                                      //         child: globals.selectedMenuDeals.categories[index].gift[indexPrograms]["payable"] == true
                                                      //             ? Icon(Icons.lock_outline, size: 45, color: Colors.grey[500])
                                                      //             : Container(),
                                                      //       ),
                                                      //     ]),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            height: 190,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                200,
                                                            child: Center(
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              new AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                                                                        )))),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Row(children: [
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            80,
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  globals.smsGames[
                                                                              indexGame]
                                                                          [
                                                                          "datas"]
                                                                      ["title"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16)),
                                                              SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                  "Coût : " +
                                                                      globals
                                                                          .smsGames[
                                                                              indexGame]
                                                                              [
                                                                              "datas"]
                                                                              [
                                                                              "price"]
                                                                          .toString() +
                                                                      " XPF TTC",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      color: Colors
                                                                              .deepOrange[
                                                                          900])),
                                                              SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                  globals.smsGames[
                                                                              indexGame]
                                                                          [
                                                                          "datas"]
                                                                      [
                                                                      "shortDescription"],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ])),
                                                  ]),
                                                )
                                              ])));
                                  return raisedButton;
                                }))));
              } else {
                return Scaffold(
                    backgroundColor: Colors.white,
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
            }));
  }
}
