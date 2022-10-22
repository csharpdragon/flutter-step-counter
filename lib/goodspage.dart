import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kayou/tuto/tuto-gift.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'detail-categoryDeal.dart';
import 'detail-dealpage.dart';
import 'detail-giftpage.dart';
import 'tools/globals.dart' as globals;
import 'package:kayou/tools/utils.dart';

class GoodsPage extends StatefulWidget {
  GoodsPageState createState() => GoodsPageState();
}

class GoodsPageState extends State<GoodsPage> {
  List<C2Choice<String>>? choiceItems;
  List<C2Choice<String>>? choiceItemsSave;
  C2Choice<String>? choiceItemsTemp;
  List<String>? chipsValue;

  UtilsState? utils;

  var items;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var myFuture;

  @override
  void initState() {
    utils = new UtilsState();
    utils!.initState();

    if (globals.chipsValueGift == "") {
      globals.chipsValueGift = "2";
    }

    globals.keyDeal = false;
    // print("refreeeeeeeeeesh");
    super.initState();

    if (globals.chipsValueGift == "2") {
      getCategoriesTransfers(globals.categoriesTransfers.length == 0, true);
      myFuture =
          getCategoriesWinGifts(globals.categoriesWinGifts.length == 0, true);
    } else {
      getCategoriesWinGifts(globals.categoriesWinGifts.length == 0, true);
      myFuture =
          getCategoriesTransfers(globals.categoriesTransfers.length == 0, true);
    }
  }

  showTutorialDeal() async {
    await utils!.initTutorialGift();
    // TutorialCoachMark tutorial = TutorialCoachMark(context,
    //     targets: globals.targetsDeal, // List<TargetFocus>
    //     colorShadow: Colors.black, // DEFAULT Colors.black
    //     // alignSkip: Alignment.bottomRight,
    //     textSkip: "Passer le tutoriel",
    //     alignSkip: Alignment.bottomRight,
    //     onFinish: () {
    //       globals.showTutorialDeal = false;
    //       utils!.setBoolValue("showTutorialDeal", false);
    //     },
    //     onClickTarget: (target) {},
    //     onClickOverlay: (p0) {},
    //     onSkip: () {
    //       globals.showTutorialDeal = false;
    //       utils!.setBoolValue("showTutorialDeal", false);
    //     })
    //   ..show();
  }

  getCategoriesWinGifts(bool force, bool init) async {
    //On refresh les points de l'utilisateur pour forcer

    if (force) {
      await utils!.getUserPoints();

      var data = await FirebaseFirestore.instance
          .collection('categories')
          .where("type", isEqualTo: "2")
          .orderBy("name")
          .get();

      await fetchWinGifts(data);
    }

    if (init) {
      if (globals.chipsValueGift == "2") {
        items = globals.categoriesWinGifts;
      }
    }

    if (globals.showTutorialDeal) {
      if (globals.chipsValueGift == "2") {
        await pushNewScreen(
          context,
          screen: TutoGiftPage(),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ).then((value) {
          globals.showTutorialDeal = false;
          utils!.setBoolValue("showTutorialDeal", false);
        });
      }
    }

    return await callAsyncFetch();
  }

  fetchWinGifts(QuerySnapshot collection) async {
    globals.categoriesSaveWinGifts = [];

    collection.docs.forEach((value) {
      List<dynamic> giftsDynamicTemp = value.get('wingifts');

      List<dynamic> listGifts = [];

      int nbGifts;
      if (giftsDynamicTemp.length > 0) {
        giftsDynamicTemp.sort((a, b) {
          var orderA; //before -> var adate = a.expiry;
          var orderB; //var bdate = b.expiry;

          orderA = a['price'];
          orderB = b['price'];
          return orderB.compareTo(orderA);
        });

        nbGifts = 0;
        for (var indiceProgram = 0;
            indiceProgram < giftsDynamicTemp.length;
            indiceProgram++) {
          if (indiceProgram == 25) {
            break;
          }

          listGifts.add(giftsDynamicTemp[indiceProgram]);
          nbGifts++;
        }

        globals.Category category = new globals.Category(
            value.id,
            value.get('name'),
            value.get('type'),
            giftsDynamicTemp.length,
            listGifts,
            giftsDynamicTemp,
            value.id);

        globals.categoriesSaveWinGifts.add(category);
      }
    });

    globals.categoriesWinGifts = globals.categoriesSaveWinGifts;
  }

  getCategoriesTransfers(bool force, bool init) async {
    //On refresh les points de l'utilisateur pour forcer

    if (force) {
      await utils!.getUserPoints();

      var data = await FirebaseFirestore.instance
          .collection('categories')
          .where("type", isEqualTo: "4")
          .orderBy("name")
          .get();

      await fetchTransfers(data);
    }

    if (init) {
      if (globals.chipsValueGift == "4") {
        items = globals.categoriesTransfers;
      }
    }

    if (globals.showTutorialDeal) {
      if (globals.chipsValueGift == "4") {
        await showTutorialDeal();
      }
    }

    return await callAsyncFetch();
  }

