import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/auth/change_password/change_password_screen.dart';
import 'package:autoparts/app_ui/screens/business_profile/update_business_profile.dart';
import 'package:autoparts/app_ui/screens/user_profile/update_profile.dart';
import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_image.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/models/country_list_model.dart';
import 'package:autoparts/models/interest_list_model.dart';
import 'package:autoparts/models/user_profile_model.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../../main.dart';
import '../../../utils/shared_preferences.dart';

class UserAccountScreen extends StatefulWidget {
  static const routeName = "/user-account";
  final bool isNewUser;

  const UserAccountScreen({Key? key, this.isNewUser = false}) : super(key: key);

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  String? nationality;
  String? networkImage;
  String interestItem = "";
  String? userName, userEmail, userGender, userType, userMobile, countryCode, dob;
  UserProfileData? userProfileData;
  static List<CountryList>? nationalityList = [];
  static List<InterestRecords>? interestRecordsList = [];
  List<String>? interestList = [];

  @override
  void initState() {
    Future.microtask(() async {
      await context.read<UserProvider>().getUserProfileApi();
      userProfileData = context.read<UserProvider>().userProfileModel!.result;
      if ((userProfileData?.userType??"") == "Individual") {
        context.read<UserProvider>().getInterestListApi();
        interestRecordsList = context.read<UserProvider>().interestListModel!.result!.records;
        context.read<UserProvider>().getCountryListApi();
        nationalityList = context.read<UserProvider>().countryListModel!.result;
      }
      setData();
    });
    super.initState();
  }

