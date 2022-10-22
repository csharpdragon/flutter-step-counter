import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

class TutoActivityPage extends StatefulWidget {
  TutoActivityPageState createState() => TutoActivityPageState();
}

class TutoActivityPageState extends State<TutoActivityPage> {
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
                          Text("Comment bien commencer avec Kayou ?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(
                            "Bienvenue sur Kayou.",
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Ce tutoriel vous permettra de prendre en main l’Application en quelques secondes.",
                          ),

                          SizedBox(height: 10),
                          Text("Comment cumuler des Kayous ?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text(
                            "Ce chiffre correspond à votre nombre de pas quotidien. Plus vous marcherez, plus vous validerez les différents paliers vous permettant de gagner des points (les « Kayous ») à échanger contre des offres ou des récompenses. ",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-01.jpg",
                                  height: 100)),
                          SizedBox(height: 10),
                          Text(
                            "Lorsque vous avez atteint le nombre de pas nécessaire pour valider un palier, pensez à cliquer sur ce bouton pour gagner vos Kayous.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-02.jpg",
                                  height: 70)),
                          SizedBox(height: 10),
                          Text(
                              "Attention ! Les pas non validés à la fin de la journée seront perdus.",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          SizedBox(height: 10),

                          //IMAGE
                          Text(
                            "Ce chiffre correspond à votre nombre total de Kayous. Vous pouvez les utiliser en contrepartie d’avantages chez nos commerçants partenaires, ou les convertir en récompenses (cadeau ou versement).",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-03.jpg",
                                  height: 120)),

                          SizedBox(height: 10),
                          //IMAGE
                          Text(
                            "Ce chiffre est le nombre de pas validé sur la journée. Il est réinitialisé tous les jours.",
                          ),

                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-04.jpg",
                                  height: 130)),
                          SizedBox(height: 10),
                          Text("Comment échanger vos Kayous ?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          //IMAGE

                          Text(
                            "Nos partenaires vous permettent d’échanger vos Kayous ou d’en gagner davantage.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-05.jpg",
                                  height: 80)),
                          SizedBox(height: 10),

                          Text(
                            "Vous pouvez également convertir vos Kayous en récompenses.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-06.jpg",
                                  height: 65)),
                          SizedBox(height: 10), //IMAGE
                          Text(
                            "Vous pouvez gagner des Kayous en vous rendant aux différents points d’intérêts référencés sur le Plan, et en validant votre position dans le cercle affiché.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-07.jpg",
                                  height: 65)),
                          SizedBox(height: 10),
                          Text("Comment accéder à mon espace personnel ?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10), //IMAGE
                          Text(
                            "Pour accéder à votre espace personnel, cliquez sur cette icône.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                                  "assets/images/tuto/activity-08.jpg",
                                  height: 50)),
                          SizedBox(height: 10),
                          Text("Comment obtenir des Kayous supplémentaires ?",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10), //IMAGE
                          Text(
                            "Vous pouvez obtenir des Kayous supplémentaires en faisant diverses activités référencées dans cette section.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                            "assets/images/tuto/activity-09.jpg",
                          )),
                        ])))));
  }
}
