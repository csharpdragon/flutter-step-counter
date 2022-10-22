import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:pinput/pinput.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../tools/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../tools/globals.dart' as globals;
import '../tools/blackListMail.dart' as blackList;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

UtilsState? utils;

GlobalKey<State> _keyLoader = new GlobalKey<State>();
GlobalKey<State> _keyLoaderGoogle = new GlobalKey<State>();
GlobalKey<State> _keyLoaderApple = new GlobalKey<State>();
GlobalKey<State> _keyLoaderFacebook = new GlobalKey<State>();
GlobalKey<State> _keyLoaderEmail = new GlobalKey<State>();
GlobalKey<State> _keyLoaderForgetPWD = new GlobalKey<State>();

GlobalKey<State> _keyLoaderOTP = new GlobalKey<State>();

var _otp = '';
var _emailVerify = '';
int nbEssai = 1;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

//Connexion avec son compte apple
signInWithApple(
  BuildContext context,
) async {
  try {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAuthProvider = OAuthProvider("apple.com");
    final credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );
    UserCredential authResult = await _auth.signInWithCredential(credential);

    if (authResult.user != null) {
      EasyLoading.show(status: 'Patientez s\'il vous plait...');

      // globals.isPremium = false;
      globals.user = authResult.user;

      //On créé maintenant la fiche utilisateur
      await utils!.checkAndCreateAccount(globals.user!);

      //on ouvre les achats
      // await utils.openPurchaseConnection();
    }
    EasyLoading.dismiss();
    return true;
  } catch (e) {
    print(e.toString());
    EasyLoading.dismiss();
    return false;
  }
}

//Connexion avec son compte google
Future<bool> signInWithGoogle(
  BuildContext context,
) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      EasyLoading.show(status: 'Patientez s\'il vous plait...');

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);

      print('----------');
      print(authResult);
      if (authResult.user != null) {
        globals.user = authResult.user;

//On créé maintenant la fiche utilisateur
        await utils!.checkAndCreateAccount(globals.user!);

        await utils!.initLevels();

        //on ouvre les achats
        // await utils.openPurchaseConnection();
      }

      EasyLoading.dismiss();

      return true;
    } else {
      return false;
    }
  } catch (e) {
    EasyLoading.dismiss();

    print(e.toString());

    return false;
  }
}

Future<bool> signInWithFacebook(
  BuildContext context,
) async {
  try {
    // Trigger the sign-in flow

    // var provider = new FacebookAuthProvider();
    // provider.addScope('email');

    // final fb = FacebookLogin();

    // if (fb == null) {
    //   return false;
    // }

    // final result = await fb.logIn(permissions: [
    //   FacebookPermission.email,
    // ]);

    // // print(await fb.getUserEmail());

    // if (result.status != FacebookLoginStatus.success) {
    //   return false;
    // } else {
    //   EasyLoading.show(status: 'Patientez s\'il vous plait...');
    // }

    // // Create a credential from the access token
    // final OAuthCredential facebookAuthCredential =
    //     FacebookAuthProvider.credential(result.accessToken!.token);

    // if (facebookAuthCredential == null) {
    //   return false;
    // }
    // // Once signed in, return the UserCredential
    // var facebookCred = await FirebaseAuth.instance
    //     .signInWithCredential(facebookAuthCredential);

    // if (facebookCred == null) {
    //   EasyLoading.dismiss();

    //   return false;
    // }

    // // print(facebookCred.user.email);
    // globals.user = facebookCred.user;
    // //On créé maintenant la fiche utilisateur
    // await utils!.checkAndCreateAccount(globals.user!);

    // await utils!.initLevels();

    // //on ouvre les achats
    // // await utils.openPurchaseConnection();

    // EasyLoading.dismiss();

    // return true;
    EasyLoading.dismiss();

    return false;
  } catch (e) {
    EasyLoading.dismiss();

    return false;
  }
}

Future<bool> signInWithEmail(
    BuildContext context, String email, String password) async {
  //sign in with email & password

  try {
    EasyLoading.show(status: 'Patientez s\'il vous plait...');

    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    if (result == null) {
      return false;
    } else {
      globals.user = result.user;

      await utils!.checkAndCreateAccount(globals.user!);

      //on ouvre les achats
      // await utils.openPurchaseConnection();
    }

    EasyLoading.dismiss();
    return true;
  } catch (e) {
    print(e);
    EasyLoading.dismiss();
    return false;
  }
}

