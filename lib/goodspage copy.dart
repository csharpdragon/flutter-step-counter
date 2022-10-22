// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chips_choice/chips_choice.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'detail-categoryDeal.dart';
// import 'detail-dealpage.dart';
// import 'tools/globals.dart' as globals;
// import 'package:kayou/tools/utils.dart';

// class GoodsPage extends StatefulWidget {
//   GoodsPageState createState() => GoodsPageState();
// }

// class GoodsPageState extends State<GoodsPage> {
//   List<C2Choice<String>> choiceItems;
//   List<C2Choice<String>> choiceItemsSave;
//   C2Choice<String> choiceItemsTemp;
//   List<String> chipsValue;

//   UtilsState utils;

//   var refreshKey = GlobalKey<RefreshIndicatorState>();

//   var myFuture;

//   @override
//   void initState() {
//     utils = new UtilsState();
//     utils.initState();
//     // print("refreeeeeeeeeesh");
//     super.initState();
//     myFuture = getCategoriesDeals(globals.categoriesDeal.length == 0);
//   }

//   getCategoriesDeals(bool force) async {
//     if (force) {
//       // print("refresh");
//       await utils.getUserPoints();
//       setState(() {
//         chipsValue = [];
//       });

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
//       choiceItemsSave = [];
//       globals.categoriesSave = [];

//       collection.docs.forEach((value) {
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

//           globals.Category category = new globals.Category(
//               value.id,
//               value["category"],
//               value["type"],
//               dealsDynamicTemp.length,
//               listDeals,
//               dealsDynamicTemp,
//               value.id);

//           globals.categoriesSave.add(category);

//           choiceItemsTemp = new C2Choice<String>(
//               label: value["category"].toString(),
//               value: value.id,
//               activeStyle: C2ChoiceStyle(color: Colors.orange[300]),
//               disabled: false,
//               selected: false);

//           choiceItemsSave.add(choiceItemsTemp);
//         }
//       });

//       globals.categoriesDeal = globals.categoriesSave;

//       // globals.choiceItemsMenuDeals = choiceItemsSave;
//     }
//   }

//   Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

//   Future<Null> refreshList() async {
//     await Future.delayed(new Duration(seconds: 1));

//     setState(() {
//       myFuture = getCategoriesDeals(true);
//     });

//     return null;
//   }

//   Future<Null> applyFilters(List filters) async {
//     // print(globals.categoriesSave);
//     globals.categoriesDeal = globals.categoriesSave;

//     List<globals.Category> categoriesTemp = [];

//     for (int i = 0; i < filters.length; i++) {
//       for (int j = 0; j < globals.categoriesDeal.length; j++) {
//         if (globals.categoriesDeal[j].id == filters[i].toString()) {
//           categoriesTemp.add(globals.categoriesDeal[j]);
//         }
//       }
//     }

//     if (categoriesTemp.length > 0) {
//       categoriesTemp.sort((a, b) {
//         var orderA; //before -> var adate = a.expiry;
//         var orderB; //var bdate = b.expiry;

//         orderA = a.name;
//         orderB = b.name;
//         return orderA.compareTo(orderB);
//       });

