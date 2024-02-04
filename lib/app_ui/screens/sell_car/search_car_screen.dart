import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/dashboard/cars_screen/car_detail_screen.dart';
import "package:autoparts/app_ui/screens/sell_car/sell_car_screen.dart";
import 'package:autoparts/app_ui/screens/sell_car/sell_complete_car_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/all_cars_model.dart';
import 'package:autoparts/models/car_convertible_model.dart';
import 'package:autoparts/models/car_makes_response.dart';
import 'package:autoparts/models/car_models_response.dart';
import 'package:autoparts/provider/car_provider.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:autoparts/utils/date_time_utils.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/material.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class SearchCarScreen extends StatefulWidget {
  static const routeName = "/search-car";

  const SearchCarScreen({Key? key}) : super(key: key);

  @override
  _SearchCarScreenState createState() => _SearchCarScreenState();
}

class _SearchCarScreenState extends State<SearchCarScreen> {
  String? selectNationality;
  List<String> nationalityList = [];
  String? selectedMakeName;
  String? selectedMakeId;
  String? selectedModelName = "Model";
  String? selectedModelId;
  String? selectedYear;
  String categoryTypeId = "";
  var makeName = [];
  var modelName = [];
  TextEditingController vinController = TextEditingController();

  @override
  void initState() {
    context.read<UserProvider>().clearCarsListing();
    categoryTypeId = sp?.getInt(SpUtil.CATEGORY_ID).toString()??"";
    nationalityList.add("India");
    nationalityList.add("Pakistan");
    nationalityList.add("Nepal");
    Future.microtask(() async {
      await context.read<UserProvider>().getCarMakesApi();
    });
    super.initState();
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [customAppbar(), _buildBody(value)],
            ));
      },
    );
  }

  _buildBody(UserProvider value) {
    return Expanded(
        child: ListView(padding: const EdgeInsets.all(0), children: [
        buildTopWidget(value),
        buildSellProduct(),
        _buildSingleChildScroll(),
      const SizedBox(height: 16),
    ]));
  }


  buildTopWidget(UserProvider value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.whiteColor,
          child: CustomRoundTextField(
            hintText: "vINNumber".tr(),
            controller: vinController,
            onChanged: (val){
              if(val.isNotEmpty){
                selectedMakeName = "Make";
                selectedModelName = "Model";
                selectedMakeId = "";
                selectedModelId = "";
                selectedDob = "year".tr();
                setState(() {});
              }
            },
            icon: const Icon(Icons.search, color: Colors.black54),
            fillColor: AppColors.whiteColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: AppColors.borderColor,
              width: 70,
              height: 2,
            ),
            Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black12)),
              child: Text(
                "orText".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_14, AppColors.blackColor),
              ),
            ),
            Container(
              color: AppColors.borderColor,
              width: 70,
              height: 2,
            )
          ],
        ),
        const SizedBox(height: 16),
        _makeDropDown(value),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: _modelDropDown(value)),
          Expanded(child: _buildDropDownYear()),
        ]),
      ],
    );
  }

  _buildDropDown() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.only(top: 3, left: 16.0, right: 16.0, bottom: 3),
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
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("dropDownMake".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        // Not necessary for Option 1
        value: selectNationality,

        onChanged: (String? newValue) {
          setState(() {
            selectNationality = newValue!;
            print(selectNationality);
          });
        },
        items: nationalityList.map((age) {
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

  _buildDropDownModel(UserProvider value) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 6),
      padding: const EdgeInsets.only(top: 2, left: 16.0, right: 16.0, bottom: 2),
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
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("model".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        // Not necessary for Option 1
        value: selectNationality,

        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectNationality = newValue;
              print(selectNationality);
            });
          }
        },
        items: nationalityList.map((age) {
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
  String? selectedDob;

  _buildDropDownYear() {
    return GestureDetector(
      onTap: (){
        DateTime currentDate = DateTime.now();
        FocusScope.of(context).unfocus();
        // showDatePicker(
        //     context: context,
        //     initialDate: DateTime(currentDate.year,currentDate.month,currentDate.day),
        //     firstDate: DateTime(1950, 1),
        //     lastDate: DateTime(currentDate.year,currentDate.month,currentDate.day),
        //     //lastDate: DateTime(DateTime.now().year - 12, 1, 1),
        //     builder: (context, picker) {
        //       return Theme(
        //         data: ThemeData.dark().copyWith(
        //           colorScheme: ColorScheme.dark(
        //             primary: AppColors.btnBlackColor,
        //             onPrimary: Colors.white,
        //             surface: Colors.grey.shade200,
        //             onSurface: Colors.black,
        //           ),
        //           dialogBackgroundColor: Colors.white,
        //         ),
        //         child: picker!,
        //       );
        //     }).then((date) {
        //   if (date != null) {
        //     setState(() {
        //       selectedDob = myFormat.format(date);
        //     });
        //   }
        // });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Select Year"),
              content: Container( // Need to use container to add size constraint.
                width: 300,
                height: 300,
                child: YearPicker(
                  initialDate: DateTime(currentDate.year,currentDate.month,currentDate.day),
                  firstDate: DateTime(1800, 1),
                  lastDate: DateTime(currentDate.year,currentDate.month,currentDate.day),
                  selectedDate: DateTime(currentDate.year,currentDate.month,currentDate.day),
                  onChanged: (DateTime dateTime) {
                    // close the dialog when year is selected.
                    selectedDob = myFormat.format(dateTime);
                    setState(() {});
                    Navigator.pop(context);
                    // Do something with the dateTime selected.
                    // Remember that you need to use dateTime.year to get the year
                  },
                ),
              ),
            );
          },
        );
      },
      child: AbsorbPointer(
        child: Container(
          margin: const EdgeInsets.only(left: 6, right: 16),
          padding:
              const EdgeInsets.only(top: 2, left: 16.0, right: 16.0, bottom: 2),
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
            iconEnabledColor: AppColors.blackColor,
            iconDisabledColor: AppColors.blackColor,
            hint: Text(selectedDob??"year".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            // Not necessary for Option 1
            onChanged: (String? newValue) {
              vinController.text = "";
              if (newValue != null) {
                setState(() {
                  selectNationality = newValue;
                  print(selectNationality);
                });
              }
            },
            items: nationalityList.map((age) {
              return DropdownMenuItem(
                child: Text(age,
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
                value: age.toString(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  buildSellProduct() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
            onTap: () async {
              await context.read<CarProvider>().getAllCars(makeId: selectedMakeId,modelId: selectedModelId,
                  categoryId: categoryTypeId,year: selectedDob == "year".tr() ? "" : selectedDob,vin: vinController.text.trim());
            },
            child: SubmitButton(
              height: 55,
              value: "searchBtn".tr().toUpperCase(),
              textColor: Colors.white,
              color: AppColors.btnBlackColor,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            )));
  }

  _makeDropDown(UserProvider value) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
      margin: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0, bottom: 0),
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
        // value: selectedMakeName,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text(selectedMakeName??"Make",
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        onChanged: (newValue) async {
          vinController.text = "";
          if (newValue != null) {
            selectedModelName = "Make";
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

  _modelDropDown(UserProvider value) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
      margin: const EdgeInsets.only(top: 0, left: 16.0, right: 16.0, bottom: 0),
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
          vinController.text = "";
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

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            Text("sellACar".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }

  _buildSingleChildScroll() {
    return Consumer<CarProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return (value.allCarsModel?.result?.products??[]).isNotEmpty && value.allCarsModel != null ?
        ListView.builder(
          padding: const EdgeInsets.only(left: 16,right: 16,bottom: 100),
          itemCount: value.allCarsModel?.result?.products?.length??0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return buildListTile(value.allCarsModel?.result?.products?[index]);
          },
        ):const NoDataWidget();
      },
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

  buildListTile(AllCarsDetail? length) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SellCompleteCarScreen(carId: length?.id.toString())));
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        length?.carNames??"",
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_18, AppColors.blackColor)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset("assets/images/dummy_car.png",width: 40,),
                        const SizedBox(width: 8),
                        Text(length?.carCategory?.name??"",
                            style: AppTextStyles.mediumStyle(
                                AppFontSize.font_14, AppColors.blackColor)),
                        const Spacer(),
                        // Text(length.region??"",
                        //     style: AppTextStyles.boldStyle(
                        //         AppFontSize.font_14, AppColors.brownColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppImages.calendar,
                                fit: BoxFit.fill,
                                height: 15,
                                width: 15,
                                color: AppColors.btnBlackColor,
                              ),
                              const SizedBox(width: 10),
                              Text(length?.year??"",
                                  style: AppTextStyles.boldStyle(
                                      AppFontSize.font_14,
                                      AppColors.hintTextColor)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(length?.transmissionType??"",
                                  style: AppTextStyles.mediumStyle(
                                      AppFontSize.font_14,
                                      AppColors.blackColor)),
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
}