bool verifyOTP(String pin) {
  print(_otp);
  print(pin);
  if (pin == _otp) {
    
    print('va te faire quand meme bounane ');

    return true;
  } else {
    nbEssai++;
    // print('va te faire bounane' + nbEssai.toString());
    return false;
  }
}

Future<bool> sendOtp(BuildContext context, String email) async {
  EasyLoading.show(status: "Veuillez patienter...");

  _otp = new Random.secure().nextInt(999999).toString().padLeft(6, '0');

  try {
    var url = Uri.parse(
        'https://us-central1-kayou-83475.cloudfunctions.net/sendEmail?email=' +
            email +
            '&template=d-fb2d7afed0274c198f7ba1c9672edcbc&from=noreply@kayou.nc&number=' +
            _otp);

    var response = await http.post(url);

    EasyLoading.dismiss();

    return true;
  } catch (e) {
    print(e.toString());

    EasyLoading.dismiss();
    return false;
  }
}

Future<bool> sendEmailResetPassword(email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> registerWithEmail(
    BuildContext context, String email, String password) async {
  //sign in with email & password

  try {
    EasyLoading.show(status: 'Patientez s\'il vous plait...');

    // print(email + "- " + password);
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (result.user == null) {
      // print("utilisateur inexistant");
      EasyLoading.dismiss();
      return false;
    } else {
      // print('utilisateur créé!');

      //On se connecte pour être sûr

      globals.user = result.user;

      await utils!.checkAndCreateAccount(globals.user!);
    }

    // widget.onSignedIn();
    EasyLoading.dismiss();
    return true;
  } catch (e) {
    print(e.toString());
    EasyLoading.dismiss();
    return false;
  }
}

showAlertDialog(BuildContext context, String message) {
  // set up the button
  // Widget okButton = ElevatedButton(
  //   child: Text(globals.dictionnary["Close"]),
  //   onPressed: () {},
  // );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // backgroundColor: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
    // title: Text("Connexion alert"),
    content: Text(
      message,
      // style: TextStyle(color: Colors.white),
    ),
    actions: [
      // okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class AuthentificationPage extends StatefulWidget {
  AuthentificationPage(
      {required this.onSignedIn,
      required this.onInit,
      required this.index,
      required this.onLaunch});

  final VoidCallback onSignedIn;
  final bool onInit;
  final bool onLaunch;
  final int index;

  _AuthentificationPage createState() => _AuthentificationPage();
}

class _AuthentificationPage extends State<AuthentificationPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    setState(() {});
    utils = new UtilsState();
    utils!.initState();

    super.initState();
  }

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 50, left: 0, right: 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(globals.dictionnary["Login"]!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(globals.dictionnary["LoginContinue"]!,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (Platform.isIOS)
                      Container(
                          width: 85,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[100],
                              onPrimary: Colors.white,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(30))),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/logo_apple.png'),
                                  height: 26,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              if (await signInWithApple(context)) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                if (widget.onInit) {
                                  //On enregistre dans les préférences le fait
                                  //qu'on a déjà ouvert une premiere fois l'application

                                  prefs.setBool('isFirstLaunch', false);
                                }
                                if (widget.onLaunch) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/HomePage');
                                } else {
                                  widget.onSignedIn();
                                  Navigator.pop(context);
                                }

                                widget.onSignedIn();

                                // print("on pop!");
                              }
                              // else {
                              //   showAlertDialog(context);
                              // }
                            },
                          )),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 85,
                        height: 55,
                        // margin: EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[100],
                            onPrimary: Colors.white,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(30))),
                          ),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue.shade900,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            if (await signInWithFacebook(context)) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (widget.onInit) {
                                //On enregistre dans les préférences le fait
                                //qu'on a déjà ouvert une premiere fois l'application

                                prefs.setBool('isFirstLaunch', false);
                              }

                              if (widget.onLaunch) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/HomePage');
                              } else {
                                widget.onSignedIn();
                                Navigator.pop(context);
                              }

                              widget.onSignedIn();
                            }
                          },
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 85,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[100],
                            onPrimary: Colors.white,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(30))),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage('assets/images/logo_google.png'),
                                height: 26,
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (await signInWithGoogle(context)) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (widget.onInit) {
                                //On enregistre dans les préférences le fait
                                //qu'on a déjà ouvert une premiere fois l'application

                                prefs.setBool('isFirstLaunch', false);
                              }

                              // print("on sort!");

                              if (widget.onLaunch) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/HomePage');
                              } else {
                                widget.onSignedIn();
                                Navigator.pop(context);
                              }

                              widget.onSignedIn();

                              // print("on pop!");
                            }
                          },
                        )),
                  ]),
                  SizedBox(
                    height: 40,
                  ),
                  Text(globals.dictionnary["Or"]!,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: globals.dictionnary["Email"],
                        ),
                        onChanged: (val) => {setState(() => email = val)},
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: globals.dictionnary["Password"],
                        ),
                        onChanged: (val) => {setState(() => password = val)},
                      )),
                  Container(
                      padding: EdgeInsets.only(right: 50),
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.white,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          globals.dictionnary["ForgetPassword"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange[700]),
                        ),
                        onPressed: () async {
                          pushNewScreen(
                            context,
                            screen: ForgetPasswordPage(
                                onSignedIn: widget.onSignedIn,
                                onInit: widget.onInit,
                                onLaunch: widget.onLaunch,
                                index: 0),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: 60,
                      // width: 270,
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,

                          // shape: RoundedRectangleBorder(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(20))),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                globals.dictionnary["Done"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          print('email: '+email);
                          if (email.length > 0 && password.length > 0) {
                            if (await signInWithEmail(
                                context, email, password)) {
                              if (widget.onInit) {
                                //On enregistre dans les préférences le fait
                                //qu'on a déjà ouvert une premiere fois l'application
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isFirstLaunch', false);
                              }
                              //On vérifie si la connexion se fait via le lancment de l'app ou bien depuis le menu profil

                              if (widget.onLaunch) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/HomePage');
                              } else {
                                widget.onSignedIn();
                                Navigator.pop(context);
                              }
                              widget.onSignedIn();
                            } else {
                              showAlertDialog(context,
                                  globals.dictionnary["ConnexionError"]!);
                            }
                          }
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      globals.dictionnary["ConnexionLibLogin1"]!,
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        globals.dictionnary["ConnexionLibLogin2"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                      onPressed: () async {
                        pushNewScreen(
                          context,
                          screen: AuthentificationRegisterPage(
                              onSignedIn: widget.onSignedIn,
                              onInit: widget.onInit,
                              onLaunch: widget.onLaunch),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ])
                ],
              )),
        ),
      ),
    );
  }
}

