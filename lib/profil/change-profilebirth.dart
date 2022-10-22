import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

UtilsState? utils;

class ProfilBirthPage extends StatefulWidget {
  ProfilBirthPageState createState() => ProfilBirthPageState();
}

class ProfilBirthPageState extends State<ProfilBirthPage> {
  double heightButton = 60;

  String birth = "";
  TextEditingController birthController = new TextEditingController();

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
                  child: Text("Date de naissance",
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
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Date de naissance actuelle :",
                      style: TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(height: 5),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(globals.dateNaissance)),
              SizedBox(height: 30),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Nouvelle date de naissance :",
                      style: TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(height: 5),
              Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: birthController,
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      labelText: '',
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          cancelText: "Annuler",
                          locale: Locale("fr", "FR"),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        // print(
                        //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        // print(
                        //     formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          birthController.text = formattedDate;
                          birth =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        birthController.text = "";
                        birth = "";
                        // print("Date is not selected");
                      }
                    },
                    onChanged: (val) => {setState(() => birth = val)},
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
                        if (birth == "") {
                          utils?.showPopupWarning(
                              context, "Saisir une date de naissance");
                        } else {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(globals.user?.uid)
                              .update({'birth': birth}).then((value) async {
                            await utils
                                ?.openPopupSuccess(
                                    context, "Mise à jour effectuée", "")
                                .then((value) {
                              setState(() {
                                globals.dateNaissance = birth;
                              });
                              Navigator.pop(context);
                            });
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
