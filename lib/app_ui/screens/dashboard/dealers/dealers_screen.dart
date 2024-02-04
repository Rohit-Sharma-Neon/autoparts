import 'package:animate_do/animate_do.dart';
import 'package:autoparts/api_service/api_base_helper.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/app_ui/screens/dashboard/dealers/dealer_detail_screen.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/advertisement_response.dart';
import 'package:autoparts/models/dealers_list_model.dart';
import 'package:autoparts/models/part_categories_list.dart';
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/routes/navigator_service.dart';
import 'package:autoparts/utils/search_utility.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import "package:flutter_typeahead/flutter_typeahead.dart";
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../api_service/api_config.dart';
import '../../../../constant/app_strings.dart';
import '../../../../main.dart';
import '../../../../provider/favourite_provider.dart';
import '../../../../utils/shared_preferences.dart';
import '../../../common_widget/show_dialog.dart';

class DealersScreen extends StatefulWidget {
  static const routeName = "/dealers-page";
  final bool isFav;

  const DealersScreen({Key? key,this.isFav = false}) : super(key: key);

  @override
  _DealersScreenState createState() => _DealersScreenState();
}

class _DealersScreenState extends State<DealersScreen> {
  final TextEditingController _categoryController = TextEditingController();
  List<CategoryModel> selectCategoryList = [];

  TextEditingController searchController = TextEditingController();
  late List<DealerList> dealerList;

  static List<CategoriesData>? categoriesData = [];
  CategoriesData? categoriesDataApi;

  bool? checkIsLogin;
  bool? isSearch;
  bool toggle = false;
  bool aTOz = false;
  String? sortAtoz = "ZtoA";

  onSearchTextChanged(String text, DealersProvider value) async {
    value.clearSearchedDealerList();
    if (text.isEmpty) {
      return;
    }
    value.dealersList!.forEach((data) {
      if (data.name!.toLowerCase().contains(text.toLowerCase())) value.setSearchedDealerData(data);
    });
  }

  @override
  void initState() {
    context.read<DealersProvider>().clearSearchedDealerList();
    super.initState();
    checkIsLogin = sp!.getBool(SpUtil.IS_LOGGED_IN) ?? false;
    Future.microtask(() async {
      await context.read<DealersProvider>().getDealerListApi(categoryId: sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString(),isFavOnly: widget.isFav);
      categoriesData = context.read<DealersProvider>().categoriesData;
      await context.read<DealersProvider>().getAdvertisementsApi();
    });
    setState(() {});
  }

  AnimationController? animateController;