class AuthentificationRegisterPage extends StatefulWidget {
  AuthentificationRegisterPage(
      {required this.onSignedIn, required this.onInit, required this.onLaunch});

  final VoidCallback onSignedIn;
  final bool onInit;
  final bool onLaunch;

  _AuthentificationRegisterPage createState() =>
      _AuthentificationRegisterPage();
}

class _AuthentificationRegisterPage extends State<AuthentificationRegisterPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    setState(() {});
    utils = new UtilsState();
    utils!.initState();

    super.initState();
  }

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 50, left: 0, right: 0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(globals.dictionnary["Register"]!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(globals.dictionnary["RegisterContinue"]!,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (Platform.isIOS)
                      Container(
                          width: 85,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[100],
                              onPrimary: Colors.white,
                              onSurface: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(30))),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/images/logo_apple.png'),
                                  height: 26,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              if (await signInWithApple(context)) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (widget.onInit) {
                                  //On enregistre dans les préférences le fait
                                  //qu'on a déjà ouvert une premiere fois l'application

                                  prefs.setBool('isFirstLaunch', false);
                                }
                                // print("on sort!");

                                if (widget.onLaunch) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/HomePage');
                                } else {
                                  widget.onSignedIn();
                                  Navigator.pop(context);
                                }

                                widget.onSignedIn();

                                // print("on pop!");
                              }
                              // else {
                              //   showAlertDialog(context);
                              // }
                            },
                          )),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 85,
                        height: 55,
                        // margin: EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[100],
                            onPrimary: Colors.white,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(30))),
                          ),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue.shade900,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            if (await signInWithFacebook(context)) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (widget.onInit) {
                                //On enregistre dans les préférences le fait
                                //qu'on a déjà ouvert une premiere fois l'application

                                prefs.setBool('isFirstLaunch', false);
                              }

                              if (widget.onLaunch) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/HomePage');
                              } else {
                                widget.onSignedIn();
                                Navigator.pop(context);
                              }

                              widget.onSignedIn();

                              // print("on pop!");
                            }
                          },
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 85,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[100],
                            onPrimary: Colors.white,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(30))),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage('assets/images/logo_google.png'),
                                height: 26,
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (await signInWithGoogle(context)) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              if (widget.onInit) {
                                //On enregistre dans les préférences le fait
                                //qu'on a déjà ouvert une premiere fois l'application

                                prefs.setBool('isFirstLaunch', false);
                              }
                              print("on sort!");

                              if (widget.onLaunch) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/HomePage');
                              } else {
                                widget.onSignedIn();
                                Navigator.pop(context);
                              }

                              widget.onSignedIn();

                              print("on pop!");
                            }
                            // else {
                            //   showAlertDialog(context);
                            // }
                          },
                        )),
                  ]),
                  SizedBox(
                    height: 40,
                  ),
                  Text(globals.dictionnary["OrRegister"]!,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: globals.dictionnary["Email"],
                        ),
                        onChanged: (val) => {setState(() => email = val)},
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: globals.dictionnary["Password"],
                        ),
                        onChanged: (val) => {setState(() => password = val)},
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: 60,
                      // width: 270,
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,

                          // shape: RoundedRectangleBorder(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(20))),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                globals.dictionnary["Done"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          print('password: '+password);
                          if (password.length < 6) {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              closeIcon: Container(),
                              title: "",
                              desc:
                                  "Le mot de passe doit avoir au minimum 6 caractères",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Fermer",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Color.fromRGBO(0, 179, 134, 1.0),
                                ),
                              ],
                            ).show();
                          } else {
                            if (email.length > 0 && password.length > 0) {
                              //On vérifie le nom de domaine de l'adresse email
                              var domain =
                                  email.substring(email.lastIndexOf("@") + 1);

                              if (!blackList.blackListEmails
                                  .contains(domain.toLowerCase())) {
                                if (!await signInWithEmail(
                                    context, email, password)) {
//On est dans une création de compte email, on envoi un code OTP pour valider qu'il s'agit d'une bonne adresse email
                                  if (await sendOtp(context, email)) {
                                    nbEssai = 1;
                                    pushNewScreen(
                                      context,
                                      screen: OTPPage(
                                          onSignedIn: widget.onSignedIn,
                                          onInit: widget.onInit,
                                          onLaunch: widget.onLaunch,
                                          email: email,
                                          password: password,
                                          index: 0),

                                      withNavBar:
                                          false, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  } else {
                                    showAlertDialog(context,
                                        globals.dictionnary["EmailError"]!);
                                  }

                                  // if (await registerWithEmail(
                                  //     context, email, password)) {
                                  //   if (widget.onInit) {
                                  //     //On enregistre dans les préférences le fait
                                  //     //qu'on a déjà ouvert une premiere fois l'application
                                  //     SharedPreferences prefs =
                                  //         await SharedPreferences.getInstance();
                                  //     prefs.setBool('isFirstLaunch', false);
                                  //   }

                                  //   if (widget.onLaunch) {
                                  //     Navigator.of(context)
                                  //         .pushReplacementNamed('/HomePage');
                                  //   } else {
                                  //     widget.onSignedIn();
                                  //     Navigator.pop(context);
                                  //   }
                                  //   widget.onSignedIn();
                                  // } else {
                                  //   showAlertDialog(context,
                                  //       globals.dictionnary["ConnexionError"]);
                                  // }
                                } else {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/HomePage');
                                }
                              }
                            }
                          }
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      globals.dictionnary["ConnexionLibRegister1"]!,
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        globals.dictionnary["ConnexionLibRegister2"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                      onPressed: () async {
                        pushNewScreen(
                          context,
                          screen: AuthentificationPage(
                              onSignedIn: widget.onSignedIn,
                              onInit: widget.onInit,
                              onLaunch: widget.onLaunch,
                              index: 0),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ])
                ],
              )),
        ),
      ),
    );
  }
}

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage(
      {required this.onSignedIn,
      required this.onInit,
      required this.index,
      required this.onLaunch});

  final VoidCallback onSignedIn;
  final bool onInit;
  final int index;
  final bool onLaunch;

  _ForgetPasswordPage createState() => _ForgetPasswordPage();
}

