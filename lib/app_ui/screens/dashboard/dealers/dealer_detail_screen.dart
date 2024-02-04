import 'dart:io';

import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import "package:autoparts/app_ui/screens/dashboard/dealers/dealer_review_screen.dart";
import "package:autoparts/app_ui/screens/dashboard/message_box_screen/message_box_screen.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import "package:autoparts/utils/url_launcher.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import "package:share_plus/share_plus.dart";
import 'package:url_launcher/url_launcher.dart';

import '../../../../api_service/api_config.dart';
import '../../../../main.dart';
import '../../../../models/dealers_details_model.dart';
import '../../../../models/product_list_model.dart';
import '../../../../provider/dealers_provider.dart';
import '../../../../provider/favourite_provider.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../common_widget/show_dialog.dart';

class DealerDetailScreen extends StatefulWidget {
  final String? dealerId;
  static const routeName = "/dealer-detail";

  const DealerDetailScreen({Key? key, this.dealerId}) : super(key: key);

  @override
  _DealerDetailScreenState createState() => _DealerDetailScreenState();
}

class _DealerDetailScreenState extends State<DealerDetailScreen> {
  bool isFavourite = false;
  bool isListType = true;
  bool showContactUSDialog = false;
  DealerDetails? dealerDetails;
  List<DealerCategories>? dealerCategories;
  List<Product>? productList;
  bool? checkIsLogin;
  String primaryCategoryId = "";

