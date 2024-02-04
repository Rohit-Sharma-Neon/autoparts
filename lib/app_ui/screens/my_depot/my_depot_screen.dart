import 'package:animate_do/animate_do.dart';
import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import 'package:autoparts/app_ui/common_widget/pagination_footer.dart';
import 'package:autoparts/app_ui/common_widget/submit_button.dart';
import "package:autoparts/app_ui/screens/dashboard/cars_screen/car_detail_screen.dart";
import 'package:autoparts/app_ui/screens/sell_car/sell_complete_car_screen.dart';
import 'package:autoparts/app_ui/screens/sell_product/add_new_product_screen.dart';
import 'package:autoparts/app_ui/screens/sell_product/sell_existing_product_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import 'package:autoparts/constant/app_strings.dart';
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/car_convertible_model.dart';
import 'package:autoparts/models/sell_listing_response.dart';
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import "package:flutter/widgets.dart";
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyDepotScreen extends StatefulWidget {
  final String? detailsId;
  static const routeName = "/car-listing";
  final String? categoryName;
  final String? isFeatured;

  const MyDepotScreen({Key? key, this.detailsId, this.categoryName, this.isFeatured}) : super(key: key);

  @override
  _MyDepotScreenState createState() => _MyDepotScreenState();
}

class _MyDepotScreenState extends State<MyDepotScreen> {
  TextEditingController controller = TextEditingController();
  String? selectTransmission;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  List<String> transmissionList = [];
  late ScrollController _controller;

