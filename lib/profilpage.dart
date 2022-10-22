import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:health/health.dart';
import 'package:kayou/profil/change-profileadress.dart';
import 'package:kayou/profil/change-profilebirth.dart';
import 'package:kayou/profil/change-profileheight.dart';
import 'package:kayou/profil/change-profilemail.dart';
import 'package:kayou/profil/change-profilename.dart';
import 'package:kayou/profil/change-profilepseudo.dart';
import 'package:kayou/profil/change-profilesex.dart';
import 'package:kayou/profil/change-profiletel.dart';
import 'package:kayou/tuto/tuto-activity.dart';
import 'package:kayou/profil/historical-profil.dart';
import 'package:kayou/profil/selectparrainage.dart';
import 'package:kayou/tools/utils.dart';
import 'package:package_info/package_info.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'authentificationPage.dart';

UtilsState? utils;

class ProfilPage extends StatefulWidget {
  ProfilPageState createState() => ProfilPageState();
}

class ProfilPageState extends State<ProfilPage> {
  double heightButton = 60;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  void initState() {
    utils = new UtilsState();
    utils!.initState();
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _onSignedIn() {
    setState(() {});
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Kayou NC',
      text: 'Rejoins moi sur Kayou. Voici mon code parrainage : ' +
          globals.uidParrainage,
      linkUrl: 'http://onelink.to/3fk4y6',
    );
  }

