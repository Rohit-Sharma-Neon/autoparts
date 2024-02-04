import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealer_detail_screen.dart';
import 'package:autoparts/app_ui/screens/dashboard/dealers/dealers_screen.dart';
import "package:autoparts/app_ui/screens/dashboard/parts_screens/product_detail_screen.dart";
import "package:autoparts/app_ui/screens/dashboard/seller_screen/seller_details_screen.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:autoparts/constant/app_strings.dart';
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/car_category_model.dart';
import 'package:autoparts/models/part_categories_list.dart';
import 'package:autoparts/models/products_part_category_list.dart';
import 'package:autoparts/models/products_parts_model.dart';
import 'package:autoparts/provider/auth_provider.dart';
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/favourite_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/provider/products_provider.dart';
import 'package:autoparts/utils/search_utility.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:autoparts/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = "/parts-page";
  final String? from;
  final String? categoryName;
  final String? productCategoryId;
  final String? isFeatured;
  final bool isFav;

  const ProductsScreen({Key? key, this.from, this.categoryName,this.productCategoryId, this.isFeatured,this.isFav = false}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _vehicleClassController = TextEditingController();
  List<CategoryModel> selectCategoryList = [];
  List<CategoryModel> selectVehicleClassList = [];
  bool? checkIsLogin;
  List<ItemModel> listItem = [];
  bool isListType = true;
  static List<FilterCategories>? categories = [];
  ProductsPartCategoryModel? productsPartCategoryModel;
  bool toggle = false;
  bool dateToggle = false;
  bool aTOz = false;
  bool isDateATOz = false;
  String? sortAtoz = "ZtoA";
  String? dateAtoz = "Date_ZtoA";
  String categoryTypeId = "";
  @override
  void initState() {
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    context.read<DealersProvider>().clearSearchedProducts();
    categoryTypeId = sp?.getInt(SpUtil.CATEGORY_ID).toString()??"";
    Future.microtask(() async {
      context.read<CarProvider>().getTopCategoriesApi(categoryTypeId,showLoader: false);
        await context.read<DealersProvider>().productPartsApi(categoryId: categoryTypeId,
            productsCategoryId: widget.productCategoryId??"",isFeatured: widget.isFeatured??"",isFavOnly: widget.isFav);
      categories = context.read<ProductsProvider>().categories;
    });
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    listItem.add(ItemModel(isStatus: false));
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  onSearchTextChanged(String text, DealersProvider value) async {
    value.clearSearchedProducts();
    if (text.isEmpty) {
      return;
    }
    value.productData!.forEach((data) {
      if (data.name!.toLowerCase().contains(text.toLowerCase())) value.setSearchCategoryData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DealersProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          backgroundColor: AppColors.cardBgColor,
          body: Column(
            children: [
              widget.from != null ? Container() : widget.isFav ? const SizedBox() : customAppbar(),
              Expanded(
                child: Stack(
                  children: [
                    _buildBody(value),
                    FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: widget.from != null ?  80 : widget.isFav ? 90 : 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: buildFilterCard(value),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  customAppbar() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(
            context,
          );
        },
        child: Container(
            color: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(children: [
              Image.asset(
                AppImages.arrowBack,
                fit: BoxFit.contain,
                height: 20,
              ),
              const SizedBox(width: 20),
              Text(widget.categoryName??"",
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_22, AppColors.blackColor)),
            ])),
      ),
    );
  }

  _buildBody(DealersProvider value) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 16,right: 16,top: widget.isFav ? 10 : 0),
          color: AppColors.whiteColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: CustomRoundTextField(
                  hintText: "Keywords, Parts, Chassis, HS...",
                  controller: searchController,
                  onChanged: (text){
                    onSearchTextChanged(text, value);
                  },
                  icon: const Icon(Icons.search, color: AppColors.brownColor),
                  fillColor: AppColors.whiteColor,
                ),
              ),
              // const SizedBox(width: 12),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         isListType = true;
              //       });
              //     },
              //     child: Image.asset(
              //       AppImages.filterListImage,
              //       height: 25,
              //       color: isListType
              //           ? AppColors.brownColor
              //           : AppColors.btnBlackColor,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 10),
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 10),
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         isListType = false;
              //       });
              //     },
              //     child: Image.asset(
              //       AppImages.menuList,
              //       color: isListType
              //           ? AppColors.btnBlackColor
              //           : AppColors.brownColor,
              //       height: 20,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        buildProductsPartsList(value),
        widget.from == "dashboard" ? const SizedBox(height: 100):const SizedBox()
        // const SizedBox(height: 16),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Image.asset(
        //     AppImages.advertisement,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        // const SizedBox(
        //   height: 110,
        // ),
      ],
    );
  }

  buildProductsPartsList(DealersProvider value) {
    return value.searchProductData.isNotEmpty || searchController.text.isNotEmpty ? 
    value.searchProductData.length != 0 ?
    Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: value.searchProductData.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(
                        context, ProductDetailScreen.routeName,
                        arguments: [value.searchProductData[index].id.toString()]);
                  },
                  child: AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          color: AppColors.whiteColor,
                          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: listItem[index].isStatus
                              ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    isListType
                                        ? Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          height: 70,
                                          width: 95,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardBgColor,
                                            borderRadius:
                                            BorderRadius.circular(7.0),
                                          ),
                                          child: value.searchProductData[index]
                                              .imageUrl ==
                                              null
                                              ? Image.asset(
                                            AppImages.defaultImage,
                                          )
                                              : Image.network(baseImageUrl +
                                              value.searchProductData[index]
                                                  .imageUrl!),
                                        ),
                                        const SizedBox(width: 15),
                                      ],
                                    )
                                        : Container(),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    value.searchProductData[index].name ?? "",
                                                    style: AppTextStyles.boldStyle(
                                                        AppFontSize.font_18,
                                                        AppColors
                                                            .blackColor)),
                                                Row(
                                                  children: [
                                                    // Image.asset(
                                                    //   AppImages.flagIconGrey,
                                                    //   fit: BoxFit.fill,
                                                    //   height: 20,
                                                    //   width: 20,
                                                    // ),
                                                    // const SizedBox(width: 12),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (checkIsLogin!) {
                                                          await context.read<FavouriteProvider>().addRemoveFav(value.searchProductData[index].id.toString(), "auto-part",isFavScreen: widget.isFav);
                                                          setState(() {
                                                            if (value.searchProductData[index].isFav == 0) {
                                                              value.searchProductData[index].isFav = 1;
                                                            } else {
                                                              value.searchProductData[index].isFav = 0;
                                                            }
                                                          });
                                                        } else {
                                                          pleaseLogin(context);
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        value.searchProductData[index].isFav == 0
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
                                          const SizedBox(height: 5),
                                          RichText(
                                            text: TextSpan(
                                              children: highlightOccurrences(value.searchProductData[index].name ?? "", searchController.text),
                                              style: AppTextStyles.mediumStyle(
                                                  16, AppColors.whiteColor),
                                            ),
                                          ),
                                          // Text(
                                          //     value.searchProductData[index].category?.name ?? "",
                                          //     style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.hintTextColor)),
                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    value.searchProductData[index]
                                                        .partNumber ??
                                                        "",
                                                    style: AppTextStyles
                                                        .regularStyle(
                                                        AppFontSize.font_14,
                                                        AppColors
                                                            .blackColor)),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      setState(() {
                                                        if (listItem[index]
                                                            .isStatus) {
                                                          for (var element
                                                          in listItem) {
                                                            element.isStatus =
                                                            false;
                                                          }
                                                        } else {
                                                          for (var element
                                                          in listItem) {
                                                            element.isStatus =
                                                            false;
                                                          }
                                                          listItem[index]
                                                              .isStatus = true;
                                                        }
                                                      });
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    listItem[index].isStatus
                                                        ? AppImages.arrowRoundUp
                                                        : AppImages.arrowRoundDown,
                                                    fit: BoxFit.fill,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: AppColors.unselectedItemColor,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Expanded(child: buildFeaturedDealersCard(value.searchProductData[index].dealers)),
                                    // Expanded(child: buildFeaturedDealersCard(value))
                                  ],
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: SmallButton(
                              //     height: 35,
                              //     width: 110,
                              //     value: "viewMore".tr(),
                              //     textColor: Colors.white,
                              //     color: AppColors.btnBlackColor,
                              //     textStyle: AppTextStyles.mediumStyle(
                              //         AppFontSize.font_12, AppColors.whiteColor),
                              //   ),
                              // ),
                            ],
                          )
                              : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                isListType
                                    ? Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      height: 70,
                                      width: 95,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBgColor,
                                        borderRadius:
                                        BorderRadius.circular(7.0),
                                      ),
                                      child: value.searchProductData[index]
                                          .imageUrl ==
                                          null
                                          ? Image.asset(
                                        AppImages.defaultImage,
                                      )
                                          : Image.network(baseImageUrl +
                                          value.searchProductData[index]
                                              .imageUrl!),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                )
                                    : Container(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: highlightOccurrences(value.searchProductData[index].name ?? "", searchController.text),
                                                style: AppTextStyles.mediumStyle(
                                                    16, AppColors.blackColor),
                                              ),
                                            ),
                                            // Text(value.searchProductData[index].name ??"",
                                            //     style: AppTextStyles.boldStyle(
                                            //         AppFontSize.font_18,
                                            //         AppColors.blackColor)),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   AppImages.flagIconGrey,
                                                //   fit: BoxFit.fill,
                                                //   height: 20,
                                                //   width: 20,
                                                // ),
                                                // const SizedBox(width: 12),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (checkIsLogin!) {
                                                      await context.read<FavouriteProvider>().addRemoveFav(value.searchProductData[index].id.toString(), "auto-part",isFavScreen: widget.isFav);
                                                      setState(() {
                                                        if (value.searchProductData[index].isFav == 0) {
                                                          value.searchProductData[index].isFav = 1;
                                                        } else {
                                                          value.searchProductData[index].isFav = 0;
                                                        }
                                                      });
                                                    } else {
                                                      pleaseLogin(context);
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    value.searchProductData[index].isFav == 0
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
                                      const SizedBox(height: 5),
                                      Text(
                                          value.searchProductData[index].category
                                              ?.name ??
                                              "",
                                          style: AppTextStyles.mediumStyle(
                                              AppFontSize.font_16,
                                              AppColors.hintTextColor)),
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                value.searchProductData[index]
                                                    .partNumber ??
                                                    "",
                                                style: AppTextStyles.regularStyle(
                                                    AppFontSize.font_14,
                                                    AppColors.blackColor)),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (listItem[index].isStatus) {
                                                    for (var element
                                                    in listItem) {
                                                      element.isStatus = false;
                                                    }
                                                  } else {
                                                    for (var element
                                                    in listItem) {
                                                      element.isStatus = false;
                                                    }
                                                    listItem[index].isStatus =
                                                    true;
                                                  }
                                                });
                                              },
                                              child: Image.asset(
                                                listItem[index].isStatus
                                                    ? AppImages.arrowRoundUp
                                                    : AppImages.arrowRoundDown,
                                                fit: BoxFit.fill,
                                                height: 25,
                                                width: 25,
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
    ) : const Expanded(child: const NoDataWidget()) :
    Consumer<LoadingProvider>(
      builder: (BuildContext context, loading, Widget? child) {
        return  (loading.isHomeLoading??false) ?
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: 6,
                itemBuilder: (_, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
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
                  );
                }),
          )
        ) :
        Expanded(
          child: value.productData != null || (value.productData?.length??0) != 0 ?
          AnimationLimiter(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: widget.isFav ? 200 : 100),
                itemCount: value.productData?.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: [value.productData?[index].id.toString()]);
                    },
                    child: AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: Card(
                          color: AppColors.whiteColor,
                          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: listItem[index].isStatus
                              ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    isListType
                                        ? Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          height: 70,
                                          width: 95,
                                          decoration: BoxDecoration(
                                            color: AppColors.cardBgColor,
                                            borderRadius:
                                            BorderRadius.circular(7.0),
                                          ),
                                          child: value.productData?[index]
                                              .imageUrl ==
                                              null
                                              ? Image.asset(
                                            AppImages.defaultImage,
                                          )
                                              : Image.network(baseImageUrl +
                                              value.productData![index]
                                                  .imageUrl!),
                                        ),
                                        const SizedBox(width: 15),
                                      ],
                                    )
                                        : Container(),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    value.productData?[index].name ?? "",
                                                    style: AppTextStyles.boldStyle(
                                                        AppFontSize.font_18,
                                                        AppColors
                                                            .blackColor)),
                                                Row(
                                                  children: [
                                                    // Image.asset(
                                                    //   AppImages.flagIconGrey,
                                                    //   fit: BoxFit.fill,
                                                    //   height: 20,
                                                    //   width: 20,
                                                    // ),
                                                    // const SizedBox(width: 12),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        if (checkIsLogin!) {
                                                          await context.read<FavouriteProvider>().addRemoveFav(value.productData?[index].id.toString(), "auto-part",isFavScreen: widget.isFav);
                                                          setState(() {
                                                            if (value.productData?[index].isFav == 0) {
                                                              value.productData?[index].isFav = 1;
                                                            } else {
                                                              value.productData?[index].isFav = 0;
                                                            }
                                                          });
                                                        } else {
                                                          pleaseLogin(context);
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        value.productData?[index].isFav == 0
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
                                          const SizedBox(height: 5),
                                          Text(
                                              value.productData?[index].category?.name ?? "",
                                              style: AppTextStyles.mediumStyle(
                                                  AppFontSize.font_16,
                                                  AppColors.hintTextColor)),
                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    value.productData?[index]
                                                        .partNumber ??
                                                        "",
                                                    style: AppTextStyles
                                                        .regularStyle(
                                                        AppFontSize.font_14,
                                                        AppColors
                                                            .blackColor)),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      setState(() {
                                                        if (listItem[index]
                                                            .isStatus) {
                                                          for (var element
                                                          in listItem) {
                                                            element.isStatus =
                                                            false;
                                                          }
                                                        } else {
                                                          for (var element
                                                          in listItem) {
                                                            element.isStatus =
                                                            false;
                                                          }
                                                          listItem[index]
                                                              .isStatus = true;
                                                        }
                                                      });
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    listItem[index].isStatus
                                                        ? AppImages.arrowRoundUp
                                                        : AppImages
                                                        .arrowRoundDown,
                                                    fit: BoxFit.fill,
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: AppColors.unselectedItemColor,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Expanded(child: buildFeaturedDealersCard(value.productData?[index].dealers)),
                                    // Expanded(child: buildFeaturedDealersCard(value))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: SmallButton(
                              //     height: 35,
                              //     width: 110,
                              //     value: "viewMore".tr(),
                              //     textColor: Colors.white,
                              //     color: AppColors.btnBlackColor,
                              //     textStyle: AppTextStyles.mediumStyle(
                              //         AppFontSize.font_12, AppColors.whiteColor),
                              //   ),
                              // ),
                              const SizedBox(height: 10),
                            ],
                          )
                              : Padding(
                                padding: const EdgeInsets.all(15),
                              child: Row(
                              children: [
                                isListType
                                    ? Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      height: 70,
                                      width: 95,
                                      decoration: BoxDecoration(
                                        color: AppColors.cardBgColor,
                                        borderRadius:
                                        BorderRadius.circular(7.0),
                                      ),
                                      child: value.productData?[index].imageUrl == null
                                          ? Image.asset(
                                        AppImages.defaultImage,
                                      )
                                          : Image.network(baseImageUrl +
                                          value.productData![index]
                                              .imageUrl!),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                )
                                    : Container(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(value.productData?[index].name ??"",
                                                style: AppTextStyles.boldStyle(
                                                    AppFontSize.font_18,
                                                    AppColors.blackColor)),
                                            Row(
                                              children: [
                                                // Image.asset(
                                                //   AppImages.flagIconGrey,
                                                //   fit: BoxFit.fill,
                                                //   height: 20,
                                                //   width: 20,
                                                // ),
                                                // const SizedBox(width: 12),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (checkIsLogin!) {
                                                      await context.read<FavouriteProvider>().addRemoveFav(value.productData?[index].id.toString(), "auto-part",isFavScreen: widget.isFav);
                                                      setState(() {
                                                        if (value.productData?[index].isFav == 0) {
                                                          value.productData?[index].isFav = 1;
                                                        } else {
                                                          value.productData?[index].isFav = 0;
                                                        }
                                                      });
                                                    } else {
                                                      pleaseLogin(context);
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    value.productData?[index].isFav == 0
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
                                      const SizedBox(height: 5),
                                      Text(
                                          value.productData?[index].category?.name ?? "",
                                          style: AppTextStyles.mediumStyle(
                                              AppFontSize.font_16,
                                              AppColors.hintTextColor)),
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                value.productData?[index]
                                                    .partNumber ??
                                                    "",
                                                style: AppTextStyles.regularStyle(
                                                    AppFontSize.font_14,
                                                    AppColors.blackColor)),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (listItem[index].isStatus) {
                                                    for (var element
                                                    in listItem) {
                                                      element.isStatus = false;
                                                    }
                                                  } else {
                                                    for (var element
                                                    in listItem) {
                                                      element.isStatus = false;
                                                    }
                                                    listItem[index].isStatus =
                                                    true;
                                                  }
                                                });
                                              },
                                              child: Image.asset(
                                                listItem[index].isStatus
                                                    ? AppImages.arrowRoundUp
                                                    : AppImages.arrowRoundDown,
                                                fit: BoxFit.fill,
                                                height: 25,
                                                width: 25,
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ):
          Center(
            child: Lottie.asset(
              AppStrings.notFoundAssets,
              repeat: true,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  buildFilterCard(DealersProvider value) {
    return Card(
      elevation: 9,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: AppColors.whiteColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        width: MediaQuery.of(context).size.width / 2 + 20,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showFilterBottomSheet(value);
            },
            child: Row(children: [
              Image.asset(
                AppImages.filtersIcon,
                fit: BoxFit.fill,
                color: AppColors.brownColor,
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 10),
              Text("filter".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_16, AppColors.brownColor)),
            ]),
          ),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showSortBottomSheet();
            },
            child: Row(children: [
              Image.asset(
                AppImages.sortIcon,
                fit: BoxFit.fill,
                color: AppColors.brownColor,
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 10),
              Text("sort".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_16, AppColors.brownColor)),
            ]),
          ),
        ]),
      ),
    );
  }

  // _buildGridView() {
  //   return Expanded(
  //     child: GridView.builder(
  //       padding: const EdgeInsets.all(6),
  //       physics: const BouncingScrollPhysics(),
  //       itemCount: 4,
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         mainAxisExtent: MediaQuery.of(context).size.width * .490,
  //       ),
  //       itemBuilder: (_, index) :> buildFeaturedDealersCard(),
  //     ),
  //   ),
  // }

  buildFeaturedDealersCard(List<Dealers>? dealers) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemCount: (dealers?.length??0) > 2 ? 2 : dealers?.length??0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, DealerDetailScreen.routeName,
                        arguments: [dealers![index].userId.toString()]);
                  },
                  child: Card(
                    color: AppColors.cardBgColor,
                    margin: const EdgeInsets.all(10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          dealers![index].user?.featured == "Yes"
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
                                dealers[index].user?.image == null
                                    ? Image.asset(
                                        AppImages.alQassemImage,
                                        width: 150,
                                        height: 50,
                                      )
                                    : Image.network(
                                        baseImageUrl + dealers[index].user!.image!,
                                        height: 50,
                                        width: 150,
                                      ),
                                const SizedBox(height: 10),
                                Text(dealers[index].user?.name ?? "",
                                    style: AppTextStyles.boldStyle(
                                        AppFontSize.font_18, AppColors.blackColor)),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Unavailable",
                                          style: AppTextStyles.mediumStyle(
                                              AppFontSize.font_12,
                                              AppColors.hintTextColor)),
                                      Image.asset(
                                        AppImages.bellIcon,
                                        fit: BoxFit.fill,
                                        height: 20,
                                        width: 20,
                                      ),
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
        (dealers?.length??0) > 1 ?
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const DealersScreen()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 7),
              decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
            child: Text("viewMore".tr(),style: const TextStyle(color: Colors.white,fontSize: 12),),
          ),
        ):const SizedBox(),
      ],
    );
  }

  showFilterBottomSheet(DealersProvider value) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: WidgetsBinding.instance!.window.viewInsets.bottom > 0.0
              ? 750
              : 300,
          child: ListView(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      "filter".tr(),
                      style: AppTextStyles.boldStyle(AppFontSize.font_22, AppColors.blackBottomColor),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        selectCategoryList.clear();
                        await context.read<DealersProvider>().productPartsApi(categoryId: categoryTypeId,productsCategoryId: widget.productCategoryId??"",isFeatured: widget.isFeatured??"");
                      },
                      child: SmallIconButton(
                        color: AppColors.brownColor,
                        height: 35,
                        width: 100,
                        textStyle: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.whiteColor),
                        value: "reset".tr(),
                        icon: AppImages.refreshArrow,
                      ),
                    ),
                    const SizedBox(width: 10),
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "category".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackBottomColor),
                    ),
                    const SizedBox(height: 10),
                    _customSearchField(setState),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        String ids="";
                        for (var a in selectCategoryList) {
                          ids = a.id.toString() + ","+ids.toString();
                        }
                        await context.read<DealersProvider>().productPartsApi(categoryId: categoryTypeId,
                            productsCategoryId: ids,isFeatured: widget.isFeatured??"");
                      },
                      child: SubmitButton(
                        color: AppColors.btnBlackColor,
                        height: 50,
                        textStyle: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.whiteColor),
                        value: "filter".tr().toUpperCase(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  showSortBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: 200,
          child: ListView(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      "sort".tr(),
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_22, AppColors.blackBottomColor),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await context.read<DealersProvider>().productPartsApi(categoryId: categoryTypeId,productsCategoryId: widget.productCategoryId??"",isFeatured: widget.isFeatured??"");
                      },
                      child: SmallIconButton(
                        color: AppColors.brownColor,
                        height: 35,
                        width: 100,
                        textStyle: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.whiteColor),
                        value: "reset".tr(),
                        icon: AppImages.refreshArrow,
                      ),
                    ),
                    const SizedBox(width: 10),
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState((){
                          toggle = !toggle;
                          if(aTOz){
                            aTOz = false;
                            sortAtoz = "AtoZ";
                          }else{
                            aTOz = true;
                            sortAtoz = "ZtoA";
                          }
                        });
                        await context.read<DealersProvider>().sortProductsApi(sort: sortAtoz,isFeatured: "");
                      },
                      child: Row(
                        children: [
                          toggle ? Image.asset(
                            AppImages.aToZDownIcon,
                            height: 25,
                            width: 25,
                          ) : Image.asset(
                            AppImages.zToaUPIcon,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Alphabetically",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_16,
                                AppColors.blackBottomColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // buildIconTile("priceLowToHigh".tr(), AppImages.arrowSortUp),
                    // const SizedBox(height: 20),
                    // buildIconTile("priceHighToLow".tr(), AppImages.arrowSortDown),
                    // const SizedBox(height: 20),
                    buildIconTile("dateListed".tr(), AppImages.calendarBlack),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  buildIconTile(text, icon) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        setState((){
          dateToggle = !dateToggle;
          if(isDateATOz){
            isDateATOz = false;
            dateAtoz = "Date_AtoZ";
          }else{
            isDateATOz = true;
            dateAtoz = "Date_ZtoA";
          }
        });
        await context.read<DealersProvider>().sortProductsApi(sort: dateAtoz,isFeatured: widget.isFeatured??"");
      },
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 25,
            width: 25,
          ),
          const SizedBox(width: 15),
          Text(
            text,
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackBottomColor),
          ),
        ],
      ),
    );
  }

  _customSearchField(setState) {
    return Consumer<CarProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderColor, width: 1.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectCategoryList.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(left: 6, top: 3, bottom: 3, right: 5),
                child: SizedBox(
                  height: 28,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(selectCategoryList.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: AppColors.borderColor, width: 1)),
                            child: Row(
                              children: [
                                const SizedBox(width: 7),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: Text(
                                    selectCategoryList[i].name??"",
                                    style: AppTextStyles.mediumStyle(
                                        AppFontSize.font_14,
                                        AppColors.blackColor),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectCategoryList.removeAt(i);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: AppColors.blackColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 5)
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              )
                  : Container(),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.whiteColor,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.greyColor,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TypeAheadField<CarCategories>(
                    textFieldConfiguration: TextFieldConfiguration(
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "search".tr(),
                        hintStyle: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.hintTextColor),
                      ),
                      controller: _categoryController,
                    ),
                    suggestionsCallback: (pattern) async {
                      return getCategorySuggestions(pattern,value.categories??[]);
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    itemBuilder: (context, CarCategories suggestion) {
                      return ListTile(
                        title: Text(suggestion.name??""),
                      );
                    },
                    onSuggestionSelected: (CarCategories suggestion) {
                      _categoryController.text = suggestion.name??"";
                      if (selectCategoryList.isNotEmpty) {
                        var contain = selectCategoryList.where((element) => element.name == _categoryController.text);
                        if (contain.isEmpty) {
                          selectCategoryList.add(CategoryModel(suggestion.name, suggestion.id));
                        }
                        _categoryController.clear();
                      } else {
                        selectCategoryList.add(CategoryModel(suggestion.name, suggestion.id));
                        _categoryController.clear();
                      }
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1 - 60,
                        minWidth: MediaQuery.of(context).size.width / 1 - 60,
                      ),
                      offsetX: 0,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: AppColors.greyColor,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<CarCategories> getCategorySuggestions(String query,List<CarCategories> value) {
    List<CarCategories> matches = [];
    matches.addAll(value);
    matches.retainWhere((s) => (s.name??"").toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  _customVehiclesSearchField(setState){
    return Container(
      decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor, width: 1.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectVehicleClassList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 6, top: 3, bottom: 3, right: 5),
                  child: SizedBox(
                    height: 28,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(selectVehicleClassList.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: AppColors.borderColor, width: 1)),
                              child: Row(
                                children: [
                                  const SizedBox(width: 7),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Text(
                                      selectVehicleClassList[i].name!,
                                      style: AppTextStyles.mediumStyle(
                                          AppFontSize.font_14,
                                          AppColors.blackColor),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectVehicleClassList.removeAt(i);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: AppColors.blackColor,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 5)
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                )
              : Container(),
          Consumer<CarProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.whiteColor,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.greyColor,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TypeAheadField<CarCategories>(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.blackColor),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: "search".tr(),
                          hintStyle: AppTextStyles.mediumStyle(
                              AppFontSize.font_16, AppColors.hintTextColor),
                        ),
                        controller: _vehicleClassController),
                    suggestionsCallback: (pattern) async {
                      return getVehiclesSuggestions(pattern,value.categories);
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    itemBuilder: (context, CarCategories suggestion) {
                      return ListTile(
                        title: Text(suggestion.name.toString()),
                      );
                    },
                    onSuggestionSelected: (CarCategories suggestion) {
                      _vehicleClassController.text = suggestion.name!;
                      if (selectVehicleClassList.isNotEmpty) {
                        var contain = selectVehicleClassList.where((element) =>
                        element.name == _vehicleClassController.text);
                        if (contain.isEmpty) {
                          selectVehicleClassList.add(CategoryModel(suggestion.name, suggestion.id));
                        }
                        _vehicleClassController.clear();
                      } else {
                        selectVehicleClassList.add(CategoryModel(suggestion.name, suggestion.id));
                        _vehicleClassController.clear();
                      }
                    },
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1 - 60,
                        minWidth: MediaQuery.of(context).size.width / 1 - 60,
                      ),
                      offsetX: 0,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: AppColors.greyColor,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          )),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static List<CarCategories> getVehiclesSuggestions(String query,List<CarCategories>? categories) {
    List<CarCategories> matches = [];
    matches.addAll(categories??[]);
    matches.retainWhere((s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class ItemModel {
  bool isStatus = false;

  ItemModel({required this.isStatus});
}

class CategoryModel {
  String? name;
  int? id;

  CategoryModel(this.name, this.id);
}

class AllCategory {
  String? name;
  int? id;

  AllCategory({this.name, this.id});
}
