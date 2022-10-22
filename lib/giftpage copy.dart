// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chips_choice/chips_choice.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:kayou/detail-giftpage.dart';
// import 'package:kayou/tools/utils.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'detail-categoryGift.dart';
// import 'tools/globals.dart' as globals;

// class GiftPage extends StatefulWidget {
//   GiftPageState createState() => GiftPageState();
// }

// class GiftPageState extends State<GiftPage> {
//   globals.Menu menuGiftTemp;
//   C2Choice<String> choiceItemsTemp;
//   String chipsValue;

//   UtilsState utils;

//   var refreshKey = GlobalKey<RefreshIndicatorState>();

//   var myFuture;

//   var items;

//   @override
//   void initState() {
//     utils = new UtilsState();
//     utils.initState();

//     super.initState();

//     if (globals.chipsValue == "") {
//       globals.chipsValue = "1";
//     }

//     getCategoriesWinGifts(globals.categoriesWinGifts.length == 0, true);
//     getCategoriesTransfers(globals.categoriesTransfers.length == 0, true);
//     // myFuture = getCategoriesGifts(globals.categoriesGifts.length == 0, true);
//   }

//   getCategoriesGifts(bool force, bool init) async {
//     //On refresh les points de l'utilisateur pour forcer

//     // setState(() {
//     // chipsValue = "1";
//     await applyFilters(globals.chipsValue);
//     // });
//     if (force) {
//       await utils.getUserPoints();

//       var data = await FirebaseFirestore.instance
//           .collection('categories')
//           .where("type", isEqualTo: "1")
//           .orderBy("name")
//           .get();

//       await fetchGifts(data);
//     }

//     if (init) {
//       // items = globals.categoriesGifts;
//     }

//     if (globals.showTutorialGift) {
//       await showTutorialGift();
//     }

//     return await callAsyncFetch();
//   }

//   showTutorialGift() async {
//     await utils.initTutorialGift();
//     TutorialCoachMark tutorial = TutorialCoachMark(context,
//         targets: globals.targetsGift, // List<TargetFocus>
//         colorShadow: Colors.black, // DEFAULT Colors.black
//         // alignSkip: Alignment.bottomRight,
//         textSkip: "Passer le tutoriel",
//         alignSkip: Alignment.bottomRight,
//         onFinish: () {
//           globals.showTutorialGift = false;
//           utils.setBoolValue("showTutorialGift", false);
//         },
//         onClickTarget: (target) {},
//         onClickOverlay: (p0) {},
//         onSkip: () {
//           globals.showTutorialGift = false;
//           utils.setBoolValue("showTutorialGift", false);
//         })
//       ..show();
//   }

//   fetchGifts(QuerySnapshot collection) async {
//     bool isFound;

//     globals.categoriesSaveGifts = [];

//     collection.docs.forEach((value) {
//       isFound = false;

//       List<dynamic> giftsDynamicTemp = value.get('gifts');

//       List<dynamic> listGifts = [];

//       int nbGifts;
//       if (giftsDynamicTemp.length > 0) {
//         giftsDynamicTemp.sort((a, b) {
//           var orderA; //before -> var adate = a.expiry;
//           var orderB; //var bdate = b.expiry;

//           orderA = a['merchand'];
//           orderB = b['merchand'];
//           return orderA.compareTo(orderB);
//         });

//         nbGifts = 0;
//         for (var indiceProgram = 0;
//             indiceProgram < giftsDynamicTemp.length;
//             indiceProgram++) {
//           if (indiceProgram == 15) {
//             break;
//           }

//           listGifts.add(giftsDynamicTemp[indiceProgram]);
//           nbGifts++;
//         }

//         for (var i = 0; i < globals.categoriesSaveGifts.length; i++) {
//           if (globals.categoriesSaveGifts[i].id == value["uidcategory"]) {
//             isFound = true;

//             for (var indiceProgram = 0;
//                 indiceProgram < giftsDynamicTemp.length;
//                 indiceProgram++) {
//               globals.categoriesSaveGifts[i].listsAll
//                   .add(giftsDynamicTemp[indiceProgram]);
//               nbGifts++;
//             }

//             globals.categoriesSaveGifts[i].nbItems =
//                 globals.categoriesSaveGifts[i].nbItems +
//                     giftsDynamicTemp.length;

//             if (globals.categoriesSaveGifts[i].lists.length <= 15) {
//               for (var j = 0; j < giftsDynamicTemp.length; j++) {
//                 if (globals.categoriesSaveGifts[i].lists.length == 15) {
//                   break;
//                 }
//                 globals.categoriesSaveGifts[i].lists.add(giftsDynamicTemp[j]);
//               }
//             }

