import 'package:animate_do/animate_do.dart';
import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/screens/dashboard/cars_screen/car_listing_screen.dart";
import 'package:autoparts/app_ui/screens/dashboard/dashboard_screen/dashboard.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:autoparts/constant/app_strings.dart';
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/main.dart';
import 'package:autoparts/models/advertisement_response.dart';
import 'package:autoparts/models/category_list_model.dart';
import 'package:autoparts/provider/common_provider.dart';
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:autoparts/utils/strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:provider/src/provider.dart';
class CarsCategoryScreen extends StatefulWidget {
  static const routeName = "/car-category";

  const CarsCategoryScreen({Key? key}) : super(key: key);

  @override
  _CarsScreenState createState() => _CarsScreenState();
}
class _CarsScreenState extends State<CarsCategoryScreen> {
  List<Categories>? categoriesList;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<CommonProvider>().getCategoryListApi();
      setState(() {
        if (context.read<CommonProvider>().categoryListModel?.success ?? false) {
          categoriesList = context
              .read<CommonProvider>()
              .categoryListModel!
              .result
              ?.categories;
        }else{
          Navigator.pushNamedAndRemoveUntil(
              context, DashboardScreen.routeName, (route) => false,
              arguments: 0);
        }
      });
      await context.read<DealersProvider>().getAdvertisementsApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop,
    child: Scaffold(backgroundColor: AppColors.whiteColor, body: _buildBody()));
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          customAppbar(),
          categoriesList != null
              ? _buildGridView()
              : Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 6.0),
                  Center(
                  child: Lottie.asset(
                  AppStrings.notFoundAssets,
                  repeat: true,
                  fit: BoxFit.cover,
            ),
          ),
                ],
              ),
          _buildCarouselSlider(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(children: [
            // GestureDetector(
            //     onTap: () {
            //       Navigator.pop(
            //         context,
            //       );
            //     },
            //     child: Image.asset(
            //       AppImages.arrowBack,
            //       fit: BoxFit.contain,
            //       height: 20,
            //     )),
            // const SizedBox(width: 20),
            Text("selectCategory".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }

  _buildGridView() {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(6),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoriesList?.length ?? 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: MediaQuery.of(context).size.width * .480,
        ),
        itemBuilder: (_, index) => AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            child: buildCarCard(categoriesList![index])),
      ),
    );
  }

  buildCarImages() {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.cardBgColor,
          borderRadius: BorderRadius.circular(10.0),
          image: const DecorationImage(
              image: AssetImage(AppImages.sliderImage), fit: BoxFit.fitHeight)),
    );
  }

  buildCarCard(Categories position) {
    return GestureDetector(
      onTap: () async {
        if (position.name == "Cars" || position.name == "Car Parts") {
          await sp!.putInt(SpUtil.CATEGORY_ID, position.id!);
          sp!.putBool(SpUtil.IS_FIRST_TIME, true);
            await sp!.putString(SpUtil.CATEGORY_NAME, position.name??"");
          Provider.of<LoadingProvider>(context,listen: false).setHomeLoading(status: true);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const DashboardScreen()));
        }else{
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              content: Text("Coming Soon...",
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_14, AppColors.blackColor)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("OK",
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ),
              ],
            ));
        }
      },
      child: ScaleAnimation(
        child: FadeInAnimation(
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
                          ? baseImageUrl + position.image!
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
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "confirmExit".tr(),
          style: AppTextStyles.boldStyle(
              AppFontSize.font_16, AppColors.blackColor),
        ),
        content: Text("doYouWantBuyBee".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_14, AppColors.blackColor)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("no".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("yes".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
          ),
        ],
      ),
    )) ??
        false;
  }

  int _current = 0;
  _buildCarouselSlider() {
    return Consumer<DealersProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return (value.advertisementResponse?.result?.records??[]).isNotEmpty && value.advertisementResponse != null ?
        FadeInUp(
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
                        (value.advertisementResponse?.result?.records??[]).length,
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
        ):Container();
      },
    );
  }
}
