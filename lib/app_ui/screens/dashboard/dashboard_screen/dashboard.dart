import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/become_dealer/become_seller_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/cars_screen/car_listing_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/favorites_screen/favorites_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/home_screen/home_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/message_box_screen/message_box_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/products_screen.dart';
import 'package:autoparts/app_ui/screens/notifications_screen/notifications_screen.dart';
import 'package:autoparts/app_ui/screens/privacy_screen/privacy_screen.dart';
import 'package:autoparts/app_ui/screens/privacy_screen/terms_conditions_screen.dart';
import 'package:autoparts/app_ui/screens/reminder/reminder_screen.dart';
import 'package:autoparts/app_ui/screens/select_category/dashboard_select_category.dart';
import 'package:autoparts/app_ui/screens/sell_car/search_car_screen.dart';
import 'package:autoparts/app_ui/screens/sell_product/sell_product_screen.dart';
import 'package:autoparts/app_ui/screens/user_profile/user_account_screen.dart';
import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_image.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/main.dart';
import 'package:autoparts/provider/dashboard_provider.dart';
import 'package:autoparts/provider/notofication_provider.dart';
import 'package:autoparts/utils/custom_navigation_bar.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import "package:easy_localization/easy_localization.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../my_depot/my_depot_screen.dart';
import '../../select_category/select_category.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/dashboard";
  final int? bottomIndex;

  const DashboardScreen({Key? key, this.bottomIndex}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int? _selectedIndex;
  bool isSeller = false;
  final PageController _pageController = PageController();
  PackageInfo? packageInfo;
  String? appVersion;
  bool? checkIsLogin;
  int? selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    sp!.putBool(SpUtil.IS_FIRST_TIME, true);
    _selectedIndex = widget.bottomIndex ?? 0;
    _initPackageInfo();
    checkIsLogin = sp?.getBool(SpUtil.IS_LOGGED_IN)??false;
    isSeller = sp?.getBool(SpUtil.IS_SELLER)??false;
    selectedCategoryIndex = sp?.getInt(SpUtil.CATEGORY_ID)??0;
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
      appVersion = packageInfo!.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      key: _key,
      // Assign the key to Scaffold.
      drawer: buildDrawer(),
      appBar: _buildAppBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children:  [
          const HomeScreen(),
          const FavoritesScreen(),
          const DashboardCategoryScreen(),
          selectedCategoryIndex == 1 ?
          const CarListingScreen(isFromBottomTab: true) :
          ProductsScreen(from: "dashboard",categoryName: "productsParts".tr(),isFeatured: "",),
          const MessageBoxScreen(from: "dashboard"),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildAppBar() {
    return CustomAppBar(
      height: 90,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      _key.currentState!.openDrawer();
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.menuIcon))),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  _selectedIndex != 0
                      ? Text(
                          _selectedIndex == 1
                              ? "favoritesNew"
                              : _selectedIndex == 2
                                  ? "selectCategory"
                                  : _selectedIndex == 3
                                      ? "productsParts"
                                      : "messageBox",
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_22, AppColors.blackColor),
                        ).tr()
                      : const SizedBox(
                          width: 35,
                        ),
                ],
              ),
              _selectedIndex == 0
                  ? Container(
                      height: 75,
                      width: 75,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.buyBeeLogo))),
                    )
                  : Container(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, MarkerMapScreen.routeName);
                      // Navigator.pushNamed(context, GoogleMapScreen.routeName);
                      checkIsLogin??false
                          ? Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserAccountScreen(isNewUser: false,)))
                          : pleaseLogin(context);
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.userIcon))),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      checkIsLogin!
                          ? Navigator.pushNamed(context, NotificationsScreen.routeName)
                          : pleaseLogin(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AppImages.bellIcon))),
                        ),
                        Consumer<NotificationProvider>(
                          builder: (BuildContext context, value, Widget? child) {
                            return (sp.getInt(SpUtil.NOTIFICATION_COUNT)??0) != 0 ?  Positioned(
                              bottom: 8,
                              left: 11,
                              child: Container(
                                // alignment: Alignment.center,
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: AppColors.btnBlackColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text((sp.getInt(SpUtil.NOTIFICATION_COUNT)??0).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                              ),
                            ):const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      height: 70.0,
      items: <Widget>[
        Image.asset(
          AppImages.homeIcon,
          height: 25,
          width: 25,
          color: AppColors.brownColor,
        ),
        Image.asset(
          AppImages.favoritesIcon,
          height: 25,
          width: 25,
          color: AppColors.brownColor,
        ),
        Image.asset(
          AppImages.addIcon,
          height: 25,
          width: 25,
          color: AppColors.brownColor,
        ),
        Image.asset(
          AppImages.searchIcon,
          height: 25,
          width: 25,
          color: AppColors.brownColor,
        ),
        Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topRight,
          children: [
            Image.asset(
              AppImages.chatIcon,
              height: 25,
              width: 25,
              color: AppColors.brownColor,
            ),
            Consumer<DashboardProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return (value.homeDataModel?.result?.messageCount??0) != 0 ?  Positioned(
                  bottom: 13,
                  left: 14,
                  child: Container(
                    // alignment: Alignment.center,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.btnBlackColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text((value.homeDataModel?.result?.messageCount??0).toString(),style: const TextStyle(fontSize: 12,color: Colors.white),),
                  ),
                ):const SizedBox();
              },
            ),
          ],
        ),
      ],
      color: AppColors.btnBlackColor,
      buttonBackgroundColor: AppColors.btnBlackColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) => _onTappedBar(index),
      letIndexChange: (index) => true,
    );
  }

  void _onTappedBar(int value) {
    print(value.toString());
    FocusScope.of(context).unfocus();
    if (value != 3) {
      checkIsLogin! ? _pageController.jumpToPage(value) : pleaseLogin(context);
      if(value == 0){
        Navigator.pop(context);
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
      }
    } else {
      if(value == 0){
        Navigator.pop(context);
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const CarsCategoryScreen()), (route) => false);
      }
      _pageController.jumpToPage(value);
    }
    setState(() {
      _selectedIndex = value;
    });

  }

  changeLanguage() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "selectLanguage".tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.boldStyle(
              AppFontSize.font_16, AppColors.blackColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.setLocale(const Locale("en", "US"));
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.locale.toString() == "en_US"
                      ? AppColors.selectedBgColor
                      : AppColors.whiteColor,
                ),
                child: Text("english".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_14, AppColors.blackColor)),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.setLocale(const Locale("ar", "DZ"));
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.locale.toString() != "en_US"
                      ? AppColors.selectedBgColor
                      : AppColors.whiteColor,
                ),
                child: Text("arabic".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_14, AppColors.blackColor)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: AppColors.brownColor,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: sp!.getString(SpUtil.USER_IMAGE) != null
                        ? Image.network(
                            baseImageUrl + sp!.getString(SpUtil.USER_IMAGE),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AppImages.user,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text("${sp!.getString(SpUtil.USER_NAME) ?? " "}",
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_20, AppColors.whiteColor)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // Navigator.pushNamedAndRemoveUntil(context,
                          //     DashboardScreen.routeName, (route) => false,
                          //     arguments: 0);
                        },
                        child: buildDrawerItemTile(
                            AppImages.drawerHomeIcon, "dHome".tr())),
                    const SizedBox(height: 25),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          checkIsLogin!
                              ? Navigator.pushNamed(
                                  context, UserAccountScreen.routeName)
                              : pleaseLogin(context);
                        },
                        child: buildDrawerItemTile(
                            AppImages.drawerUserIcon, "myAccount".tr())),
                    const SizedBox(height: 25),
                    sp!.getString(SpUtil.USER_TYPE).toString() == "Individual"
                        ? Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    checkIsLogin!
                                        ? Navigator.pushNamed(context,
                                            BecomeSellerScreen.routeName)
                                        : pleaseLogin(context);
                                  },
                                  child: buildDrawerItemTile(
                                      AppImages.drawerUserGroup,
                                      isSeller ? "manageSellerAccount".tr() : "becomeASeller".tr())),
                              const SizedBox(height: 25)
                            ],
                          )
                        : const SizedBox(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        checkIsLogin!
                            ? Navigator.pushNamed(
                                context, ReminderScreen.routeName)
                            : pleaseLogin(context);
                      },
                      child: buildDrawerItemTile(AppImages.drawerManageReminder,
                          "manageReminder".tr()),
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        checkIsLogin!
                            ? Navigator.pushNamed(
                                context, SellProductScreen.routeName)
                            : pleaseLogin(context);
                      },
                      child: buildDrawerItemTile(
                          AppImages.drawerCarSteering, "sellAProduct".tr()),
                    ),
                    const SizedBox(height: 25),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (checkIsLogin!) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyDepotScreen(categoryName: "myDepot".tr(),)));
                          }else{
                            pleaseLogin(context);
                          }
                        },
                        child: buildDrawerItemTile(
                            AppImages.drawerOwnCars, "myDepot".tr())),
                    const SizedBox(height: 25),
                    GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          // Navigator.pushNamed(context, SearchCarScreen.routeName);
                          changeLanguage();
                        },
                        child: buildDrawerItemTile(
                            AppImages.changeLanguage, "changeLanguageString".tr())),
                    const SizedBox(height: 25),
                    (checkIsLogin??false) ?
                    GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          // Navigator.pushNamed(context, SearchCarScreen.routeName);
                          doLogOut(context);
                        },
                        child: buildDrawerItemTile(
                            AppImages.logOutIcon, "logOut".tr())) : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 55,
            color: AppColors.bgColor,
            alignment: Alignment.center,
            child: Text("version".tr() + " ${appVersion ?? ""}",
                style: AppTextStyles.regularStyle(
                    AppFontSize.font_16, AppColors.submitGradiantColor1)),
          ),
          Container(
            height: 55,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticPage(headingName: "privacyPolicy".tr(),type: "privacy-policy",)));
                    },
                    child: Text("privacyPolicy".tr(),
                        style: AppTextStyles.regularStyle(AppFontSize.font_16,
                            AppColors.submitGradiantColor1))),
                Container(
                  height: 20,
                  width: 2,
                  color: AppColors.borderColor,
                  alignment: Alignment.center,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> StaticPage(headingName: "termsConditions".tr(),type: "terms-of-use",)));
                    },
                    child: Text("termsConditions".tr(),
                        style: AppTextStyles.regularStyle(AppFontSize.font_16,
                            AppColors.submitGradiantColor1))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildDrawerItemTile(icon, text) {
    return Row(
      children: [
        Image.asset(
          icon,
          height: 30,
          width: 30,
        ),
        const SizedBox(width: 20),
        Text(text,
            style: AppTextStyles.regularStyle(
                AppFontSize.font_20, AppColors.submitGradiantColor1)),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const CustomAppBar({
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: AppColors.whiteColor,
      alignment: Alignment.center,
      child: child,
    );
  }
}
/*  _buildBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _bottomBarItem(AppImages.homeIcon, "home".tr()),
        _bottomBarItem(AppImages.dealersIcon, "dealers".tr()),
        _bottomBarItem(AppImages.partsIcon, "parts".tr()),
        _bottomBarItem(AppImages.favoritesIcon, "favorites".tr()),
        _bottomBarItem(AppImages.carsIcon, "cars".tr()),
      ],
      onTap: _onTappedBar,
      iconSize: 30,
      selectedIconTheme: const IconThemeData(color: AppColors.whiteColor),
      selectedLabelStyle:
          AppTextStyles.mediumStyle(AppFontSize.font_14, AppColors.whiteColor),
      unselectedLabelStyle: AppTextStyles.mediumStyle(
          AppFontSize.font_14, AppColors.unselectedItemColor),
      backgroundColor: AppColors.blackBottomColor,
      unselectedItemColor: AppColors.unselectedItemColor,
      selectedItemColor: AppColors.whiteColor,
      currentIndex: _selectedIndex!,
    );
  }*/