//             globals.categoriesSaveGifts[i].listsAll.sort((a, b) {
//               var orderA; //before -> var adate = a.expiry;
//               var orderB; //var bdate = b.expiry;
//               // print(a['merchand']);
//               orderA = a['merchand'];
//               orderB = b['merchand'];
//               return orderA.compareTo(orderB);
//             });

//             globals.categoriesSaveGifts[i].lists.sort((a, b) {
//               var orderA; //before -> var adate = a.expiry;
//               var orderB; //var bdate = b.expiry;

//               orderA = a['merchand'];
//               orderB = b['merchand'];
//               return orderA.compareTo(orderB);
//             });
//           }

//           // print(globals.categoriesSaveGifts[i].listsAll);

//         }

//         if (!isFound) {
//           globals.Category category = new globals.Category(
//               value["uidcategory"],
//               value["category"],
//               value.get('type'),
//               giftsDynamicTemp.length,
//               listGifts,
//               giftsDynamicTemp,
//               value.id);

//           globals.categoriesSaveGifts.add(category);
//         }
//       }
//     });

//     // globals.categoriesGifts = globals.categoriesSaveGifts;
//     globals.selectedMenuGifts.categories = globals.categoriesSaveGifts;
//   }

//   getCategoriesWinGifts(bool force, bool init) async {
//     //On refresh les points de l'utilisateur pour forcer

//     if (force) {
//       await utils.getUserPoints();

//       var data = await FirebaseFirestore.instance
//           .collection('categories')
//           .where("type", isEqualTo: "2")
//           .orderBy("name")
//           .get();

//       await fetchWinGifts(data);
//     }

//     if (!init) {
//       items = globals.categoriesWinGifts;
//     }

//     return await callAsyncFetch();
//   }

//   getCategoriesDeals(bool force) async {
//     if (force) {
//       // print("refresh");
//       await utils.getUserPoints();

//       var data = await FirebaseFirestore.instance
//           .collection('categories')
//           .where("type", isEqualTo: "5")
//           .orderBy("name")
//           .get();

//       await fetchDeals(data, force);
//     }

//     return await callAsyncFetch();
//   }

//   fetchDeals(QuerySnapshot collection, bool force) async {
//     if (force) {
//       bool isFound;

//       globals.categoriesSave = [];

//       collection.docs.forEach((value) {
//         isFound = false;
//         List<dynamic> dealsDynamicTemp = value["deals"];

//         List<dynamic> listDeals = [];

//         int nbDeals;
//         if (dealsDynamicTemp.length > 0) {
//           dealsDynamicTemp.sort((a, b) {
//             var orderA; //before -> var adate = a.expiry;
//             var orderB; //var bdate = b.expiry;

//             orderA = a['merchand'];
//             orderB = b['merchand'];
//             return orderA.compareTo(orderB);
//           });

//           nbDeals = 0;
//           for (var indiceProgram = 0;
//               indiceProgram < dealsDynamicTemp.length;
//               indiceProgram++) {
//             if (indiceProgram == 15) {
//               break;
//             }

//             listDeals.add(dealsDynamicTemp[indiceProgram]);
//             nbDeals++;
//           }

//           for (var i = 0; i < globals.categoriesSave.length; i++) {
//             if (globals.categoriesSave[i].id == value["uidcategory"]) {
//               isFound = true;
//               for (var indiceProgram = 0;
//                   indiceProgram < dealsDynamicTemp.length;
//                   indiceProgram++) {
//                 globals.categoriesSave[i].listsAll
//                     .add(dealsDynamicTemp[indiceProgram]);
//               }

//               globals.categoriesSave[i].nbItems =
//                   globals.categoriesSave[i].nbItems + dealsDynamicTemp.length;

//               if (globals.categoriesSave[i].lists.length <= 15) {
//                 for (var j = 0; j < dealsDynamicTemp.length; j++) {
//                   if (globals.categoriesSave[i].lists.length == 15) {
//                     break;
//                   }
//                   globals.categoriesSave[i].lists.add(dealsDynamicTemp[j]);
//                 }
//               }

//               globals.categoriesSave[i].listsAll.sort((a, b) {
//                 var orderA; //before -> var adate = a.expiry;
//                 var orderB; //var bdate = b.expiry;
//                 // print(a['merchand']);
//                 orderA = a['merchand'];
//                 orderB = b['merchand'];
//                 return orderA.compareTo(orderB);
//               });

//               globals.categoriesSave[i].lists.sort((a, b) {
//                 var orderA; //before -> var adate = a.expiry;
//                 var orderB; //var bdate = b.expiry;

