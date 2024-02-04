import 'package:animate_do/animate_do.dart';
import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import 'package:autoparts/app_ui/common_widget/submit_button.dart';
import "package:autoparts/app_ui/screens/dashboard/cars_screen/car_detail_screen.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:autoparts/constant/app_strings.dart';
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/car_convertible_model.dart';
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../provider/user_provider.dart';

class CarListingScreen extends StatefulWidget {
  final String? detailsId;
  static const routeName = "/car-listing";
  final String? categoryName;
  final String? isFeatured;
  final bool isFromBottomTab;
  final bool isFav;

  const CarListingScreen({Key? key, this.detailsId, this.categoryName, this.isFeatured,this.isFromBottomTab = false,this.isFav = false}) : super(key: key);

  @override
  _CarListingScreenState createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  String? selectedTransmission;
  String? selectedCondition;
  RangeValues mileageRangeValues = const RangeValues(1, 60);
  RangeValues priceRangeValues = const RangeValues(1, 10000);
  List<String> transmissionList = ["AMT", "Auto"];
  List<String> conditionList = ["New","Used","Salvage"];
  String? selectedMakeName;
  String? selectedMakeId;
  String? selectedModelName = "Model";
  String? selectedModelId;
  String? selectedYear;
  String categoryTypeId = "";
  var makeName = [];
  var modelName = [];

