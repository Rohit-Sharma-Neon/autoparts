import 'dart:io';

import 'package:autoparts/api_service/api_base_helper.dart';
import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/sell_listing_response.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';

class SellCompleteCarScreen extends StatefulWidget {
  static const routeName = "/sell-complete-car";
  final String? carId;
  final SoldData? carData;
  final bool isUpdating;
  const SellCompleteCarScreen({Key? key,this.carId,this.carData,this.isUpdating = false}) : super(key: key);

  @override
  _SellCompleteCarScreenState createState() => _SellCompleteCarScreenState();
}

class _SellCompleteCarScreenState extends State<SellCompleteCarScreen> {
  int conditionValue = -1;
  String? conditionStatus;
  int warrantyValue = -1;
  int selectedColorIndex = -1;
  String? selectedColorCode;
  final ImagePicker _picker = ImagePicker();
  List<ProductColorModel> colorData = [];
  bool mileageSwitch = false;
  bool kmSwitched = false;
  bool timeSwitched = false;
  String? imageOne,imageTwo,imageThree;
  String? imageType;
  TextEditingController chassisNumberController = TextEditingController();
  TextEditingController warrantyDurationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController engineController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController drivenController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    colorData.add(ProductColorModel(color: AppColors.carModelColor1));
    colorData.add(ProductColorModel(color: AppColors.carModelColor2));
    colorData.add(ProductColorModel(color: AppColors.carModelColor3));
    colorData.add(ProductColorModel(color: AppColors.carModelColor4));
    colorData.add(ProductColorModel(color: AppColors.blackColor));
    colorData.add(ProductColorModel(color: AppColors.greyColor));
    super.initState();
    if(widget.carData != null){
      setData();
    }
  }

  String? selectedTransmissionType;

  setData(){
    imageOne = widget.carData?.image??"";
    imageTwo = widget.carData?.imageTwo??"";
    imageThree = widget.carData?.imageThree??"";
    descriptionController.text = widget.carData?.description??"";
    mileageController.text = widget.carData?.mileage??"";
    selectedColorCode = widget.carData?.color??"";
    if((widget.carData?.productCondition??"") == "New"){
      conditionValue = 0;
      conditionStatus = "New";
    }else if((widget.carData?.productCondition??"") == "Used"){
      conditionValue = 1;
      conditionStatus = "Used";
    }else if((widget.carData?.productCondition??"") == "Salvage"){
      conditionValue = 2;
      conditionStatus = "Salvage";
    }else{
      conditionValue = -1;
    }
    if((widget.carData?.warranty??"") == "Yes"){
      warrantyValue = 1;
    }else if((widget.carData?.productCondition??"") == "Used"){
      warrantyValue = 2;
    }else{
      warrantyValue = -1;
    }
    mileageSwitch = (widget.carData?.mileageType??"") == "Km" ? false : true;
    kmSwitched = (widget.carData?.sellData?.mileageType??"") == "Km" ? false : true;
    timeSwitched = (widget.carData?.sellData?.warrantyType??"") == "Months" ? false : true;
    chassisNumberController.text = widget.carData?.sellData?.chassisNumber??"";
    drivenController.text = widget.carData?.sellData?.kmDriven??"";
    warrantyDurationController.text = widget.carData?.sellData?.warrantyTime??"";
    engineController.text = widget.carData?.sellData?.engineNumber??"";
    priceController.text = widget.carData?.price.toString()??"";
    colorData.forEach((element) {
      if(element.color.toHex() == (widget.carData?.color??"")){
        setState(() {
          selectedColorIndex = colorData.indexOf(element);
        });
      }
    });
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customAppbar(),
            _buildBody()
          ],
        ));
  }

  _buildBody() {
    return Expanded(
        child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
          const SizedBox(height: 5),
          Text("Images",
              textAlign: TextAlign.start,
              style: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.submitGradiantColor1)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      imageType = "imageOne";
                    });
                    _showImagePicker(context);
                  },
                  child: (imageOne??"").isEmpty ? Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.messageBgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.blackColor, width: 1)),
                      child: Image.asset(
                        "assets/images/business_car.png",
                        width: 60,
                        height: 60,
                      )):
                  Container(
                    height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.messageBgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.blackColor, width: 1)),
                      child: CachedNetworkImage(imageUrl:baseImageUrl + (imageOne??""))),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      imageType = "imageTwo";
                    });
                    _showImagePicker(context);
                  },
                  child: (imageTwo??"").isEmpty ? Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.messageBgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.blackColor, width: 1)),
                      child: Image.asset(
                        "assets/images/business_car.png",
                        width: 60,
                        height: 60,
                      )):
                  Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.messageBgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.blackColor, width: 1)),
                      child: CachedNetworkImage(imageUrl:baseImageUrl + (imageTwo??""))),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      imageType = "imageThree";
                    });
                    _showImagePicker(context);
                  },
                  child: (imageThree??"").isEmpty ? Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.messageBgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.blackColor, width: 1)),
                      child: Image.asset(
                        "assets/images/business_car.png",
                        width: 60,
                        height: 60,
                      )):
                  Container(
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.messageBgColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.blackColor, width: 1)),
                      child: CachedNetworkImage(imageUrl:baseImageUrl + (imageThree??""))),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 16),
          // GestureDetector(
          //   onTap: (){},
          //   child: SubmitButton(
          //     height: 40,
          //     value: "Upload Images",
          //     textColor: Colors.white,
          //     color: AppColors.btnBlackColor,
          //     textStyle: AppTextStyles.mediumStyle(
          //         AppFontSize.font_16, AppColors.whiteColor),
          //   ),
          // ),
          const SizedBox(height: 16),
          CustomRoundTextField(
            padding: EdgeInsets.zero,
            controller: chassisNumberController,
            hintText: "Chassis Number",
            fillColor: AppColors.whiteColor,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
            ],
            onChanged: (text) {},
          ),
          const SizedBox(height: 16),
          CustomRoundTextField(
            padding: EdgeInsets.zero,
            maxLines: 10,
            minLines: 5,
            controller: descriptionController,
            hintText: "Description",
            fillColor: AppColors.whiteColor,
            onChanged: (text) {},
          ),
          const SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomRoundTextField(
                    padding: EdgeInsets.zero,
                    hintText: "Mileage",
                    controller: mileageController,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    fillColor: AppColors.whiteColor,
                    onChanged: (text) {},
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text("km".tr(),
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
                      value: mileageSwitch,
                      onToggle: (value) {
                        setState(() {
                          mileageSwitch = value;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Text("miles".tr(),
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.blackColor)),
                  ],
                ),
              ]),
          const SizedBox(height: 16),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomRoundTextField(
                    padding: EdgeInsets.zero,
                    hintText: "Total Driven",
                    controller: drivenController,
                    keyboardType: TextInputType.number,
                    fillColor: AppColors.whiteColor,
                    onChanged: (text) {},
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text("km".tr(),
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
                      value: kmSwitched,
                      onToggle: (value) {
                        setState(() {
                          kmSwitched = value;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Text("miles".tr(),
                        style: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.blackColor)),
                  ],
                ),
              ]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: CustomRoundTextField(
                  padding: EdgeInsets.zero,
                  controller: warrantyDurationController,
                  hintText: "Warranty Duration",
                  fillColor: AppColors.whiteColor,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {},
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Text("Months",
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
                    value: timeSwitched,
                    onToggle: (value) {
                      setState(() {
                        timeSwitched = value;
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                  Text("Years", style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomRoundTextField(
            padding: EdgeInsets.zero,
            hintText: "Engine No.",
            fillColor: AppColors.whiteColor,
            controller: engineController,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            onChanged: (text) {},
          ),
          const SizedBox(height: 16),
          buildRadioButtons(),
          const SizedBox(height: 10),
          CustomRoundTextField(
            padding: EdgeInsets.zero,
            hintText: "Product Price",
            fillColor: AppColors.whiteColor,
            controller: priceController,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("AED",style: TextStyle(fontWeight: FontWeight.w800),),
              ],
            ),
            keyboardType: TextInputType.number,
            onChanged: (text) {},
          ),
          const SizedBox(height: 10),
          Text("Color",
              textAlign: TextAlign.start,
              style: AppTextStyles.boldStyle(
                  AppFontSize.font_16, AppColors.blackColor)),
          _builtColors(),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              if((imageOne??"").isEmpty&&(imageTwo??"").isEmpty&&(imageThree??"").isEmpty){
                showToastMessage("Minimum 1 image required!");
              }else if(chassisNumberController.text.isEmpty){
                showToastMessage("Chassis No. required!");
              }else if(descriptionController.text.isEmpty){
                showToastMessage("Description required!");
              }else if(mileageController.text.isEmpty){
                showToastMessage("Mileage required!");
              }else if(drivenController.text.isEmpty){
                showToastMessage("Driven Number required!");
              }else if(warrantyDurationController.text.isEmpty){
                showToastMessage("Warranty Duration required!");
              }else if(engineController.text.isEmpty){
                showToastMessage("Engine No. required!");
              }else if(conditionValue == -1){
                showToastMessage("Select Condition");
              }else if(priceController.text.isEmpty){
                showToastMessage("Price required!");
              }else if(selectedColorIndex == -1){
                showToastMessage("Please select Color");
              }else{
                FocusScope.of(context).unfocus();
                if (widget.isUpdating) {
                  await context.read<UserProvider>().updateSoldCar(
                    imageOne: imageOne??"",
                    imageTwo: imageTwo??"",
                    imageThree: imageThree??"",
                    description: descriptionController.text.trim(),
                    mileage: mileageController.text.trim(),
                    mileageType: mileageSwitch ? "Miles" : "Km",
                    carCondition: conditionStatus,
                    warranty: warrantyValue == 1 ? "Yes" : "No",
                    price: priceController.text.trim(),
                    color: selectedColorCode,
                    carId: widget.carData?.productId.toString()??"",
                    recordId: widget.carData?.id.toString()??"",
                    chassisNumber: chassisNumberController.text.trim(),
                    kmDriven: drivenController.text.trim(),
                    kmDrivenType: kmSwitched ? "Miles" : "Km",
                    warrantyTime: warrantyDurationController.text.trim(),
                    warrantyType: timeSwitched ? "Years" : "Months",
                    engineNumber: engineController.text.trim(),
                  );
                }else{
                  await context.read<UserProvider>().carSellApi(
                    imageOne: imageOne??"",
                    imageTwo: imageTwo??"",
                    imageThree: imageThree??"",
                    description: descriptionController.text.trim(),
                    mileage: mileageController.text.trim(),
                    mileageType: mileageSwitch ? "Miles" : "Km",
                    carCondition: conditionStatus,
                    warranty: warrantyValue == 1 ? "Yes" : "No",
                    price: priceController.text.trim(),
                    color: selectedColorCode,
                    carId: widget.carId,
                    chassisNumber: chassisNumberController.text.trim(),
                    kmDriven: drivenController.text.trim(),
                    kmDrivenType: kmSwitched ? "Miles" : "Km",
                    warrantyTime: warrantyDurationController.text.trim(),
                    warrantyType: timeSwitched ? "Years" : "Months",
                    engineNumber: engineController.text.trim(),
                  ).then((value) {
                    if(value){
                      showActionDialog(context, "Car Added Successfully\nDo you want to add more car?", (){
                        clearForm();
                      },onNoPressed: (){
                        Navigator.pop(context,"update");
                        Navigator.pop(context,"update");
                      });
                    }
                  });
                }
              }
              // else if(selectedColorIndex == -1){
              //   showToastMessage("Select Color");
              // }
            },
            child: SubmitButton(
              height: 55,
              value: widget.isUpdating ? "Update" : "save".tr().toUpperCase(),
              textColor: Colors.white,
              color: AppColors.btnBlackColor,
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.whiteColor),
            ),
          ),
          const SizedBox(height: 16),

      // buildProductsPartsList(),
    ]));
  }

  clearForm(){
    imageOne = "";
    imageTwo = "";
    imageThree = "";
    descriptionController.text = "";
    mileageController.text = "";
    mileageSwitch = false;
    conditionValue = -1;
    conditionStatus = "";
    warrantyValue = -1;
    priceController.text = "";
    selectedColorCode = "";
    selectedColorIndex = -1;
    chassisNumberController.text = "";
    drivenController.text = "";
    warrantyDurationController.text = "";
    engineController.text = "";
    kmSwitched = false;
    timeSwitched = false;
    Navigator.pop(context);
    setState(() {});
  }

  _builtColors() {
    return Container(
        padding: const EdgeInsets.all(0),
        child: Column(children: [
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(colorData.length, (index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColorIndex = index;
                          selectedColorCode = colorData[index].color.toHex(leadingHashSign: true);
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: selectedColorIndex == index
                                      ? AppColors.blackColor
                                      : Colors.white,
                                  width: 2),
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: colorData[index].color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                }),
              ]),
          const SizedBox(
            height: 15,
          ),
        ]));
  }


  buildRadioButtons(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Condition",
            textAlign: TextAlign.start,
            style: AppTextStyles.boldStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        Row(
            children: [
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
                          conditionStatus = "New";
                          setState(() {
                            conditionValue = 1;
                          });
                        },
                        activeColor: AppColors.brownColor,
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
                          conditionStatus = "Used";
                          setState(() {
                            conditionValue = 2;
                          });
                        },
                        activeColor: AppColors.brownColor,
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
                          conditionStatus = "Salvage";
                          setState(() {
                            conditionValue = 3;
                          });
                        },
                        activeColor: AppColors.brownColor,
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
        const SizedBox(height: 8),
      ],
    );
  }

  _buildProductImage(position) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(5, (index) {
            return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
                    color: AppColors.messageBgColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.borderColor, width: 2)),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.defaultImage,
                      width: 60,
                      height: 60,
                    ),
                  ],
                ));
          })
        ]);
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
            Text("sellCompleteCar".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }
  void _showImagePicker(context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text("photoGallery".tr()),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text("camera".tr()),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    var file = await cropImage(File(image!.path));
    var response =
    await ApiBaseHelper().imageUploadApi(File(file!.path), "Profile");
    if (imageType == "imageOne") {
      imageOne = response;
    } else if (imageType == "imageTwo") {
      imageTwo = response;
    } else if(imageType == "imageThree"){
      imageThree = response;
    }
    setState(() {});
  }

  _imgFromGallery() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var file = await cropImage(File(image!.path));
    var response =
    await ApiBaseHelper().imageUploadApi(File(file!.path), "Profile");
    if (imageType == "imageOne") {
      imageOne = response;
    } else if (imageType == "imageTwo") {
      imageTwo = response;
    } else if(imageType == "imageThree"){
      imageThree = response;
    }
    setState(() {});
  }

  Future<File?> cropImage(pickedFile) async {
    File? file;
    if (pickedFile != null) {
      file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 311,
          ratioY: 127,
        ),
        cropStyle: CropStyle.rectangle,
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: AppColors.btnBlackColor,
          toolbarWidgetColor: AppColors.brownColor,
          activeControlsWidgetColor: AppColors.brownColor,
          backgroundColor: AppColors.btnBlackColor,
          hideBottomControls: true,
          showCropGrid: false,
          cropFrameColor: Colors.transparent,
        ),
        iosUiSettings: const IOSUiSettings(
          aspectRatioLockEnabled: true,
        ),
        maxHeight: 750,
        maxWidth: 512,
      );
    }
    return file!;
  }


}

class ProductColorModel {
  Color color;
  ProductColorModel({required this.color});
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

