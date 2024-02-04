import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import 'package:autoparts/app_ui/common_widget/submit_button.dart';
import 'package:autoparts/constant/app_colors.dart';
import 'package:autoparts/constant/app_image.dart';
import 'package:autoparts/constant/app_text_style.dart';
import 'package:autoparts/models/advertisement_response.dart';
import 'package:autoparts/models/all_cars_model.dart';
import 'package:autoparts/provider/dealers_provider.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../api_service/api_config.dart';
import '../../../main.dart';
import '../../../models/car_category_model.dart';
import '../../../provider/car_provider.dart';
import '../../../provider/dashboard_provider.dart';
import '../../../utils/shared_preferences.dart';

class ReminderScreen extends StatefulWidget {
  static const routeName = "/reminder";

  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String? selectedCarName;
  String? selectedCarId;
  String? selectedPartName;
  String? selectedPartId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read<CarProvider>().getAllCars();
      context.read<CarProvider>().getCategoriesApi("2");
      context.read<UserProvider>().getReminderListApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
              customAppbar(),
              _buildBody(),
            ]),
              _buildCarouselSlider(),
            ],
          ),
        ));
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        const SizedBox(
          height: 16,
        ),
        Text("selectCar".tr(), style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.submitGradiantColor1)),
        const SizedBox(
          height: 10,
        ),
            _buildCarDropDown(),
        const SizedBox(
          height: 16,
        ),
        Text("selectParts".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.submitGradiantColor1)),
        const SizedBox(
          height: 10,
        ),
            _buildPartsDropDown(),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: () async {
              if ((selectedCarId??"").isNotEmpty) {
                context.read<UserProvider>().addReminderApi(carId: selectedCarId,productId: selectedPartId??"");
                await context.read<UserProvider>().getReminderListApi();
              }else{
                showToastMessage("First select car");
              }
            },
            child: SubmitButton(
              height: 55,
              value: "notifyMe".tr().toUpperCase(),
              textColor: Colors.white,
              color: AppColors.btnBlackColor,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            )),
            /// List
            Consumer<UserProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return (value.reminderListResponse?.result?.products?.data??[]).isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.reminderListResponse?.result?.products?.data?.length??0,
                    itemBuilder: (context, index){
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(0,0),
                              spreadRadius: 1.0,
                              blurRadius: 1.0,
                            )
                          ]
                        ),
                        width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  value.reminderListResponse?.result?.products?.data?[index].product == null
                                      ? Text(value.reminderListResponse?.result?.products?.data?[index].carName.toString()??"",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 16))
                                      : SizedBox(
                                        height: 40,
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Expanded(child: Text("${value.reminderListResponse?.result?.products?.data?[index].carName.toString()??""} - ${value.reminderListResponse?.result?.products?.data?[index].product?.name.toString()??""}",
                                              style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 16),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                              GestureDetector(onTap: () async {
                                await context.read<UserProvider>().deleteReminderApi(reminderId: value.reminderListResponse?.result?.products?.data?[index].id.toString()??"",index: index);
                              },child: const Icon(Icons.delete_rounded,size: 30,))
                            ],
                          ));
                    }):const SizedBox();
              },

            ),
            const SizedBox(height: 30),
          ]),
    );
  }

  int _current = 0;

  _buildCarouselSlider() {
    return Consumer<DealersProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return (value.advertisementResponse?.result?.records??[]).isNotEmpty ?
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(bottom: 30),
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
                items: value.advertisementResponse?.result?.records?.map<Widget>((i) {
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
        ):const SizedBox();
      },
    );
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
            Text("addReminder".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }

  _buildCarDropDown() {
    return Consumer<CarProvider>(
      builder: (BuildContext context, value, Widget? child) {
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
            // value: selectNationality,
            iconEnabledColor: AppColors.blackColor,
            iconDisabledColor: AppColors.blackColor,
            hint: Text(selectedCarName??"Select Car",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            //Not necessary for Option 1
            onChanged: (newValue) {
              setState(() {
                selectedCarName = newValue.toString();
              });
              for (var a in value.allCarsModel!.result!.products!) {
                if (a.carNames == newValue.toString()) {
                  selectedCarId = a.id.toString();
                }
              }
            },
            items: value.allCarsModel?.result?.products?.map((AllCarsDetail e) {
              return DropdownMenuItem(
                child: Text(e.carNames??"Select Car",
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
                value: e.carNames??"Select Car",
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _buildPartsDropDown() {
    return Consumer<CarProvider>(
      builder: (BuildContext context, value, Widget? child) {
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
            // value: selectNationality,
            iconEnabledColor: AppColors.blackColor,
            iconDisabledColor: AppColors.blackColor,
            hint: Text(selectedPartName??"Select Part",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            //Not necessary for Option 1
            onChanged: (newValue) {
              setState(() {
                selectedPartName = newValue.toString();
              });
              for (var a in value.partCategories!) {
                if (a.name == newValue.toString()) {
                  selectedPartId = a.id.toString();
                }
              }
            },
            items: value.partCategories!.map((CarCategories e) {
              return DropdownMenuItem(
                child: Text(e.name??"Select Part",
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
                value: e.name??"Select Part",
              );
            }).toList(),
          ),
        );
      },
    );
  }

  buildCarImages() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: AppColors.cardBgColor,
          borderRadius: BorderRadius.circular(10.0),
          image: const DecorationImage(
              image: AssetImage(AppImages.sliderImage), fit: BoxFit.fitHeight)),
    );
  }
}