  setData() {
    userName = userProfileData!.name!;
    userEmail = userProfileData!.email!;
    userMobile = userProfileData!.mobile!;
    if (userProfileData!.userType! == "Business") {
      networkImage = baseImageUrl + (userProfileData?.businessLogo??"");
    }else{
      networkImage = baseImageUrl + userProfileData!.image!;
    }
    countryCode = userProfileData!.countryCode!;
    userGender = userProfileData!.gender!;
    userType = userProfileData!.userType!;
    sp!.putString(SpUtil.USER_TYPE,userType.toString());
    interestList = userProfileData!.interest != null
        ? userProfileData!.interest!.split(RegExp(r','))
        : [];
    dob = userProfileData!.dob != null ? userProfileData!.dob! : "";
    if (userProfileData!.nationality != null) {
      for (var element in nationalityList!) {
        if (element.id.toString() == userProfileData!.nationality!) {
          nationality = element.name!;
        }
      }
    }
    for (var i in interestList!) {
      for (var element in interestRecordsList!) {
        if (element.interestId.toString() == i) {
          if (interestItem == "") {
            interestItem = element.name.toString();
          } else {
            interestItem += ", " + element.name.toString();
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [customAppbar(), _buildBody()],
        ));
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Image.asset(
                      AppImages.arrowBack,
                      fit: BoxFit.contain,
                      height: 20,
                    )),
                const SizedBox(width: 20),
                Text("myAccount".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
            const Spacer(),
            (userProfileData?.userType??"") == "Business" ? const SizedBox() :
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, UpdateProfileScreen.routeName);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfileScreen(isNewUser: widget.isNewUser,))).then((value) async {
                  if(value == "update"){
                    if (sp!.getString(SpUtil.USER_TYPE).toString() == "Individual") {
                      context.read<UserProvider>().getInterestListApi();
                      interestRecordsList = context.read<UserProvider>().interestListModel!.result!.records;
                      context.read<UserProvider>().getCountryListApi();
                      nationalityList = context.read<UserProvider>().countryListModel!.result;
                    }
                    await context.read<UserProvider>().getUserProfileApi();
                    userProfileData = context.read<UserProvider>().userProfileModel!.result;

                    setData();
                  }
                });
              },
              child: Text("editProfile".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_16, AppColors.brownColor)),
            ),
          ])),
    );
  }

  _buildBody() {
    return Consumer<UserProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Expanded(
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Material(
                    borderRadius: BorderRadius.circular(100),
                    elevation: 8,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.hintTextColor,
                      child: CircleAvatar(
                          backgroundColor: AppColors.whiteColor,
                          radius: 57,
                          backgroundImage: networkImage != null
                              ? NetworkImage(networkImage??"") as ImageProvider
                              : const AssetImage(AppImages.user)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(value.userProfileModel?.result?.name ?? "",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_20, AppColors.submitGradiantColor1)),
                const SizedBox(
                  height: 6,
                ),
                (userGender??"").isEmpty ? const SizedBox() :
                Column(
                  children: [
                    Text((userGender ?? "") + "  ${dob ?? ""}",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_18, AppColors.submitGradiantColor1)),
                    const SizedBox(
                      height: 6,
                    ),
                  ],
                ),
                (nationality ?? "").isEmpty ? const SizedBox(height: 10,) :
                Column(
                  children: [
                    Text(value.userProfileModel?.result?.nationality ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.submitGradiantColor1)),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email Address",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.mediumStyle(AppFontSize.font_16,
                                AppColors.submitGradiantColor1)),
                        const SizedBox(height: 5),
                        Text(value.userProfileModel?.result?.email ?? "",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_20, AppColors.blackColor)),
                      ],
                    )),
                const SizedBox(height: 16),
                Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mobile Number",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.mediumStyle(AppFontSize.font_16,
                                AppColors.submitGradiantColor1)),
                        const SizedBox(height: 5),
                        Text("${value.userProfileModel?.result?.countryCode ?? ""} ${value.userProfileModel?.result?.mobile ?? ""}",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_20, AppColors.blackColor)),
                      ],
                    )),
                const SizedBox(height: 16),
                interestItem.isEmpty ? const SizedBox() :
                Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Interest",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.mediumStyle(AppFontSize.font_16,
                                AppColors.submitGradiantColor1)),
                        const SizedBox(height: 5),
                        Text(interestItem,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_20, AppColors.blackColor)),
                      ],
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ChangePasswordScreen.routeName);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Row(children: [
                            Image.asset(
                              AppImages.changePassword,
                              fit: BoxFit.fill,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 16),
                            Text("changePassword".tr(),
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_18, AppColors.blackColor)),
                          ]),
                          const Spacer(),
                          Image.asset(
                            AppImages.btnRightArrow,
                            fit: BoxFit.fill,
                            height: 35,
                            width: 35,
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    changeLanguage();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Row(children: [
                            Image.asset(
                              AppImages.changeLanguage,
                              fit: BoxFit.fill,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 16),
                            Text("changeLanguageString".tr(),
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_18, AppColors.blackColor)),
                          ]),
                          const Spacer(),
                          Image.asset(
                            AppImages.btnRightArrow,
                            fit: BoxFit.fill,
                            height: 35,
                            width: 35,
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 16),
                userType != "Individual"
                    ? GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, UpdateBusinessProfile.routeName);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateBusinessProfile(isNewUser: widget.isNewUser,))).then((value) async {
                      if(value == "update"){
                        await context.read<UserProvider>().getCountryListApi();
                        nationalityList = context.read<UserProvider>().countryListModel!.result;
                        await context.read<UserProvider>().getUserProfileApi();
                        userProfileData = context.read<UserProvider>().userProfileModel!.result;
                        await context.read<UserProvider>().getInterestListApi();
                        interestRecordsList = context.read<UserProvider>().interestListModel!.result!.records;
                        setData();
                      }
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Row(children: [
                            Image.asset(
                              AppImages.updateBusinessInfo,
                              fit: BoxFit.fill,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 16),
                            Text("updateBusinessInfo".tr(),
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_18,
                                    AppColors.blackColor)),
                          ]),
                          const Spacer(),
                          Image.asset(
                            AppImages.btnRightArrow,
                            fit: BoxFit.fill,
                            height: 35,
                            width: 35,
                          ),
                        ],
                      )),
                )
                    : const SizedBox(),
                userType != "Individual"
                    ? const SizedBox(height: 16)
                    : const SizedBox(),
                GestureDetector(
                  onTap: () {
                    doLogOut(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Row(children: [
                            Image.asset(
                              AppImages.logOutIcon,
                              fit: BoxFit.fill,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 16),
                            Text("logOut".tr(),
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_18, AppColors.blackColor)),
                          ]),
                          const Spacer(),
                          Image.asset(
                            AppImages.btnRightArrow,
                            fit: BoxFit.fill,
                            height: 35,
                            width: 35,
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
        );
      },
    );
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
}