  @override
  void initState() {
    context.read<UserProvider>().init();
    Future.microtask(() async {
      await context.read<UserProvider>().getUserSellerListingApi();
    });
    _controller = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  //
  // void _loadMore() {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     Future.microtask(() async {
  //       await context.read<UserProvider>().getUserSellerListingApi();
  //     });
  //   }
  // }

  void _loadMore() {
    if (context.read<UserProvider>().hasNextPage == true &&
        context.read<UserProvider>().isLoadMore == false
        && _controller.position.extentAfter < 300) {
      Future.microtask(() {
        context.read<UserProvider>().setLoadMore(true);
        context.read<UserProvider>().getUserSellerListingApi();
      });
    }
  }

  TextEditingController searchController = TextEditingController();

  onSearchTextChanged(String text, CarProvider value) async {
    value.clearSearchedCarSubCategoryData();
    if (text.isEmpty) {
      return;
    }
    value.convertibleDataList!.forEach((data) {
      if ((data.make?.title??"").toLowerCase().contains(text.toLowerCase())) value.setSearchedCarSubCategoryData(data);
      if ((data.model?.title??"").toLowerCase().contains(text.toLowerCase())) value.setSearchedCarSubCategoryData(data);
      if ((data.carCategory?.name??"").toLowerCase().contains(text.toLowerCase())) value.setSearchedCarSubCategoryData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _buildBody(),
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
    return Consumer<UserProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Column(
            children: [
              customAppbar(),
              // _textField(value),
              Consumer<LoadingProvider>(
                builder: (BuildContext context, loading, Widget? child) {
                  if ((loading.isHomeLoading??false)) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(6),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 8,
                        itemBuilder: (_, index) => Card(
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
                    );
                  }else{
                    return (value.sellListing??[]).isNotEmpty ?
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: value.sellListing?.length??0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return buildListTile(value.sellListing![index]);
                              },
                            ),
                            if(value.page != 1)
                              paginationFooter(isLoading: value.isLoadMore,
                                  hasNextPage: value.hasNextPage,
                                  isDismiss: !value.isDismiss)


                          ],
                        ),
                      ),
                    ) :Center(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height / 6.0),
                          Lottie.asset(
                            AppStrings.notFoundAssets,
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  buildListTile(SoldData length) {
    return GestureDetector(
      onTap: () {
        if (length.sellStatus == "Pending") {
          if(length.sellType == "Product"){
            if(length.sellProductType == "New"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewProductScreen(existingData: length,isUpdating: true,))).then((value) async {
                if(value == "update"){
                  context.read<UserProvider>().init();
                  await context.read<UserProvider>().getUserSellerListingApi();
                }
              });
            }else if(length.sellProductType == "Exist"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SellExistingProductScreen(existingData: length,
                  isUpdating: true,productNumber: length.products?.name??""))).then((value) async {
                    if(value == "update"){
                      context.read<UserProvider>().init();
                      await context.read<UserProvider>().getUserSellerListingApi();
                    }
              });
            }
          }else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SellCompleteCarScreen(carData: length,
                isUpdating: true,carId: length.id.toString(),))).then((value) async {
                  if(value == "update"){
                    context.read<UserProvider>().init();
                    await context.read<UserProvider>().getUserSellerListingApi();
                  }
              });
          }
        }
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              (length.image??"").isEmpty && (length.products?.imageUrl??"").isEmpty
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
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     buildTitleCard("newString".tr().toUpperCase(), AppColors.brownColor),
                //     buildTitleCard("7 ${"photos".tr()}", AppColors.blackColor),
                //   ],
                // ),
              )
                  : Container(
                padding: const EdgeInsets.all(3),
                height: 110,
                width: 100,
                decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                        image: length.sellType == "Product" ?
                        NetworkImage(baseImageUrl+(length.products?.imageUrl??"")) :
                        NetworkImage(baseImageUrl+(length.image??"")),
                        fit: BoxFit.fill)
                ),
                //   child: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     buildTitleCard(
                //         "newString".tr().toUpperCase(), AppColors.brownColor),
                //     buildTitleCard("7 ${"photos".tr()}", AppColors.blackColor),
                //   ],
                // ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    length.sellType == "Product" ?
                    Text(
                        length.products?.name??"",
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor))
                    : Text(
                        '${length.products?.make?.title ?? ""} ${length.products?.model?.title ?? ""} ${length.products?.carCategory?.name ?? ""}',
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("AED ${length.price.toString()}",
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_16, AppColors.hintTextColor)),
                        length.sellStatus != "Pending" ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.btnBlackColor,
                        ),child: const Text("Sold",style: TextStyle(fontSize: 10,color: Colors.white))) : const SizedBox()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Date of Listing: ",
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                              /// Date of listing
                              Text(dateParse(
                                date: length.createdAt,
                                output: "dd/MM/yyyy",
                              ),
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                            ],
                          ),
                        ],
                    ),
                    length.sellStatus == "Pending" ?
                    Column(
                      children: [
                        const SizedBox(height: 6),
                        GestureDetector(
                            onTap: () {
                              alertBox(length);
                            },
                            child: SubmitButton(
                              height: 35,
                              value: "SOLD",
                              textColor: Colors.white,
                              color: AppColors.btnBlackColor,
                              textStyle: AppTextStyles.mediumStyle(
                                  AppFontSize.font_16, AppColors.whiteColor),
                            )),
                      ],
                    ):const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void alertBox(SoldData length) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: alertBoxBody(length)),
      ),
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
                "Inactive Now",
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
  alertBoxBody(SoldData length) {
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
              Text("Do you want to mark your Product as Sold.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularStyle(AppFontSize.font_18, AppColors.blackColor)),
              const SizedBox(height: 30),
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await context.read<UserProvider>().markProductAsSoldApi(recordId: length.id.toString(),productId: length.productId.toString());
                  },
                  child: SubmitButton(
                    height: 45,
                    value: "YES",
                    textColor: Colors.white,
                    color: AppColors.btnBlackColor,
                    textStyle: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.whiteColor),
                  )),
              const SizedBox(height: 15),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SubmitButton(
                    height: 45,
                    value: "NO",
                    textColor: Colors.white,
                    color: AppColors.brownColor,
                    textStyle: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.whiteColor),
                  )),
            ],
          ),
        )
      ],
    );
  }

  String dateParse({date, output}) {
    if (date == null || date == "") return "";
    const formatFull = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    DateTime parseDate = DateFormat(formatFull).parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat(output);
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
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



  static String _valueToString(double value) {
    return value.toStringAsFixed(0);
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
                              onTap: () {},
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
                            buildIconTile(
                                "mileageHighToLow".tr(), AppImages.arrowSortUp),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "mileageLowToHigh".tr(),
                                AppImages.arrowSortDown),
                            const SizedBox(height: 20),

                            buildIconTile(
                                "priceLowToHigh".tr(), AppImages.arrowSortUp),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "priceHighToLow".tr(), AppImages.arrowSortDown),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "newestFirst".tr(), AppImages.calendarBlack),
                            const SizedBox(height: 20),
                            buildIconTile(
                                "oldestFirst".tr(), AppImages.calendarBlack),
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

  _buildDropDown(hintText, setState) {
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
        hint: Text(hintText,
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        // Not necessary for Option 1
        value: selectTransmission,
        onChanged: (String? newValue) {
          setState(() {
            selectTransmission = newValue!;
            print(selectTransmission);
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
}