class _ForgetPasswordPage extends State<ForgetPasswordPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    setState(() {});
    utils = new UtilsState();
    utils!.initState();

    super.initState();
  }

  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leadingWidth: 120,
        toolbarHeight: 50,
        centerTitle: true,
        title: Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            child: Text("Mot de passe",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18))),
        leading: Container(
            margin: EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 13),
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
                      style: TextStyle(fontSize: 14, color: Colors.orange[700]))
                ]))),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
                padding: EdgeInsets.only(top: 220, left: 0, right: 0),
                child: Column(
                  children: [
                    Text(globals.dictionnary["TitleForgetPassword"]!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(globals.dictionnary["LibForgetPassword"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: globals.dictionnary["Email"],
                          ),
                          onChanged: (val) => {
                            setState(() {
                              email = val;
                              _emailVerify = email;
                            })
                          },
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 60,
                        // width: 270,
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange[700],
                            onPrimary: Colors.black,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,

                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(20))),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  globals.dictionnary["Done"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            print('eamil: '+ email);
                            if (email.length > 0) {
                              // print(email);
                              if (await sendEmailResetPassword(email)) {
                                Navigator.pop(context);
                                showAlertDialog(context,
                                    "Veuillez consulter vos mails où un lien de réinitialisation vous a été envoyé.");
                              }
                              // if (await sendOtp(context, email)) {
                              //   nbEssai = 1;
                              //   pushNewScreen(
                              //     context,
                              //     screen: OTPPage(
                              //         onSignedIn: widget.onSignedIn,
                              //         onInit: widget.onInit,
                              //         onLaunch: widget.onLaunch,
                              //         index: 0),

                              //     withNavBar:
                              //         false, // OPTIONAL VALUE. True by default.
                              //     pageTransitionAnimation:
                              //         PageTransitionAnimation.cupertino,
                              //   );
                              // }
                              else {
                                // print("bbb");
                                showAlertDialog(context,
                                    globals.dictionnary["EmailError"]!);
                              }
                            } else {
                              // print("aaaa");
                              showAlertDialog(
                                  context, globals.dictionnary['EmailError']!);
                            }
                          },
                        )),
                  ],
                ))),
      ),
    );
  }
}