  fetchTransfers(QuerySnapshot collection) async {
    globals.categoriesSaveTransfers = [];

    collection.docs.forEach((value) {
      List<dynamic> transfersDynamicTemp = value.get('transfers');

      List<dynamic> listGifts = [];

      if (transfersDynamicTemp.length > 0) {
        transfersDynamicTemp.sort((a, b) {
          var orderA; //before -> var adate = a.expiry;
          var orderB; //var bdate = b.expiry;

          // orderA = a['merchand'];
          // orderB = b['merchand'];
          // return orderA.compareTo(orderB);

          orderA = a['price'];
          orderB = b['price'];
          return orderB.compareTo(orderA);
        });

        for (var indiceProgram = 0;
            indiceProgram < transfersDynamicTemp.length;
            indiceProgram++) {
          if (indiceProgram == 15) {
            break;
          }

          listGifts.add(transfersDynamicTemp[indiceProgram]);
        }

        globals.Category category = new globals.Category(
            value.id,
            value.get('name'),
            value.get('type'),
            transfersDynamicTemp.length,
            listGifts,
            transfersDynamicTemp,
            value.id);

        globals.categoriesSaveTransfers.add(category);
      }
    });

    globals.categoriesTransfers = globals.categoriesSaveTransfers;
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  Future<Null> refreshList() async {
    await Future.delayed(new Duration(seconds: 1));
    // print(chipsValue);
    setState(() {
      if (globals.chipsValueGift == "2") {
        myFuture = getCategoriesWinGifts(true, false);
      } else {
        myFuture = getCategoriesTransfers(true, false);
      }
    });

    return null;
  }

  applyFilters(filter) async {
    switch (filter) {
      case "2":
        {
          items = globals.categoriesWinGifts;
        }
        break;
      case "4":
        {
          items = globals.categoriesTransfers;
        }
        break;
    }
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
                        leadingWidth: 150,
                        toolbarHeight: 50,
                        centerTitle: true,
                        title: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text("Récompenses",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18))),
                        leading: Container(
                            margin: EdgeInsets.only(
                                left: 13, top: 10, bottom: 10, right: 13),
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(20),
                            //     color: Colors.orange[700]),
                            child: Row(children: [
                              Icon(Icons.account_balance_wallet_outlined,
                                  color: Colors.cyan[700]!),
                              SizedBox(width: 10),
                              Text(
                                  utils!.addSeparateurMillier(
                                          globals.profitUser.toString()) +
                                      " Ꝃ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ])),
                        actions: [
                          // IconButton(
                          //   icon: Icon(CupertinoIcons.info),
                          //   onPressed: () {
                          //     showTutorialGift();
                          //   },
                          // )
                          Container(
                              margin: EdgeInsets.only(right: 10),
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
                                      screen: TutoGiftPage(),
                                      withNavBar:
                                          false, // OPTIONAL VALUE. True by default.
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  ),
                                  child: Container(
                                      child: Image.asset(
                                    "assets/images/tuto_icon.png",
                                    height: 32,
                                    width: 32,
                                    fit: BoxFit.fill,
                                  ))))
                        ]),
                    backgroundColor: Colors.white,
                    // body: Container())));
                    body: RefreshIndicator(
                        key: refreshKey,
                        onRefresh: refreshList,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.zero,
                                  child: ChipsChoice<String>.single(
                                    key: globals.keyButtonDeal,
                                    placeholder: "",
                                    value: globals.chipsValueGift,
                                    onChanged: (val) async {
                                      globals.chipsValueGift = val;
                                      await applyFilters(
                                          globals.chipsValueGift);
                                      setState(() {
                                        // print(value);
                                      });
                                    },
                                    choiceBuilder: (item) {
                                      return (Container(
                                          margin: EdgeInsets.only(
                                            left: 20,
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          height: 33,

                                          // key: globals.keyButtonGift1,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.transparent,
                                                onSurface: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                onPrimary: Colors.transparent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: item.selected
                                                          ? Colors.cyan[700]!
                                                          : Colors.grey,
                                                      width:
                                                          item.selected ? 2 : 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                40))),
                                              ),
                                              onPressed: () async {
                                                globals.chipsValueGift =
                                                    item.value;
                                                await applyFilters(
                                                    globals.chipsValueGift);
                                                setState(() {
                                                  // print(value);
                                                });
                                              },
                                              child: Text(item.label,
                                                  key: item.meta,
                                                  style: TextStyle(
                                                      color: item.selected
                                                          ? Colors.cyan[700]!
                                                          : Colors.grey,
                                                      fontWeight: item.selected
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal)))));
                                    },
                                    choiceItems: globals
                                        .choiceItemsMenuGifts.reversed
                                        .toList(),
                                    choiceStyle: C2ChoiceStyle(
                                      brightness: Brightness.light,
                                      showCheckmark: false,
                                      color: Colors.transparent,
                                    ),
                                    choiceActiveStyle: C2ChoiceStyle(
                                        showCheckmark: false,
                                        color: Colors.red,
                                        borderColor: Colors.orange[700],
                                        borderWidth: 1.5,
                                        // padding: EdgeInsets.zero,
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            // backgroundColor: Colors.black,
                                            color: Colors.orange[700])),
                                    wrapped: false,
                                    textDirection: TextDirection.rtl,
                                    direction: Axis.horizontal,
                                  )),
                              Expanded(
                                  child: ListView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            height: 30,
                                          ),
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 15),
                                          itemCount: items[index].lists.length,
                                          itemBuilder: (context, indexList) {
                                            var raisedButton;

                                            raisedButton = ElevatedButton(
                                                onPressed: () async {
                                                  pushNewScreen(context,
                                                      screen: DetailGiftPage(
                                                          items[index].lists[
                                                              indexList]["id"],
                                                          globals
                                                              .chipsValueGift),
                                                      withNavBar: true,
                                                      pageTransitionAnimation:
                                                          PageTransitionAnimation
                                                              .cupertino);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.transparent,
                                                  onPrimary: Colors.black,
                                                  onSurface: Colors.transparent,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  shadowColor: Colors.white,
                                                ),
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            50,
                                                    height: 310,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.grey[100],
                                                      // border: Border.all(
                                                      //     color: Colors.grey[
                                                      //         100],
                                                      //     width:
                                                      //         1),
                                                    ),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        utils!.addSeparateurMillier(items[index].lists[indexList]["price"].toString()) +
                                                                            " Ꝃ",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.cyan[700]!,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 14)),
                                                                    Text(
                                                                        globals.chipsValueGift ==
                                                                                "2"
                                                                            ? " pour obtenir ce cadeau"
                                                                            : " pour obtenir ce versement",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Icon(
                                                                        Iconic
                                                                            .arrow_curved,
                                                                        color: Colors
                                                                            .cyan[700])
                                                                  ])),
                                                          Container(
                                                            height: 190,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: items[index]
                                                                          .lists[
                                                                      indexList]
                                                                  [
                                                                  "imagePresentation"],
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    50,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  // borderRadius: BorderRadius.only(
                                                                  //     topLeft: Radius
                                                                  //         .circular(
                                                                  //             20),
                                                                  //     topRight:
                                                                  //         Radius.circular(
                                                                  //             20)),
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  Container(
                                                                      height:
                                                                          190,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          200,
                                                                      child: Center(
                                                                          child: Container(
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: CircularProgressIndicator(
                                                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                                                                              )))),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    right: 5),
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Row(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl: items[index]
                                                                            .lists[indexList]
                                                                        [
                                                                        "merchandLogo"],
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      width: 60,
                                                                      height:
                                                                          60,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(60),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context, url) => Container(
                                                                        height: 60,
                                                                        width: 60,
                                                                        child: Center(
                                                                            child: Container(
                                                                                height: 20,
                                                                                width: 20,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                                                                                )))),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          140,
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(items[index].lists[indexList]["merchand"],
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                            // SizedBox(height: 2),
                                                                            chipsValue == "4"
                                                                                ? Container()
                                                                                : Text(items[index].lists[indexList]["subtitle"], textAlign: TextAlign.left, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.deepOrange[900])),
                                                                            // SizedBox(height: 2),
                                                                            Text(items[index].lists[indexList]["title"],
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontSize: 14))
                                                                          ])),
                                                                ]),
                                                          ),
                                                          SizedBox(height: 10),
                                                        ])));

                                            if (index == items.length - 1) {
                                              return Column(children: [
                                                raisedButton,
                                                SizedBox(height: 30),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    child: Column(children: [
                                                      Text(
                                                          "Pour plus d'informations sur la fonctionnement des récompenses, vous pouvez consulter nos",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12)),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          elevation: 0,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: Colors
                                                              .transparent,
                                                          onPrimary:
                                                              Colors.black,
                                                          onSurface: Colors
                                                              .transparent,
                                                          shadowColor: Colors
                                                              .transparent,
                                                        ),
                                                        child: Text(
                                                            "Conditions Générales d'Utilisation",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline)),
                                                        onPressed: () {
                                                          utils!.openLink(
                                                              'http://kayou.nc/conditions-generales-dutilisation/');
                                                        },
                                                      )
                                                    ]))
                                              ]);
                                            } else {
                                              return raisedButton;
                                            }
                                          },
                                        ),
                                        SizedBox(height: 30),

                                        // ])
                                        // ),
                                      ]);
                                },
                              ))
                            ])));
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
            }));
  }
}
