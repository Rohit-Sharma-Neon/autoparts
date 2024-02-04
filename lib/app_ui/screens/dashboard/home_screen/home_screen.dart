import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/screens/dashboard/cars_screen/car_detail_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/cars_screen/car_listing_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/cars_screen/top_category_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealers_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/product_detail_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/products_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/favourite_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/material.dart";
import "package:easy_localization/easy_localization.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../api_service/api_config.dart';
import '../../../../main.dart';
import '../../../../models/home_data_model.dart';
import '../../../../provider/dashboard_provider.dart';
import '../../../../utils/shared_preferences.dart';
import '../dealers/dealer_detail_screen.dart';
import '../seller_screen/seller_details_screen.dart';
import '../seller_screen/sellers_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  String categoryTypeId = "";

  @override
  void initState() {
    categoryTypeId = sp?.getInt(SpUtil.CATEGORY_ID).toString()??"";
    super.initState();
    Future.microtask(() async {
      await context.read<DashboardProvider>().getHomeDataApi(sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider,LoadingProvider>(builder: (BuildContext context, value, loading, Widget? child) {
      return Scaffold(backgroundColor: AppColors.whiteColor, body: buildBody(value,loading));
    });
  }

  buildBody(DashboardProvider value, LoadingProvider loading) {
    return SingleChildScrollView(
      physics: (loading.isHomeLoading??false) ? const NeverScrollableScrollPhysics() : null,
      child: AnimationLimiter(
        child: Column(
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                value.banner != null
                    ? _buildCarouselSlider(value.banner,loading)
                    : const SizedBox(),
                const SizedBox(height: 16),
                value.topCategories != null
                    ? Column(
                  children: [
                    buildSeeAllRow("topCategories".tr(),enableSeeAll: (value.topCategories?.length??0)>5),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          (value.topCategories?.length ?? 0) > 5 ? 5 : value.topCategories?.length ?? 0,
                              (position) {
                            return buildTopCategoriesCard(value.topCategories![position],loading);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
                    : const SizedBox(),
                value.dealers != null
                    ? Column(
                  children: [
                    buildSeeAllRow("dealerSmall".tr(),enableSeeAll: (value.dealers?.length??0)>5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          value.dealers?.length ?? 0,
                              (position) {
                            return buildFeaturedDealersCard(value.dealers![position],loading);
                          },
                        ),
                      ),
                    ),
                  ],
                )
                    : const SizedBox(),
                value.sellers != null
                    ? Column(
                  children: [
                    buildSeeAllRow("sellers".tr(),enableSeeAll: (value.sellers?.length??0)>5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          value.sellers?.length ?? 0,
                              (position) {
                            return buildSellersCard(value.sellers![position],loading);
                          },
                        ),
                      ),
                    ),
                  ],
                )
                    : const SizedBox(),
                value.bannerOne != null
                    ? _buildCarouselSliderNew(value.bannerOne)
                    : const SizedBox(),
                const SizedBox(height: 16),
                value.topCarsForSale != null
                    ? Column(
                  children: [
                    buildSeeAllRow(categoryTypeId == "1" ? "carSale".tr() : "carPartsSale".tr(),enableSeeAll: true),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: categoryTypeId == "1" ? List.generate(
                            (value.topCarsForSale?.length ?? 0) > 5 ? 5 : value.topCarsForSale?.length ?? 0,
                                (position) {
                              return buildTopCarSaleCard(value.topCarsForSale![position]);
                            },
                          ) : List.generate(
                            (value.topProductForSale?.length ?? 0) > 5 ? 5 : value.topProductForSale?.length ?? 0,
                                (position) {
                              return buildTopProductsSaleCard(value.topProductForSale![position]);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
                    : const SizedBox(),
                value.bannerOne != null
                    ? _buildCarouselSliderNew(value.bannerOne)
                    : const SizedBox(),
                const SizedBox(height: 16),
                categoryTypeId == "2" ?
                value.featuredProduct != null
                    ? Column(
                  children: [
                    buildSeeAllRow(categoryTypeId == "1" ? "featuredCars".tr() : "featuredProduct".tr(),enableSeeAll: (value.featuredProduct?.length??0)>5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          value.featuredProduct?.length ?? 0,
                              (position) {
                            return buildFeaturedProductsCard(value.featuredProduct![position]);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                )
                    : const SizedBox()
                    : value.featuredCar != null
                    ? Column(
                  children: [
                    buildSeeAllRow("featuredCars".tr(),enableSeeAll: true),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            children: List.generate(
                              (value.featuredCar?.length ?? 0) > 5 ? 5 :value.featuredCar?.length ?? 0,
                                  (position) {
                                return buildFeaturedCars(value.featuredCar![position]);
                              },
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                )
                    : const SizedBox(),
                const SizedBox(height: 100,)
              ],
            )
        ),
      ),
    );
  }

  buildSeeAllRow(name, {required bool enableSeeAll}) {
    return Consumer<LoadingProvider>(
      builder: (BuildContext context, loading, Widget? child) {
        return (loading.isHomeLoading??false)
            ? Shimmer.fromColors(
          baseColor: Colors.grey.shade600,
          highlightColor: Colors.grey.shade100,
          enabled: (loading.isHomeLoading??false),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Container(
                  color: (loading.isHomeLoading??false) ? Colors.transparent : Colors.transparent,
                  child: Text(name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_20, AppColors.blackColor)),
                ),
                const Spacer(),
                // enableSeeAll ?
                Container(
                  // color: (loading.isHomeLoading??false) ? Colors.red : Colors.transparent,
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
                )
                // : const SizedBox(),
              ])),
        )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Container(
                    color: (loading.isHomeLoading??false) ? Colors.transparent : Colors.transparent,
                    child: Text(name,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_20, AppColors.blackColor)),
                  ),
                  const Spacer(),
                  // enableSeeAll ?
                  GestureDetector(
                    onTap: (loading.isHomeLoading??false) ? (){} : () {
                      if (name == "topCategories".tr()) {
                        // Navigator.pushNamed(context, PartsScreens.routeName);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const TopCategoriesScreen()));
                      }
                      if (name == "dealerSmall".tr()) {
                        // Provider.of<LoadingProvider>(context,listen: false).setHomeLoading(status: true);
                        Navigator.pushNamed(context, DealersScreen.routeName);
                      }
                      if (name == "sellers".tr()) {
                        Navigator.pushNamed(context, SellersScreen.routeName);
                      }
                      if (name == "carSale".tr() || name == "carPartsSale".tr()) {
                        if (categoryTypeId == "1") {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CarListingScreen(categoryName: "carSale".tr(),isFromBottomTab: false,)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(categoryName: categoryTypeId == "1" ? "Top Cars for Sale" : "Top Car Parts Sale",)));
                        }
                      }
                      // if(name == "featuredCars".tr()){
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => CarListingScreen(categoryName: "featuredCars".tr(),)));
                      // }
                      if (name == "featuredProduct".tr() || name == "featuredCars".tr()) {
                        if (categoryTypeId == "1") {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CarListingScreen(categoryName: "featuredCars".tr(),isFeatured: "Yes",isFromBottomTab: false,)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsScreen(categoryName: "featuredProduct".tr(),isFeatured: "Yes")));
                        }
                      }
                    },
                    child: Container(
                      // color: (loading.isHomeLoading??false) ? Colors.red : Colors.transparent,
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
                ]));
      },
    );
  }

  buildTopCategoriesCard(TopCategories data,LoadingProvider loading) {
    String categoryId = sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString();
    return GestureDetector(
      onTap: (loading.isHomeLoading??false) ? (){} : (){
        if (categoryId == "1") {
          // Navigator.pushNamed(context, CarListingScreen.routeName, arguments: [data.id.toString()]);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CarListingScreen(categoryName: data.name??"",detailsId: data.id.toString(),)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(productCategoryId: data.id.toString(),categoryName: data.name??"",)));
        }
      },
      child: Container(
        alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 16),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              color: AppColors.btnBlackColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 (loading.isHomeLoading??false) ? Shimmer.fromColors(
                 baseColor: Colors.grey.shade800,
                 highlightColor: Colors.grey.shade400,
                 enabled: (loading.isHomeLoading??false),
                 child: Container(
                 color: Colors.red,
                 width: 70,
                 height: 60,
              ),
            ) : Container(
            color: (loading.isHomeLoading??false) ? Colors.red : Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                data.image != null ? baseImageUrl + data.image! : demoImageUrlOLd,
                width: 70,
                height: 60,
              ),
            ),
          ),
                (loading.isHomeLoading??false) ? Shimmer.fromColors(
                baseColor: Colors.grey.shade600,
                highlightColor: Colors.grey.shade100,
                enabled: (loading.isHomeLoading??false),
                child: Container(color: (loading.isHomeLoading??false) ? Colors.red : Colors.transparent,
                child: Text("data.name", style: AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.whiteColor),maxLines: 2,overflow: TextOverflow.ellipsis,
                ))): Text(data.name ?? "", style: AppTextStyles.boldStyle(AppFontSize.font_16, AppColors.whiteColor),maxLines: 2,overflow: TextOverflow.ellipsis,
                ),
          ])),
    );
  }

  buildFeaturedDealersCard(Dealers data,LoadingProvider loading) {
    return (loading.isHomeLoading??false) ?
    Shimmer.fromColors(
      baseColor: Colors.grey.shade600,
      highlightColor: Colors.grey.shade100,
      enabled: (loading.isHomeLoading??false),
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
          elevation: 7,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              data.featured == "Yes" ?
              Container(
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 3, bottom: 1),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.brownColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text("featured".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_10, AppColors.whiteColor))):const SizedBox(),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      data.image != null
                          ? baseImageUrl + data.image!
                          : demoImageUrlOLd,
                      width: 150,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(data.name??"",style: TextStyle(color: Colors.black),),
                ],
              ),
            ],
          )),
    ) : GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DealerDetailScreen.routeName,
            arguments: [data.id.toString()]);
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
          elevation: 7,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              data.featured == "Yes" ?
              Container(
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 3, bottom: 1),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.brownColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text("featured".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_10, AppColors.whiteColor))):const SizedBox(),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      data.image != null
                          ? baseImageUrl + data.image!
                          : demoImageUrlOLd,
                      width: 150,
                      height: 70,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(data.name ?? "",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          )),
    );
  }

  buildSellersCard(Sellers data,LoadingProvider loading) {
    return  (loading.isHomeLoading??false) ? Shimmer.fromColors(
      baseColor: Colors.grey.shade600,
      highlightColor: Colors.grey.shade100,
      enabled: (loading.isHomeLoading??false),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, SellerDetailsScreen.routeName, arguments: [data.id.toString()]);
        },
        child: Card(
            color: AppColors.whiteColor,
            margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: baseImageUrl + (data.image??demoImageUrlOLd),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.network(
                          demoImageUrlOLd,
                          width: 55,
                          height: 55,
                        ),
                        height: 55,
                        width: 55,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150,
                      child: Text(data.name ?? "",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_18, AppColors.blackColor)),
                    ),
                    const SizedBox(height: 5),
                    Row(children: [
                      data.avgRate.toString() != null && data.avgRate.toString().isNotEmpty && data.avgRate.toString() != "null" ?
                       const Icon(
                        Icons.star,
                        size: 20,
                        color: AppColors.startMarkColor,
                      ):const SizedBox(),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          data.avgRate.toString().isNotEmpty && data.avgRate.toString() != "null" ?
                          Text("${data.avgRate.toString().isNotEmpty && data.avgRate.toString() != "null" ? data.avgRate.toString() : ""}",
                              style: AppTextStyles.boldStyle(
                                  AppFontSize.font_12, AppColors.blackBottomColor)): const SizedBox(),
                          const SizedBox(width: 4),
                          data.totalRate.toString() != "0" && data.totalRate.toString().isNotEmpty && data.totalRate.toString() != "null" ?
                          Text("(${data.totalRate.toString() != "0" && data.totalRate.toString().isNotEmpty && data.totalRate.toString() != "null" ? data.totalRate.toString():""} Review)",
                              style: AppTextStyles.boldStyle(
                                  AppFontSize.font_12, AppColors.blackBottomColor)):const SizedBox(),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 10),
                  ],
                ),
                data.sellerVerify == "Yes" ?
                Padding(padding: const EdgeInsets.all(4),
                child: Image.asset("assets/images/ic_verified.png",height: 20,width: 20,)):const SizedBox(),
              ],
            )),
      ),
    ):GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SellerDetailsScreen.routeName, arguments: [data.id.toString()]);
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
          elevation: 7,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: baseImageUrl + (data.image??demoImageUrlOLd),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                        demoImageUrlOLd,
                        width: 55,
                        height: 55,
                      ),
                      height: 55,
                      width: 55,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 150,
                    child: Text(data.name ?? "",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                  ),
                  const SizedBox(height: 5),
                  Row(children: [
                    data.avgRate.toString() != null && data.avgRate.toString().isNotEmpty && data.avgRate.toString() != "null" ?
                    const Icon(
                      Icons.star,
                      size: 20,
                      color: AppColors.startMarkColor,
                    ):const SizedBox(height: 20),
                    const SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: [
                        data.avgRate.toString().isNotEmpty && data.avgRate.toString() != "null" ?
                        Text("${data.avgRate.toString().isNotEmpty && data.avgRate.toString() != "null" ? data.avgRate.toString() : ""}",
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_12, AppColors.blackBottomColor)): const SizedBox(),
                        const SizedBox(width: 4),
                        data.totalRate.toString() != "0" && data.totalRate.toString().isNotEmpty && data.totalRate.toString() != "null" ?
                        Text("(${data.totalRate.toString() != "0" && data.totalRate.toString().isNotEmpty && data.totalRate.toString() != "null" ? data.totalRate.toString():""} Review)",
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_12, AppColors.blackBottomColor)):const SizedBox(),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 10),
                ],
              ),
              data.sellerVerify == "Yes" ?
              Padding(padding: const EdgeInsets.all(4),
                  child: Image.asset("assets/images/ic_verified.png",height: 20,width: 20,)):const SizedBox(),
            ],
          )),
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

  alertBoxBody(FeaturedProduct data) {
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
                            data.imageUrl != null
                                ? baseImageUrl + data.imageUrl!
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
                                Text(data.name ?? "",
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
                          Text(data.name ?? "",
                              style: AppTextStyles.mediumStyle(
                                  AppFontSize.font_14,
                                  AppColors.hintTextColor)),
                          const SizedBox(height: 7),
                          Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: AppColors.brownColor,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Text("available".tr(),
                                  style: AppTextStyles.mediumStyle(
                                      AppFontSize.font_10,
                                      AppColors.whiteColor))),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text("description".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_20, AppColors.blackBottomColor)),
                const SizedBox(height: 10),
                Text(data.descriptions ?? "",
                    style: AppTextStyles.regularStyle(
                        AppFontSize.font_14, AppColors.hintTextColor)),
              ],
            ))
      ],
    );
  }

  void productDetailAlertBox(FeaturedProduct data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: alertBoxBody(data)),
      ),
    );
  }

  buildFeaturedProductsCard(FeaturedProduct data) {
    return GestureDetector(
      onTap: () {
        // productDetailAlertBox(data);
        Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: [data.id.toString()]);
      },
      child: SizedBox(
        width: 190,
        height: 180,
        child: Card(
            color: AppColors.whiteColor,
            margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    (data.partCondition ?? "").isNotEmpty ?
                Container(
                    padding: const EdgeInsets.only(
                        left: 4, right: 4, top: 3, bottom: 1),
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.brownColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Text(data.partCondition ?? "",
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_10, AppColors.whiteColor))):const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.network(
                          data.imageUrl != null
                              ? baseImageUrl + data.imageUrl!
                              : demoImageUrlOLd,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Text(data.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_16, AppColors.blackColor)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ]),
            )),
      ),
    );
  }

  buildTopCarSaleCard(TopCarsForSale data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CarDetailScreen(detailsId: data.id.toString(),sellRecordId: data.sellRecordId.toString())));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        data.image != null
                            ? baseImageUrl + (data.image??"")
                            : demoImageUrlOLd,
                      ),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitleCard(data.grade ?? "".toUpperCase(), AppColors.brownColor),
                    buildTitleCard("7 ${"photos".tr()}", AppColors.blackColor),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${data.make?.title ?? ""}  ${data.model?.title ?? ""} | ${data.carCategory?.name ?? ""}',
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 5),
                    Text('AED ${data.price?.toStringAsFixed(2) ?? ""} ',
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_16, AppColors.hintTextColor)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(data.transmissionType ?? "",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_14, AppColors.blackColor)),
                        const Spacer(),
                        Text(data.region ?? "",
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_14, AppColors.brownColor)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppImages.calendar,
                                fit: BoxFit.fill,
                                height: 20,
                                width: 20,
                                color: AppColors.btnBlackColor,
                              ),
                              const SizedBox(width: 10),
                              Text(data.year ?? "",
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                AppImages.meterWifi,
                                fit: BoxFit.fill,
                                color: AppColors.btnBlackColor,
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 10),
                              Text('${data.kmDriven ?? ""} km',
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                            ],
                          ),
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

  buildFeaturedCars(FeaturedCar data) {
    return GestureDetector(
      onTap: () {
        ///Navigator.pushNamed(context, CarDetailScreen.routeName);
        Navigator.pushNamed(context, CarDetailScreen.routeName,arguments: [data.id.toString()]);
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        data.image != null
                            ? baseImageUrl + (data.image??"")
                            : demoImageUrlOLd,
                      ),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitleCard(data.grade ?? "".toUpperCase(), AppColors.brownColor),
                    buildTitleCard("7 ${"photos".tr()}", AppColors.blackColor),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${data.make?.title ?? ""}  ${data.model?.title ?? ""} | ${data.carCategory?.name ?? ""}',
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 5),
                    Text('AED ${data.price?.toStringAsFixed(2) ?? ""} ',
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_16, AppColors.hintTextColor)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(data.transmissionType ?? "",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_14, AppColors.blackColor)),
                        const Spacer(),
                        Text(data.region ?? "",
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_14, AppColors.brownColor)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppImages.calendar,
                                fit: BoxFit.fill,
                                height: 20,
                                width: 20,
                                color: AppColors.btnBlackColor,
                              ),
                              const SizedBox(width: 10),
                              Text(data.year ?? "",
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(
                                AppImages.meterWifi,
                                fit: BoxFit.fill,
                                color: AppColors.btnBlackColor,
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 10),
                              Text('${data.totalRunning ?? ""} km',
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                            ],
                          ),
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

  buildTopProductsSaleCard(TopProductForSale data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetailScreen(detailsId: data.id.toString())));
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
                              // GestureDetector(
                              //   onTap: () async {
                              //     if (checkIsLogin!) {
                              //       await context.read<FavouriteProvider>().addRemoveFav(data.id.toString(), "auto-part");
                              //       setState(() {
                              //         if (data.isFav == 0) {
                              //           data.isFav = 1;
                              //         } else {
                              //           data.isFav = 0;
                              //         }
                              //       });
                              //     } else {
                              //       pleaseLogin(context);
                              //     }
                              //   },
                              //   child: Image.asset(
                              //     data.isFav == 0
                              //         ? AppImages.favOutlineGrey
                              //         : AppImages.favoritesIcon,
                              //     fit: BoxFit.fill,
                              //     height: 20,
                              //     width: 20,
                              //   ),
                              // ),
                            ],
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              data.qty != 0
                                  ? "availableSmall".tr()
                                  : "unAvailableSmall".tr(),
                              style: AppTextStyles.mediumStyle(
                                  AppFontSize.font_12,
                                  AppColors.hintTextColor)),
                          Text('AED ${data.price ?? ""} ',
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

  buildTitleCard(text, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            padding:
                const EdgeInsets.only(left: 4, right: 4, top: 3, bottom: 1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(text,
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_10, AppColors.whiteColor))),
      ],
    );
  }

  _buildCarouselSlider(List<BannerList>? list,LoadingProvider loading) {
    return (loading.isHomeLoading??false) ? Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade100,
      child: Stack(
        // alignment: Alignment.bottomCenter,
        overflow: Overflow.visible,
        children: [
          Row(mainAxisSize: MainAxisSize.min,children: [
            Container(decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.red),)
          ]
          ),
          Container(
            height: 175,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ],
      ),
    ) : Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              autoPlay: true,
              height: 175,
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
          items: list!.map<Widget>((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(productCategoryId: i.bannerUrl??"",categoryName: i.category?.name??"",)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                      image: DecorationImage(
                        image: NetworkImage(
                          i.bannerImage != null
                              ? baseImageUrl + i.bannerImage!
                              : demoImageUrlOLd,
                        ),
                        fit: BoxFit.fill,
                      )
                    ),
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

  _buildCarouselSliderNew(List<BannerOne>? list) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              autoPlay: true,
              height: 175,
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
          items: list!.map<Widget>((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(productCategoryId: i.bannerUrl??"",categoryName: i.user?.name??"",)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        image: DecorationImage(
                          image: NetworkImage(
                            i.bannerImage != null
                                ? baseImageUrl + i.bannerImage!
                                : demoImageUrlOLd,
                          ),
                          fit: BoxFit.fill,
                        )),
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
        ),
      ],
    );
  }
}
