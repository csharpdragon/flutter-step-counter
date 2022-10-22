import 'dart:async';

import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:purchases_flutter/object_wrappers.dart';
// import 'package:device_info/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

bool isFirstLaunch = false;
bool isIos = false;
bool isIpad = false;

Position? position;

PersistentTabController? controller;
PurchaserInfo? purchaserInfo;
bool hideNavBar = false;

bool showTutorial = true;
bool showTutorialGift = true;
bool showTutorialMap = true;
bool showTutorialDeal = true;
bool tutoMap = false;
List<TargetFocus> targets = [];
List<TargetFocus> targetsGift = [];
List<TargetFocus> targetsMap = [];
List<TargetFocus> targetsDeal = [];

TutorialCoachMark? tutorialCoachMark;

//Activite
GlobalKey keyButton = GlobalKey();
GlobalKey keyButton1 = GlobalKey();
GlobalKey keyButton2 = GlobalKey();
GlobalKey keyButton3 = GlobalKey();
GlobalKey keyButton4 = GlobalKey();
GlobalKey keyButton5 = GlobalKey();
GlobalKey keyButton6 = GlobalKey();

GlobalKey keyBottomNavigation1 = GlobalKey();
GlobalKey keyBottomNavigation2 = GlobalKey();
GlobalKey keyBottomNavigation3 = GlobalKey();
GlobalKey keyBottomNavigation4 = GlobalKey();

//Recompense
GlobalKey keyButtonGift = GlobalKey();
GlobalKey keyButtonGift1 = GlobalKey();
GlobalKey keyButtonGift2 = GlobalKey();
GlobalKey keyButtonGift4 = GlobalKey();

//Cashback
GlobalKey keyButtonDeal = GlobalKey();
GlobalKey keyButtonDeal1 = GlobalKey();
GlobalKey keyButtonDeal2 = GlobalKey();
GlobalKey keyButtonDeal4 = GlobalKey();

//Map
GlobalKey keyButtonMap = GlobalKey();
GlobalKey keyButtonMap1 = GlobalKey();
GlobalKey keyButtonMap2 = GlobalKey();
GlobalKey keyButtonMap4 = GlobalKey();

bool keyDeal = false;

LatLng? center;
double zoom = 15.0;

AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;

bool endTimer = false;
bool endTimerAds = false;

int endTime = 0;

String email = "";
String tel = "";
String adress = "";
String uidParrainage = "";
String name = "";
String pseudo = "";
String parrain = "";
String codeParrain = "";
int todayAds = 0;
Map todayFeet = {};
String dateNaissance = "";
int poids = 0;
int taille = 0;
String sexe = "";
int age = 0;

User? user;

int lastFeet = 0;
int dayFeetValidate = 0;
int lastDayFeetValidate = 0;

int dayWin = 0;
int lastDayWin = 0;

bool initPedometer = true;

bool setTimer = false;

int profitUser = 0;

String lastDay = "0";
String day = "";

String currency = "";

int currentIndex = 0;
int bottomNavIndex = 0;

bool pubOK = false;
bool parrainOK = false;

bool isInstalledGoogleFit = false;

List<Level>? levels;

String chipsValue = "";
String chipsValueGift = "";

bool messageCagou = false;

int savedStepsCount = 0;
int todaySteps = 0;
bool ads = true;

Database? db;

bool validateParrain = false;

List historical = [];

int nbOffers = 0;
int nbCashback = 0;

List<Category> categoriesCashback = [];
List<Category> categoriesGifts = [];
List<Category> categoriesSaveGifts = [];

List<Category> categoriesWinGifts = [];
List<Category> categoriesTransfers = [];
List<Category> categoriesSaveWinGifts = [];
List<Category> categoriesSaveTransfers = [];
List<Category> categoriesSaveMap = [];
List<Category> categoriesOffers = [];
List<Category> categoriesSaveOffers = [];
List<Category> categoriesSave = [];
List<Category> categoriesDealMap = [];
Menu? selectedMenuGifts;
Menu? selectedMenuWinGifts;
Menu? selectedMenuTransfers;
Menu? selectedMenuOffers;
Menu? selectedMenuCashback;
List<Menu>? menusGifts;
List<Menu>? menusWinGifts;
List<Menu>? menusTransfers;
List<Menu>? menusOffers;