//                 orderA = a['merchand'];
//                 orderB = b['merchand'];
//                 return orderA.compareTo(orderB);
//               });
//             }
//           }
//           if (!isFound) {
//             globals.Category category = new globals.Category(
//                 value["uidcategory"],
//                 value["category"],
//                 value["type"],
//                 dealsDynamicTemp.length,
//                 listDeals,
//                 dealsDynamicTemp,
//                 value.id);

//             globals.categoriesSave.add(category);

//             choiceItemsTemp = new C2Choice<String>(
//                 label: value["category"].toString(),
//                 value: value.id,
//                 activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//                 disabled: false,
//                 selected: false);
//           }
//         }
//       });

//       globals.categoriesOffers = globals.categoriesSave;
//     }
//   }

//   fetchWinGifts(QuerySnapshot collection) async {
//     globals.categoriesSaveWinGifts = [];

//     collection.docs.forEach((value) {
//       List<dynamic> giftsDynamicTemp = value.get('wingifts');

//       List<dynamic> listGifts = [];

//       int nbGifts;
//       if (giftsDynamicTemp.length > 0) {
//         giftsDynamicTemp.sort((a, b) {
//           var orderA; //before -> var adate = a.expiry;
//           var orderB; //var bdate = b.expiry;

//           orderA = a['price'];
//           orderB = b['price'];
//           return orderB.compareTo(orderA);
//         });

//         nbGifts = 0;
//         for (var indiceProgram = 0;
//             indiceProgram < giftsDynamicTemp.length;
//             indiceProgram++) {
//           if (indiceProgram == 15) {
//             break;
//           }

//           listGifts.add(giftsDynamicTemp[indiceProgram]);
//           nbGifts++;
//         }

//         globals.Category category = new globals.Category(
//             value.id,
//             value.get('name'),
//             value.get('type'),
//             giftsDynamicTemp.length,
//             listGifts,
//             giftsDynamicTemp,
//             value.id);

//         globals.categoriesSaveWinGifts.add(category);
//       }
//     });

//     globals.categoriesWinGifts = globals.categoriesSaveWinGifts;

//     //On ajoute au menu "Cadeaux"
//     globals.selectedMenuWinGifts.categories = globals.categoriesWinGifts;
//   }

//   getCategoriesTransfers(bool force, bool init) async {
//     //On refresh les points de l'utilisateur pour forcer

//     if (force) {
//       await utils.getUserPoints();

//       var data = await FirebaseFirestore.instance
//           .collection('categories')
//           .where("type", isEqualTo: "4")
//           .orderBy("name")
//           .get();

//       await fetchTransfers(data);
//     }

//     if (!init) {
//       items = globals.categoriesTransfers;
//     }

//     return await callAsyncFetch();
//   }

//   fetchTransfers(QuerySnapshot collection) async {
//     globals.categoriesSaveTransfers = [];

//     collection.docs.forEach((value) {
//       List<dynamic> transfersDynamicTemp = value.get('transfers');

//       List<dynamic> listGifts = [];

//       int nbGifts;
//       if (transfersDynamicTemp.length > 0) {
//         transfersDynamicTemp.sort((a, b) {
//           var orderA; //before -> var adate = a.expiry;
//           var orderB; //var bdate = b.expiry;

//           // orderA = a['merchand'];
//           // orderB = b['merchand'];
//           // return orderA.compareTo(orderB);

//           orderA = a['price'];
//           orderB = b['price'];
//           return orderB.compareTo(orderA);
//         });

//         nbGifts = 0;
//         for (var indiceProgram = 0;
//             indiceProgram < transfersDynamicTemp.length;
//             indiceProgram++) {
//           if (indiceProgram == 15) {
//             break;
//           }

//           listGifts.add(transfersDynamicTemp[indiceProgram]);
//           nbGifts++;
//         }

//         globals.Category category = new globals.Category(
//             value.id,
//             value.get('name'),
//             value.get('type'),
//             transfersDynamicTemp.length,
//             listGifts,
//             transfersDynamicTemp,
//             value.id);

//         globals.categoriesSaveTransfers.add(category);
//       }
//     });

//     globals.categoriesTransfers = globals.categoriesSaveTransfers;

//     //On ajoute au menu "Virements"
//     // globals.menusGifts[2].categories = globals.categoriesTransfers;
//     globals.selectedMenuTransfers.categories = globals.categoriesTransfers;
//     // categoriesSave2 = categoriesSave;
//     // menuGiftTemp = globals.menusGifts[2];
//   }

//   Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

