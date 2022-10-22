import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

UtilsState? utils;

class SelectParrainagePage extends StatefulWidget {
  SelectParrainagePageState createState() => SelectParrainagePageState();
}

class SelectParrainagePageState extends State<SelectParrainagePage> {
  double heightButton = 60;

  String parrain = "";

  void initState() {
    utils = new UtilsState();
    utils?.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("Code de parrainage",
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
                        Icon(Icons.arrow_back_ios, color: Colors.orange[700]),
                        Text("Retour",
                            style: TextStyle(
                                fontSize: 14, color: Colors.orange[700]))
                      ]))),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 20),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Saisissez votre code parrainage :",
                      style: TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(height: 5),
              Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      labelText: '',
                    ),
                    onChanged: (val) => {setState(() => parrain = val.trim())},
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.orange[700],
                      borderRadius: BorderRadius.circular(60)),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        onPrimary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        primary: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      onPressed: () async {
                        if (!await utils?.isConnectedToInternet()) {
                          await utils?.showInternetConnectionDialog(context);
                        } else {
                          if (parrain == "" || parrain == globals.codeParrain) {
                            utils?.showPopupWarning(
                                context, "Saisir un code de parrainage valide");
                          } else {
                            if (!globals.validateParrain) {
                              globals.validateParrain = true;
                              //On récupere d'abord le parrain et on affecte
                              // print(parrain);
                              var data = await FirebaseFirestore.instance
                                  .collection('users')
                                  .where("uid", isEqualTo: parrain)
                                  .limit(1)
                                  .get();

                              if (data.docs.length == 0) {
                                await utils
                                    ?.openPopupError(context,
                                        "La parrain n'est pas valide!", "")
                                    .then((value) {
                                  Navigator.pop(context);
                                });
                              } else {
                                var doc = data.docs.first;
                                var nameParrain = doc.get("name");
                                var points = doc.get("points");
                                var pointsToday =
                                    utils?.getValue(doc, "todayPoints", "int");

                                if (doc.get("name").length == 0) {
                                  nameParrain = doc.get("pseudo");
                                }

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(globals.user?.uid)
                                    .update({
                                  'codeParrain': parrain,
                                  'parrain': nameParrain,
                                  'points': FieldValue.increment(5),
                                  'todayPoints': FieldValue.increment(5)
                                }).then((value) async {
                                  var filleul = globals.name.length > 0
                                      ? globals.name
                                      : globals.pseudo;
                                  globals.profitUser += 5;
                                  globals.dayWin += 5;

                                  //On créé l'historique
                                  utils?.updateHistorique(
                                      globals.uidParrainage,
                                      "PAR",
                                      "Parrainage - " + nameParrain,
                                      5,
                                      "");

                                  utils?.updateHistorique(
                                      parrain,
                                      "PAR",
                                      "Parrainage - " + filleul.toString(),
                                      10,
                                      "");
                                  //On crédite le parrain
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(doc.id)
                                      .update({
                                    'points': FieldValue.increment(10),
                                    'todayPoints': FieldValue.increment(10)
                                  }).then((value) async {
                                    await utils
                                        ?.openPopupSuccess(
                                            context,
                                            "Félicitations!",
                                            "Vous venez de gagner 5Ꝃ")
                                        .then((value) {
                                      setState(() {
                                        globals.codeParrain = parrain;
                                        globals.parrain = nameParrain;
                                      });

                                      Navigator.pop(context);
                                    });
                                  });
                                });
                              }
                            }
                          }
                        }
                      },
                      child: Container(
                          child: Text("Enregistrer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)))))
            ]))));
  }
}
