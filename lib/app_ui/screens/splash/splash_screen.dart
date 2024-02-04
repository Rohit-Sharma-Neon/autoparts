// import 'dart:async';
// import 'package:autoparts/app_ui/screens/dashboard/dashboard_screen/dashboard.dart';
// import 'package:autoparts/app_ui/screens/tutorial/tutorial_screen.dart';
// import 'package:autoparts/constant/app_image.dart';
// import 'package:autoparts/constant/app_prefkeys.dart';
// import "package:flutter/material.dart";
// import "package:shared_preferences/shared_preferences.dart";
//
// class Splash extends StatefulWidget {
//   static const  routeName = "/";
//   const Splash({Key? key}) : super(key: key);
//
//   @override
//   _SplashState createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   SharedPreferences? prefs;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     startTime();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Container(
//         alignment: Alignment.center,
//         width: double.infinity,
//         height: double.infinity,
//        color: const Color(0xFF332222),
//         child: Image.asset(
//           AppImages.buyBeeLogo
//           // fit: BoxFit.contain,
//           // height: 150,
//           // width: 150,
//         ),
//       ),
//     );
//   }
//
//   startTime() async {
//     Timer(const Duration(seconds: 0), () async {
//       prefs = await SharedPreferences.getInstance();
//       bool? isLogin = prefs!.getBool(AppPrefKeys.IS_LOGGED_IN);
//       String? apiToken = prefs!.getString(AppPrefKeys.AUTHENTICATION);
//       print("apiToken:-$apiToken");
//       print("isLogin:- $isLogin");
//
//       if (isLogin != null && isLogin) {
//         print("login true");
//         Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.routeName,  (route) => false, arguments: 0);
//       } else {
//         print("login false");
//         Navigator.pushReplacementNamed(context, TutorialScreen.routeName);
//       }
//     });
//   }
// }
