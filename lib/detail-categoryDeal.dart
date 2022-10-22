import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kayou/detail-dealpage.dart';
import 'package:kayou/tools/utils.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'tools/globals.dart' as globals;

UtilsState? utils;

class CategoryDealPage extends StatefulWidget {
  final globals.Category category;

  CategoryDealPage(this.category);
  CategoryDealPageState createState() => CategoryDealPageState();
}

class CategoryDealPageState extends State<CategoryDealPage> {
  double heightButton = 60;

  void initState() {
    utils = new UtilsState();
    utils!.initState();
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
                  child: Text(widget.category.name,
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
            body: Container(
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          indent: 15,
                        ),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.category.listsAll.length,
                    itemBuilder: (context, indexPrograms) {
                      var raisedButton;

                      raisedButton = ElevatedButton(
                          onPressed: () async {
                            pushNewScreen(context,
                                screen: DetailDealPage(widget
                                    .category.listsAll[indexPrograms]["id"]),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onPrimary: Colors.black,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.only(left: 0, right: 0),
                          ),
                          child: Container(
                              height: 270,
                              width: MediaQuery.of(context).size.width - 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[100],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 190,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.category
                                                .listsAll[indexPrograms]
                                            ["imagePresentation"],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          //************************************* */
                                          /* A DECOMMENTER POUR LE TAG DISPONIBLE / INDISPONIBLE*/
                                          // child: Column(
                                          //     children: [
                                          //       Container(
                                          //         margin:
                                          //             EdgeInsets.all(15),
                                          //         alignment:
                                          //             Alignment.topRight,
                                          //         padding:
                                          //             EdgeInsets.all(5),
                                          //         height:
                                          //             30,
                                          //         child: globals.selectedMenuDeals.categories[index].gift[indexPrograms]["payable"] == true
                                          //             ? Icon(Icons.lock_outline, size: 45, color: Colors.grey[500])
                                          //             : Container(),
                                          //       ),
                                          //     ]),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                                height: 190,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    200,
                                                child: Center(
                                                    child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.grey[
                                                                      400]!),
                                                        )))),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      alignment: Alignment.bottomLeft,
                                      child: Row(children: [
                                        CachedNetworkImage(
                                          imageUrl: widget.category
                                                  .listsAll[indexPrograms]
                                              ["merchandLogo"],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: Center(
                                                      child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                new AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors.grey[
                                                                        400]!),
                                                          )))),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: Center(
                                                      child:
                                                          Icon(Icons.error))),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      widget.category.listsAll[
                                                              indexPrograms]
                                                          ["merchand"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                  SizedBox(height: 2),
                                                  Text(
                                                      widget.category.listsAll[
                                                              indexPrograms]
                                                          ["subtitle"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color:
                                                              Colors.deepOrange[
                                                                  900])),
                                                  SizedBox(height: 2),
                                                  Row(children: [
                                                    Text(
                                                        utils!.addSeparateurMillier(widget
                                                                .category
                                                                .listsAll[
                                                                    indexPrograms]
                                                                    ["price"]
                                                                .toString()) +
                                                            " Ꝃ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .cyan[700])),
                                                    Text(" par "),
                                                    Text(
                                                        utils!.addSeparateurMillier(widget
                                                                .category
                                                                .listsAll[
                                                                    indexPrograms]
                                                                    [
                                                                    "priceDeal"]
                                                                .toString()) +
                                                            " XPF",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .cyan[700])),
                                                    Text(" dépensés")
                                                  ])
                                                ])),
                                      ]),
                                    )
                                  ])));
                      return raisedButton;
                    }))));
  }
}
