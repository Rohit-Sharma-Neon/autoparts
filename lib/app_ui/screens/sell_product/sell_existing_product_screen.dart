import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/sell_listing_response.dart';
import 'package:autoparts/provider/products_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter_switch/flutter_switch.dart";
import 'package:provider/provider.dart';

import '../../../models/all_cars_model.dart';
import '../../../provider/car_provider.dart';
import '../../common_widget/show_dialog.dart';

class SellExistingProductScreen extends StatefulWidget {
  static const routeName = "/sell-product-detail";
  final String? productId, productNumber;
  final SoldData? existingData;
  final bool isUpdating;
  const SellExistingProductScreen({Key? key,this.productId, this.productNumber,this.existingData,this.isUpdating = false}) : super(key: key);

  @override
  _SellExistingProductScreenState createState() => _SellExistingProductScreenState();
}

class _SellExistingProductScreenState extends State<SellExistingProductScreen> {
  int conditionValue = -1;
  bool expectancySwitch = false;
  bool secondarySwitch = false;
  String kmMonth = "KM";
  String milesYear = "Miles";
  String? distanceType;
  String condition = "";
  TextEditingController priceController = TextEditingController();
  TextEditingController expectancyController = TextEditingController();
  TextEditingController wareHouseController = TextEditingController();

  String? selectedCarName;
  String? selectedCarId;

  @override
  void initState() {
    super.initState();
    if(widget.existingData != null){
      setData();
    }
  }