  @override
  void initState() {
    context.read<CarProvider>().clearSearchedCarSubCategoryData();
    Future.microtask(() async {
      await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"",
          carCategoryId: widget.detailsId,isShimmer: true,isFavOnly: widget.isFav);
      await context.read<UserProvider>().getCarMakesApi();
    });
    print("sdfsdfds");
    print(widget.detailsId);
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  onSearchTextChanged(String text, CarProvider value) async {
    value.clearSearchedCarSubCategoryData();
    if (text.isEmpty) {
      return;
    }
    value.convertibleDataList!.forEach((data) {
      if ((data.carName??"").toLowerCase().contains(text.toLowerCase())) value.setSearchedCarSubCategoryData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, value, Widget? child) {
        makeName.clear();
        for (var a in value.carMakesResponse?.result?.records??[]) {
          makeName.add(a.title);
        }
        modelName.clear();
        for (var a in value.carModelsResponse?.result?.records??[]) {
          modelName.add(a.title);
        }
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            children: [
              _buildBody(),
              Consumer<LoadingProvider>(
                builder: (BuildContext context, loading, Widget? child) {
                  return (loading.isHomeLoading??false) ? const SizedBox() : FadeInUp(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(padding: EdgeInsets.only(bottom: widget.isFromBottomTab ? 80 : widget.isFav ? 90 : 0),
                      child: buildFilterCard(value)),
                    ),
                  );
                },
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

  _buildBody() {
    Widget defaultShimmer({required Widget child}){
      return Shimmer.fromColors(child: child, baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade100,);
    }
    return Consumer<CarProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Column(
            children: [
              widget.isFromBottomTab ? const SizedBox() : widget.isFav ? const SizedBox() : customAppbar(),
              _textField(value),
              Consumer<LoadingProvider>(
                builder: (BuildContext context, loading, Widget? child) {
                  if ((loading.isHomeLoading??false)) {
                    return Expanded(
                      child: AnimationLimiter(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(right: 6,left: 6,top: 6),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 8,
                          itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(
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
                  }else{
                    return Expanded(
                        child: value.searchedCarSubCategoryList.isNotEmpty || searchController.text.isNotEmpty ? value.searchedCarSubCategoryList != 0
                            ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: List.generate(
                            value.searchedCarSubCategoryList.length,
                                (position) {
                              return buildListTile(value.searchedCarSubCategoryList[position]);
                            },),
                        ) : const NoDataWidget()
                            : (value.convertibleDataList??[]).isNotEmpty && value.convertibleDataList != null ?
                        ListView.builder(
                          padding: EdgeInsets.only(right: 16,left: 16,bottom: widget.isFromBottomTab ? 180 : 90),
                          shrinkWrap: true,
                          itemCount: value.convertibleDataList?.length??0,
                          itemBuilder: (BuildContext context, int index) {
                            return buildListTile(value.convertibleDataList![index]);
                          },
                        ) : Center(
                          child: Lottie.asset(
                            AppStrings.notFoundAssets,
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        )
                    );
                  }
                },
              ),
            ],
          );
        });
  }

  _textField(CarProvider value) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: widget.isFav ? 10 : 0),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        padding: const EdgeInsets.all(0),
        hintText: "search".tr(),
        onChanged: (text){
          onSearchTextChanged(text,value);
        },
        controller: searchController,
        icon: const Icon(Icons.search, color: AppColors.brownColor),
        fillColor: AppColors.whiteColor,
      ),
    );
  }

  buildListTile(ConvertibleData length) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, CarDetailScreen.routeName,arguments: [length.id.toString()]);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CarDetailScreen(detailsId: length.id.toString(),sellRecordId: length.sellRecordId.toString(),isFav: widget.isFav,)));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              length.image == null
                  ?  Container(
                padding: const EdgeInsets.all(3),
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(7.0),
                    image: const DecorationImage(
                        image:AssetImage(AppImages.carCargo),
                            //:NetworkImage("https://i.imgur.com/BoN9kdC.png"),
                        fit: BoxFit.fill)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitleCard(
                        "newString".tr().toUpperCase(), AppColors.brownColor),
                    buildTitleCard("7 ${"photos".tr()}", AppColors.blackColor),
                  ],
                ),
              )
                  : Container(
                padding: const EdgeInsets.all(3),
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(7.0),
                    image:  DecorationImage(
                        image:NetworkImage(baseImageUrl+length.image!),
                        fit: BoxFit.fill)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTitleCard(
                        "newString".tr().toUpperCase(), AppColors.brownColor),
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
                        length.carName??"",
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 5),
                    Text("AED ${length.price.toString()}",
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_16, AppColors.hintTextColor)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(length.transmissionType??"",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_14, AppColors.blackColor)),
                        const Spacer(),
                        Text(length.region??"",
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
                              Text(length.year??"",
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
                              Text("${length.totalRunning??""} km",
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
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
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

  buildFilterCard(UserProvider value) {
    return Card(
      elevation: 9,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: AppColors.whiteColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        width: MediaQuery
            .of(context)
            .size
            .width / 2 + 20,
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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

  showFilterBottomSheet(UserProvider value) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 750,
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
                                  AppFontSize.font_22, AppColors
                                  .blackBottomColor),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true);
                              },
                              child: SmallIconButton(
                                height: 35,
                                width: 100,
                                color: AppColors.brownColor,
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
                            _makeDropDown(value,setState),
                            const SizedBox(height: 5),
                            // CustomRoundTextField(
                            //   hintText: "model".tr(),
                            //   fillColor: AppColors.whiteColor,
                            //   controller: modelController,
                            //   onChanged: (text) {},
                            // ),
                            _modelDropDown(value,setState),
                            const SizedBox(height: 5),
                            CustomRoundTextField(
                              hintText: "year".tr(),
                              fillColor: AppColors.whiteColor,
                              controller: yearController,
                              maxLength: 4,
                              onChanged: (text) {},
                            ),

                            Text("mileage".tr(),
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_16, AppColors
                                    .blackBottomColor)),
                            const SizedBox(height: 8),
                            mileageRangeSlider(setState),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text("1 KM",
                                    style: AppTextStyles.regularStyle(
                                        AppFontSize.font_14,
                                        AppColors.blackBottomColor)),
                                const Spacer(),
                                Text("60 KM",
                                    style: AppTextStyles.regularStyle(
                                        AppFontSize.font_14,
                                        AppColors.blackBottomColor)),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Text("price".tr(),
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_16, AppColors
                                    .blackBottomColor)),
                            const SizedBox(height: 8),
                            priceRangeSlider(setState),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text("AED 1.00",
                                    style: AppTextStyles.regularStyle(
                                        AppFontSize.font_14,
                                        AppColors.blackBottomColor)),
                                const Spacer(),
                                Text("AED 10000.00",
                                    style: AppTextStyles.regularStyle(
                                        AppFontSize.font_14,
                                        AppColors.blackBottomColor)),
                              ],
                            ),

                            const SizedBox(height: 15),

                            _transmissionDropDown(setState),
                            const SizedBox(height: 15),
                            _conditionDropDown(setState),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"",
                                    carCategoryId: widget.detailsId??"",isShimmer: true,makeId: selectedMakeId??"",
                                    modelId: selectedModelId??"",isFavOnly: widget.isFav,
                                  productCondition: selectedCondition,transmissionType: selectedTransmission,
                                    year: yearController.text.trim(),minPrice: priceRangeValues.start.toString(),
                                    maxPrice: priceRangeValues.end.toString(),minMileage: mileageRangeValues.start.toString(),
                                    maxMileage: mileageRangeValues.end.toString());
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

                    ],
                  ),
                );
              }),
    );
  }

  _makeDropDown(UserProvider value,setState) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: DropdownButton(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        isExpanded: true,
        underline: Container(),
        iconSize: 25,
        // value: selectedMakeName,
        value: selectedMakeName,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("Make",
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        onChanged: (newValue) async {
          if (newValue != null) {
            selectedModelName = "Model";
            setState(() {
              selectedMakeName = newValue.toString();
              for (var a in value.carMakesResponse!.result!.records!) {
                if (a.title == newValue.toString()) {
                  selectedMakeId = a.id.toString();
                }
              }
            });
            setState(() {});
            await context.read<UserProvider>().getCarModelsApi(carMakeId: selectedMakeId??"");
            setState(() {});
          }
        },
        items: makeName.map((makeNames) {
          return DropdownMenuItem(
            child: Text(makeNames??"",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            value: makeNames??"",
          );
        }).toList(),
      ),
    );
  }
  _modelDropDown(UserProvider value,setState) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: DropdownButton(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        isExpanded: true,
        underline: Container(),
        iconSize: 25,
        // value: selectedModelName??"Model",
        // value: selectedModelName,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text(selectedModelName??"Model", style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor)),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              selectedModelName = newValue.toString();
              for (var a in value.carModelsResponse!.result!.records!) {
                if (a.title == newValue.toString()) {
                  selectedModelId = a.id.toString();
                }
              }
            });
          }
        },
        items: modelName.map((e) {
          return DropdownMenuItem(
            child: Text(e??"",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            value: e??"",
          );
        }).toList(),
      ),
    );
  }
  mileageRangeSlider(setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
        ),
        child: RangeSlider(
          activeColor: AppColors.brownColor,
          inactiveColor: AppColors.brownColor.withOpacity(.7),
          values: mileageRangeValues,
          min: 1,
          max: 60,
          divisions: 50,
          labels: RangeLabels(
            mileageRangeValues.start.round().toString(),
            mileageRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              mileageRangeValues = values;
            });
          },
        ),
      ),
    );
  }
  priceRangeSlider(setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
        ),
        child: RangeSlider(
          activeColor: AppColors.brownColor,
          inactiveColor: AppColors.brownColor.withOpacity(.7),
          values: priceRangeValues,
          min: 1,
          max: 10000,
          divisions: 50,
          labels: RangeLabels(
            priceRangeValues.start.round().toString(),
            priceRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              priceRangeValues = values;
            });
          },
        ),
      ),
    );
  }
  showSortBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 450,
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
                                  AppFontSize.font_22, AppColors
                                  .blackBottomColor),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true);
                              },
                              child: SmallIconButton(
                                height: 35,
                                width: 100,
                                color: AppColors.brownColor,
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
                            buildIconTile("mileageHighToLow".tr(), AppImages.arrowSortUp,onTap: () async {
                              Navigator.pop(context);
                              await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true
                              ,sort: "M_ZtoA");
                            }),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "mileageLowToHigh".tr(),
                                AppImages.arrowSortDown,onTap: () async {
                              Navigator.pop(context);
                              await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true
                                  ,sort: "M_AtoZ");
                            }),
                            const SizedBox(height: 20),

                            buildIconTile(
                                "priceLowToHigh".tr(), AppImages.arrowSortUp,onTap: () async {
                              Navigator.pop(context);
                              await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true
                                  ,sort: "P_AtoZ");
                            }),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "priceHighToLow".tr(), AppImages.arrowSortDown,onTap: () async {
                              Navigator.pop(context);
                              await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true
                                  ,sort: "P_ZtoA");
                            }),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "newestFirst".tr(), AppImages.calendarBlack,onTap: () async {
                              Navigator.pop(context);
                              await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true
                                  ,sort: "ZtoA");
                            }),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "oldestFirst".tr(), AppImages.calendarBlack,onTap: () async {
                              Navigator.pop(context);
                              await context.read<CarProvider>().getCarConvertible("1", isFeatured: widget.isFeatured??"", carCategoryId: widget.detailsId,isShimmer: true
                                  ,sort: "AtoZ");
                            }),
                            const SizedBox(height: 20),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  buildIconTile(text, icon, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
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

  _transmissionDropDown(setState) {
    return Container(
      padding:
      const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: DropdownButton(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(FocusNode()); //remove focus
          });
        },
        isExpanded: true,
        underline: Container(),
        iconSize: 25,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("Transmission",
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        // Not necessary for Option 1
        value: selectedTransmission,
        onChanged: (String? newValue) {
          setState(() {
            selectedTransmission = newValue!;
          });
        },
        items: transmissionList.map((age) {
          return DropdownMenuItem(
            child: Text(age,
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            value: age.toString(),
          );
        }).toList(),
      ),
    );
  }

  _conditionDropDown(setState) {
    return Container(
      padding:
      const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: DropdownButton(
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(FocusNode()); //remove focus
          });
        },
        isExpanded: true,
        underline: Container(),
        iconSize: 25,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("Condition",
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        // Not necessary for Option 1
        value: selectedCondition,
        onChanged: (String? newValue) {
          setState(() {
            selectedCondition = newValue!;
          });
        },
        items: conditionList.map((age) {
          return DropdownMenuItem(
            child: Text(age,
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            value: age.toString(),
          );
        }).toList(),
      ),
    );
  }
}
