import 'dart:io';

import 'package:autoparts/app_ui/screens/dashboard/dealers/dealer_review_screen.dart';
import "package:autoparts/app_ui/screens/dashboard/message_box_screen/message_box_screen.dart";
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/products_screen.dart';
import "package:autoparts/app_ui/screens/dashboard/parts_screens/product_detail_screen.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/utils/strings.dart';
import "package:autoparts/utils/url_launcher.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:share_plus/share_plus.dart";
import 'package:url_launcher/url_launcher.dart';

import '../../../../api_service/api_config.dart';
import '../../../../main.dart';
import '../../../../models/seller_details_model.dart';
import '../../../../provider/favourite_provider.dart';
import '../../../../provider/sellers_provider.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../common_widget/show_dialog.dart';

class SellerDetailsScreen extends StatefulWidget {
  final String? sellerId;

  static const routeName = "/seller";

  const SellerDetailsScreen({Key? key, this.sellerId}) : super(key: key);

  @override
  _SellerDetailsScreenState createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<SellerDetailsScreen> {
  bool? checkIsLogin;
  SellerDetail? sellerDetail;
  List<Products>? productsList;

  @override
  void initState() {
    super.initState();
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;

    Future.microtask(() async {
      await context.read<SellersProvider>().getSellerDetailsApi(widget.sellerId.toString());
      // if (dealerDetails!.dealerCategories!.isNotEmpty) {
      //   await context.read<DealersProvider>().getProductsListApi(
      //       dealerDetails?.dealerCategories![0].categoryId.toString());
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellersProvider>(
        builder: (BuildContext context, value, Widget? child) {
      sellerDetail = value.sellerDetail;
      productsList = value.sellerDetailsResponse?.result?.products;

      return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // customAppbar(),
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
                      return [
                        createSilverAppBar(value),
                        createSilverBottomAppBar(value),
                      ];
                    },
                    body: productPartCatalogue(value),
                  ),
                ),
              ],
            )),
      );
    },
    );
  }

  SliverAppBar createSilverAppBar(SellersProvider value) {
    return SliverAppBar(
      backgroundColor: AppColors.bgColor,
      expandedHeight: MediaQuery.of(context).size.height * .590,
      floating: false,
      automaticallyImplyLeading: false,
      pinned: false,
      elevation: 0,
      toolbarHeight: 0,
      excludeHeaderSemantics: true,
      collapsedHeight: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          color: AppColors.whiteColor,
          child: Column(
            children: [
              buildCarImages(value),
              buildCardReview(value),
              buildCardLocation(value),
              buildContactUsCard(value),
            ],
          ),
        ),
      ),
    );
  }

  // customAppbar() {
  //   return SafeArea(
  //     child: Container(
  //         color: AppColors.cardBgColor,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //         child: Row(children: [
  //           Row(
  //             children: [
  //               GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(
  //                       context,
  //                     );
  //                   },
  //                   child: Image.asset(
  //                     AppImages.arrowBack,
  //                     fit: BoxFit.contain,
  //                     height: 20,
  //                   )),
  //               const SizedBox(width: 20),
  //               // Text("sellerDetails".tr(),
  //               //     style: AppTextStyles.boldStyle(
  //               //         AppFontSize.font_22, AppColors.blackColor)),
  //             ],
  //           ),
  //           const Spacer(),
  //           // GestureDetector(
  //           //   onTap: () {},
  //           //   child: Image.asset(
  //           //     AppImages.favOutlineGrey,
  //           //     fit: BoxFit.fill,
  //           //     height: 25,
  //           //     width: 25,
  //           //   ),
  //           // ),
  //         ])),
  //   );
  // }

  buildCarImages(SellersProvider value) {
    return Container(
      height: MediaQuery.of(context).size.height * .300,
      color: AppColors.cardBgColor,
      width: double.infinity,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: baseImageUrl + (sellerDetail?.userResult?.image??""),
            placeholder: (context, url) => const Center(child: SizedBox(height: 50,width: 50,child: CircularProgressIndicator())),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          Positioned(
            left: 16,
            top: 20,
            child: GestureDetector(
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
          ),
          Positioned(
            right: 16,
            top: 60,
            child: sellerDetail?.userResult?.sellerVerify == "Yes" ?
            Padding(padding: const EdgeInsets.all(4),
                child: Image.asset("assets/images/ic_verified.png",height: 30,width: 30,)):const SizedBox(),
          ),
        ],
      ),
    );
  }

  buildCardReview(SellersProvider value) {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: baseImageUrl + (sellerDetail?.userResult?.image??""),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.network(
                      demoImageUrlOLd,
                      width: 50,
                      height: 50,
                    ),
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                ),
                // Image.network(
                //   sellerDetail?.userResult?.image != null
                //       ? baseImageUrl + sellerDetail!.userResult!.image!
                //       : demoImageUrlOLd,
                //   width: 60,
                //   height: 60,
                // ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sellerDetail?.userResult?.name ?? "",
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, DealerReviewScreen.routeName);
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
                            "${sellerDetail?.userResult?.avgRate ?? "0"} (${sellerDetail?.userResult?.totalRate ?? "0"} Review)",
                            style: AppTextStyles.boldStyle(AppFontSize.font_12,
                                AppColors.blackBottomColor)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                if (checkIsLogin!) {
                  await context.read<FavouriteProvider>().addRemoveFav(sellerDetail?.userResult?.id.toString(), "seller").then((value) {
                    setState(() {
                      if(value){
                        sellerDetail?.userResult?.isFav = 1;
                      }else{
                        sellerDetail?.userResult?.isFav = 0;
                      }
                    });
                  });
                } else {
                  pleaseLogin(context);
                }
              },
              child: Image.asset(
                sellerDetail?.userResult?.isFav == 0
                    ? AppImages.favOutlineGrey
                    : AppImages.favoritesIcon,
                width: 28,
                height: 25,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"productListed".tr()}: ${sellerDetail?.products?.length??0}",
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_14, AppColors.blackColor)),
              Container(
                height: 15,
                width: 2,
                color: AppColors.borderColor,
                alignment: Alignment.center,
              ),
              Text("${"productSold".tr()}: ${sellerDetail?.userResult?.productSold?.toString()??"0"}",
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_14, AppColors.blackColor)),
            ],
          )
        ],
      ),
    );
  }

  buildContactUsCard(SellersProvider value) {
    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
      child: Card(
        color: AppColors.whiteColor,
        elevation: 9,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 55,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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

  static Future<void> openMap({required double latitude, required double longitude}) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  buildCardLocation(SellersProvider value) {
    return GestureDetector(
      onTap: (){
        openMap(latitude: double.parse(sellerDetail?.userResult?.latitude??"0.0"), longitude: double.parse(sellerDetail?.userResult?.longitude??"0.0"));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        color: AppColors.cardBgColor,
        child: Row(children: [
          Expanded(
            flex: 10,
            child: Row(children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.location_on,
                  size: 30,
                  color: AppColors.hintTextColor,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 11,
                child: Text(sellerDetail?.userResult?.address ?? "",
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
            child: Text("${sellerDetail?.userResult?.distance ?? ""} km",
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.boldDecorationStyle(TextDecoration.underline,
                    AppFontSize.font_16, AppColors.brownColor)),
          ),
        ]),
      ),
    );
  }

  SliverAppBar createSilverBottomAppBar(SellersProvider value) {
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
        flexibleSpace: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("productPartCatalogue".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_18, AppColors.blackColor)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductsScreen(categoryName: "Products")));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("seeAll".tr(),
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_16, AppColors.brownColor)),
                      const SizedBox(width: 7),
                      Image.asset(
                        AppImages.rightDoubleArrow,
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }

  productPartCatalogue(SellersProvider value) {
    return Container(
        color: AppColors.whiteColor,
        child: ListView(
          padding: EdgeInsets.zero,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Column(
              children: List.generate(
                  (productsList?.length ?? 0) > 5 ? 5 : productsList?.length ?? 0, (index) => buildListTile(index)),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  buildListTile(index) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, ProductDetailScreen.routeName);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetailScreen(detailsId: productsList?[index].id.toString()??"",)));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: baseImageUrl + (productsList?[index].imageUrl??""),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  "assets/appIcon/appLogo.png",
                  width: 50,
                  height: 50,
                ),
                height: 65,
                width: 65,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(productsList?[index].name ?? "",
                              style: AppTextStyles.boldStyle(
                                  AppFontSize.font_18, AppColors.blackColor)),
                          Row(
                            children: [
                              Image.asset(
                                AppImages.questionInquiry,
                                color: AppColors.hintTextColor,
                                fit: BoxFit.fill,
                                height: 20,
                                width: 20,
                              ),
                              // const SizedBox(width: 12),
                              // Image.asset(
                              //   AppImages.flagIconGrey,
                              //   fit: BoxFit.fill,
                              //   height: 20,
                              //   width: 20,
                              // ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () async {
                                  if (checkIsLogin!) {
                                    await context.read<FavouriteProvider>().addRemoveFav(productsList?[index].id.toString(), "auto-part");
                                    setState(() {
                                      if (productsList?[index].isFav == 0) {
                                        productsList?[index].isFav = 1;
                                      } else {
                                        productsList?[index].isFav = 0;
                                      }
                                    });
                                  } else {
                                    pleaseLogin(context);
                                  }
                                },
                                child: Image.asset(
                                  productsList?[index].isFav == 0
                                      ? AppImages.favOutlineGrey
                                      : AppImages.favoritesIcon,
                                  fit: BoxFit.fill,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 5),
                    Text(productsList?[index].categories?.name ?? "",
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.hintTextColor)),
                    const SizedBox(height: 5),
                    Text(productsList?[index].partNumber ?? "",
                        style: AppTextStyles.regularStyle(
                            AppFontSize.font_14, AppColors.blackColor)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              productsList?[index].qty != 0
                                  ? "availableSmall".tr()
                                  : "unAvailableSmall".tr(),
                              style: AppTextStyles.mediumStyle(
                                  AppFontSize.font_12,
                                  AppColors.hintTextColor)),
                          Text('AED ${productsList?[index].price ?? ""} ',
                              style: AppTextStyles.boldStyle(
                                  AppFontSize.font_16,
                                  AppColors.hintTextColor)),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogContactUS() {
    var mobile;
    var email;
    mobile = sellerDetail?.userResult?.mobile ?? "";
    email = sellerDetail?.userResult?.email ?? "";
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

  void shareData() {
    Share.share(officialWebsite);
  }
}
// class MyBorderShape extends ShapeBorder {
//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
//   @override
//   Path getInnerPath(Rect? rect, {TextDirection? textDirection}) => null!;
//
//   final double holeSize = 70;
//   final double borderRadius = 10;
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     print(rect.topLeft);
//     var startX = rect.topLeft.dx;
//     var startY = rect.topLeft.dy;
//
//     return Path.combine(
//       PathOperation.union,
//       Path()
//         ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)))
//         ..close(),
//       Path()
//         ..moveTo(startX + 20, startY)
//         ..lineTo(startX + 35, startY - 15)
//         ..lineTo(startX + 50, startY)
//         ..close(),
//     );
//   }
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
//
//   @override
//   ShapeBorder scale(double t) => this;
// }
