import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/common_widget/custom_textfield.dart';
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import "package:autoparts/app_ui/screens/dashboard/cars_screen/car_listing_screen.dart";
import 'package:autoparts/app_ui/screens/dashboard/parts_screens/products_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:autoparts/constant/app_strings.dart';
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/utils/search_utility.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';

class TopCategoriesScreen extends StatefulWidget {
  static const routeName = "/cars-page";


  const TopCategoriesScreen({Key? key}) : super(key: key);

  @override
  _TopCategoriesScreenState createState() => _TopCategoriesScreenState();
}

class _TopCategoriesScreenState extends State<TopCategoriesScreen> {

  String categoryTypeId = "";

  @override
  void initState() {
    context.read<CarProvider>().searchTopCategoryData.clear();
    categoryTypeId = sp?.getInt(SpUtil.CATEGORY_ID).toString()??"";
    super.initState();
    Future.microtask(() async {
      await context.read<CarProvider>().getTopCategoriesApi(sp!.getInt(SpUtil.CATEGORY_ID.toString()),showLoader: false);
    });
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  onSearchTextChanged(String text, CarProvider value) async {
    value.setSearchCategoryClear();
    if (text.isEmpty) {
      return;
    }
    value.categories!.forEach((data) {
      if (data.name!.toLowerCase().contains(text.toLowerCase())) value.setSearchCategoryData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  _buildBody() {
    return Consumer<CarProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            customAppbar(),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColors.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: CustomRoundTextField(
                      hintText: "search".tr(),
                      controller: searchController,
                      onChanged: (txt) {
                        onSearchTextChanged(txt, value);
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
            _buildGridView(value),
          ],
        );
      },
    );
  }

  _buildGridView(CarProvider value) {
    Widget defaultShimmer({required Widget child}){
      return Shimmer.fromColors(child: child, baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade100,);
    }
    String categoryId = sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString();
    return Consumer<LoadingProvider>(
      builder: (BuildContext context, loading, Widget? child) {
        if ((loading.isHomeLoading??false)) {
          return Expanded(
            child: AnimationLimiter(
              child: GridView.builder(
                padding: const EdgeInsets.all(6),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
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
                          color: AppColors.btnBlackColor,
                          margin: const EdgeInsets.all(10),
                          elevation: 7,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      defaultShimmer(
                                          child: Icon(Icons.image,size: 70,)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  defaultShimmer(child: Container(color: Colors.grey,height: 15,width: 100)),
                                  const SizedBox(height: 14),
                                  defaultShimmer(child: Container(color: Colors.grey,height: 10,width: 30)),
                                ],
                              ),
                            ),
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }else{
          return Expanded(
              child: value.searchTopCategoryData.isNotEmpty || searchController.text.isNotEmpty
                  ? value.searchTopCategoryData.length != 0 ? GridView.builder(
                  padding: const EdgeInsets.all(6),
                  physics: const BouncingScrollPhysics(),
                  itemCount: value.searchTopCategoryData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: MediaQuery.of(context).size.width * .480,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (value.searchTopCategoryData[index].totalItem != 0) {
                          if (categoryId == "1") {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CarListingScreen(categoryName: value.searchTopCategoryData[index].name,detailsId: value.searchTopCategoryData[index].id.toString(),)));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(productCategoryId: value.searchTopCategoryData[index].id.toString(),categoryName: value.searchTopCategoryData[index].name,)));
                          }
                        }
                      },
                      child: Card(
                        color: AppColors.btnBlackColor,
                        margin: const EdgeInsets.all(10),
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              value.searchTopCategoryData[index].image! != null
                                  ? Image.network(
                                baseImageUrl + value.searchTopCategoryData[index].image!,
                                width: 100,
                                height: 50,
                              )
                                  : Image.asset(
                                AppImages.carMaruti,
                                width: 100,
                                height: 50,
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: highlightOccurrences(value.searchTopCategoryData[index].name ?? "", searchController.text),
                                  style: AppTextStyles.mediumStyle(
                                      16, AppColors.whiteColor),
                                ),
                              ),
                              // Text(value.searchTopCategoryData[index].name ?? "",
                              //     style: AppTextStyles.boldStyle(
                              //         AppFontSize.font_20, AppColors.blackColor)),
                              /*const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.calendar,
                                      fit: BoxFit.fill,
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text("2018 - 2021",
                                        style: AppTextStyles.boldStyle(
                                            AppFontSize.font_16,
                                            AppColors.hintTextColor)),
                                  ]),*/
                              const SizedBox(height: 10),
                              Text("${value.searchTopCategoryData[index].totalItem.toString()} ${sp?.getString(SpUtil.CATEGORY_NAME)??""}",
                                  style: AppTextStyles.regularStyle(
                                      AppFontSize.font_14, AppColors.whiteColor)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                //itemBuilder: (_, index) => buildCarCard(index),
              ) : const NoDataWidget()
                  : (value.categories??[]).isNotEmpty && value.categories != null ? GridView.builder(
                  padding: const EdgeInsets.all(6),
                  physics: const BouncingScrollPhysics(),
                  itemCount: value.categories?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: MediaQuery.of(context).size.width * .480,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (value.categories?[index].totalItem != 0) {
                          if (categoryId == "1") {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CarListingScreen(categoryName: value.categories?[index].name,detailsId: value.categories?[index].id.toString(),)));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(productCategoryId: value.categories?[index].id.toString(),categoryName: value.categories?[index].name,)));
                          }
                        }
                      },
                      child: Card(
                        color: AppColors.btnBlackColor,
                        margin: const EdgeInsets.all(10),
                        elevation: 7,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              value.categories![index].image! != null
                                  ? Image.network(
                                baseImageUrl + value.categories![index].image!,
                                width: 100,
                                height: 50,
                              )
                                  : Image.asset(
                                AppImages.carMaruti,
                                width: 100,
                                height: 50,
                              ),
                              const SizedBox(height: 10),
                              Text(value.categories?[index].name ?? "",
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_20, AppColors.whiteColor)),
                              /*const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppImages.calendar,
                                      fit: BoxFit.fill,
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text("2018 - 2021",
                                        style: AppTextStyles.boldStyle(
                                            AppFontSize.font_16,
                                            AppColors.hintTextColor)),
                                  ]),*/
                              const SizedBox(height: 10),
                              Text("${value.categories?[index].totalItem.toString()} ${sp?.getString(SpUtil.CATEGORY_NAME)??""}",
                                  style: AppTextStyles.regularStyle(
                                      AppFontSize.font_14, AppColors.whiteColor)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                //itemBuilder: (_, index) => buildCarCard(index),
              ) : const NoDataWidget()
            // Center(
            //   child: Lottie.asset(
            //     AppStrings.notFoundAssets,
            //     repeat: true,
            //     fit: BoxFit.cover,
            //   ),
            // )
          );
        }
      },
    );
  }

 /* buildCarCard(position) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CarListingScreen.routeName);
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.all(10),
          elevation: 7,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.carMaruti,
                  width: 100,
                  height: 50,
                ),
                const SizedBox(height: 10),
                Text("Crossover",
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_20, AppColors.blackColor)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    AppImages.calendar,
                    fit: BoxFit.fill,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 10),
                  Text("2018 - 2021",
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_16, AppColors.hintTextColor)),
                ]),
                const SizedBox(height: 10),
                Text("9256 Cars",
                    style: AppTextStyles.regularStyle(
                        AppFontSize.font_14, AppColors.blackColor)),
              ],
            ),
          )),
    );
  }*/

  customAppbar() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            color: AppColors.whiteColor,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                child: Image.asset(
                  AppImages.arrowBack,
                  fit: BoxFit.contain,
                  height: 20,
                ),
              ),
              const SizedBox(width: 20),
              Text("Top Categories",
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_22, AppColors.blackColor)),
            ])),
      ),
    );
  }
}