  @override
  Widget build(BuildContext context) {
    return Consumer<DealersProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return Scaffold(
        backgroundColor: AppColors.cardBgColor,
        body: Column(
          children: [
            widget.isFav ? const SizedBox() :
            customAppbar(),
            Expanded(
                    child: Stack(
                      children: [
                        _buildBody(value),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 10),
                        //   child: Align(
                        //     alignment: Alignment.bottomCenter,
                        //     child: buildFilterCard(),
                        //   ),
                        // )
                      ],
                    ),
                  )
          ],
        ),
        floatingActionButton: Consumer<LoadingProvider>(
              builder: (BuildContext context, loading, Widget? child) {
                return (loading.isHomeLoading??false) ? const SizedBox() : FadeInUp(
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 90,vertical: widget.isFav ? 60 : 10),
                      child: buildFilterCard()),
                );
              },
            )
      );
    });
  }

  int _current = 0;

  _buildCarouselSlider(List<Records>? list) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(bottom: 150),
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
            items: list!.map<Widget>((i) {
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

  buildFilterCard() {
    return Card(
      elevation: 9,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: AppColors.whiteColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        width: MediaQuery.of(context).size.width / 2 + 20,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showFilterBottomSheet();
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
                color: AppColors.brownColor,
                fit: BoxFit.fill,
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

  customAppbar() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
              Text("dealerSmall".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_22, AppColors.blackColor)),
            ])),
      ),
    );
  }

  _buildBody(DealersProvider value) {
    Widget defaultShimmer({required Widget child}){
      return Shimmer.fromColors(child: child, baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade100,);
    }
    dealerList = value.dealersList ?? [];
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16,right: 16,top: widget.isFav ? 10 : 0),
          color: AppColors.whiteColor,
          child: CustomRoundTextField(
            onChanged: (text){
              onSearchTextChanged(text, value);
            },
            controller: searchController,
            hintText: "search".tr(),
            icon: const Icon(Icons.search, color: AppColors.brownColor),
            fillColor: AppColors.whiteColor,
          ),
        ),
        Consumer<LoadingProvider>(
          builder: (BuildContext context, loading, Widget? child) {
            if ((loading.isHomeLoading??false)) {
              return Expanded(child: AnimationLimiter(
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
            } else {
              return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildGridView(value),
                    _buildCarouselSlider(value.advertisementResponse?.result?.records??[])
                  ],
                ),
              ),
            );
            }
          },
        )

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Image.asset(
        //     AppImages.advertisement,
        //     fit: BoxFit.fill,
        //   ),
        // ),
        // const SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }

  _buildGridView(DealersProvider value) {
    if (value.searchedDealersList.isNotEmpty || searchController.text.isNotEmpty) {
      return value.searchedDealersList.length != 0 ? GridView.builder(
          padding: const EdgeInsets.all(6),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.searchedDealersList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: MediaQuery.of(context).size.width * .470,
          ),
          itemBuilder: (_, index) => buildFeaturedDealersCard(value.searchedDealersList[index],index),
        ): const NoDataWidget();
    } else {
      if ((value.dealersList??[]).isNotEmpty) {
        if (mounted) {
          animateController?.forward();
        }
      }
      return (value.dealersList??[]).isNotEmpty && value.dealersList != null
        ? GridView.builder(
          padding: const EdgeInsets.all(6),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.dealersList?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: MediaQuery.of(context).size.width * .470,
          ),
          itemBuilder: (_, index) =>
              buildFeaturedDealersCard(value.dealersList![index],index),
        ):const NoDataWidget();
    }
  }

  buildFeaturedDealersCard(DealerList data,index) {
    String formatted = '';
    for (var a in data.dealerCategories!) {
      formatted += "${a.category?.name ?? ""}, ";
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DealerDetailScreen.routeName,
            arguments: [data.id.toString()]);
      },
      child: Card(
          color: AppColors.whiteColor,
          margin: const EdgeInsets.all(10),
          elevation: 7,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    data.featured == "Yes"
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
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              data.image != null
                                  ? baseImageUrl + data.image!
                                  : demoImageUrlOLd,
                              width: 150,
                              height: 50,
                            ),
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: highlightOccurrences(data.name ?? "", searchController.text,),
                                        style: AppTextStyles.boldStyle(
                                                    AppFontSize.font_18,
                                                    AppColors.blackColor),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (checkIsLogin!) {
                                        await context.read<FavouriteProvider>().addRemoveFav(data.id.toString(),
                                            "dealer",index: index,isFavScreen: widget.isFav).then((value){
                                          setState(() {
                                            if(value){
                                              data.isFav = 1;
                                            }else{
                                              data.isFav = 0;
                                            }
                                          });
                                        });
                                      } else {
                                        pleaseLogin(context);
                                      }
                                    },
                                    child: Image.asset(
                                      data.isFav == 0
                                          ? AppImages.favOutline
                                          : AppImages.favoritesIcon,
                                      fit: BoxFit.fill,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 6),
                            Text(formatted.isNotEmpty
                                    ? formatted.substring(
                                        0, formatted.length - 2)
                                    : "",
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_12,
                                    AppColors.hintTextColor)),
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
                                  "${data.avgRate ?? "0"}/${data.totalRate ?? "0"}",
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.blackColor)),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              ])),
    );
  }

  showFilterBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: WidgetsBinding.instance!.window.viewInsets.bottom > 0.0
              ? 500
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
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_22, AppColors.blackBottomColor),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          context.read<DealersProvider>().clearSearchedDealerList();
                          categoriesData = context.read<DealersProvider>().categoriesData;
                          context.read<DealersProvider>().getDealerListApi(categoryId: sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString());
                          selectCategoryList.clear();
                          Navigator.pop(context);
                        });
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
                    // Text(
                    //   "category".tr(),
                    //   style: AppTextStyles.mediumStyle(
                    //       AppFontSize.font_16, AppColors.blackBottomColor),
                    // ),
                    // const SizedBox(height: 10),
                    // _customSearchField(setState),
                    const SizedBox(height: 20),
                    Text(
                      "rating".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackBottomColor),
                    ),
                    const SizedBox(height: 10),
                    buildRatingBar(),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.pop(context);
                        String ids="";
                        for (var a in selectCategoryList) {
                          ids = a.id.toString() + ","+ids.toString();
                        }
                        await context.read<DealersProvider>().getDealerListApi(categoryId: ids.toString(), rating: rating.toString());
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
              const SizedBox(height: 13),
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
          height: 250,
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
                   /* GestureDetector(
                      onTap: () {},
                      child: SmallIconButton(
                        color: AppColors.brownColor,
                        height: 35,
                        width: 100,
                        textStyle: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.whiteColor),
                        value: "reset".tr(),
                        icon: AppImages.refreshArrow,
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          context.read<DealersProvider>().clearSearchedDealerList();
                          categoriesData = context.read<DealersProvider>().categoriesData;
                          context.read<DealersProvider>().getDealerListApi(categoryId: sp!.getInt(SpUtil.CATEGORY_ID.toString()).toString());
                          selectCategoryList.clear();
                          Navigator.pop(context);
                        });
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
                        context.read<DealersProvider>().getSortApi(sort: sortAtoz);
                      },
                      child: Row(
                        children: [
                          toggle
                              ? Image.asset(
                                  AppImages.aToZDownIcon,
                                  height: 25,
                                  width: 25,
                                )
                              : Image.asset(
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
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        await context.read<DealersProvider>().getSortApi(sort: "rate");
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            AppImages.startRatingBlack,
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Rating",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_16,
                                AppColors.blackBottomColor),
                          ),
                        ],
                      ),
                    ),
                    // buildIconTile("alphabetically".tr(), AppImages.sortDescendingIcon),
                    // const SizedBox(height: 20),
                    // buildIconTile("rating".tr(), AppImages.startRatingBlack),
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
    return Row(
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
    );
  }

  int _rating = 0;

  void rate(int rating) {
    //Other actions based on rating such as api calls.
    setState(() {
      _rating = rating;
    });
  }

  double rating = 5.0;

  buildRatingBar() {
    return RatingBar(
      initialRating: rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      glow: false,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star,
          color: AppColors.brownColor,
          size: 20,
        ),
        half: const Icon(
          Icons.star_half_outlined,
          color: AppColors.brownColor,
          size: 20,
        ),
        empty: const Icon(
          Icons.star_outline,
          color: AppColors.brownColor,
          size: 20,
        ),
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (rating) {
        setState(() {
          this.rating = rating;
        });
        print(rating);
        print(this.rating);
      },
    );
  }

  _customSearchField(setState) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor, width: 1.5)),
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectCategoryList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 6, top: 3, bottom: 3, right: 5),
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Text(
                                      selectCategoryList[i].name!,
                                      style: AppTextStyles.mediumStyle(
                                          AppFontSize.font_14,
                                          AppColors.blackColor),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // context.read<DealersProvider>().productDetailsPartsApi(sp!.putInt(SpUtil.CATEGORY_ID, categories![i].id!));
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
            child:
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TypeAheadField<CategoriesData>(
                textFieldConfiguration: TextFieldConfiguration(
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.blackColor),
                  decoration: InputDecoration(
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "search".tr(),
                    hintStyle: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.hintTextColor),
                  ),
                  controller: _categoryController,
                ),
                suggestionsCallback: (pattern) async {
                  return getCategorySuggestions(pattern);
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                itemBuilder: (context, CategoriesData suggestion) {
                  return ListTile(
                    title: Text(suggestion.name.toString()),
                  );
                },
                onSuggestionSelected: (CategoriesData suggestion) {
                  _categoryController.text = suggestion.name!;
                  if (selectCategoryList.isNotEmpty) {
                    var contain = selectCategoryList.where((element) => element.name == _categoryController.text);
                    if (contain.isEmpty) {
                      selectCategoryList.add(CategoryModel(suggestion.name, suggestion.id));
                    }
                    _categoryController.clear();
                  }
                  else {
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
  }

  static List<CategoriesData> getCategorySuggestions(String query) {
    List<CategoriesData> matches = [];
    matches.addAll(categoriesData!);
    matches.retainWhere(
        (s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    //matches.retainWhere((s) => s.id!.toString().contains(query.toString()));
    return matches;
  }
}

class IMageClass {
  String? images;
  String? type;
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