bool isValidate = false;
bool isValidatePub = true;

//Gestion des paliers
bool palier1000 = false;
bool palier2000 = false;
bool palier3000 = false;
bool palier4000 = false;
bool palier5000 = false;
bool palier6000 = false;
bool palier7000 = false;
bool palier8000 = false;
bool palier9000 = false;
bool palier10000 = false;
bool palier11000 = false;
bool palier12000 = false;
bool palier13000 = false;
bool palier14000 = false;
bool palier15000 = false;
bool palier16000 = false;
bool palier17000 = false;
bool palier18000 = false;
bool palier19000 = false;
bool palier20000 = false;

List<dynamic> smsGames = [];

List<_HealthData> data = [
  new _HealthData('0 H', 0),
  new _HealthData('1 H', 0),
  new _HealthData('2 H', 0),
  new _HealthData('3 H', 0),
  new _HealthData('4 H', 0),
  new _HealthData('5 H', 0),
  new _HealthData('6 H', 0),
  new _HealthData('7 H', 0),
  new _HealthData('8 H', 0),
  new _HealthData('9 H', 0),
  new _HealthData('10 H', 0),
  new _HealthData('11 H', 0),
  new _HealthData('12 H', 0),
  new _HealthData('13 H', 0),
  new _HealthData('14 H', 0),
  new _HealthData('15 H', 0),
  new _HealthData('16 H', 0),
  new _HealthData('17 H', 0),
  new _HealthData('18 H', 0),
  new _HealthData('19 H', 0),
  new _HealthData('20 H', 0),
  new _HealthData('21 H', 0),
  new _HealthData('22 H', 0),
  new _HealthData('23 H', 0),
];

class _HealthData {
  _HealthData(this.hour, this.steps);

  final String hour;
  final double steps;
}

String chipCashback = "Cashback";
String chipOffer = "Offres";

List<C2Choice<String>> choiceItemsMenuGifts = [];
List<C2Choice<String>> choiceItemsMenuOffers = [];
List<C2Choice<ChipMap>>? choiceItemsMap;
List<dynamic> pointsOfInterest = [];
List<dynamic> validatePointsOfInterest = [];
List<dynamic> merchandsMapItems = [];
Set<Circle> circles = {};
Set<Marker> markers = {};

Stream<StepCount>? stepCountStream;
Stream<PedestrianStatus>? pedestrianStatusStream;
StreamSubscription<StepCount>? streamSubscription;

class ChipMap {
  final String id;
  final String name;
  final String type;

  ChipMap(this.id, this.name, this.type);
}

bool init = false;

class Level {
  final int level;
  final int profit;
  bool isChecked;

  Level(this.level, this.profit, this.isChecked);
}

bool autorisationPodometer = false;

// Map<String, String> dictionnary = frenchDictionnary;

Map<String, String> dictionnary = englishDictionnary;