  @override
  void initState() {
    primaryCategoryId = sp?.getInt(SpUtil.CATEGORY_ID).toString()??"";
    super.initState();
    print("dfsdfsdfsd");
    print(widget.dealerId.toString());
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;

    Future.microtask(() async {
      await context.read<DealersProvider>().getDealerDetailsApi(widget.dealerId.toString(),);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DealersProvider>(
        builder: (BuildContext context, value, Widget? child) {
      dealerDetails = value.dealerDetails;
      productList = value.productList;

      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              value.dealerDetails != null
                  ? Expanded(
                      child: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
                          return <Widget>[
                            createSilverAppBar(),
                            dealerDetails!.dealerCategories != null
                                ? createSilverBottomAppBar()
                                : const SizedBox(),

                          ];
                        },
                        body: ListView(
                          padding: const EdgeInsets.all(0),
                          children: [
                            productList != null
                                ? _buildGridView()
                                : Center(
                                    child: Lottie.asset(
                                      AppStrings.notFoundAssets,
                                      repeat: true,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Lottie.asset(
                        AppStrings.notFoundAssets,
                        repeat: true,
                        fit: BoxFit.cover,
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }

  buildFeaturedProductsCard(position) {
    return GestureDetector(
      onTap: () {
        productDetailAlertBox(position);
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
          elevation: 7,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  (productList?[position].partCondition??"").toString().isEmpty ? const SizedBox(height: 20) :
              Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.brownColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text(productList?[position].partCondition??"",
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_10, AppColors.whiteColor))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.network(
                        productList?[position].imageUrl != null
                            ? baseImageUrl + productList![position].imageUrl!
                            : demoImageUrlOLd,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Text(truncateWithEllipsis(15,productList?[position].name ?? ""),
                        maxLines: 1,
                        // overflow: TextOverflow.visible,
                        style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ]),
          )),
    );
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  buildCardReview() {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Card(
              color: AppColors.whiteColor,
              elevation: 7,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: baseImageUrl + (dealerDetails?.image??""),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.network(
                    demoImageUrlOLd,
                    width: 120,
                    height: 70,
                  ),
                  height: 50,
                  width: 110,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dealerDetails?.name ?? "",
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_18, AppColors.blackColor)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DealerReviewScreen.routeName);
                  },
                  child: Row(children: [
                    const Icon(
                      Icons.star,
                      size: 20,
                      color: AppColors.startMarkColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        "${dealerDetails?.avgRate ?? "0"} (${dealerDetails?.totalRate ?? "0"} Review)",
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_12, AppColors.blackBottomColor)),
                  ]),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                dealerDetails?.featured == "Yes"
                    ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.brownColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("featured".tr(),
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_10,
                            AppColors.whiteColor)))
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                if (checkIsLogin!) {
                  await context.read<FavouriteProvider>().addRemoveFav(dealerDetails?.id.toString(), "dealer").then((value){
                    setState(() {
                      if(value){
                        dealerDetails?.isFav = 1;
                      }else{
                        dealerDetails?.isFav = 0;
                      }
                    });
                  });
                  // setState(() {
                  //   if (dealerDetails?.isFav == 0) {
                  //     dealerDetails?.isFav = 1;
                  //   } else {
                  //     dealerDetails?.isFav = 0;
                  //   }
                  // });
                } else {
                  pleaseLogin(context);
                }
              },
              child: Image.asset(
                dealerDetails?.isFav == 0
                    ? AppImages.favOutline
                    : AppImages.favoritesIcon,
                height: 25,
                width: 28,
                color: AppColors.btnBlackColor,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  buildContactUsCard() {
    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 10),
      child: Card(
        color: AppColors.whiteColor,
        elevation: 9,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
              onTap: () {
                showDialogContactUS();
              },
              child: Row(children: [
                Image.asset(
                  AppImages.phoneIcon,
                  fit: BoxFit.fill,
                  height: 25,
                  width: 18,
                ),
                const SizedBox(width: 10),
                Text("contactUs".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_16, AppColors.hintTextColor)),
              ]),
            ),
            GestureDetector(
              onTap: () {
                shareData();
              },
              child: Row(children: [
                Image.asset(
                  AppImages.linkShare,
                  fit: BoxFit.fill,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 10),
                Text("share".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_16, AppColors.hintTextColor)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  void shareData() {
    Share.share("Buy&Bee.com");
  }

  static Future<void> openMap({required double latitude, required double longitude}) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  buildCardLocation() {
    return  GestureDetector(
      onTap: (){
        openMap(latitude: double.parse(dealerDetails?.latitude??"0.0"), longitude: double.parse(dealerDetails?.longitude??"0.0"));
      },
      child: Container(
        color: AppColors.cardBgColor,
        child: Row(children: [
          Expanded(
            flex: 10,
            child: Row(children: [
              const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(top: 8,bottom: 8,left: 16),
                  child: Icon(
                    Icons.location_on,
                    size: 30,
                    color: AppColors.hintTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                flex: 11,
                child: Text(dealerDetails?.address ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.hintTextColor)),
              ),
            ]),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 8,bottom: 8,right: 16),
              child: Text("${dealerDetails?.distance ?? ""} km",
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.boldDecorationStyle(TextDecoration.underline,
                      AppFontSize.font_16, AppColors.brownColor)),
            ),
          ),
        ]),
      ),
    );
  }

  void productDetailAlertBox(position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: alertBoxBody(position)),
      ),
    );
  }

  customTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      alignment: Alignment.center,
      width: double.infinity,
      color: AppColors.cardBgColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: (dealerDetails?.dealerCategories?.length ?? 0) != 0 ?
        Row(
          children: List.generate(
            dealerDetails?.dealerCategories?.length ?? 0,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 25),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      for (var element in dealerDetails!.dealerCategories!) {
                        element.isSelect = false;
                      }
                      dealerDetails?.dealerCategories![index].isSelect = true;
                    });
                    if (dealerDetails!.dealerCategories!.isNotEmpty) {
                      await context.read<DealersProvider>().getProductsListApi(primaryCategoryId,productCategoryId: dealerDetails?.dealerCategories?[index].categoryId.toString());
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          dealerDetails?.dealerCategories?[index].category?.name ?? "",
                          style: AppTextStyles.mediumStyle(
                              AppFontSize.font_16,
                              dealerDetails
                                          ?.dealerCategories?[index].isSelect ??
                                      false
                                  ? AppColors.blackColor
                                  : AppColors.hintTextColor)),
                      const SizedBox(height: 10),
                      Container(
                        height: 3,
                        width: 15,
                        color: dealerDetails?.dealerCategories?[index].isSelect ?? false
                                ? AppColors.blackColor
                                : AppColors.cardBgColor,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ):
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text("No Categories Found!",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)
            )
          ],
        ),
      ),
    );
  }

  _buildGridView() {
    return SizedBox(
      child: (productList?.length ?? 0) != 0 ?
      GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(6),
        physics: const BouncingScrollPhysics(),
        itemCount: productList?.length ?? 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: MediaQuery.of(context).size.width * .480,
        ),
        itemBuilder: (_, index) => buildFeaturedProductsCard(index),
      ):const NoDataWidget(),
    );
  }

  alertBoxBody(position) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        alertBoxTopBar(),
        SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Card(
                        color: AppColors.whiteColor,
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            productList?[position].imageUrl != null
                                ? baseImageUrl + productList![position].imageUrl!
                                : demoImageUrlOLd,
                            height: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text( productList?[position].name??"",
                                    style: AppTextStyles.boldStyle(
                                        AppFontSize.font_18,
                                        AppColors.blackColor)),
                                Image.asset(
                                  AppImages.questionInquiry,
                                  fit: BoxFit.fill,
                                  height: 20,
                                  width: 20,
                                ),
                              ]),
                          const SizedBox(height: 5),
                          Text(productList?[position].category?.name??"",
                              style: AppTextStyles.mediumStyle(
                                  AppFontSize.font_14,
                                  AppColors.hintTextColor)),
                          const SizedBox(height: 7),
                          (productList?[position].qty ?? 0) > 0 ?
                          Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppColors.brownColor,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Text("available".tr(),
                                  style: AppTextStyles.mediumStyle(
                                      AppFontSize.font_10,
                                      AppColors.whiteColor))) : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                (productList?[position].descriptions??"").isNotEmpty ?
                Text("description".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_20, AppColors.blackBottomColor)):const SizedBox(),
                const SizedBox(height: 10),
                (productList?[position].descriptions??"").isNotEmpty ?
                Text(productList?[position].descriptions??"",
                    style: AppTextStyles.regularStyle(
                        AppFontSize.font_14, AppColors.hintTextColor)):const SizedBox(),
              ],
            ))
      ],
    );
  }

  alertBoxTopBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                "productDetail".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackBottomColor),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  AppImages.circleCrossIcon,
                  color: AppColors.btnBlackColor,
                  height: 35,
                  width: 35,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Divider(
          color: AppColors.borderColor,
          thickness: 1.5,
          height: 0,
        ),
      ],
    );
  }

  void showDialogContactUS() {
    var mobile;
    var email;
    mobile = dealerDetails?.mobile ?? "";
    email = dealerDetails?.email ?? "";
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  SliverAppBar createSilverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.bgColor,
      expandedHeight: MediaQuery.of(context).size.height * .520,
      floating: false,
      automaticallyImplyLeading: false,
      pinned: false,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          color: AppColors.bgColor,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .240,
                color: AppColors.cardBgColor,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    CachedNetworkImage(
                      imageUrl: "http://3.20.147.34:3001/img/users/202205170652480534.jpg",
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                        child: Image.asset(
                          AppImages.arrowBack,
                          fit: BoxFit.contain,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              buildCardReview(),
              buildCardLocation(),
              buildContactUsCard()
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar createSilverBottomAppBar() {
    return SliverAppBar(
        elevation: 0,
        forceElevated: true,
        backgroundColor: AppColors.cardBgColor,
        floating: false,
        pinned: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        excludeHeaderSemantics: true,
        expandedHeight: 0,
        collapsedHeight: 40,
        flexibleSpace: customTabBar());
  }
}
