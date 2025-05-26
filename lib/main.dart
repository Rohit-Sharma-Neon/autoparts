// @dart=2.9
import 'dart:io';

import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import 'package:autoparts/app_ui/screens/tutorial/tutorial_screen.dart';
import 'package:autoparts/constant/app_strings.dart';
import "package:autoparts/constant/app_theme.dart";
import "package:autoparts/provider/auth_provider.dart";
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/common_provider.dart';
import "package:autoparts/provider/dashboard_provider.dart";
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/favourite_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/provider/location_provider.dart';
import 'package:autoparts/provider/notofication_provider.dart';
import 'package:autoparts/provider/products_provider.dart';
import 'package:autoparts/provider/sellers_provider.dart';
import "package:autoparts/provider/user_provider.dart";
import "package:autoparts/routes/custom_router.dart";
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:easy_localization/easy_localization.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:provider/provider.dart";
import "package:responsive_framework/responsive_framework.dart";

import 'app_ui/screens/auth/signup_screen/signup_select_type.dart';
import 'app_ui/screens/select_category/select_category.dart';
SpUtil sp;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
FirebaseFirestore firebaseFirestore;
AndroidNotificationChannel channel;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  firebaseFirestore = FirebaseFirestore.instance;
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel = const AndroidNotificationChannel(
    'default_notification_channel_id', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  sp = await SpUtil.getInstance();
  Provider.debugCheckInvalidValueType = null;
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ChangeNotifierProvider<CommonProvider>(create: (_) => CommonProvider()),
      ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider()),
      ChangeNotifierProvider<DealersProvider>(create: (_) => DealersProvider()),
      ChangeNotifierProvider<FavouriteProvider>(create: (_) => FavouriteProvider()),
      ChangeNotifierProvider<SellersProvider>(create: (_) => SellersProvider()),
      ChangeNotifierProvider<CarProvider>(create: (_) => CarProvider()),
      ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
      ChangeNotifierProvider<ProductsProvider>(create: (_) => ProductsProvider()),
    ],
    child: EasyLocalization(
      supportedLocales: const [
        Locale("en", "US"),
        Locale("ar", "DZ"),
      ],
      path: "assets/appLanguage",
      fallbackLocale: const Locale("en", "US"),
      child:  const MyApp(),
    ),
  ));
}
class MyApp extends StatefulWidget {

   const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // generateFcmToken();
    setupFirebase();
    super.initState();
  }

  setupFirebase() async {
    await FirebaseMessaging.instance.getToken().then((String token) {
      assert(token != null);
      print("Token from main class ---> "+token.toString());
      sp.putString(SpUtil.FCM_TOKEN, token.toString());
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      var type = message.data['type'];
      if (type.toString() == "5") {
        print("onMessage Data  ====>  " + message.data.toString());
        showImageNotification(message.data);
      } else {
        showLocalNotification(notification.title, notification.body, notification.hashCode);
      }
      // print("onMessage Type  ====>  " +
      //     message.data['type'].runtimeType.toString());
      // print("onMessage Campaign Id  ====>  " + message.data['campaign_id']);
      // print("onMessage Campaign Id  ====>  " +
      //     message.data['campaign_id'].runtimeType.toString());
      // mainNotificationProvider.readIncrement();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print("onMessage Data  ====>  " + message.data.toString().toString());

      var type = message.data['type'];
      if (type.toString() == "5") {
        showImageNotification(message.data);
      } else {
        showLocalNotification(notification.title, notification.body, notification.hashCode);
      }

      // mainNotificationProvider.readIncrement();
    });
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        RemoteNotification notification = message.notification;
        print("onMessage Data  ====>  " + message.data.toString().toString());

        var type = message.data['type'];
        if (type.toString() == "5") {
          showImageNotification(message.data);
        } else {
          showLocalNotification(
              notification.title, notification.body, notification.hashCode);
        }

        // mainNotificationProvider.readIncrement();
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  showImageNotification(data) async {
    print("onMessage Data  ====>  " + data['image'].toString().toString());
    print("onMessage Data  ====>  " + data['body'].toString().toString());
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: data['title'].toString(),
          body: data['body'].toString(),
          bigPicture: data['image'].toString(),
          notificationLayout: NotificationLayout.BigPicture),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget screen;

    context.read<DashboardProvider>().initDashboard();
    context.read<FavouriteProvider>().initDashboard();
    context.read<DealersProvider>().initDealers();
    context.read<SellersProvider>().initSellers();
    context.read<UserProvider>().initUserProvider();
    context.read<CarProvider>().initCarProvider();
    context.read<ProductsProvider>().initProductsProvider();
    context.read<NotificationProvider>().initNotificationsProvider();
    //checkIsLogin = sp.getBool(SpUtil.IS_FIRST_TIME) ?? false;
    bool checkIsLogin = sp.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    bool isAddressGet = sp.getBool(SpUtil.IS_ADDRESS_GET) ?? false;
    bool isUserTypeSelected = sp.getBool(SpUtil.IS_USERTYPE_SELECTED) ?? false;
    print("Check IS_FIRST_TIME ==>> ${sp.getBool(SpUtil.IS_FIRST_TIME)}");
    print("Check IS_LOGGED_IN ==>> ${sp.getBool(SpUtil.IS_LOGGED_IN)}");
    print("Check USER_ID ==>> ${sp.getString(SpUtil.USER_ID)}");
    print("Check ACCESS_TOKEN ==>> ${sp.getString(SpUtil.ACCESS_TOKEN)}");

    if(checkIsLogin){
      if (isUserTypeSelected) {
        if(isAddressGet){
          screen = const CarsCategoryScreen();
        }else{
          screen = const LocationScreen();
        }
      }else{
        if(isAddressGet){
          screen = const SignupSelectType();
        }else{
          screen = const LocationScreen();
        }
      }
    }else{
      const TutorialScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 900,
          minWidth: 400,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(400, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      title: AppStrings.appTitle,
      navigatorKey: NavigationService.navigatorKey,
      theme: AppTheme.lightTheme,
      onGenerateRoute: CustomRouter.generateRoute,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      home: checkIsLogin ? isAddressGet ? const CarsCategoryScreen() : const LocationScreen() : const TutorialScreen(),
      initialRoute: TutorialScreen.routeName,
    );
  }
  showLocalNotification(title, message, id) async {
    flutterLocalNotificationsPlugin.show(
      hashCode,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelShowBadge: true,
          //largeIcon: FilePathAndroidBitmap(largeIconPath),
          icon: 'launch_background',
        ),
      ),
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    RemoteNotification notification = message.notification;
    var type = message.data['type'];
    if (type.toString() == "5") {
      showImageNotification(message.data);
    } else {
      showLocalNotification(
          notification.title, notification.body, notification.hashCode);
    }
    // print("onMessage Type  ====>  " +
    //     message.data['type'].runtimeType.toString());
    // print("onMessage Campaign Id  ====>  " + message.data['campaign_id']);
    // print("onMessage Campaign Id  ====>  " +
    //     message.data['campaign_id'].runtimeType.toString());
    // mainNotificationProvider.readIncrement();
    print("MessagingBackgroundHandler  ====>  " + message.data.toString());
    print("type MessagingBackgroundHandler ====>  " +
        message.data['type'].toString());
  }
}
/*
Variant: debug
Config: debug
Store: /home/admin1/.android/debug.keystore
Alias: AndroidDebugKey
MD5: 
SHA1:
SHA-256: 
*/
/// has key genrate url ===>  
// hash key =====  
