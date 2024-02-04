import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/sell_car/sell_complete_car_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/car_makes_response.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
class SellCarScreen extends StatefulWidget {
  static const routeName = "/sell-car";
  const SellCarScreen({Key? key}) : super(key: key);

  @override
  _SellCarScreenState createState() => _SellCarScreenState();
}
class _SellCarScreenState extends State<SellCarScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customAppbar(),
            _buildSingleChildScroll()
          ],
        ));
  }
   buildSellProduct() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SellCompleteCarScreen.routeName);
            },
            child: SubmitButton(
              height: 55,
              value: "continueText".tr().toUpperCase(),
              textColor: Colors.white,
              color: AppColors.submitGradiantColor1,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            )));
  }
  _buildSingleChildScroll() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            3,
            (position) {
              return Card(
                  color: AppColors.whiteColor,
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        AppImages.carCargo,
                        width: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.width * .4,
                      ),
                      Text("wantToSell".tr(),
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_22, AppColors.blackColor)),
                      const SizedBox(height: 10),
                      Text("completeCar".tr(),
                          style: AppTextStyles.boldStyle(
                              AppFontSize.font_28, AppColors.blackColor)),
                      const SizedBox(height: 10),
                      buildSellProduct(),
                    ],
                  ));
            },
          ),
        ),
      ),
    );
  }
  String? selectedMakeName;
  String? selectedMakeId;
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
  _buildDropDown() {
    return Consumer<UserProvider>(
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
            value: selectedMakeName,
            iconEnabledColor: AppColors.blackColor,
            iconDisabledColor: AppColors.blackColor,
            hint: Text("Make",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            onChanged: (newValue) {
              setState(() {
                selectedMakeName = newValue.toString();
                for (var a in value.carMakesResponse?.result?.records??[]) {
                  if (a.name == newValue.toString()) {
                    selectedMakeId = a.id.toString();
                  }
                }
              });
            },
            items: (value.carMakesResponse?.result?.records??[]).map((CarMakeRecord e) {
              return DropdownMenuItem(
                child: Text(e.title??"",
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
                value: e.title.toString(),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}