//   Future<Null> refreshList() async {
//     await Future.delayed(new Duration(seconds: 1));
//     // print(chipsValue);
//     setState(() {
//       if (globals.chipsValue == "1") {
//         myFuture = getCategoriesGifts(true, false);
//       } else if (globals.chipsValue == "2") {
//         myFuture = getCategoriesWinGifts(true, false);
//       } else {
//         myFuture = getCategoriesTransfers(true, false);
//       }
//     });

//     return null;
//   }

//   applyFilters(filter) async {
//     switch (filter) {
//       case "1":
//         {
//           // items = globals.categoriesGifts;
//         }
//         break;
//       case "2":
//         {
//           items = globals.categoriesWinGifts;
//         }
//         break;
//       case "3":
//         {}
//         break;
//       case "4":
//         {
//           items = globals.categoriesTransfers;
//         }
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async => false,
//         child: FutureBuilder(
//             future: myFuture,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Scaffold(
//                     appBar: AppBar(
//                         backgroundColor: Colors.grey[200],
//                         elevation: 0,
//                         leadingWidth: 100,
//                         toolbarHeight: 50,
//                         centerTitle: true,
//                         title: Container(
//                             margin: EdgeInsets.only(top: 5, bottom: 5),
//                             child: Text("Récompenses",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 18))),
//                         leading: Container(
//                             margin: EdgeInsets.only(
//                                 left: 13, top: 10, bottom: 10, right: 13),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: Colors.orange[700]),
//                             child: Text(
//                                 utils.addSeparateurMillier(
//                                         globals.profitUser.toString()) +
//                                     " Ꝃ",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14))),
//                         actions: [
//                           // IconButton(
//                           //   icon: Icon(CupertinoIcons.info),
//                           //   onPressed: () {
//                           //     showTutorialGift();
//                           //   },
//                           // )
//                           Container(
//                               margin: EdgeInsets.only(right: 10),
//                               // padding: EdgeInsets.only(top: 10),
//                               // height: 10,
//                               width: 30,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: ElevatedButton(
//                                   onPressed: () {
//                                     showTutorialGift();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     padding: EdgeInsets.zero,
//                                     enableFeedback: false,
//                                     splashFactory: NoSplash.splashFactory,
//                                     animationDuration: Duration(seconds: 0),
//                                     shadowColor: Colors.transparent,
//                                     primary: Colors.transparent,
//                                     elevation: 0,
//                                     onSurface: Colors.transparent,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(20))),
//                                   ),
//                                   child: Container(
//                                       child: Image.asset(
//                                     "assets/images/tuto_icon.png",
//                                     height: 32,
//                                     width: 32,
//                                     fit: BoxFit.fill,
//                                   ))))
//                         ]),
//                     backgroundColor: Colors.white,
//                     // body: Container())));
//                     body: RefreshIndicator(
//                         key: refreshKey,
//                         onRefresh: refreshList,
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                   alignment: Alignment.center,
//                                   padding: EdgeInsets.zero,
//                                   child: ChipsChoice<String>.single(
//                                     key: globals.keyButtonGift,
//                                     placeholder: "",
//                                     value: globals.chipsValue,
//                                     onChanged: (val) async {
//                                       globals.chipsValue = val;
//                                       await applyFilters(globals.chipsValue);
//                                       setState(() {
//                                         // print(value);
//                                       });
//                                     },
//                                     choiceBuilder: (item) {
//                                       return (Container(
//                                           margin: EdgeInsets.only(
//                                             left: 20,
//                                             top: 10,
//                                             bottom: 10,
//                                           ),
//                                           height: 33,