Map<String, String> englishDictionnary = {
  "ActivityMenu": "Activity",
  "GiftMenu": "Gifts",
  "MapMenu": "Map",
  "GoodsMenu": "Goods",
  "SettingMenu": "Settings",
  "WaitingLib": "Please wait...",
  "TodayLib": "Today",
  "ContainsLib": "Contains ",
  "LightroomLib": "x Lightroom presets",
  "LongPressLib": "Long press on the photo to see it without filter",
  "DownloadPreset": "GET THIS PRESET",
  "SeeAll": "View all",
  "SeeAllPresets": "View all presets",
  "Premium": "PREMIUM",
  "Free": "FREE",
  "MyFavorites": "My favorites",
  "All": "All",
  "PresetLib": "Lightroom preset",
  "Instagram": "Follow us on Instagram",
  "ChangeLanguage": "Change language",
  "LegalNotice": "Legal notice",
  "TermsOfService": "Terms of service",
  "Support": "Contact us",
  "FAQ": "FAQ",
  "RestorePurchases": "Restore purchases",
  "SignOut": "Sign out",
  "SignIn": "Sign in",
  "French": "French",
  "English": "English",
  "Italian": "Italian",
  "Filter": "Filters",
  "TodayAppBar": "Featured",
  "dateDayFormat": "MMMM",
  //Les jours de la semaine en minuscle
  "monday": "Monday",
  "lundi": "Monday",
  "tuesday": "Tuesday",
  "mardi": "Tuesday",
  "wednesday": "Wednesday",
  "mercredi": "Wednesday",
  "thursday": "Thursday",
  "jeudi": "Thursday",
  "friday": "Friday",
  "vendredi": "Friday",
  "saturday": "Saturday",
  "samedi": "Saturday",
  "sunday": "Sunday",
  "dimanche": "Sunday",
  //Les mois de l'année en minuscle
  "january": "January",
  "janvier": "January",
  "février": "February",
  "february": "February",
  "mars": "March",
  "march": "March",
  "avril": "April",
  "april": "April",
  "may": "May",
  "mai": "May",
  "juin": "June",
  "june": "June",
  "juillet": "July",
  "july": "July",
  "août": "August",
  "august": "August",
  "september": "September",
  "septembre": "Septembre",
  "october": "October",
  "octobre": "October",
  "november": "November",
  "novembre": "November",
  "december": "December",
  "décembre": "December",
  "Login": "Login",
  "LoginContinue": "Log in to continue",
  "Register": "Register",
  "RegisterContinue": "Register to continue",
  "Password": "Password",
  "ConfirmPassword": "Confirm password",
  "Email": "Email",
  "GoogleSignIn": "Sign in with Google",
  "AppleSignIn": "Sign in with Apple",
  "FacebookSignIn": "Sign in with Facebook",
  "EmailSignIn": "Sign in with your email",
  "GoogleRegister": "Register with Google",
  "AppleRegister": "Register with Apple",
  "FacebookRegister": "Register with Facebook",
  "EmailRegister": "Register with your email",
  "Or": "Or login with email",
  "OrRegister": "Or register with email",
  "ConnexionLibLogin1": "Don't have an account ?",
  "ConnexionLibLogin2": "Register now",
  "ConnexionLibRegister1": "Already have an account ?",
  "ConnexionLibRegister2": "Login",
  "ForgetPassword": "Forgot password ?",
  "TitleForgetPassword": "Forgot password",
  "LibForgetPassword":
      "Enter your email for the verification process, we will send 6 digit code to your email.",
  "TitleOTP": "Enter 6 digits code",
  "LibOTP": "Enter the 6 digits code that you received on your email.",
  "Signin": "Sign in",
  "Slide1_L1": "Discover more than",
  "Slide1_L2": "1000 Lightroom presets",
  "Slide2_L1": "Quickly apply",
  "Slide2_L2": "any preset",
  "Slide3_L1": "Take your pictures",
  "Slide3_L2": "to the next level",
  "Before": "Before",
  "After": "After",
  "Done": "Done",
  "Next": "Next",
  "Skip": "Skip",
  "Subscription_L1": "Get access to more than",
  "Subscription_L2": "1,000 Lightroom presets",
  "Subscription_L3": "Unlimited access. New presets every day",
  "Subscription_L4": "Hurry! Your offer expires in :",
  "Subscription_monthlyPriceIndication": " / month",
  "Subscription_annuallyPriceIndication": " / year",
  "CancelSubscription": "Cancel anytime",
  "Restore": "Restore",
  "Continue": "Continue",
  "Download": "Preset being downloaded",
  "DownloadOK": "Your preset has been downloaded successfully!",
  "DownloadNOK": "There was an error while downloading the file.",
  "NotificationDownloadNOK": "Failure",
  "NotificationDownloadOK": "Success",
  "ConnexionError": "Email adress and/or password wrong",
  "EmailError": "Email adress wrong",
  "Close": "Close",
  "NoInternetConnection": "You are disconnected to the Internet",
  "VerifiyInternetConnection": "Please check your internet connection",
  "NoFavorites": "No favorites",
  "Slider1":
      "Get access to over 100 different preset packs. With this massive collection, you can apply a large variety of effects to your photos.",
  "Slider2":
      "Apply professional edits in one click with our Lightroom presets, and save hours of image treatment.",
  "Slider3":
      "Make yourself stand out on social media today! All you need is your mobile phone and a pack of presets!",
  "SubjectResetPassword": "Resetting your Filter Studio password",
  "MailResetPassword": "Enter the following code to reset your password : ",
  "Back": "Back",
  "PasswordError": "Password wrong",
  "OTPError": "Verification code wrong",
  "PopupResetPassword":
      "Please check your emails where a reset link has been sent to you.",
  "PurchaseError": "Subscription unavailable in your country",
  "OrPrice": "Or ",
  "Yearly": "Yearly access",
  "Monthly": "Monthly access",
  "Sale": "Get 50% OFF now",
  "Hour": "Hours",
  "Minute": "Minutes",
  "Second": "Seconds"
};