  @override
  Widget build(BuildContext context) {
    var versionLib = Text("Kayou - " + _packageInfo.version.toString(), //+
        // " (" +
        // _packageInfo.buildNumber.toString() +
        // ") ",
        style: TextStyle(color: Colors.grey[400], fontSize: 12));
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
              elevation: 0,
              leadingWidth: 120,
              toolbarHeight: 50,
              centerTitle: true,
              title: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text("Paramètres",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18))),
              leading: Container(
                  margin:
                      EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 13),
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
                        Icon(Icons.arrow_back, color: Colors.cyan[700]!),
                        Text("Retour",
                            style: TextStyle(
                                fontSize: 14, color: Colors.cyan[700]!))
                      ]))),
              actions: [
                Container(
                    margin:
                        EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 0),
                    child: ElevatedButton(
                        onPressed: () {
                          pushNewScreen(context,
                              screen: HistoricalProfilPage(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary: Colors.transparent,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text("Historique",
                            style: TextStyle(
                                fontSize: 14, color: Colors.cyan[700]!))))
              ],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(children: [
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: ElevatedButton(
                      onPressed: () {
                        pushNewScreen(context,
                            screen: ProfilEmailPage(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                        onPrimary: Colors.black,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 80, child: Text("Email")),
                          Container(
                              width: MediaQuery.of(context).size.width - 135,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                globals.email,
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ))
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ],
                      ))),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //               screen: ProfilNamePage(),
              //               withNavBar: true,
              //               pageTransitionAnimation:
              //                   PageTransitionAnimation.cupertino);
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(width: 100, child: Text("Nom - prénom")),
              //             Container(
              //                 width: MediaQuery.of(context).size.width - 200,
              //                 child: Text(
              //                   globals.name,
              //                   overflow: TextOverflow.ellipsis,
              //                   style: TextStyle(color: Colors.grey),
              //                   textAlign: TextAlign.center,
              //                 )),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: ElevatedButton(
                      onPressed: () {
                        pushNewScreen(context,
                            screen: ProfilPseudoPage(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                        onPrimary: Colors.black,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 80, child: Text("Pseudo")),
                          Container(
                              width: MediaQuery.of(context).size.width - 135,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                globals.pseudo,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              )),
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ],
                      ))),
              // Container(
              //     alignment: Alignment.center,
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //               screen: ProfilTelPage(),
              //               withNavBar: true,
              //               pageTransitionAnimation:
              //                   PageTransitionAnimation.cupertino);
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(width: 80, child: Text("Téléphone")),
              //             Text(
              //               globals.tel,
              //               style: TextStyle(color: Colors.grey),
              //               textAlign: TextAlign.center,
              //             ),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //               screen: ProfilAdressPage(),
              //               withNavBar: true,
              //               pageTransitionAnimation:
              //                   PageTransitionAnimation.cupertino);
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               width: 80,
              //               child: Text("Adresse"),
              //             ),
              //             Container(
              //                 width: MediaQuery.of(context).size.width - 180,
              //                 child: Text(globals.adress,
              //                     textAlign: TextAlign.center,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.grey))),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              globals.parrain.length == 0
                  ? Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: heightButton,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: ElevatedButton(
                          onPressed: () {
                            globals.parrainOK = false;
                            pushNewScreen(
                              context,
                              screen: SelectParrainagePage(),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            ).then((value) {
                              if (globals.parrainOK) {
                                utils!.openPopupSuccess(
                                    context,
                                    "Félicitations!",
                                    "Vous venez de gagner 5Ꝃ");
                              } else {}

                              globals.parrainOK = false;
                              globals.validateParrain = false;
                              // }
                            });

                            setState(() {});
                            // pushNewScreen(context,
                            //     screen: SelectParrainagePage(),
                            //     withNavBar: true,
                            //     pageTransitionAnimation:
                            //         PageTransitionAnimation.cupertino);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.transparent,
                            onPrimary: Colors.black,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(child: Text("J'ai un code parrain")),
                              Icon(Icons.arrow_forward,
                                  color: Colors.cyan[700]!)
                            ],
                          )))
                  : Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: heightButton,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Container(
                          padding: EdgeInsets.only(left: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: 80,
                                  child: Text("Parrain",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width - 135,
                                  alignment: Alignment.centerLeft,
                                  child: Text(globals.parrain,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey))),
                            ],
                          ))),
              // SizedBox(height: 20),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     child: Text("Activité physique")),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //                   screen: ProfilBirthPage(),
              //                   withNavBar: true,
              //                   pageTransitionAnimation:
              //                       PageTransitionAnimation.cupertino)
              //               .then((value) {
              //             setState(() {});
              //           });
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               width: 80,
              //               child: Text("Date de naissance"),
              //             ),
              //             Container(
              //                 width: MediaQuery.of(context).size.width - 180,
              //                 child: Text(globals.dateNaissance,
              //                     textAlign: TextAlign.center,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.grey))),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //                   screen: ProfilWeightPage(),
              //                   withNavBar: true,
              //                   pageTransitionAnimation:
              //                       PageTransitionAnimation.cupertino)
              //               .then((value) {
              //             setState(() {});
              //           });
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               width: 80,
              //               child: Text("Poids (Kg)"),
              //             ),
              //             Container(
              //                 width: MediaQuery.of(context).size.width - 180,
              //                 child: Text(globals.poids.toString(),
              //                     textAlign: TextAlign.center,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.grey))),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //                   screen: ProfilHeightPage(),
              //                   withNavBar: true,
              //                   pageTransitionAnimation:
              //                       PageTransitionAnimation.cupertino)
              //               .then((value) {
              //             setState(() {});
              //           });
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               width: 80,
              //               child: Text("Taille (cm)"),
              //             ),
              //             Container(
              //                 width: MediaQuery.of(context).size.width - 180,
              //                 child: Text(globals.taille.toString(),
              //                     textAlign: TextAlign.center,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.grey))),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              //     height: heightButton,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () {
              //           pushNewScreen(context,
              //                   screen: ProfilSexPage(),
              //                   withNavBar: true,
              //                   pageTransitionAnimation:
              //                       PageTransitionAnimation.cupertino)
              //               .then((value) {
              //             setState(() {});
              //           });
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Container(
              //               width: 80,
              //               child: Text("Sexe"),
              //             ),
              //             Container(
              //                 width: MediaQuery.of(context).size.width - 180,
              //                 child: Text(globals.sexe,
              //                     textAlign: TextAlign.center,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.grey))),
              //             Icon(Icons.arrow_forward,
              //                 color: Colors.cyan[700]!)
              //           ],
              //         ))),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 50),
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage('assets/images/parrain.png'),
                                height: 60,
                              )),
                          // child: Icon(
                          //   FontAwesomeIcons.instagram,
                          //   size: 24,
                          // )),
                          Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            width: MediaQuery.of(context).size.width - 120,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Invitez un proche",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24)),
                                  // SizedBox(height: 5),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("10 Kayous (Ꝃ)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.cyan[700]!)),
                                        Text(" pour le parrain",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("5 Kayous (Ꝃ)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.cyan[700]!)),
                                        Text(" pour le filleul",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey))
                                      ]),
                                ]),
                          ),
                        ]),
                    onPressed: () async {
                      if (globals.name == "" && globals.pseudo == "") {
                        utils!.showPopupWarning(context,
                            "Merci de saisir le nom - prénom ou le pseudo avant de parrainer un ami");
                      } else {
                        await share();
                      }
                    },
                  )),
              // Container(
              //     margin: EdgeInsets.only(left: 10, right: 10, top: 50),
              //     height: 100,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(width: 1, color: Colors.grey)),
              //     child: ElevatedButton(
              //         onPressed: () async {
              //           if (globals.name == "" && globals.pseudo == "") {
              //             utils!.showPopupWarning(context,
              //                 "Merci de saisir le nom - prénom ou le pseudo avant de parrainer un ami");
              //           } else {
              //             await share();
              //           }
              //         },
              //         style: ElevatedButton.styleFrom(
              //           elevation: 0,
              //           primary: Colors.transparent,
              //           onPrimary: Colors.black,
              //           onSurface: Colors.transparent,
              //           shadowColor: Colors.transparent,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text("Inviter un proche",
              //                       style: TextStyle(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 24)),
              //                   SizedBox(height: 10),
              //                   Text("10 Kayous (Ꝃ) pour le parrain",
              //                       style: TextStyle(
              //                           fontSize: 13, color: Colors.grey)),
              //                   Text("5 Kayous (Ꝃ) pour le filleul",
              //                       style: TextStyle(
              //                           fontSize: 13, color: Colors.grey))
              //                 ]),
              //             Icon(Icons.supervisor_account_outlined,
              //                 color: Colors.cyan[700]!, size: 40)
              //           ],
              //         ))),
              // SizedBox(height: 50),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 50),
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage('assets/images/shop.png'),
                                height: 60,
                              )),
                          // child: Icon(
                          //   FontAwesomeIcons.instagram,
                          //   size: 24,
                          // )),
                          Container(
                            margin: const EdgeInsets.only(left: 5.0),
                            width: MediaQuery.of(context).size.width - 120,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Devenez partenaire",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24)),
                                  SizedBox(height: 5),
                                  Text("Remplissez notre formulaire en ligne",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.grey)),
                                ]),
                          ),
                        ]),
                    onPressed: () async {
                      utils!.openLink('https://kayou.nc/contact-pro/');
                    },
                  )),
              SizedBox(height: 50),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/logo_insta_2.png'),
                                height: 26,
                              )),
                          // child: Icon(
                          //   FontAwesomeIcons.instagram,
                          //   size: 24,
                          // )),
                          SizedBox(width: 50),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text("Suivez nous sur Instagram",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))),

                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ]),
                    onPressed: () async {
                      utils!.openLink('https://www.instagram.com/kayou.nc/');
                    },
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage('assets/images/logo_doc.png'),
                                height: 26,
                              )),
                          SizedBox(width: 50),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text("Mentions légales",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))),
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ]),
                    onPressed: () {
                      utils!.openLink('https://kayou.nc/mentions-legales/');
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage('assets/images/logo_doc.png'),
                                height: 26,
                              )),
                          SizedBox(width: 50),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text("Conditions Générales d'Utilisation",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))),
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ]),
                    onPressed: () {
                      utils!.openLink(
                          'https://kayou.nc/conditions-generales-dutilisation/');
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage('assets/images/logo_doc.png'),
                                height: 26,
                              )),
                          SizedBox(width: 50),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text("Politique de confidentialité",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))),
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ]),
                    onPressed: () {
                      utils!.openLink(
                          'https://kayou.nc/politique-de-confidentialite-2/');
                    },
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/logo_messenger_1.png'),
                                height: 26,
                              )),
                          SizedBox(width: 50),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Text("Contactez-nous",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))),
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ]),
                    onPressed: () async {
                      utils!.openLink('https://m.me/kayou.nc');
                    },
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image:
                                    AssetImage('assets/images/logo_kayou.png'),
                                height: 30,
                              )),
                          SizedBox(width: 50),
                          Container(
                              margin: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Supprimer mon compte Kayou",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black)),
                                    SizedBox(height: 5),
                                    Text(
                                        "Attention, cette action est irréversible",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            // fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Colors.grey)),
                                  ])),
                          // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                        ]),
                    onPressed: () async {
                      if (await utils!.isConnectedToInternet()) {
                        if (await confirm(
                          context,
                          title: Text('Confirmation'),
                          content: Container(
                              padding: EdgeInsets.zero,
                              height: 110,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Voulez-vous vraiment supprimer votre compte kayou et perdre l\'ensemble de vos kayous?',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 14)),
                                    SizedBox(height: 5),
                                    Text(
                                        "Attention, cette action est irréversible!",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14))
                                  ])),
                          textOK: Text('Oui'),
                          textCancel: Text('Non'),
                        )) {
                          EasyLoading.show(status: "Suppression en cours...");
                          bool disconnect = await utils!.deleteUser();
                          EasyLoading.dismiss();
                          // print(disconnect);
                          // globals.hideNavBar = true;
                          // setState(() {});
                          if (disconnect) {
                            pushNewScreen(
                              context,
                              screen: AuthentificationPage(
                                onSignedIn: _onSignedIn,
                                onInit: false,
                                index: 0,
                                onLaunch: false,
                              ),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          } else {
                            globals.hideNavBar = false;
                            setState(() {});
                          }
                        }
                      } else {
                        utils!.showInternetConnectionDialog(context);
                      }
                    },
                  )),
              SizedBox(
                height: 30,
              ),
              Platform.isAndroid
                  ? Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: heightButton,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.grey)),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          onPrimary: Colors.black,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/logo-fit.png'),
                                    height: 25,
                                  )),
                              SizedBox(width: 50),
                              Container(
                                  margin: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                      "Rafraichir la connexion Google Fit",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black))),
                              // Icon(Icons.arrow_forward, color: Colors.cyan[700]!)
                            ]),
                        onPressed: () async {
                          if (await confirm(
                            context,
                            title: Text('Confirmation'),
                            content: Text(
                              'Voulez-vous vraiment rafraichir la connexion à l\'application Google Fit ?',
                              textAlign: TextAlign.center,
                            ),
                            textOK: Text('Oui'),
                            textCancel: Text('Non'),
                          )) {
                            HealthFactory health = new HealthFactory();

                            List<HealthDataType> types = [
                              HealthDataType.STEPS,
                            ];

                            var permissions = [HealthDataAccess.READ];

                            await health.requestAuthorization(types,
                                permissions: permissions);
                            // if (await utils!.deleteCacheDir()) {
                            //   Alert(
                            //     context: context,
                            //     type: AlertType.success,
                            //     closeIcon: Container(),
                            //     title: "",
                            //     desc:
                            //         "Les données ont bien été supprimées. Vous pouvez relancer l'application.",
                            //     buttons: [
                            //       DialogButton(
                            //         child: Text(
                            //           "Fermer",
                            //           style: TextStyle(
                            //               color: Colors.white, fontSize: 18),
                            //         ),
                            //         onPressed: () => Navigator.pop(context),
                            //         color: Color.fromRGBO(0, 179, 134, 1.0),
                            //       ),
                            //     ],
                            //   ).show();
                            // }
                          }
                        },
                      ))
                  : Container(),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                  height: heightButton,
                  decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1, color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onPrimary: Colors.black,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text("Déconnexion",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () async {
                      bool disconnect = await utils!.signOut();

                      // print(disconnect);
                      // globals.hideNavBar = true;
                      // setState(() {});
                      if (disconnect) {
                        pushNewScreen(
                          context,
                          screen: AuthentificationPage(
                            onSignedIn: _onSignedIn,
                            onInit: false,
                            index: 0,
                            onLaunch: false,
                          ),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      } else {
                        globals.hideNavBar = false;
                        setState(() {});
                      }
                    },
                  )),
              SizedBox(height: 30),
              versionLib,
              SizedBox(height: 20),
            ]))));
  }
}