//                                           // key: globals.keyButtonGift1,
//                                           child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 primary: Colors.transparent,
//                                                 onSurface: Colors.transparent,
//                                                 shadowColor: Colors.transparent,
//                                                 onPrimary: Colors.transparent,
//                                                 elevation: 0,
//                                                 shape: RoundedRectangleBorder(
//                                                     side: BorderSide(
//                                                       color: item.selected
//                                                           ? Colors.orange[700]
//                                                           : Colors.grey,
//                                                       width:
//                                                           item.selected ? 2 : 1,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.all(
//                                                             Radius.circular(
//                                                                 40))),
//                                               ),
//                                               onPressed: () async {
//                                                 globals.chipsValue = item.value;
//                                                 await applyFilters(
//                                                     globals.chipsValue);
//                                                 setState(() {
//                                                   // print(value);
//                                                 });
//                                               },
//                                               child: Text(item.label,
//                                                   key: item.meta,
//                                                   style: TextStyle(
//                                                       color: item.selected
//                                                           ? Colors.orange[700]
//                                                           : Colors.grey,
//                                                       fontWeight: item.selected
//                                                           ? FontWeight.bold
//                                                           : FontWeight
//                                                               .normal)))));
//                                     },
//                                     choiceItems: globals
//                                         .choiceItemsMenuGifts.reversed
//                                         .toList(),
//                                     choiceStyle: C2ChoiceStyle(
//                                       brightness: Brightness.light,
//                                       showCheckmark: false,
//                                     ),
//                                     choiceActiveStyle: C2ChoiceStyle(
//                                         showCheckmark: false,
//                                         color: Colors.red,
//                                         borderColor: Colors.orange[700],
//                                         borderWidth: 1.5,
//                                         // padding: EdgeInsets.zero,
//                                         labelStyle: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             // backgroundColor: Colors.black,
//                                             color: Colors.orange[700])),
//                                     wrapped: false,
//                                     textDirection: TextDirection.rtl,
//                                     direction: Axis.horizontal,
//                                   )),
//                               globals.chipsValue == "1"
//                                   ? Expanded(
//                                       child: ListView.builder(
//                                       physics: ScrollPhysics(),
//                                       itemCount: items.length,
//                                       itemBuilder: (context, index) {
//                                         return Column(children: [
//                                           Container(
//                                             padding: EdgeInsets.zero,
//                                             height: 325,
//                                             child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Container(
//                                                       padding: EdgeInsets.only(
//                                                           left: 15, right: 10),
//                                                       child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             globals.chipsValue ==
//                                                                     "1"
//                                                                 ? Text(
//                                                                     items[index]
//                                                                         .name,
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           22,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w600,
//                                                                       // letterSpacing: 1
//                                                                     ),
//                                                                   )
//                                                                 : Container(),
//                                                             globals.chipsValue ==
//                                                                     "1"
//                                                                 ? ElevatedButton(
//                                                                     style: ElevatedButton
//                                                                         .styleFrom(
//                                                                       primary:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       elevation:
//                                                                           0,
//                                                                       onPrimary:
//                                                                           Colors
//                                                                               .white,
//                                                                       onSurface:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       shadowColor:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       padding: EdgeInsets.only(
//                                                                           right:
//                                                                               15),
//                                                                     ),
//                                                                     child:
//                                                                         Center(
//                                                                       child: Text(
//                                                                           globals.dictionnary["SeeAll"] +
//                                                                               " (" +
//                                                                               items[index]
//                                                                                   .nbItems
//                                                                                   .toString() +
//                                                                               ")",
//                                                                           style: TextStyle(
//                                                                               fontSize: 14,
//                                                                               color: Colors.grey)),
//                                                                     ),
//                                                                     onPressed:
//                                                                         () async {
//                                                                       pushNewScreen(
//                                                                           context,
//                                                                           screen: CategoryGiftPage(items[
//                                                                               index]),
//                                                                           withNavBar:
//                                                                               true,
//                                                                           pageTransitionAnimation:
//                                                                               PageTransitionAnimation.cupertino);
//                                                                     },
//                                                                   )
//                                                                 : Container(),
//                                                           ])),
//                                                   Container(
//                                                       padding: EdgeInsets.only(
//                                                           left: 15, right: 10),
//                                                       height: 275,
//                                                       child: ListView.separated(
//                                                           separatorBuilder:
//                                                               (context,
//                                                                       index) =>
//                                                                   Divider(
//                                                                     indent: 15,
//                                                                   ),
//                                                           scrollDirection:
//                                                               Axis.horizontal,
//                                                           itemCount:
//                                                               items[index]
//                                                                   .lists
//                                                                   .length,
//                                                           itemBuilder: (context,
//                                                               indexList) {
//                                                             var raisedButton;