  setData(){
    if((widget.existingData?.productCondition??"") == "New"){
      conditionValue = 1;
      condition = "New";
    }else if((widget.existingData?.productCondition??"") == "Used"){
      conditionValue = 2;
      condition = "Used";
    }else if((widget.existingData?.productCondition??"") == "Salvage"){
      conditionValue = 3;
      condition = "Salvage";
    }else{
      conditionValue = -1;
    }
    if((widget.existingData?.lifeExpectancyType??"") == "Time"){
      setState(() {
        secondarySwitch = true;
      });
    }else{
      setState(() {
        secondarySwitch = false;
      });
    }
    // expectancySwitch = (widget.existingData?.lifeExpectancyType??"") == "Time" ? true : false;
    // secondarySwitch = false;
    if (!secondarySwitch) {
      kmMonth = "KM";
      milesYear = "Miles";
    }else{
      kmMonth = "Months";
      milesYear = "Years";
    }
    distanceType = widget.existingData?.distanceType.toString()??"";
    priceController.text = widget.existingData?.price.toString()??"";
    expectancyController.text = widget.existingData?.lifeExpectancy.toString()??"";
    wareHouseController.text = widget.existingData?.warehouseCode??"";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [customAppbar(), _buildBody()],
        ));
  }

  _buildCarDropDown() {
    return Consumer<CarProvider>(
      builder: (BuildContext context, value, Widget? child) {
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

  _buildBody() {
    return Expanded(
        child: ListView(padding: const EdgeInsets.all(0), children: [
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("productDetail".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_20, AppColors.submitGradiantColor1),
              ),
          ),
          // const SizedBox(height: 16),
          // _buildCarDropDown(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16,bottom: 10),
            child: Text("Product Price",
                textAlign: TextAlign.start,
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.whiteColor,
            child: CustomRoundTextField(
              hintText: "productPrice".tr(),
              keyboardType: TextInputType.number,
              controller: priceController,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("AED",style: TextStyle(fontWeight: FontWeight.w800),),
                ],
              ),
              fillColor: AppColors.whiteColor,
            ),
          ),
          buildContainer(),
      // buildProductsPartsList(),
    ]));
  }

  buildContainer() {
    return Container(
        color: AppColors.whiteColor,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("condition".tr(),
                textAlign: TextAlign.start,
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            Row(children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 1,
                        groupValue: conditionValue,
                        onChanged: (index) {
                          setState(() {
                            conditionValue = 1;
                          });
                        },
                        activeColor:AppColors.brownColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("newString".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 2,
                        groupValue: conditionValue,
                        onChanged: (index) {
                          setState(() {
                            conditionValue = 2;
                          });
                        },
                        activeColor:AppColors.brownColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("conditionUsed".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 3,
                        groupValue: conditionValue,
                        onChanged: (index) {
                          setState(() {
                            conditionValue = 3;
                          });
                        },
                        activeColor:AppColors.brownColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("conditionSalvage".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ]),
            const SizedBox(height: 10),
            Text("lifeExpectancy".tr(),
                textAlign: TextAlign.start,
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            const SizedBox(height: 16),
            Row(
              children: [
                Text("distance".tr(),
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
                const SizedBox(width: 5),
                FlutterSwitch(
                  height: 28.0,
                  width: 60.0,
                  padding: 5.0,
                  toggleSize: 25.0,
                  borderRadius: 30.0,
                  toggleColor: AppColors.brownColor,
                  activeColor: AppColors.btnBlackColor,
                  inactiveColor: AppColors.btnBlackColor,
                  value: secondarySwitch,
                  onToggle: (value) {
                    setState(() {
                      secondarySwitch = value;
                      if(secondarySwitch){
                        kmMonth = "Months";
                        milesYear = "Years";
                      }else{
                        kmMonth = "KM";
                        milesYear = "Miles";
                      }
                    });
                  },
                ),
                const SizedBox(width: 5),
                Text("time".tr(),
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomRoundTextField(
                      hintText: "lifeExpectancyHint".tr(),
                      fillColor: AppColors.whiteColor,
                      controller: expectancyController,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(kmMonth,
                          style: AppTextStyles.mediumStyle(
                              AppFontSize.font_16, AppColors.blackColor)),
                      const SizedBox(width: 5),
                      FlutterSwitch(
                        height: 28.0,
                        width: 60.0,
                        padding: 5.0,
                        toggleSize: 25.0,
                        borderRadius: 30.0,
                        toggleColor: AppColors.brownColor,
                        activeColor: AppColors.btnBlackColor,
                        inactiveColor: AppColors.btnBlackColor,
                        value: expectancySwitch,
                        onToggle: (value) {
                          print(value.toString());
                          setState(() {
                            expectancySwitch = value;
                          });
                          if(expectancySwitch){
                            distanceType = kmMonth;
                          }else{
                            distanceType = milesYear;
                          }
                        },
                      ),
                      const SizedBox(width: 5),
                      Text(milesYear,
                          style: AppTextStyles.mediumStyle(
                              AppFontSize.font_16, AppColors.blackColor)),
                    ],
                  ),
                ]),
            const SizedBox(height: 10),
            CustomRoundTextField(
              hintText: "Input Warehouse Code",
              fillColor: AppColors.whiteColor,
              controller: wareHouseController,
              onChanged: (text) {},
            ),
            /*const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                if(priceController.text.trim().isEmpty){
                  showToastMessage("Price can't be empty");
                }else if(conditionValue == -1){
                  showToastMessage("Please select condition.");
                }else if(expectancyController.text.trim().isEmpty){
                  showToastMessage("Please enter expectancy.");
                }else if(wareHouseController.text.trim().isEmpty){
                  showToastMessage("Please enter Warehouse Code.");
                }else{
                  String condition = "";
                  if(conditionValue == 1){
                    condition = "New";
                  }else if(conditionValue == 2){
                    condition = "Used";
                  }else if(conditionValue == 3){
                    condition = "Salvage";
                  }
                  await context.read<ProductsProvider>().sellProductApi(price: priceController.text.trim(),
                      condition: condition,expectancyType: expectancySwitch ? "Distance" : "Type",
                      expectancy: expectancyController.text.trim(),expectancyDurationType: distanceType,
                      isProductNew: false,shouldPop: false,wareHouseCode: wareHouseController.text.trim(),
                      productId: widget.productId
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(), //here we set the circular figure
                        color: AppColors.brownColor),
                    child: const Center(
                        child: Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    )),
                  ),
                  const SizedBox(width: 10),
                  Text("addMoreUnit".tr(),
                      style: AppTextStyles.boldDecorationStyle(
                          TextDecoration.underline,
                          AppFontSize.font_16,
                          AppColors.brownColor)),
                ],
              ),
            ),*/
            const SizedBox(height: 25),
            GestureDetector(
                onTap: () async {
                  if(priceController.text.trim().isEmpty){
                    showToastMessage("Price can't be empty");
                  }else if(conditionValue == -1){
                    showToastMessage("Please select condition.");
                  }else if(expectancyController.text.trim().isEmpty){
                    showToastMessage("Please enter expectancy.");
                  }else if(wareHouseController.text.trim().isEmpty){
                    showToastMessage("Please enter Warehouse Code.");
                  }else{
                    if(conditionValue == 1){
                      condition = "New";
                    }else if(conditionValue == 2){
                      condition = "Used";
                    }else if(conditionValue == 3){
                      condition = "Salvage";
                    }
                    if (widget.isUpdating) {
                      print(secondarySwitch.toString());
                      await context.read<ProductsProvider>().updateSoldProductApi(price: priceController.text.trim(),
                          condition: condition,expectancyType: !secondarySwitch ? "Distance" : "Time",
                          expectancy: expectancyController.text.trim(),expectancyDurationType: distanceType,
                          isProductNew: false,shouldPop: true,wareHouseCode: wareHouseController.text.trim(),
                          productId: widget.existingData?.productId.toString()??"",recordId: widget.existingData?.id.toString()??"",
                      ).then((value) {
                        if(value){
                          Navigator.pop(context,"update");
                        }
                      });
                    }else{
                      await context.read<ProductsProvider>().sellProductApi(price: priceController.text.trim(),
                          condition: condition,expectancyType: !secondarySwitch ? "Distance" : "Time",
                          expectancy: expectancyController.text.trim(),expectancyDurationType: distanceType,
                          isProductNew: false,shouldPop: true,wareHouseCode: wareHouseController.text.trim(),
                          productId: widget.productId
                      ).then((value) {
                        if(value){
                          showActionDialog(context, "Product Added Successfully\nDo you want to add more car?", (){
                            clearForm();
                          },onNoPressed: (){
                            Navigator.pop(context,"update");
                            Navigator.pop(context,"update");
                          });
                        }
                      });
                    }
                  }
                },
                child: SubmitButton(
                  height: 50,
                  value: widget.isUpdating ? "Update" : "save".tr().toUpperCase(),
                  textColor: Colors.white,
                  color: AppColors.btnBlackColor,
                  textStyle: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.whiteColor),
                )),
            const SizedBox(height: 25),
          ],
        ));
  }

  clearForm(){
    priceController.text = "";
    conditionValue = -1;
    expectancySwitch = false;
    expectancyController.text = "";
    wareHouseController.text = "";
    secondarySwitch = false;
    Navigator.pop(context);
    setState(() {});
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
            Text(widget.productNumber??"",
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }
}
