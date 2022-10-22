import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

class TutoGiftPage extends StatefulWidget {
  TutoGiftPageState createState() => TutoGiftPageState();
}

class TutoGiftPageState extends State<TutoGiftPage> {
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
                          Text("Comment utiliser les récompenses ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 10),
                          Text(
                            "Vous pouvez convertir les Kayous que vous cumulez en Récompenses. Il existe 2 types de Récompenses : les Cadeaux et les Versements.",
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Les cadeaux sont des objets ou des offres disponibles en quantité limitée, mais renouvelés régulièrement.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                            "assets/images/tuto/Recompenses-01.jpg",
                          )),
                          SizedBox(height: 10),
                          Text(
                            "Les versements vous permettent d’obtenir des chèques libellés à votre ordre. Ils sont aussi disponibles en quantité limitée, mais renouvelés régulièrement.",
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Image.asset(
                            "assets/images/tuto/Recompenses-02.jpg",
                          )),
                        ])))));
  }
}