class OTPPage extends StatefulWidget {
  OTPPage(
      {required this.onSignedIn,
      required this.onInit,
      required this.index,
      required this.onLaunch,
      required this.email,
      required this.password});

  final VoidCallback onSignedIn;
  final bool onInit;
  final int index;
  final bool onLaunch;
  final String email;
  final String password;

  _OTPPage createState() => _OTPPage();
}

class _OTPPage extends State<OTPPage> with TickerProviderStateMixin {
  final TextEditingController _pinPutController = TextEditingController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.orange[700]!),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    setState(() {});
    utils = new UtilsState();
    utils!.initState();

    super.initState();
  }

  String pinField = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 120,
        leading: Container(
            margin: EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 13),
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
                      style: TextStyle(fontSize: 14, color: Colors.orange[700]))
                ]))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
                padding: EdgeInsets.only(top: 220, left: 0, right: 0),
                child: Column(
                  children: [
                    Text(globals.dictionnary["TitleOTP"]!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(globals.dictionnary["LibOTP"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: Pinput(
                        length: 6,
                        onCompleted: (String pin) => {pinField = pin,print("here:  "+pinField)},
                        controller: _pinPutController,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 60,
                        // width: 270,
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange[700],
                            onPrimary: Colors.white,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,

                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(20))),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  globals.dictionnary["Done"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            if (verifyOTP(pinField)) {
                              _pinPutController.text = '';
                              setState(() {});
                              print("passed");
                              if (await registerWithEmail(
                                  context, widget.email, widget.password)) {
                                if (widget.onInit) {
                                  //On enregistre dans les préférences le fait
                                  //qu'on a déjà ouvert une premiere fois l'application
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('isFirstLaunch', false);
                                }

                                if (widget.onLaunch) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/HomePage');
                                } else {
                                  widget.onSignedIn();
                                  Navigator.pop(context);
                                }
                                widget.onSignedIn();
                              } else {
                                showAlertDialog(context,
                                    globals.dictionnary["ConnexionError"]!);
                                nbEssai = 1;
                                Navigator.pop(context, true);
                              }
                              //ON envoie l'email de réinitialisation
                              // if (await sendEmailResetPassword(_emailVerify)) {
                              //   pushNewScreen(
                              //     context,
                              //     screen: AuthentificationPage(
                              //         onSignedIn: widget.onSignedIn,
                              //         onInit: widget.onInit,
                              //         onLaunch: widget.onLaunch,
                              //         index: 0),

                              //     withNavBar:
                              //         false, // OPTIONAL VALUE. True by default.
                              //     pageTransitionAnimation:
                              //         PageTransitionAnimation.cupertino,
                              //   );
                              //   showAlertDialog(context,
                              //       globals.dictionnary["PopupResetPassword"]);
                              // }
                            } else {
                              _pinPutController.text = '';
                              if (nbEssai > 3) {
                                nbEssai = 1;
                                Navigator.pop(context, true);
                              }
                              showAlertDialog(
                                  context, globals.dictionnary['OTPError']!);
                            }
                          },
                        )),
                  ],
                ))),
      ),
    );
  }
}