//       globals.categoriesDeal = categoriesTemp;
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
//                       backgroundColor: Colors.grey[200],
//                       elevation: 0,
//                       leadingWidth: 100,
//                       toolbarHeight: 50,
//                       centerTitle: true,
//                       title: Container(
//                           margin: EdgeInsets.only(top: 5, bottom: 5),
//                           child: Text("Cashback",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 18))),
//                       leading: Container(
//                           margin: EdgeInsets.only(
//                               left: 13, top: 10, bottom: 10, right: 13),
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.orange[700]),
//                           child: Text(
//                               utils.addSeparateurMillier(
//                                       globals.profitUser.toString()) +
//                                   " Ꝃ",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14))),
//                     ),
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
//                                   alignment: Alignment.centerLeft,
//                                   padding: EdgeInsets.only(top: 0),
//                                   child: ChipsChoice<String>.multiple(
//                                     placeholder: "",
//                                     value: chipsValue,
//                                     onChanged: (val) => setState(() {
//                                       chipsValue = val;
//                                       // print(value);
//                                       applyFilters(chipsValue);
//                                     }),
//                                     // choiceItems: globals
//                                     //     .choiceItemsMenuDeals.reversed
//                                     //     .toList(),
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
//                                             fontWeight: FontWeight.bold,
//                                             // backgroundColor: Colors.black,
//                                             color: Colors.orange[700])),
//                                     wrapped: false,
//                                     textDirection: TextDirection.rtl,
//                                     direction: Axis.horizontal,
//                                   )),
//                               Expanded(
//                                   child: ListView.builder(
//                                 // controller: _scrollViewController,
//                                 itemCount: globals.categoriesDeal.length,
//                                 itemBuilder: (context, index) {
//                                   return Column(children: [
//                                     Container(
//                                       padding: EdgeInsets.zero,
//                                       height: 320,
//                                       child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                                 padding: EdgeInsets.only(
//                                                     left: 15, right: 10),
//                                                 child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Text(
//                                                         globals
//                                                             .categoriesDeal[
//                                                                 index]
//                                                             .name,
//                                                         style: TextStyle(
//                                                           fontSize: 22,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           // letterSpacing: 1
//                                                         ),
//                                                       ),
//                                                       ElevatedButton(
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                           primary: Colors
//                                                               .transparent,
//                                                           onPrimary:
//                                                               Colors.white,
//                                                           elevation: 0,
//                                                           onSurface: Colors
//                                                               .transparent,
//                                                           shadowColor: Colors
//                                                               .transparent,
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                                   right: 15),
//                                                         ),
//                                                         child: Center(
//                                                           child: Text(
//                                                               globals.dictionnary[
//                                                                       "SeeAll"] +
//                                                                   " (" +
//                                                                   globals
//                                                                       .categoriesDeal[
//                                                                           index]
//                                                                       .nbItems
//                                                                       .toString() +
//                                                                   ")",
//                                                               style: TextStyle(
//                                                                   fontSize: 14,
//                                                                   color: Colors
//                                                                       .grey)),
//                                                         ),
//                                                         onPressed: () async {
//                                                           pushNewScreen(context,
//                                                               screen: CategoryDealPage(
//                                                                   globals.categoriesDeal[
//                                                                       index]),
//                                                               withNavBar: true,
//                                                               pageTransitionAnimation:
//                                                                   PageTransitionAnimation
//                                                                       .cupertino);
//                                                         },
//                                                       ),
//                                                     ])),
//                                             Container(
//                                                 padding: EdgeInsets.only(
//                                                     left: 15, right: 10),
//                                                 height: 270,
//                                                 child: ListView.separated(
//                                                     separatorBuilder:
//                                                         (context, index) =>
//                                                             Divider(
//                                                               indent: 15,
//                                                             ),
//                                                     addAutomaticKeepAlives:
//                                                         false,
//                                                     addRepaintBoundaries: true,
//                                                     scrollDirection:
//                                                         Axis.horizontal,
//                                                     itemCount: globals
//                                                         .categoriesDeal[index]
//                                                         .lists
//                                                         .length,
//                                                     itemBuilder: (context,
//                                                         indexPrograms) {
//                                                       var raisedButton;

