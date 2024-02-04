import 'package:autoparts/app_ui/screens/dashboard/cars_screen/car_listing_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealer_detail_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealers_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/products_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/seller_screen/sellers_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/favourite_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../api_service/api_config.dart';
import '../../../../constant/app_strings.dart';
import '../../../../main.dart';
import '../../../../models/favorites_list_model.dart';
import '../../../../provider/dealers_provider.dart';
import '../../../../utils/shared_preferences.dart';
import '../cars_screen/car_detail_screen.dart';
import '../parts_screens/product_detail_screen.dart';
import '../seller_screen/seller_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = "/favorites-page";

  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<TabItemModel> tabItem = [
    TabItemModel(id: 1, isStatus: true, name: "dealersNew".tr()),
    TabItemModel(id: 2, isStatus: false, name: "sealers".tr()),
    TabItemModel(id: 3, isStatus: false, name: "partsNew".tr()),
    TabItemModel(id: 4, isStatus: false, name: "carsNew".tr()),
  ];
  bool? checkIsLogin;

  int selectedIndex = 0;
  List<FavoritesList>? dealersList;
  List<FavoritesList>? carsList;
  List<FavoritesList>? partsList;

  @override
  void initState() {
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
            //extendBody: true,
              body: _buildBody(value));
        });
  }

  _buildBody(FavouriteProvider provider) {
    return Consumer<LoadingProvider>(
      builder: (BuildContext context, loading, Widget? child) {
        return Column(
          children: [
            customTabBar(),
            if (selectedIndex == 0) const Expanded(child: DealersScreen(isFav: true)),
            if (selectedIndex == 1) const Expanded(child: SellersScreen(isFav: true)),
            if (selectedIndex == 2) const Expanded(child: ProductsScreen(isFav: true)),
            if (selectedIndex == 3) const Expanded(child: CarListingScreen(isFav: true)),
          ],
        );
      },
    );
  }

  customTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      color: AppColors.cardBgColor,
      child: Row(
        children: List.generate(
          tabItem.length,
              (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 25),
              child: InkWell(
                onTap: () {
                  setState(() {
                    //dealer/seller/auto-part

                    selectedIndex = index;
                    for (var element in tabItem) {
                      element.isStatus = false;
                    }
                    tabItem[index].isStatus = true;
                    if (selectedIndex == 0) {
                      Future.microtask(() async {
                        await context.read<DealersProvider>().getDealerListApi(categoryId: sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString(),isFavOnly: true);
                      });
                    } else if (selectedIndex == 1) {
                      Future.microtask(() async {

                      });
                    } else if (selectedIndex == 2) {
                      Future.microtask(() async {
                      });
                    } else if (selectedIndex == 3) {
                      Future.microtask(() async {
                      });
                    }
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(tabItem[index].name,
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_18,
                            tabItem[index].isStatus
                                ? AppColors.blackColor
                                : AppColors.hintTextColor)),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      width: 15,
                      color: tabItem[index].isStatus
                          ? AppColors.blackColor
                          : AppColors.cardBgColor,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildDealersView(List<FavoritesList>? dealers) {
    dealersList = dealers;

    return Consumer<LoadingProvider>(
      builder: (BuildContext context, loading, Widget? child) {
        return (loading.isHomeLoading??false) ? Expanded(
          child: AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(6),
              physics: const BouncingScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: MediaQuery.of(context).size.width * .480,
              ),
              itemBuilder: (_, index) => AnimationConfiguration.staggeredGrid(
                columnCount: 2,
                position: index,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade600,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 30,top: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) : Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(6),
            physics: const BouncingScrollPhysics(),
            itemCount: dealers?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: MediaQuery.of(context).size.width * .480,
            ),
            itemBuilder: (_, index) => buildFavoritesDealersCard(dealers![index]),
          ),
        );
      },
    );
  }

  _buildSellersView(List<FavoritesList>? sellers) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(6),
        physics: const BouncingScrollPhysics(),
        itemCount: sellers?.length ?? 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: MediaQuery.of(context).size.width * .490,
        ),
        itemBuilder: (_, index) => buildFavoritesSellersCard(sellers![index]),
      ),
    );
  }

  _buildPartsView(List<FavoritesList>? parts) {
    partsList = parts;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Column(
              children: List.generate(parts?.length ?? 0,
                      (index) => buildFavoritesPartsCard(parts![index])),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  _buildCarsView(List<FavoritesList>? cars) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(6),
        physics: const BouncingScrollPhysics(),
        itemCount: cars?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (_, index) => buildFavoritesCarsCard(cars![index]),
      ),
    );
  }

  buildFavoritesDealersCard(FavoritesList data) {
    String formatted = '';
    for (var a in data.products!.dealerCategories!) {
      formatted += "${a.category?.name ?? ""}, ";
    }
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> DealerDetailScreen(dealerId: data.products?.id.toString()??"",)));
      },
      child: Card(
        color: AppColors.whiteColor,
        margin: const EdgeInsets.all(10),
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                data.products?.imageUrl == "Yes"
                    ? Container(
                    padding: const EdgeInsets.only(
                        left: 4, right: 4, top: 3, bottom: 1),
                    margin: const EdgeInsets.only(bottom: 15, right: 5),
                    decoration: BoxDecoration(
                      color: AppColors.brownColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Text("featured".tr(),
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_10, AppColors.whiteColor)))
                    : const SizedBox(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        data.products!.imageUrl != null
                            ? baseImageUrl + data.products!.imageUrl!
                            : demoImageUrlOLd,
                        width: 150,
                        height: 50,
                      ),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data.products?.name ?? "",
                                style: AppTextStyles.boldStyle(
                                    AppFontSize.font_18, AppColors.blackColor)),
                          ]),
                      const SizedBox(height: 5),
                      Text(
                          formatted.isNotEmpty
                              ? formatted.substring(0, formatted.length - 2)
                              : "",
                          style: AppTextStyles.mediumStyle(
                              AppFontSize.font_12, AppColors.hintTextColor)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: AppColors.startMarkColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${data.products?.avgRate ?? "0"}/${data.products?.totalRate ?? "0"}",
                                style: AppTextStyles.boldStyle(
                                    AppFontSize.font_14,
                                    AppColors.hintTextColor)),
                          ]),
                          GestureDetector(
                            onTap: () async {
                              await context.read<FavouriteProvider>().addRemoveFav(data.products?.id ?? "", "dealer");
                              setState(() {});
                            },
                            child: Image.asset(
                              AppImages.favoritesIcon,
                              color: AppColors.btnBlackColor,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildFavoritesSellersCard(FavoritesList data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SellerDetailsScreen.routeName,
            arguments: [data.products?.id.toString()??""]);
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
          elevation: 7,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  data.products?.imageUrl != null
                      ? baseImageUrl + data.products!.imageUrl!
                      : demoImageUrlOLd,
                  width: 150,
                  height: 70,
                ),
              ),
              SizedBox(
                width: 150,
                child: Text(data.products?.name ?? "",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_18, AppColors.blackColor)),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: AppColors.startMarkColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                          "${data.products?.avgRate ?? "0"}/${data.products?.totalRate ?? "0"}",
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_14, AppColors.hintTextColor)),
                    ]),
                    GestureDetector(
                      onTap: () async {
                        await context.read<FavouriteProvider>().addRemoveFav(data.products?.id ?? "", "seller");
                        // dealersList?.removeWhere((item) => item.id == data.products?.id);
                      },
                      child: Image.asset(
                        AppImages.favoritesIcon,
                        color: AppColors.btnBlackColor,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          )),
    );
  }

  buildFavoritesPartsCard(FavoritesList data) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, ProductDetailScreen.routeName);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetailScreen(detailsId: data.products?.id.toString()??"",)));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 86,
                width: 95,
                decoration: BoxDecoration(
                  color: AppColors.cardBgColor,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Image.network(
                  data.products?.imageUrl != null
                      ? baseImageUrl + data.products!.imageUrl!
                      : demoImageUrlOLd,
                ),
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
                          Text(data.products?.name ?? "",
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
                                  await context.read<FavouriteProvider>().addRemoveFav(data.products?.id ?? "", "auto-part");
                                  partsList?.removeWhere(
                                          (item) => item.id == data.products?.id);
                                },
                                child: Image.asset(
                                  AppImages.favoritesIcon,
                                  fit: BoxFit.fill,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 5),
                    Text(data.products?.name ?? "",
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.hintTextColor)),
                    const SizedBox(height: 5),
                    Text(data.products?.name ?? "",
                        style: AppTextStyles.regularStyle(
                            AppFontSize.font_14, AppColors.blackColor)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* Text(
                              data.products?.name ?? "" != 0
                                  ? "availableSmall".tr()
                                  : "unAvailableSmall".tr(),
                              style: AppTextStyles.mediumStyle(
                                  AppFontSize.font_12,
                                  AppColors.hintTextColor))*/
                          Text('AED ${data.products?.price ?? ""} ',
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

  buildFavoritesCarsCard(FavoritesList data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CarDetailScreen(detailsId: data.productId)));
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
                        (data.products?.image??"").isNotEmpty
                            ? baseImageUrl + (data.products?.image??"")
                            : demoImageUrlOLd,
                      ),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitleCard(data.products?.grade ?? "".toUpperCase(), AppColors.brownColor),
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
                        '${data.products?.make?.title ?? ""}  ${data.products?.model?.title ?? ""} | ${data.products?.carCategory?.name ?? ""}',
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AED ${data.products?.price?.toStringAsFixed(2) ?? ""} ',
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_16, AppColors.hintTextColor)),
                        // GestureDetector(
                        //   onTap: () async {
                        //     if (checkIsLogin!) {
                        //       await context.read<FavouriteProvider>().addRemoveFav(result?.id.toString(), "cars");
                        //       setState(() {
                        //         if (data. == 0) {
                        //           result?.isFav = 1;
                        //         } else {
                        //           result?.isFav = 0;
                        //         }
                        //       });
                        //     } else {
                        //       pleaseLogin(context);
                        //     }
                        //   },
                        //   child: Image.asset(
                        //     result?.isFav == 0
                        //         ? AppImages.favOutlineGrey
                        //         : AppImages.favoritesIcon,
                        //     fit: BoxFit.fill,
                        //     height: 20,
                        //     width: 20,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(data.products?.transmissionType ?? "",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_14, AppColors.blackColor)),
                        const Spacer(),
                        Text(data.products?.region ?? "",
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
                              Text(data.products?.year ?? "",
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
                              Text('${data.products?.totalRunning ?? ""} km',
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

  Widget shimmerDealer(){
    return Expanded(child:
    AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(6),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: MediaQuery.of(context).size.width * .470,
        ),
        itemBuilder: (_, index) => AnimationConfiguration.staggeredGrid(
          columnCount: 2,
          position: index,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: Card(
                  color: AppColors.whiteColor,
                  margin: const EdgeInsets.all(10),
                  elevation: 7,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          overflow: Overflow.visible,
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        defaultShimmer(
                                            child: const Icon(Icons.image,size: 70,)
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          defaultShimmer(child: Container(color: Colors.grey,height: 13,width: 100)),
                                          defaultShimmer(child: Image.asset(
                                            AppImages.favoritesIcon,
                                            fit: BoxFit.fill,
                                            height: 20,
                                            width: 20,
                                          ),),
                                        ]),
                                    const SizedBox(height: 4),
                                    defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 70)),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      defaultShimmer(child: const Icon(
                                        Icons.star,
                                        size: 20,
                                        color: AppColors.startMarkColor,
                                      ),),
                                      const SizedBox(width: 5),
                                      defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 30)),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: -8,
                                child: defaultShimmer(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 6),
                                    margin: const EdgeInsets.only(bottom: 15, right: 5),
                                    decoration: BoxDecoration(
                                      color: AppColors.brownColor,
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ])),
            ),
          ),
        ),
      ),
    ));
  }
  Widget shimmerSeller(){
    return Expanded(
      child: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(6),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: MediaQuery.of(context).size.width * .470,
          ),
          itemBuilder: (_, index) => AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: Card(
                    color: AppColors.whiteColor,
                    margin: const EdgeInsets.all(10),
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          defaultShimmer(
                                              child: const Icon(Icons.image,size: 70,)
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            defaultShimmer(child: Container(color: Colors.grey,height: 13,width: 100)),
                                            defaultShimmer(child: Image.asset(
                                              AppImages.favoritesIcon,
                                              fit: BoxFit.fill,
                                              height: 20,
                                              width: 20,
                                            ),),
                                          ]),
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        defaultShimmer(child: const Icon(
                                          Icons.star,
                                          size: 20,
                                          color: AppColors.startMarkColor,
                                        ),),
                                        const SizedBox(width: 5),
                                        defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 30)),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -16,
                                  right: 6,
                                  child: defaultShimmer(
                                      child: Image.asset("assets/images/ic_verified.png",height: 20,width: 20,)
                                  )
                              ),
                            ],
                          ),
                        ])),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget shimmerParts(){
    return Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: 6,
              itemBuilder: (_, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: SizedBox(
                        height: 110,
                        child: Card(
                            color: AppColors.whiteColor,
                            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                      baseColor: Colors.grey.shade400,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(width: 100,height: 70,decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10)),margin: const EdgeInsets.symmetric(
                                          horizontal: 10
                                      ))),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(width: 90,height: 12,margin: const EdgeInsets.only(left: 10,top: 5),color: Colors.white)),
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(width: 100,height: 10,margin: const EdgeInsets.only(left: 10,top: 20),color: Colors.white)),
                                      Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(width: 80,height: 8,margin: const EdgeInsets.only(left: 10,top: 10),color: Colors.white)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey.shade400,
                                            highlightColor: Colors.grey.shade100,
                                            child: Container(width: 20,height: 20,margin: const EdgeInsets.only(left: 10,top: 5),color: Colors.white)),
                                        Shimmer.fromColors(
                                            baseColor: Colors.grey.shade400,
                                            highlightColor: Colors.grey.shade100,
                                            child: Container(width: 20,height: 20,margin: const EdgeInsets.only(left: 10,top: 20),color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
    );
  }
  Widget shimmerCars(){
    return Expanded(
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(6),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Card(
                  color: AppColors.whiteColor,
                  margin: const EdgeInsets.all(10),
                  elevation: 7,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(flex: 3,child: defaultShimmer(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 50,top: 50,right: 20,left: 20),
                              child: Image.asset("assets/images/car_placeholder.png"),
                            )
                        ),),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                defaultShimmer(child: Container(color: Colors.grey,height: 13,width: 150)),
                                const SizedBox(height: 8),
                                defaultShimmer(child: Container(color: Colors.grey,height: 13,width: 70)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 40)),
                                    defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 70)),
                                  ],),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 60)),
                                    defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 60)),
                                  ],),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget defaultShimmer({required Widget child}){
    return Shimmer.fromColors(child: child, baseColor: Colors.grey.shade500,
      highlightColor: Colors.grey.shade100,);
  }

}

class TabItemModel {
  int id;
  bool isStatus;
  String name;

  TabItemModel({required this.id, required this.isStatus, required this.name});
}
