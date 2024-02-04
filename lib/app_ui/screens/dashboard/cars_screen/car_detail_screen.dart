import 'dart:io';

import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealer_detail_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/message_box_screen/message_box_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/car_detailss_model.dart';
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/favourite_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:autoparts/utils/strings.dart';
import 'package:autoparts/utils/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:carousel_slider/carousel_slider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../../provider/user_provider.dart';

class CarDetailScreen extends StatefulWidget {
  final String? detailsId;
  final String? sellRecordId;
  static const  routeName = "/car-detail";
  final bool isFav;
  const CarDetailScreen({Key? key,this.detailsId,this.sellRecordId,this.isFav = false}) : super(key: key);

  @override
  _CarDetailScreenState createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  int _current = 0;
  bool? checkIsLogin;
  @override
  void initState() {
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    super.initState();
    Future.microtask(() async {
      await context.read<CarProvider>().carDetailsPartsApi(widget.detailsId.toString(),sellRecordId: widget.sellRecordId);
      print(widget.detailsId.toString());
      // print(result?.hsNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
              backgroundColor: AppColors.cardBgColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  customAppbar(),
                  const SizedBox(height: 16),
                  _buildBody(value)
                ],
              ));
        });

  }

  _buildBody(CarProvider value) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          _buildCarouselSlider(value.carImages),
          buildCarFeatures(value.carDetailsModel),
          buildCarItemOverview(value.result,value.carDetailsModel?.sellData),
        ],
      ),
    );
  }

  void shareData() {
    Share.share(officialWebsite);
  }

  buildCarFeatures(CarDetailsModel? result) {
    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${result?.result?.make?.title??""} ${result?.result?.model?.title??""} ${result?.result?.carCategory?.name??""}",
                    //"Audi S7 Quattro 2014 GCC - 2022 MMW Warranty/FSH",
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_20, AppColors.blackColor)),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      shareData();
                    },
                    child: Image.asset(
                      AppImages.shareSocialIcon,
                      fit: BoxFit.fill,

                      height: 25,
                      width: 25,
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () async {
                      if (checkIsLogin!) {
                        await context.read<FavouriteProvider>().addRemoveFav(result?.sellData?.id.toString(), "cars",isFavScreen: widget.isFav).then((value){
                          setState(() {
                            if(value){
                              result?.result?.isFav = 1;
                            }else{
                              result?.result?.isFav = 0;
                            }
                          });
                        });
                      } else {
                        pleaseLogin(context);
                      }
                    },
                    child: Image.asset(
                      result?.result?.isFav == 0
                          ? AppImages.favOutlineGrey
                          : AppImages.favoritesIcon,
                      fit: BoxFit.fill,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              (result?.sellData?.price??0) != 0 ?
              Text("AED ${result?.sellData?.price??"--"}",
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_18, AppColors.hintTextColor)):const SizedBox(),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialogContactUS(result?.sellData);
                    },
                    child: Image.asset(
                      AppImages.phoneIcon,
                      fit: BoxFit.fill,
                      height: 25,
                      width: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      AppImages.questionInquiry,
                      fit: BoxFit.fill,

                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          carAvailabilityCard(result)
        ],
      ),
    );
  }

  carAvailabilityCard(CarDetailsModel? result) {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child:
              Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
            buildItemColumn("year".tr().toUpperCase(), AppImages.calendar, result?.result?.year??""),
                  (result?.sellData?.kmDriven.toString()??"").isEmpty ? const SizedBox() :
                  Padding(padding: const EdgeInsets.only(left: 60),child: buildItemColumn(result?.sellData?.kmDrivenType?.toUpperCase(),
                      AppImages.meterWifi, result?.sellData?.kmDriven.toString()??"")),
                  (result?.sellData?.warrantyTime.toString()??"").isEmpty ? const SizedBox() :
                  Padding(padding: const EdgeInsets.only(left: 60),child: buildItemColumn("warranty".tr().toUpperCase(),
                      AppImages.achievementAward, "${(result?.sellData?.warrantyTime.toString()??"")} ${(result?.sellData?.warrantyType.toString()??"")}")),

          ]),
              ),
        ));
  }

  buildItemColumn(String? title, icon, dec) {
    return Column(
      children: [
        Text(title??"",
            style: AppTextStyles.boldStyle(
                AppFontSize.font_12, AppColors.brownColor)),
        const SizedBox(height: 7),
        Image.asset(
          icon,
          color: AppColors.blackColor,
          height: 20,
          width: 20,
        ),
        const SizedBox(height: 7),
        Text(dec.toString(),
            style: AppTextStyles.boldStyle(
                AppFontSize.font_14, AppColors.hintTextColor)),
      ],
    );
  }

  buildCarItemOverview(CarResultDetails? result,SellData? sellData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("itemOverview".tr(), style: AppTextStyles.boldStyle(AppFontSize.font_18, AppColors.blackColor)),
          const SizedBox(height: 10),
          buildRow("Region :", result?.region??""),
          const SizedBox(height: 5),
          buildRow("Transmission Type :", result?.transmissionType??""),
          const SizedBox(height: 5),
          buildRow("Grade :", result?.grade??""),
          const SizedBox(height: 5),
          buildRow("Engine No. :", sellData?.engineNumber??""),
          (sellData?.chassisNumber??"").isEmpty && (sellData?.chassisNumber??"") == "null" ? const SizedBox() :
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("Chassis Number :", sellData?.chassisNumber??""),
            ],
          ),
          (sellData?.price??0) == 0 ? const SizedBox() :
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("Price :", (sellData?.price.toString()??"")+" AED"),
            ],
          ),
          (sellData?.mileage??"").isEmpty ? const SizedBox() :
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("Mileage :", '${sellData?.mileage.toString()??""} ${sellData?.mileageType.toString()??""}/ltr'),
            ],
          ),
          (result?.engine??"").isEmpty ? const SizedBox() :
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("Fuel Type :", result?.engine.toString()??""),
            ],
          ),
          (sellData?.productCondition??"").isEmpty ? const SizedBox() :
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("Condition :", sellData?.productCondition.toString()??""),
            ],
          ),
          (sellData?.description??"").isEmpty ? const SizedBox() :
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("Description :", sellData?.description.toString()??""),
            ],
          ),
          const SizedBox(height: 10),
          sp.getString(SpUtil.USER_TYPE) == "Individual" ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sp.getString(SpUtil.USER_TYPE), style: AppTextStyles.boldStyle(AppFontSize.font_18, AppColors.blackColor)),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, DealerDetailScreen.routeName,
                      arguments: [sellData?.user?.id.toString()]);
                },
                child: SizedBox(
                  width: 180,
                  child: Card(
                    color: AppColors.whiteColor,
                    margin: const EdgeInsets.all(10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          sellData?.user?.featured == "Yes"
                              ? Container(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 3, bottom: 1),
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppColors.brownColor,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Text("featured".tr(),
                                  style: AppTextStyles.mediumStyle(
                                      AppFontSize.font_10,
                                      AppColors.whiteColor)))
                              : Container(height: 21,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sellData?.user?.image == null
                                    ? Image.asset(
                                  AppImages.alQassemImage,
                                  width: 150,
                                  height: 50,
                                )
                                    : Image.network(
                                  baseImageUrl + (sellData?.user?.image??""),
                                  height: 50,
                                  width: 150,
                                ),
                                const SizedBox(height: 20),
                                Text(sellData?.user?.name ?? "",
                                    style: AppTextStyles.boldStyle(AppFontSize.font_18, AppColors.blackColor)),
                                // Row(
                                //     mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Text("Unavailable",
                                //           style: AppTextStyles.mediumStyle(
                                //               AppFontSize.font_12,
                                //               AppColors.hintTextColor)),
                                //       GestureDetector(
                                //         onTap: () async {
                                //           await context.read<UserProvider>().setReminderApi(userId: sellData?.user?.id.toString()).then((value){
                                //             setState(() {
                                //               if(value == 0){
                                //                 sellData?.user?.isReminder = "No";
                                //               }else{
                                //                 dealers?[index].isReminder = "Yes";
                                //               }
                                //             });
                                //           });
                                //         },
                                //         child: Icon((dealers?[index].isReminder??"No") == "No" ? Icons.notifications_none : Icons.notifications,
                                //             size: 26,color: AppColors.blackColor),
                                //       )
                                //     ]),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ]),
                  ),
                ),
              ),
            ],
          ):const SizedBox(),
          // buildRow("${"accidentHistoryCheck".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"doors".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"bodyCondition".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"mechanicalCondition".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"noOfCylinders".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"transmissionType".tr()} :", result?.transmissionType??""),
          // const SizedBox(height: 5),
          // buildRow("${"regionalSpecs".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"horsepower".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"fuelType".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"steeringSide".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"color".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"condition".tr()} :", "--"),
          // const SizedBox(height: 5),
          // buildRow("${"build".tr()} :", result?.region??""),
          // const SizedBox(height: 10),
          // Text("description".tr(),
          //     style: AppTextStyles.boldStyle(
          //         AppFontSize.font_18, AppColors.blackColor)),
          // const SizedBox(height: 5),
          // Text(
          //     "Stunning 2014 Audi S7 Quattro with 140,000kms! 4.0 Litre Turbocharged 8 cylinder, 4 Wheel Drive, 8 Speed Auto with 420 BHP… Ibis White with Black leather interior.",
          //     style: AppTextStyles.regularStyle(
          //         AppFontSize.font_14, AppColors.hintTextColor)),
        ],
      ),
    );
  }

  _launchWhatsapp(phone) async {
    var url = '';

    if (Platform.isAndroid) {
      setState(() {
        url = "https://wa.me/$phone/?text=Hello";
      });
    } else {
      setState(() {
        url = "https://api.whatsapp.com/send?phone=$phone=Hello";
      });
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  buildContactRow(icon, text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: AppColors.brownColor,
              shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
              //color: const Color(0xFF66BB6A),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ]),
          child: Image.asset(
            icon,
            fit: BoxFit.fill,
            height: 20,
            width: 20,
          ),
        ),
        const SizedBox(width: 15),
        Text(text,
            style: AppTextStyles.boldStyle(
                AppFontSize.font_16, AppColors.submitGradiantColor1)),
      ],
    );
  }

  void showDialogContactUS(SellData? sellData) {
    var mobile;
    var email;
    mobile = sellData?.user?.mobile ?? "";
    email = sellData?.user?.email ?? "";
    showGeneralDialog(
      context: context,
      //barrierColor: Colors.transparent,
      barrierDismissible: true,
      barrierLabel: "Label",

      pageBuilder: (_, __, ___) => Align(
        alignment: Alignment.center,
        child: Card(
            elevation: 0,
            margin: const EdgeInsets.only(left: 35, right: 35, bottom: 0),
            //shape: MyBorderShape(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Expanded(
                        flex: 6,
                        child: GestureDetector(
                            onTap: () {
                              _launchWhatsapp(mobile);
                              //UrlLauncher.launchWhatsapp("917891226154");
                            },
                            child: buildContactRow(
                                AppImages.whatsApp, "whatsapp".tr()))),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: GestureDetector(
                          onTap: () {
                            UrlLauncher.launchCaller(mobile);
                          },
                          child: buildContactRow(AppImages.phone, "call".tr())),
                    )
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(
                      flex: 6,
                      child: GestureDetector(
                          onTap: () {
                            UrlLauncher.launchSms(mobile);
                          },
                          child: buildContactRow(AppImages.sms, "sms".tr())),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MessageBoxScreen.routeName);
                          },
                          child: buildContactRow(AppImages.chat, "chat".tr())),
                    )
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(
                      flex: 6,
                      child: GestureDetector(
                          onTap: () {
                            UrlLauncher.launchEmail(email);
                          },
                          child:
                          buildContactRow(AppImages.email, "email".tr())),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: GestureDetector(
                          onTap: () {},
                          child: buildContactRow(
                              AppImages.enquiry, "enquiry".tr())),
                    )
                  ]),
                ],
              ),
            )),
      ),
    );
  }

  buildRow(text, decText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(text,
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_14, AppColors.blackColor)),
        ),
        Expanded(
          child: Text(decText,
              textAlign: TextAlign.end,
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_14, AppColors.blackColor)),
        ),
      ],
    );
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.cardBgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
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


          ])),
    );
  }

  _buildCarouselSlider(List<String> list) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              autoPlay: true,
              height: 185,
              scrollDirection: Axis.horizontal,
              autoPlayCurve: Curves.ease,
              viewportFraction: 1.0,
              aspectRatio: 2.0,
              enlargeCenterPage: false,
              reverse: false,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 4000),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: list.map<Widget>((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    color: AppColors.bgColor,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: baseImageUrl + i,
                      placeholder: (context, url) => Shimmer.fromColors(baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade100,child: Image.asset("assets/images/car_placeholder.png",width: 300,)),
                      errorWidget: (context, url, error) => Image.asset("assets/images/car_placeholder.png",width: 300,color: Colors.grey.shade400,),
                      fit: BoxFit.fill,
                    ),
                );
              },
            );
          }).toList(),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 150),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  list.length,
                  (index) => Container(
                        margin: const EdgeInsets.only(right: 15),
                        width: _current == index ? 16 : 12,
                        height: _current == index ? 16 : 12,
                        decoration: BoxDecoration(
                            color: _current == index
                                ? AppColors.brownColor
                                : AppColors.greyColor,
                            shape: BoxShape.circle),
                      ))),
        )
      ],
    );
  }
}
