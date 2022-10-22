import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayou/tools/utils.dart';
import 'package:loading_animations/loading_animations.dart';
import 'tools/globals.dart' as globals;
import 'package:video_player/video_player.dart';
import 'dart:async';

class AdMobPage extends StatefulWidget {
  AdMobPageState createState() => AdMobPageState();
}

class AdMobPageState extends State<AdMobPage> {
  var myFuture;
  QuerySnapshot? querySnapshot;
  var data = null;
  Timer? _timer;
  VideoPlayerController? _controller;

  int seconds = 15;

  bool isInitialised = false;

  UtilsState? utils;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    if (_controller != null) {
      _controller!.dispose();
    }
  }

  @override
  void initState() {
    super.initState();

    utils = new UtilsState();
    utils!.initState();
    myFuture = loadAds();
  }

  loadAds() async {
    globals.endTimerAds = false;
    querySnapshot = await FirebaseFirestore.instance
        .collection('ads')
        .where("published", isEqualTo: true)
        .orderBy("views")
        .limit(1)
        .get();

    querySnapshot!.docs.forEach((value) {
      data = value;
    });

    if (data != null) {
      if (data["type"] == "video") {
        _controller = VideoPlayerController.network(data["adlink"])
          ..initialize().then((_) {
            isInitialised = true;
            _controller!.setLooping(false);
            _controller!.play();
            setState(() {});
          });
      } else if (data["type"] == "youtube") {}

      if (data["type"] == "image") {
        setTimer();
      }
    }

    return await callAsyncFetch();
  }

  //Ajout du pack en favoris
  void setTimer() async {
    if (_timer != null) {
      _timer!.cancel();
    }

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds == 1) {
            //Fin du Timer
            timer.cancel();
            globals.endTimerAds = true;
            // setState(() {});
          } else {
            if (seconds == 1) {
              //Fin du Timer
              timer.cancel();
              globals.endTimerAds = true;
              // setState(() {});
            } else {
              seconds = seconds - 1;
            }
          }
        },
      ),
    );
  }

  Future<String> callAsyncFetch() => Future.value("Chargement en cours...");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var body;
                if (data == null) {
                  Navigator.pop(context);
                }

                if (data["type"] == "image") {
                  body = Container(
                    width: MediaQuery.of(context).size.width,
                    child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: CachedNetworkImage(
                          imageUrl: data["adlink"],
                          imageBuilder: (context, imageProvider) {
                            return Container(
                                width: MediaQuery.of(context).size.width - 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ));
                          },
                          placeholder: (context, url) => Container(
                              height: 190,
                              width: MediaQuery.of(context).size.width - 200,
                              child: Center(
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.grey[400]!),
                                      )))),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                  );
                } else if (data["type"] == "video") {
                  if (_controller!.value.isInitialized) {
                    setTimer();
                  }
                  body = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //     padding: EdgeInsets.only(left: 20, right: 20),
                        //     child: Divider(color: Colors.white, height: 1)),
                        // SizedBox(height: 15),
                        // Container(
                        //     padding: EdgeInsets.only(left: 20),
                        //     child: Text(data["merchand"],
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 16))),
                        SizedBox(height: 20),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: _controller!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  )
                                : Center(
                                    child: Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.grey[400]!),
                                        )))),
                        SizedBox(height: 20),
                        (data["link"].toString().length > 0)
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    onSurface: Colors.transparent,
                                    elevation: 1),
                                onPressed: () {
                                  utils!.openLink(data["link"]);
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Visiter le lien",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          Icon(Icons.arrow_forward_ios_rounded,
                                              color: Colors.white),
                                        ])))
                            : Container(),
                        SizedBox(height: 15),
                        (data["link"].toString().length > 0)
                            ? Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Divider(color: Colors.white, height: 1))
                            : Container(),
                      ]);
                } else {}

                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarBrightness: Brightness.dark,
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarDividerColor: Colors.transparent),
                      elevation: 0,
                      leadingWidth: 65,
                      leading: globals.endTimerAds
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      size: 24,
                                      color: data["type"] == "image"
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    onPressed: () async {
                                      if (globals.isValidatePub) {
                                        globals.isValidatePub = false;
                                        if (globals.endTimerAds) {
                                          utils!.updateAds(data.id);
                                          if (globals.ads) {
                                            if (await utils!.updatePub(
                                                1, data["merchand"])) {
                                              globals.pubOK = true;
                                            }
                                          }
                                        }
                                        Navigator.pop(context);
                                      }
                                    },
                                  ))),
                      actions: [
                        globals.endTimerAds
                            ? Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 10, bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                height: 50,
                                width: 50,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      icon: Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      color: Colors.transparent,
                                      onPressed: () async {
                                        if (globals.isValidatePub) {
                                          globals.isValidatePub = false;
                                          utils!.updateAds(data.id);
                                          if (globals.ads) {
                                            if (await utils!.updatePub(
                                                1, data["merchand"])) {
                                              globals.pubOK = true;
                                            }
                                          }

                                          Navigator.pop(context);
                                        }
                                      },
                                    )))
                            : Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 10, bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                height: 50,
                                width: 50,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(seconds.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.redAccent[700],
                                            fontWeight: FontWeight.bold))))
                      ],
                    ),
                    floatingActionButton: (data["link"].toString().length > 0 &&
                            data["type"] == "image")
                        ? Container(
                            alignment: Alignment.bottomRight,
                            width: 150,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shadowColor: Colors.transparent,
                                    onSurface: Colors.transparent,
                                    elevation: 1),
                                onPressed: () {
                                  utils!.openLink(data["link"]);
                                },
                                child: Container(
                                    // padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text("Visiter le lien",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          color: Colors.black),
                                    ]))))
                        : Container(),
                    extendBodyBehindAppBar: true,
                    backgroundColor: Colors.black,
                    body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[body]));
              } else {
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarBrightness: Brightness.light,
                          statusBarColor: Colors.transparent,
                          systemNavigationBarColor: Colors.transparent,
                          systemNavigationBarDividerColor: Colors.transparent),
                      toolbarHeight: 90,
                      elevation: 0,
                      leadingWidth: 65,
                      leading: Container(
                          margin:
                              EdgeInsets.only(top: 25, left: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          height: 20,
                          width: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                size: 20, color: Colors.cyan[700]!),
                            color: Colors.transparent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )),
                    ),
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
            }));
  }
}
