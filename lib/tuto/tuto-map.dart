import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

class TutoMapPage extends StatefulWidget {
  TutoMapPageState createState() => TutoMapPageState();
}

class TutoMapPageState extends State<TutoMapPage> {
  double heightButton = 60;

  String weight = "";

  void initState() {
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
                  child: Text("Tutoriel",
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
                        Icon(Icons.arrow_back_ios, color: Colors.cyan[700]!),
                        Text("Retour",
                            style: TextStyle(
                                fontSize: 14, color: Colors.cyan[700]!))
                      ]))),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text("Comment utiliser le plan ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 10),
                          Text(
                            "Le plan r??f??rence plusieurs points d'int??r??ts en Nouvelle-Cal??donie, repr??sent??s par un cercle bleu sur la carte.",
                          ),
                          SizedBox(height: 30),
                          Text(
                            "En vous rendant sur les diff??rents points d???int??r??ts, vous pouvez gagner des Kayous suppl??mentaires.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                            "assets/images/tuto/Plan-02.jpg",
                          )),
                          SizedBox(height: 20),
                          Text(
                            "Pour valider un point d'int??r??t, il faut autoriser le partage de votre position et vous rendre dans le cercle bleu afin de le valider.",
                          ),
                          SizedBox(height: 10),
                          Text(
                            "En validant un point d'int??r??t, celui-ci dispara??t du plan.",
                          ),
                          SizedBox(height: 10),
                          Text(
                              "Info : Les points d???int??r??ts sont r??initialis??s tous les jours.",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          SizedBox(height: 30),
                          Text("Comment recentrer sur ma position actuelle ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 10),
                          Text(
                            "Cette ic??ne permet de recentrer la carte sur votre position actuelle.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/Plan-01.jpg",
                                  height: 50,
                                  width: 50)),
                        ])))));
  }
}
