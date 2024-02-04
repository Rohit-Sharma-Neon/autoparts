import 'package:animate_do/animate_do.dart';
import 'package:autoparts/api_service/api_config.dart';
import 'package:autoparts/app_ui/screens/sell_car/search_car_screen.dart';
import 'package:autoparts/app_ui/screens/sell_product/sell_product_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/category_list_model.dart';
import 'package:autoparts/provider/common_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../../constant/app_strings.dart';
import '../../../models/advertisement_response.dart';
import '../../../provider/dealers_provider.dart';

class DashboardCategoryScreen extends StatefulWidget {
  static const routeName = "/car-category";

  const DashboardCategoryScreen({Key? key}) : super(key: key);

  @override
  _DashboardCategoryScreen createState() => _DashboardCategoryScreen();
}

class _DashboardCategoryScreen extends State<DashboardCategoryScreen> {
  List<Categories>? categoriesList;

  @override
  void initState() {
    super.initState();
    // categoriesList = [Categories(name: "type1",categoryId: 1)];
    Future.microtask(() async {
      context.read<DealersProvider>().getAdvertisementsApi();
      await context.read<CommonProvider>().getCategoryListApi();
      setState(() {
        if (context.read<CommonProvider>().categoryListModel?.success ?? false) {
          categoriesList = context.read<CommonProvider>().categoryListModel!.result?.categories;
        } else {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true, body: _buildBody());
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          categoriesList != null
              ? _buildGridView()
              : Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 6.0),
                  FadeInDown(
                    child: Center(child: Lottie.asset(
                          AppStrings.notFoundAssets,
                          repeat: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ),
                ],
              ),
          _buildCarouselSlider(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  int _current = 0;
  _buildCarouselSlider() {
    return Consumer<DealersProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return  FadeInUp(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CarouselSlider(
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
                  items: (value.advertisementResponse?.result?.records??[]).map<Widget>((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductsScreen(productCategoryId: i.bannerUrl??"",categoryName: "",)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    i.image != null
                                        ? baseImageUrl + (i.image??"")
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
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 150),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                        value.advertisementResponse?.result?.records?.length??0,
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
          ),
        );
      },
    );
  }

  _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(6),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoriesList?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: MediaQuery.of(context).size.width * .450,
      ),
      itemBuilder: (_, index) => buildCarCard(categoriesList![index], index),
    );
  }

  buildCarCard(Categories position, index) {
    return GestureDetector(
      onTap: () async {
        if (index == 0) {
          Navigator.pushNamed(context, SearchCarScreen.routeName);
        } else if (index == 1) {
          Navigator.pushNamed(context, SellProductScreen.routeName);
        } else if (index == 2) {
          alertBox();
        } else {
          alertBox();
        }
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.all(10),
          elevation: 9,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  position.image != null
                      ? baseImageUrl + (position.image ?? "")
                      : demoImageUrlOLd,
                  width: 150,
                  height: 70,
                ),
                const SizedBox(height: 15),
                Text(position.name!,
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
          )),
    );
  }

  void alertBox() {
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Text("Coming Soon",
                    style: AppTextStyles.regularStyle(
                        AppFontSize.font_18, AppColors.greyColor)),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        )
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
                "Alert",
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
}