//                                                       raisedButton =
//                                                           ElevatedButton(
//                                                               onPressed:
//                                                                   () async {
//                                                                 pushNewScreen(
//                                                                     context,
//                                                                     screen: DetailDealPage(globals
//                                                                             .categoriesDeal[
//                                                                                 index]
//                                                                             .lists[indexPrograms]
//                                                                         ["id"]),
//                                                                     withNavBar:
//                                                                         true,
//                                                                     pageTransitionAnimation:
//                                                                         PageTransitionAnimation
//                                                                             .cupertino);
//                                                               },
//                                                               style:
//                                                                   ElevatedButton
//                                                                       .styleFrom(
//                                                                 primary: Colors
//                                                                     .transparent,
//                                                                 onPrimary:
//                                                                     Colors
//                                                                         .black,
//                                                                 elevation: 0,
//                                                                 onSurface: Colors
//                                                                     .transparent,
//                                                                 shadowColor: Colors
//                                                                     .transparent,
//                                                                 padding: EdgeInsets
//                                                                     .only(
//                                                                         left: 0,
//                                                                         right:
//                                                                             0),
//                                                               ),
//                                                               child: Container(
//                                                                   width: MediaQuery.of(
//                                                                               context)
//                                                                           .size
//                                                                           .width -
//                                                                       60,
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             20),
//                                                                     color: Colors
//                                                                             .grey[
//                                                                         100],
//                                                                   ),
//                                                                   child: Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .center,
//                                                                       children: [
//                                                                         Container(
//                                                                           height:
//                                                                               190,
//                                                                           child:
//                                                                               CachedNetworkImage(
//                                                                             imageUrl:
//                                                                                 globals.categoriesDeal[index].lists[indexPrograms]["imagePresentation"],
//                                                                             imageBuilder: (context, imageProvider) =>
//                                                                                 Container(
//                                                                               width: MediaQuery.of(context).size.width - 60,
//                                                                               decoration: BoxDecoration(
//                                                                                 borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//                                                                                 image: DecorationImage(
//                                                                                   image: imageProvider,
//                                                                                   fit: BoxFit.cover,
//                                                                                 ),
//                                                                               ),
//                                                                               //************************************* */
//                                                                               /* A DECOMMENTER POUR LE TAG DISPONIBLE / INDISPONIBLE*/
//                                                                               // child: Column(
//                                                                               //     children: [
//                                                                               //       Container(
//                                                                               //         margin:
//                                                                               //             EdgeInsets.all(15),
//                                                                               //         alignment:
//                                                                               //             Alignment.topRight,
//                                                                               //         padding:
//                                                                               //             EdgeInsets.all(5),
//                                                                               //         height:
//                                                                               //             30,
//                                                                               //         child: globals.selectedMenuDeals.categories[index].gift[indexPrograms]["payable"] == true
//                                                                               //             ? Icon(Icons.lock_outline, size: 45, color: Colors.grey[500])
//                                                                               //             : Container(),
//                                                                               //       ),
//                                                                               //     ]),
//                                                                             ),
//                                                                             placeholder: (context, url) => Container(
//                                                                                 height: 190,
//                                                                                 width: MediaQuery.of(context).size.width - 200,
//                                                                                 child: Center(
//                                                                                     child: Container(
//                                                                                         height: 20,
//                                                                                         width: 20,
//                                                                                         child: CircularProgressIndicator(
//                                                                                           valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]),
//                                                                                         )))),
//                                                                             errorWidget: (context, url, error) =>
//                                                                                 Icon(Icons.error),
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 10),
//                                                                         Container(
//                                                                           padding: EdgeInsets.only(
//                                                                               left: 10,
//                                                                               right: 10),
//                                                                           alignment:
//                                                                               Alignment.bottomLeft,
//                                                                           child:
//                                                                               Row(children: [
//                                                                             CachedNetworkImage(
//                                                                               imageUrl: globals.categoriesDeal[index].lists[indexPrograms]["merchandLogo"],
//                                                                               imageBuilder: (context, imageProvider) => Container(
//                                                                                 width: 60,
//                                                                                 height: 60,
//                                                                                 decoration: BoxDecoration(
//                                                                                   borderRadius: BorderRadius.circular(60),
//                                                                                   image: DecorationImage(
//                                                                                     image: imageProvider,
//                                                                                     fit: BoxFit.cover,
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                               placeholder: (context, url) => Container(
//                                                                                   height: 60,
//                                                                                   width: 60,
//                                                                                   child: Center(
//                                                                                       child: Container(
//                                                                                           height: 20,
//                                                                                           width: 20,
//                                                                                           child: CircularProgressIndicator(
//                                                                                             valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[400]),
//                                                                                           )))),
//                                                                               errorWidget: (context, url, error) => Container(height: 60, width: 60, child: Center(child: Icon(Icons.error))),
//                                                                             ),
//                                                                             SizedBox(width: 10),
//                                                                             Container(
//                                                                                 width: MediaQuery.of(context).size.width - 150,
//                                                                                 child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                                                                   Text(globals.categoriesDeal[index].lists[indexPrograms]["merchand"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                                                                                   SizedBox(height: 2),
//                                                                                   Text(globals.categoriesDeal[index].lists[indexPrograms]["subtitle"], textAlign: TextAlign.left, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.deepOrange[900])),
//                                                                                   SizedBox(height: 2),
//                                                                                   Row(children: [
//                                                                                     Text(utils.addSeparateurMillier(globals.categoriesDeal[index].lists[indexPrograms]["price"].toString()) + " Ꝃ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
//                                                                                     Text(" par "),
//                                                                                     Text(utils.addSeparateurMillier(globals.categoriesDeal[index].lists[indexPrograms]["priceDeal"].toString()) + " XPF", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
//                                                                                     Text(" dépensés")
//                                                                                   ])
//                                                                                 ])),
//                                                                           ]),
//                                                                         )
//                                                                       ])));
//                                                       return raisedButton;
//                                                     }))
//                                             // ])
//                                             // ),
//                                           ]),
//                                     ),
//                                     SizedBox(height: 15)
//                                   ]);
//                                 },
//                               ))
//                             ])));
//               } else {
//                 return Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Center(
//                           child: LoadingBouncingGrid.square(
//                         size: 80,
//                         backgroundColor: Colors.orange[700],
//                       )),
//                     ]);
//               }
//             }));
//   }
// }