//                                                             raisedButton =
//                                                                 ElevatedButton(
//                                                                     onPressed:
//                                                                         () async {
//                                                                       pushNewScreen(
//                                                                           context,
//                                                                           screen: DetailGiftPage(
//                                                                               items[index].lists[indexList][
//                                                                                   "id"],
//                                                                               globals
//                                                                                   .chipsValue),
//                                                                           withNavBar:
//                                                                               true,
//                                                                           pageTransitionAnimation:
//                                                                               PageTransitionAnimation.cupertino);
//                                                                     },
//                                                                     style: ElevatedButton
//                                                                         .styleFrom(
//                                                                       primary:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       onPrimary:
//                                                                           Colors
//                                                                               .black,
//                                                                       elevation:
//                                                                           0,
//                                                                       onSurface:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       shadowColor:
//                                                                           Colors
//                                                                               .transparent,
//                                                                       padding: EdgeInsets.only(
//                                                                           left:
//                                                                               0,
//                                                                           right:
//                                                                               0),
//                                                                     ),
//                                                                     child: Container(
//                                                                         width: globals.isIpad ? MediaQuery.of(context).size.width - 300 : MediaQuery.of(context).size.width - 60,
//                                                                         decoration: BoxDecoration(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(20),
//                                                                           color:
//                                                                               Colors.grey[100],
//                                                                           // border: Border.all(
//                                                                           //     color: Colors.grey[
//                                                                           //         100],
//                                                                           //     width:
//                                                                           //         1),
//                                                                         ),
//                                                                         child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//                                                                           Container(
//                                                                             height:
//                                                                                 190,
//                                                                             child:
//                                                                                 CachedNetworkImage(
//                                                                               imageUrl: items[index].lists[indexList]["imagePresentation"],
//                                                                               imageBuilder: (context, imageProvider) => Container(
//                                                                                 width: MediaQuery.of(context).size.width - 60,
//                                                                                 decoration: BoxDecoration(
//                                                                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//                                                                                   image: DecorationImage(
//                                                                                     image: imageProvider,
//                                                                                     fit: BoxFit.cover,
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                               placeholder: (context, url) => Container(
//                                                                                   height: 190,
//                                                                                   width: MediaQuery.of(context).size.width - 200,
//                                                                                   child: Center(
//                                                                                       child: Container(
//                                                                                           height: 20,
//                                                                                           width: 20,
//                                                                                           child: CircularProgressIndicator(
//                                                                                             valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]),
//                                                                                           )))),
//                                                                               errorWidget: (context, url, error) => Icon(Icons.error),
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(
//                                                                               height: 5),
//                                                                           Container(
//                                                                             padding:
//                                                                                 EdgeInsets.only(left: 5, right: 5),
//                                                                             alignment:
//                                                                                 Alignment.bottomLeft,
//                                                                             child:
//                                                                                 Row(children: [
//                                                                               CachedNetworkImage(
//                                                                                 imageUrl: items[index].lists[indexList]["merchandLogo"],
//                                                                                 imageBuilder: (context, imageProvider) => Container(
//                                                                                   width: 60,
//                                                                                   height: 60,
//                                                                                   decoration: BoxDecoration(
//                                                                                     borderRadius: BorderRadius.circular(60),
//                                                                                     image: DecorationImage(
//                                                                                       image: imageProvider,
//                                                                                       fit: BoxFit.cover,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                                 placeholder: (context, url) => Container(
//                                                                                     height: 60,
//                                                                                     width: 60,
//                                                                                     child: Center(
//                                                                                         child: Container(
//                                                                                             height: 20,
//                                                                                             width: 20,
//                                                                                             child: CircularProgressIndicator(
//                                                                                               valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]),
//                                                                                             )))),
//                                                                                 errorWidget: (context, url, error) => Icon(Icons.error),
//                                                                               ),
//                                                                               SizedBox(width: 10),
//                                                                               Container(
//                                                                                   width: globals.isIpad ? MediaQuery.of(context).size.width - 450 : MediaQuery.of(context).size.width - 210,
//                                                                                   child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                                                                     Text(items[index].lists[indexList]["merchand"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                                                                                     // SizedBox(height: 2),
//                                                                                     globals.chipsValue == "4" ? Container() : Text(items[index].lists[indexList]["subtitle"], textAlign: TextAlign.left, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.deepOrange[900])),
//                                                                                     // SizedBox(height: 2),
//                                                                                     Text(items[index].lists[indexList]["title"], textAlign: TextAlign.left, style: TextStyle(fontSize: 14))
//                                                                                   ])),
//                                                                               Container(alignment: Alignment.center, height: 60, width: 70, child: Text(utils.addSeparateurMillier(items[index].lists[indexList]["price"].toString()) + " Ꝃ", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 16)))
//                                                                             ]),
//                                                                           )
//                                                                         ])));

//                                                             return raisedButton;
//                                                           })),

//                                                   // ])
//                                                   // ),
//                                                 ]),
//                                           ),
//                                           index == items.length - 1
//                                               ? Column(children: [
//                                                   SizedBox(height: 30),
//                                                   Container(
//                                                       margin: EdgeInsets.only(
//                                                           left: 20, right: 20),
//                                                       child: Column(children: [
//                                                         Text(
//                                                             "Pour plus d'informations sur la fonctionnement des récompenses, vous pouvez consulter nos",
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .black,
//                                                                 fontSize: 12)),
//                                                         ElevatedButton(
//                                                           style: ElevatedButton
//                                                               .styleFrom(
//                                                             elevation: 0,
//                                                             padding:
//                                                                 EdgeInsets.zero,
//                                                             primary: Colors
//                                                                 .transparent,
//                                                             onPrimary:
//                                                                 Colors.black,
//                                                             onSurface: Colors
//                                                                 .transparent,
//                                                             shadowColor: Colors
//                                                                 .transparent,
//                                                           ),
//                                                           child: Text(
//                                                               "Conditions Générales d'Utilisation",
//                                                               style: TextStyle(
//                                                                   fontSize: 12,
//                                                                   color: Colors
//                                                                       .black,
//                                                                   decoration:
//                                                                       TextDecoration
//                                                                           .underline)),
//                                                           onPressed: () {
//                                                             utils.openLink(
//                                                                 'http://kayou.nc/conditions-generales-dutilisation/');
//                                                           },
//                                                         ),
//                                                         SizedBox(height: 15),
//                                                       ]))
//                                                 ])
//                                               : Container(height: 0),
//                                           SizedBox(height: 15),
//                                         ]);
//                                       },
//                                     ))
//                                   : Expanded(
//                                       child: ListView.builder(
//                                       physics: ScrollPhysics(),
//                                       scrollDirection: Axis.vertical,
//                                       itemCount: items.length,
//                                       itemBuilder: (context, index) {
//                                         return Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             children: [
//                                               ListView.separated(
//                                                 separatorBuilder:
//                                                     (context, index) =>
//                                                         SizedBox(
//                                                   height: 30,
//                                                 ),
//                                                 physics: ScrollPhysics(),
//                                                 shrinkWrap: true,
//                                                 padding:
//                                                     EdgeInsets.only(top: 15),
//                                                 itemCount:
//                                                     items[index].lists.length,
//                                                 itemBuilder:
//                                                     (context, indexList) {
//                                                   var raisedButton;

//                                                   raisedButton = ElevatedButton(
//                                                       onPressed: () async {
//                                                         pushNewScreen(context,
//                                                             screen: DetailGiftPage(
//                                                                 items[index].lists[
//                                                                         indexList]
//                                                                     ["id"],
//                                                                 globals
//                                                                     .chipsValue),
//                                                             withNavBar: true,
//                                                             pageTransitionAnimation:
//                                                                 PageTransitionAnimation
//                                                                     .cupertino);
//                                                       },
//                                                       style: ElevatedButton
//                                                           .styleFrom(
//                                                         primary:
//                                                             Colors.transparent,
//                                                         onPrimary: Colors.black,
//                                                         onSurface:
//                                                             Colors.transparent,
//                                                         elevation: 0,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             20))),
//                                                         shadowColor:
//                                                             Colors.white,
//                                                       ),
//                                                       child: Container(
//                                                           alignment: Alignment
//                                                               .center,
//                                                           width: MediaQuery.of(
//                                                                       context)
//                                                                   .size
//                                                                   .width -
//                                                               50,
//                                                           height: 280,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         20),
//                                                             color: Colors
//                                                                 .grey[100],
//                                                             // border: Border.all(
//                                                             //     color: Colors.grey[
//                                                             //         100],
//                                                             //     width:
//                                                             //         1),
//                                                           ),
//                                                           child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .center,
//                                                               children: [
//                                                                 Container(
//                                                                   height: 190,
//                                                                   child:
//                                                                       CachedNetworkImage(
//                                                                     imageUrl: items[index]
//                                                                             .lists[indexList]
//                                                                         [
//                                                                         "imagePresentation"],
//                                                                     imageBuilder:
//                                                                         (context,
//                                                                                 imageProvider) =>
//                                                                             Container(
//                                                                       width: MediaQuery.of(context)
//                                                                               .size
//                                                                               .width -
//                                                                           50,
//                                                                       decoration:
//                                                                           BoxDecoration(
//                                                                         borderRadius: BorderRadius.only(
//                                                                             topLeft:
//                                                                                 Radius.circular(20),
//                                                                             topRight: Radius.circular(20)),
//                                                                         image:
//                                                                             DecorationImage(
//                                                                           image:
//                                                                               imageProvider,
//                                                                           fit: BoxFit
//                                                                               .cover,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     placeholder: (context, url) => Container(
//                                                                         height: 190,
//                                                                         width: MediaQuery.of(context).size.width - 200,
//                                                                         child: Center(
//                                                                             child: Container(
//                                                                                 height: 20,
//                                                                                 width: 20,
//                                                                                 child: CircularProgressIndicator(
//                                                                                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]),
//                                                                                 )))),
//                                                                     errorWidget: (context,
//                                                                             url,
//                                                                             error) =>
//                                                                         Icon(Icons
//                                                                             .error),
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(
//                                                                     height: 5),
//                                                                 Container(
//                                                                   padding: EdgeInsets
//                                                                       .only(
//                                                                           left:
//                                                                               5,
//                                                                           right:
//                                                                               5),
//                                                                   alignment:
//                                                                       Alignment
//                                                                           .bottomLeft,
//                                                                   child: Row(
//                                                                       children: [
//                                                                         CachedNetworkImage(
//                                                                           imageUrl:
//                                                                               items[index].lists[indexList]["merchandLogo"],
//                                                                           imageBuilder: (context, imageProvider) =>
//                                                                               Container(
//                                                                             width:
//                                                                                 60,
//                                                                             height:
//                                                                                 60,
//                                                                             decoration:
//                                                                                 BoxDecoration(
//                                                                               borderRadius: BorderRadius.circular(60),
//                                                                               image: DecorationImage(
//                                                                                 image: imageProvider,
//                                                                                 fit: BoxFit.cover,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           placeholder: (context, url) => Container(
//                                                                               height: 60,
//                                                                               width: 60,
//                                                                               child: Center(
//                                                                                   child: Container(
//                                                                                       height: 20,
//                                                                                       width: 20,
//                                                                                       child: CircularProgressIndicator(
//                                                                                         valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]),
//                                                                                       )))),
//                                                                           errorWidget: (context, url, error) =>
//                                                                               Icon(Icons.error),
//                                                                         ),
//                                                                         SizedBox(
//                                                                             width:
//                                                                                 10),
//                                                                         Container(
//                                                                             width: MediaQuery.of(context).size.width -
//                                                                                 210,
//                                                                             child:
//                                                                                 Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                                                               Text(items[index].lists[indexList]["merchand"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                                                                               // SizedBox(height: 2),
//                                                                               globals.chipsValue == "4" ? Container() : Text(items[index].lists[indexList]["subtitle"], textAlign: TextAlign.left, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.deepOrange[900])),
//                                                                               // SizedBox(height: 2),
//                                                                               Text(items[index].lists[indexList]["title"], textAlign: TextAlign.left, style: TextStyle(fontSize: 14))
//                                                                             ])),
//                                                                         Container(
//                                                                             alignment: Alignment
//                                                                                 .center,
//                                                                             height:
//                                                                                 60,
//                                                                             width:
//                                                                                 70,
//                                                                             child:
//                                                                                 Text(utils.addSeparateurMillier(items[index].lists[indexList]["price"].toString()) + " Ꝃ", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 16)))
//                                                                       ]),
//                                                                 ),
//                                                                 SizedBox(
//                                                                     height: 10),
//                                                               ])));

//                                                   if (index ==
//                                                       items.length - 1) {
//                                                     return Column(children: [
//                                                       raisedButton,
//                                                       SizedBox(height: 30),
//                                                       Container(
//                                                           margin:
//                                                               EdgeInsets.only(
//                                                                   left: 20,
//                                                                   right: 20),
//                                                           child:
//                                                               Column(children: [
//                                                             Text(
//                                                                 "Pour plus d'informations sur la fonctionnement des récompenses, vous pouvez consulter nos",
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontSize:
//                                                                         12)),
//                                                             ElevatedButton(
//                                                               style:
//                                                                   ElevatedButton
//                                                                       .styleFrom(
//                                                                 elevation: 0,
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .zero,
//                                                                 primary: Colors
//                                                                     .transparent,
//                                                                 onPrimary:
//                                                                     Colors
//                                                                         .black,
//                                                                 onSurface: Colors
//                                                                     .transparent,
//                                                                 shadowColor: Colors
//                                                                     .transparent,
//                                                               ),
//                                                               child: Text(
//                                                                   "Conditions Générales d'Utilisation",
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           12,
//                                                                       color: Colors
//                                                                           .black,
//                                                                       decoration:
//                                                                           TextDecoration
//                                                                               .underline)),
//                                                               onPressed: () {
//                                                                 utils.openLink(
//                                                                     'http://kayou.nc/conditions-generales-dutilisation/');
//                                                               },
//                                                             )
//                                                           ]))
//                                                     ]);
//                                                   } else {
//                                                     return raisedButton;
//                                                   }
//                                                 },
//                                               ),
//                                               SizedBox(height: 30),

//                                               // ])
//                                               // ),
//                                             ]);
//                                       },
//                                     )),
//                             ])));
//               } else {
//                 return Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Center(
//                           child: LoadingBouncingGrid.square(
//                         size: 80,
//                         backgroundColor: Colors.cyan[700]!,
//                       )),
//                     ]);
//               }
//             }));
//   }
// }
