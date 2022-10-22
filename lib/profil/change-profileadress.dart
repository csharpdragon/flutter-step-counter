import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

UtilsState? utils;

class ProfilAdressPage extends StatefulWidget {
  ProfilAdressPageState createState() => ProfilAdressPageState();
}

class ProfilAdressPageState extends State<ProfilAdressPage> {
  double heightButton = 60;

  String adress = "";

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
                  child: Text("Adresse physique",
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
                child: Column(children: [
              SizedBox(height: 20),
              SizedBox(height: 30),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Adresse physique actuelle :",
                      style: TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(height: 5),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(globals.adress)),
              SizedBox(height: 30),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Nouvelle adresse physique :",
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
                    onChanged: (val) => {setState(() => adress = val)},
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
                        primary: Colors.cyan[700]!,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      onPressed: () async {
                        if (adress == "") {
                          utils?.showPopupWarning(
                              context, "Saisir une adresse physique");
                        } else {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(globals.user?.uid)
                              .update({'adress': adress}).then((value) async {
                            await utils
                                ?.openPopupSuccess(
                                    context, "Mise à jour effectuée", "")
                                .then((value) {
                              setState(() {
                                globals.adress = adress;
                              });
                              Navigator.pop(context);
                            });
                            // Alert(
                            //   context: context,
                            //   type: AlertType.success,
                            //   closeIcon: Container(),
                            //   title: "",
                            //   desc: "Mise à jour effectuée",
                            //   buttons: [
                            //     DialogButton(
                            //       child: Text(
                            //         "Fermer",
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 18),
                            //       ),
                            //       onPressed: () => Navigator.pop(context),
                            //       color: Color.fromRGBO(0, 179, 134, 1.0),
                            //     ),
                            //   ],
                            // ).show().then((value) {
                            // setState(() {
                            //   globals.adress = adress;
                            // });
                            // Navigator.pop(context);
                            // });
                          });
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
