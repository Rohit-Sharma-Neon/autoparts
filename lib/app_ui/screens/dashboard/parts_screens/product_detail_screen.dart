import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealer_detail_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/get_products_details.dart';
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/favourite_provider.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:autoparts/utils/custom_video_player.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:autoparts/utils/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../main.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? detailsId;
  static const routeName = "/product-detail";
  const ProductDetailScreen({Key? key,this.detailsId}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool? checkIsLogin;
  //ResultData? result;
  @override
  void initState() {
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    super.initState();
    Future.microtask(() async {
      await context.read<DealersProvider>().productDetailsPartsApi(widget.detailsId.toString());
      print(widget.detailsId.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DealersProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildBody(value)
                ],
              ));
        });
  }

  _buildBody(DealersProvider dealersProvider) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          buildCarImages(dealersProvider.result),
          buildCarTitle(dealersProvider.result),
          buildCarTechnicalDescription(dealersProvider.result),
          CustomVideoPlayer(videoUrl: dealersProvider.result?.video),
          buildFeaturedDealersCard(dealersProvider.result?.dealers),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void shareData() {
    Share.share(officialWebsite);
  }


  buildCarTitle(ResultData? result){
   return Container(
        color: AppColors.cardBgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(result?.name??"",
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22,
                        AppColors.blackColor)),
                const Spacer(),
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
                    // const SizedBox(width: 10),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Image.asset(
                    //     AppImages.flagIconGrey,
                    //     fit: BoxFit.fill,
                    //
                    //     height: 25,
                    //     width: 25,
                    //   ),
                    // ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        if (checkIsLogin!) {
                          await context.read<FavouriteProvider>().addRemoveFav(result?.id.toString(), "auto-part");
                          setState(() {
                            if (result?.isFav == 0) {
                              result?.isFav = 1;
                            } else {
                              result?.isFav = 0;
                            }
                          });
                        } else {
                          pleaseLogin(context);
                        }
                      },
                      child: Image.asset(
                        result?.isFav == 0
                            ? AppImages.favOutline
                            : AppImages.favoritesIcon,
                        height: 25,
                        width: 28,
                        color: AppColors.btnBlackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(result?.category?.name??"",
                style: AppTextStyles.mediumStyle(
                    16,
                    AppColors.hintTextColor)),
            const SizedBox(height: 4),
            Text(result?.partNumber??"",
                style: AppTextStyles.regularStyle(
                    14,
                    AppColors.blackColor)),

          ],
        ),
    );
  }


  buildCarTechnicalDescription(ResultData? result){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("technicalDescription".tr(),
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_18,
                  AppColors.blackColor)),

          (result?.partNumber??"").toString().isNotEmpty && result?.partNumber != null ?
          Column(
            children: [
              const SizedBox(height: 10),
              buildRow("${"partNumber".tr()} :",result?.partNumber??""),
            ],
          ):const SizedBox(),

          (result?.hsNumber??"").toString().isNotEmpty && result?.hsNumber != null ?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"hSNumber".tr()} :",result?.hsNumber??""),
            ],
          ):const SizedBox(),

          (result?.featured??"").toString().isNotEmpty && result?.featured != null ?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"featuredSmall".tr()} :",result?.featured??""),
            ],
          ):const SizedBox(),

          (result?.qty.toString()??"").toString().isNotEmpty && result?.qty != null?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"quantity".tr()} :",result?.qty.toString()??""),
            ],
          ):const SizedBox(),

          (result?.price??"").toString().isNotEmpty && result?.price != null ?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"price".tr()} :",("AED "+(result?.price??""))),
            ],
          ):const SizedBox(),

          (result?.weight??"").toString().isNotEmpty && result?.weight != null ?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"weight".tr()} :",result?.weight??""),
            ],
          ):const SizedBox(),

          (result?.unit.toString()??"").toString().isNotEmpty && result?.unit != null?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"unit".tr()} :",result?.unit.toString()??""),
            ],
          ):const SizedBox(),

          (result?.partCondition.toString()??"").toString().isNotEmpty && result?.partCondition != null ?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"partCondition".tr()} :",result?.partCondition.toString()??""),
            ],
          ):const SizedBox(),
          (result?.unit.toString()??"").toString().isNotEmpty && result?.unit != null?
          Column(
            children: [
              const SizedBox(height: 5),
              buildRow("${"unit".tr()} :",result?.unit.toString()??""),
            ],
          ):const SizedBox(),
          // const SizedBox(height: 5),
          // buildRow("${"manufacture".tr()} :","SAG"),
          // const SizedBox(height: 5),
          // buildRow("${"remark".tr()} :","220MM SACHS"),
          // const SizedBox(height: 5),
          // Text("${"note".tr()} :",
          //     style: AppTextStyles.mediumStyle(
          //         AppFontSize.font_14,
          //         AppColors.blackColor)),
          const SizedBox(height: 0),
          (result?.descriptions.toString()??"").toString().isNotEmpty && result?.descriptions != null ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text("${"note".tr()} :",
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_14,
                      AppColors.blackColor)),
              const SizedBox(height: 3),
              Text(result?.descriptions??"",
                  style: AppTextStyles.regularStyle(
                      AppFontSize.font_14,
                      AppColors.hintTextColor)),
            ],
          ):const SizedBox(),
        ],
      ),
    );
  }

  buildRow(text,decText){
    return  Row(
      children: [
        Text(text,
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_14,
                AppColors.blackColor)),
        const Spacer(),
        Text(decText,
            style: AppTextStyles.boldStyle(
                AppFontSize.font_14,
                AppColors.blackColor)),
      ],
    );
  }

  buildFeaturedDealersCard(List<Dealers>? dealers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Product Availability and Price",
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_18,
                  AppColors.blackColor)),
        ),
        Container(
          height: 170,
          width: double.infinity,
          color: AppColors.cardBgColor,
          child: GridView.builder(
            shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1),
              itemCount: dealers?.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, DealerDetailScreen.routeName,
                        arguments: [dealers![index].userId.toString()]);
                  },
                  child: Card(
                    color: AppColors.whiteColor,
                    margin: const EdgeInsets.all(10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          dealers?[index].user?.featured == "Yes"
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
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dealers?[index].user?.image == null
                                    ? Image.asset(
                                  AppImages.alQassemImage,
                                  width: 150,
                                  height: 50,
                                )
                                    : Image.network(
                                  baseImageUrl + dealers![index].user!.image!,
                                  height: 50,
                                  width: 150,
                                ),
                                const SizedBox(height: 10),
                                Text(dealers?[index].user?.name ?? "",
                                    style: AppTextStyles.boldStyle(AppFontSize.font_18, AppColors.blackColor)),
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Unavailable",
                                          style: AppTextStyles.mediumStyle(
                                              AppFontSize.font_12,
                                              AppColors.hintTextColor)),
                                      GestureDetector(
                                        onTap: () async {
                                          await context.read<UserProvider>().setReminderApi(userId: dealers?[index].user?.id.toString()).then((value){
                                            setState(() {
                                              if(value == 0){
                                                dealers?[index].isReminder = "No";
                                              }else{
                                                dealers?[index].isReminder = "Yes";
                                              }
                                            });
                                          });
                                        },
                                        child: Icon((dealers?[index].isReminder??"No") == "No" ? Icons.notifications_none : Icons.notifications,
                                            size: 26,color: AppColors.blackColor),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ]),
                  ),
                );
              }),
        ),
      ],
    );
  }

  buildCarImages(ResultData? result) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: baseImageUrl + (result?.imageUrl??""),
          placeholder: (context, url) => const Center(child: SizedBox(height: 60,width: 60,child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.fill,
          width: double.infinity,
          height: 240,
        ),
        Positioned(
          left: 16,
          top: 60,
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
      ],
    );
  }


}
