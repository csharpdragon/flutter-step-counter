import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kayou/tools/utils.dart';
import 'package:kayou/tools/globals.dart' as globals;
import 'package:loading_animations/loading_animations.dart';

import 'package:intl/intl.dart';

UtilsState? utils;

class HistoricalProfilPage extends StatefulWidget {
  HistoricalProfilPageState createState() => HistoricalProfilPageState();
}

class HistoricalProfilPageState extends State<HistoricalProfilPage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var myFuture;

  void initState() {
    utils = new UtilsState();
    utils?.initState();
    super.initState();

    myFuture = getHistorical(globals.historical.length == 0);
  }

  getHistorical(force) async {
    try {
      if (force) {
        DateFormat dateFormatDay = DateFormat("EEEE");
        DateFormat dateFormatYear = DateFormat("yyyy");
        DateFormat dateFormatJour = DateFormat("dd");
        DateFormat dateFormatFirebase = DateFormat("yyyy-MM-dd");
        DateFormat dateFormatMois =
            DateFormat(globals.dictionnary["dateDayFormat"]);

        String date;

        globals.historical = [];
        var data = await FirebaseFirestore.instance
            .collection('historical')
            .where("uid", isEqualTo: globals.uidParrainage)
            .get();

        data.docs.forEach((value) {
          for (var i = 0; i < value["details"].length; i++) {
            if (value["details"][i]["total"] > 0 &&
                value["details"][i]['type'] != "PAS" &&
                value["details"][i]['type'] != "PVS") {
              var dateTemp = DateFormat('yyyy-MM-dd')
                  .format((value["details"][i]["date"] as Timestamp).toDate());

              date = globals.dictionnary[dateFormatDay
                      .format(dateFormatFirebase.parse(dateTemp))
                      .toLowerCase()
                      .toString()]! +
                  " " +
                  dateFormatJour.format(dateFormatFirebase.parse(dateTemp)) +
                  " " +
                  globals.dictionnary[dateFormatMois
                      .format(dateFormatFirebase.parse(dateTemp))
                      .toLowerCase()
                      .toString()]! +
                  " " +
                  dateFormatYear.format(dateFormatFirebase.parse(dateTemp));
              // print(DateFormat("yyyMMDDHHmm")
              //     .format((value["details"][i]["date"] as Timestamp).toDate()));
              globals.historical.add({
                //On rajoute dateTemp pour faciliter le tri dans le GroupListView
                "date": dateTemp + "#" + date,
                "datetime": value["details"][i]["date"],
                "total": value["details"][i]["total"],
                "type": value["details"][i]["type"],
                "description": value["details"][i]["description"],
              });
            }
          }
        });
      }

      return await callAsyncFetch();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  Future<Null> refreshList() async {
    await Future.delayed(new Duration(seconds: 1));

    setState(() {
      myFuture = getHistorical(true);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                          child: Text("Historique",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18))),
                      leading: Container(
                          margin: EdgeInsets.only(
                              left: 0, top: 10, bottom: 10, right: 13),
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
                                Icon(Icons.arrow_back,
                                    color: Colors.cyan[700]!),
                                Text("Retour",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.cyan[700]!))
                              ]))),
                    ),
                    backgroundColor: Colors.white,
                    body: RefreshIndicator(
                      key: refreshKey,
                      onRefresh: refreshList,
                      child: GroupedListView<dynamic, String>(
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        elements: globals.historical,
                        groupBy: (element) => element['date'],
                        // groupComparator: (value1, value2) =>
                        //     value2.compareTo(value1),
                        itemComparator: (item1, item2) =>
                            item1['datetime'].compareTo(item2['datetime']),
                        order: GroupedListOrder.DESC,
                        // useStickyGroupSeparators: true,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            value.split("#")[1],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        itemBuilder: (c, element) {
                          var icon;
                          var pointsLib;
                          var title;
                          var color;

                          switch (element['type']) {
                            case "PAS":
                              title = "";
                              icon = Icons.directions_walk_rounded;
                              pointsLib = element['total'].toString() +
                                  " pas effectué(s)";
                              break;
                            case "PVS":
                              title = "";
                              icon = Icons.directions_walk_rounded;
                              pointsLib = element['total'].toString() +
                                  " pas validé(s)";
                              break;
                            case "CBK":
                              color = Colors.green[600];
                              title = "+" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = CupertinoIcons.tag;
                              pointsLib = element['description'];
                              break;

                            case "MAP":
                              color = Colors.green[600];
                              title = "+" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = FontAwesomeIcons.streetView;
                              pointsLib = element['description'];
                              break;

                            case "PAR":
                              color = Colors.green[600];
                              title = "+" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = Icons.supervisor_account_outlined;
                              pointsLib = element['description'];
                              break;

                            case "PJR":
                              color = Colors.green[600];
                              title = "+" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = Icons.directions_walk_rounded;
                              pointsLib =
                                  element['total'].toString() + " Ꝃ gagné(s)";
                              break;

                            case "RCP":
                              color = Colors.red[900];
                              title = "-" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = CupertinoIcons.gift;
                              pointsLib = element['description'];
                              break;
                            case "PUB":
                              color = Colors.green[600];
                              title = "+" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = CupertinoIcons.memories;
                              pointsLib = "Pub " + element['description'];
                              break;
                            case "SMS":
                              color = Colors.green[600];
                              title = "+" +
                                  element['total'].toString() +
                                  " Kayou(s)";
                              icon = Icons.message_outlined;
                              pointsLib = element['description'];
                              break;
                            default:
                          }

                          if (element['type'] == "PAS" ||
                              element['type'] == "PVS") {
                            return Container();
                          } else {
                            return Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Container(
                                    margin: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Row(children: [
                                      Container(
                                          height: 50,
                                          width: 50,
                                          child: Icon(icon,
                                              size: 36,
                                              color: Colors.black
                                                  .withOpacity(0.5))),
                                      SizedBox(width: 10),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(title,
                                                style: TextStyle(
                                                    color: color,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Text(pointsLib),
                                            SizedBox(height: 5),
                                            Text(
                                                DateFormat("dd/MM/yyyy HH:mm")
                                                    .format((element["datetime"]
                                                            as Timestamp)
                                                        .toDate()),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                )),
                                          ])
                                    ])));
                          }
                        },
                      ),
                    )));
          } else {
            return Scaffold(
                body: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Center(
                      child: LoadingBouncingGrid.square(
                    size: 80,
                    backgroundColor: Colors.cyan[700]!,
                  )),
                ]));
          }
        });
  }
}