Map<String, String> frenchDictionnary = {
  "ActivityMenu": "Activité",
  "GiftMenu": "Cadeaux",
  "MapMenu": "Carte",
  "GoodsMenu": "Bons plans",
  "SettingMenu": "Paramètres",
  "WaitingLib": "Patientez s'il vous plait...",
  "TodayLib": "Aujourd'hui",
  "DateFormat": "",
  "ContainsLib": "Contient ",
  "LightroomLib": "x presets Lightroom",
  "LongPressLib": "Appuyez longuement sur la photo pour la voir sans le filtre",
  "DownloadPreset": "OBTENIR CE PRESET",
  "SeeAll": "Voir tout",
  "SeeAllPresets": "Voir tous les presets",
  "Premium": "PREMIUM",
  "Free": "GRATUIT",
  "MyFavorites": "Mes favoris",
  "All": "Tout",
  "PresetLib": "Preset Lightroom",
  "Instagram": "Nous suivre sur Instagram",
  "ChangeLanguage": "Changer la langue",
  "LegalNotice": "Mentions légales",
  "TermsOfService": "Conditions d'utilisation",
  "Support": "Contactez-nous",
  "FAQ": "FAQ",
  "RestorePurchases": "Restaurer les achats",
  "SignOut": "Se déconnecter",
  "SignIn": "Se connecter",
  "French": "Français",
  "English": "Anglais",
  "Italian": "Italien",
  "Filter": "Filtres",
  "TodayAppBar": "En ce moment",
  "dateDayFormat": "MMMM",
  //Les jours de la semaine en minuscle
  "monday": "Lundi",
  "lundi": "Lundi",
  "tuesday": "Mardi",
  "mardi": "Mardi",
  "wednesday": "Mercredi",
  "mercredi": "Mercredi",
  "thursday": "Jeudi",
  "jeudi": "Jeudi",
  "friday": "Vendredi",
  "vendredi": "Vendredi",
  "saturday": "Samedi",
  "samedi": "Samedi",
  "sunday": "Dimanche",
  "dimanche": "Dimanche",
  //Les mois de l'année en minuscle
  "january": "Janvier",
  "janvier": "Janvier",
  "février": "Février",
  "february": "Février",
  "mars": "Mars",
  "march": "Mars",
  "avril": "Avril",
  "april": "Avril",
  "may": "Mai",
  "mai": "Mai",
  "juin": "Juin",
  "june": "Juin",
  "juillet": "Juillet",
  "july": "Juillet",
  "août": "Août",
  "august": "Août",
  "september": "Septembre",
  "septembre": "Septembre",
  "october": "Octobre",
  "octobre": "Octobre",
  "november": "Novembre",
  "novembre": "Novembre",
  "december": "Décembre",
  "décembre": "Décembre",
  "Login": "Connexion",
  "LoginContinue": "Connectez-vous pour continuer",
  "Register": "Inscription",
  "RegisterContinue": "Inscrivez-vous pour continuer",
  "Password": "Mot de passe",
  "ConfirmPassword": "Confirmation mot de passe",
  "Email": "Adresse email",
  "GoogleSignIn": "Continuer avec Google",
  "AppleSignIn": "Continuer avec Apple",
  "FacebookSignIn": "Continuer avec Facebook",
  "EmailSignIn": "Continuer",
  "GoogleRegister": "S'inscrire avec Google",
  "AppleRegister": "S'inscrire avec Apple",
  "FacebookRegister": "S'inscrire avec Facebook",
  "EmailRegister": "S'inscrire avec votre email",
  "Or": "Ou se connecter avec votre email",
  "OrRegister": "Ou s'inscrire avec votre email",
  "ConnexionLibLogin1": "Vous n'avez pas de compte ?",
  "ConnexionLibLogin2": "Inscrivez-vous",
  "ConnexionLibRegister1": "Déjà un compte ?",
  "ConnexionLibRegister2": "Connectez-vous",
  "ForgetPassword": "Mot de passe oublié ?",
  "TitleForgetPassword": "Mot de passe oublié",
  "LibForgetPassword":
      "Entrez votre email pour la procédure de réinitialisation de mot de passe, nous vous enverrons un lien de réinitialisation par email.",
  "TitleOTP": "Entrez le code à 6 chiffres",
  "LibOTP": "Entrez le code à 6 chiffre que vous avez reçu sur votre email.",
  "Signin": "Connexion",
  "Slide1_L1": "Rentabilisez chaque pas que vous faites. ",
  "Slide1_L2": "Accumulez des Kayous (Ꝃ) au quotidien à chaque pas effectué!",
  "Slide2_L1": "Dépensez-vous pour dépenser moins.",
  "Slide2_L2":
      "Echangez vos Kayous (Ꝃ) contre des bons d'achat, des cadeaux ou de l’argent.",
  "Slide3_L1": "Redécouvrez votre ville.",
  "Slide3_L2":
      "Profitez de vos balades pour visiter les partenaires et points d’intérêts près de chez vous, et accumulez plus rapidement des Kayous (Ꝃ).",
  "Before": "Avant",
  "After": "Après",
  "Done": "Continuer",
  "Next": "Suivant",
  "Skip": "Passer",
  "Subscription_L1": "Envie de débloquer plus de ",
  "Subscription_L2": "1.000 presets ?",
  "Subscription_L3": "Devenez premium dès aujourd'hui",
  "Subscription_L4": "Vite! Ton offre expire dans :",
  "Subscription_monthlyPriceIndication": " / mois",
  "Subscription_annuallyPriceIndication": " / année",
  "CancelSubscription": "Résiliez à tout moment.",
  "Restore": "Restaurer",
  "Continue": "Continuer",
  "Download": "Preset en cours de téléchargement",
  "DownloadOK": "Votre preset a été téléchargé avec succès!",
  "DownloadNOK": "Une erreur est survenue lors du téléchargement.",
  "NotificationDownloadNOK": "Echec",
  "NotificationDownloadOK": "Succès",
  "ConnexionError": "Adresse email et/ou mot de passe incorrect",
  "EmailError": "Adresse email incorrect",
  "Close": "Fermer",
  "NoInternetConnection": "Vous n'êtes pas connecté à Internet",
  "VerifiyInternetConnection":
      "Vérifiez votre connexion internet s'il vous plait",
  "NoFavorites": "Aucun favoris",
  "Slider1":
      "Accédez à plus de 100 packs différents. Grâce à cette collection massive, vous pourrez appliquer une grande variété d'effets à vos photos.",
  "Slider2":
      "Appliquez des retouches professionnelles en un clic grâce à nos presets Lightroom, et économisez des heures de traitement.",
  "Slider3":
      "Démarquez-vous sur les réseaux dès aujourd'hui ! Tout ce dont vous avez besoin, c'est de votre téléphone portable et d'un pack de presets !",
  "MailResetPassword":
      "Entrez le code suivant pour réinitialiser votre mot de passe : ",
  "SubjectResetPassword": "Réinitialisation de votre mot de passe Kayou NC",
  "Back": "Retour",
  "PasswordError": "Mot de passe incorrect",
  "OTPError": "Code de vérification incorrect",
  "PopupResetPassword":
      "Veuillez consulter vos mails où un lien de réinitialisation vous a été envoyé.",
  "PurchaseError": "Abonnement indisponible dans votre région",
  "OrPrice": "Soit ",
  "Yearly": "Abonnement annuel",
  "Monthly": "Abonnement mensuel",
  "Sale": "Economisez 50% maintenant",
  "Hour": "Heures",
  "Minute": "Minutes",
  "Second": "Secondes"
};

class GiftCategory {
  final String merchand;
  final String merchandId;
  final String logoMerchand;
  final String gift;
  final num price;
  final String image;

  GiftCategory(this.merchand, this.merchandId, this.logoMerchand, this.gift,
      this.price, this.image);
}

class Menu {
  final String name;
  final String type;
  List<Category> categories;

  Menu(this.name, this.type, this.categories);
}

class Category {
  String id;
  String name;
  String type;
  int nbItems;
  List<dynamic> lists;
  List<dynamic> listsAll;
  String idCategory;

  Category(this.id, this.name, this.type, this.nbItems, this.lists,
      this.listsAll, this.idCategory);
}
