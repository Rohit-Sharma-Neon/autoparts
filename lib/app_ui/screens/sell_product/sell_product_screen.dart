import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/sell_product/add_new_product_screen.dart';
import 'package:autoparts/app_ui/screens/sell_product/sell_existing_product_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/product_list_model.dart';
import 'package:autoparts/provider/products_provider.dart';
import 'package:autoparts/utils/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../api_service/api_config.dart';
import '../../../main.dart';
import '../../../models/products_parts_model.dart';
import '../../../provider/favourite_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../common_widget/show_dialog.dart';

class SellProductScreen extends StatefulWidget {
  static const  routeName = "/sell-product";
  const SellProductScreen({Key? key}) : super(key: key);

  @override
  _SellProductScreenState createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {

  bool? checkIsLogin;

  @override
  void initState() {
    checkIsLogin = sp?.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    super.initState();
    Future.microtask(() async {
      await context.read<ProductsProvider>().productPartsApi();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.cardBgColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [customAppbar(), _textField(), _buildBody(),buildSellProduct(),],
        ));
  }

  _buildBody() {
    return Consumer<ProductsProvider>(
    builder: (BuildContext context, value, Widget? child) {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          itemCount: value.productData?.length??0,
          itemBuilder: (BuildContext context, int index) {
            return buildTopProductsSaleCard(value.productData![index]);
          },
        ),
      );
    },
    );
  }

  buildTopProductsSaleCard(ProductData data) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SellExistingProductScreen(productId: data.id.toString(), productNumber: data.partNumber??"",)));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: baseImageUrl + (data.imageUrl??""),
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
                          Text(data.name ?? "",
                              style: AppTextStyles.boldStyle(
                                  AppFontSize.font_18, AppColors.blackColor)),
                          GestureDetector(
                            onTap: () async {
                              if (checkIsLogin!) {
                                await context.read<FavouriteProvider>().addRemoveFav(data.id.toString(), "auto-part");
                                setState(() {
                                  if (data.isFav == 0) {
                                    data.isFav = 1;
                                  } else {
                                    data.isFav = 0;
                                  }
                                });
                              } else {
                                pleaseLogin(context);
                              }
                            },
                            child: Image.asset(
                              data.isFav == 0
                                  ? AppImages.favOutline
                                  : AppImages.favoritesIcon,
                              height: 25,
                              width: 28,
                              color: AppColors.btnBlackColor,
                            ),
                          ),
                        ]),
                    const SizedBox(height: 5),
                    Text(data.name ?? "",
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.hintTextColor)),
                    const SizedBox(height: 5),
                    Text(data.partNumber ?? "",
                        style: AppTextStyles.regularStyle(
                            AppFontSize.font_14, AppColors.blackColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildSellProduct() {
    return Card(
        color: AppColors.whiteColor,
        margin: const EdgeInsets.only(left: 16, right: 16,bottom: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Image.asset(
                    AppImages.sellFile,
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(height: 20),
                  Text("enterYourOwn".tr(),
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_18, AppColors.blackColor)),
                  const SizedBox(height: 10),
                  Text("couldNtFind".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.hintTextColor)),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AddNewProductScreen.routeName);
                      },
                      child: SubmitButton(
                        height: 40,
                        color: AppColors.btnBlackColor,
                        value: "create".tr().toUpperCase(),
                        textColor: Colors.white,
                        textStyle: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.whiteColor),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ));
  }

  _textField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        padding: const EdgeInsets.only(bottom: 16),
        hintText: "partNumber".tr(),
        icon: const Icon(Icons.search, color: Colors.black54),
        fillColor: AppColors.whiteColor,
      ),
    );
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            const SizedBox(width: 20),
            Text("Sell Individual Parts",
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
            const Spacer(),
            GestureDetector(
              onTap: (){
                uploadCSVAlertBox();
              },
              child: Row(
                children: [
                  Image.asset(
                    AppImages.upload,
                    fit: BoxFit.fill,
                    height: 18,
                    width: 18,
                    color: AppColors.greyColor,
                  ),
                  const SizedBox(width: 8),
                  Text("CSV",
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.submitGradiantColor1)),
                ],
              ),
            )
          ])),
    );
  }

  void uploadCSVAlertBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: alertBoxBody()),
      ),
    );
  }

  alertBoxBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        alertBoxTopBar(),
        SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: ButtonWithIcon(
                          height: 55,
                          value: "uploadCsv".tr().toUpperCase(),
                          icon: AppImages.upload,
                          textColor: Colors.white,
                          textStyle: AppTextStyles.mediumStyle(
                              AppFontSize.font_16, AppColors.whiteColor),
                        ))),
                const SizedBox(height: 16),
                GestureDetector(
                    onTap: () {
                      UrlLauncher.launchURL("http://3.20.147.34:3001/part_sample_file.csv");
                    },
                    child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: ButtonWithIcon(
                          height: 55,
                          value: "downloadSampleData".tr().toUpperCase(),
                          textColor: Colors.white,
                          icon: AppImages.download,
                          textStyle: AppTextStyles.mediumStyle(
                              AppFontSize.font_16, AppColors.whiteColor),
                        ))),
                const SizedBox(height: 16),
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
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  AppImages.circleCrossIcon,
                  height: 35,
                  width: 35,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
