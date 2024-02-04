import 'dart:io';

import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/all_cars_model.dart';
import 'package:autoparts/models/car_category_model.dart';
import 'package:autoparts/models/sell_listing_response.dart';
import 'package:autoparts/provider/loading_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_switch/flutter_switch.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../api_service/api_base_helper.dart';
import '../../../api_service/api_config.dart';
import '../../../provider/car_provider.dart';
import '../../../provider/products_provider.dart';
import '../../common_widget/show_dialog.dart';

class AddNewProductScreen extends StatefulWidget {
  static const routeName = "/add-product";
  final SoldData? existingData;
  final bool isUpdating;
  const AddNewProductScreen({Key? key, this.existingData,this.isUpdating = false}) : super(key: key);

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  int conditionValue = -1;
  String condition = "";
  bool expectancySwitch = false;
  bool secondarySwitch = false;
  String? selectNationality;
  String? productImage;
  String? uploadedVideoPath;
  late VideoPlayerController _videoPlayerController;
  File? file;
  final ImagePicker _picker = ImagePicker();
  String? productVideo;
  String kmMonth = "KM";
  String milesYear = "Miles";
  List<String> nationalityList = [];
  List<CarCategories>? categories = [];
  String? distanceType;
  TextEditingController priceController = TextEditingController();
  TextEditingController expectancyController = TextEditingController();
  TextEditingController wareHouseController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController specificationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nationalityList.add("India");
    nationalityList.add("Pakistan");
    nationalityList.add("Nepal");
    super.initState();
    Future.microtask(() async {
      context.read<CarProvider>().getAllCars();
      await context.read<CarProvider>().getTopCategoriesApi("2");
      categories = context.read<CarProvider>().categories;
      if(widget.existingData != null){
        setData();
      }
    });
  }

  String? selectedCarName;
  String? selectedCarId;

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
    if (!secondarySwitch) {
      kmMonth = "KM";
      milesYear = "Miles";
    }else{
      kmMonth = "Months";
      milesYear = "Years";
    }
    categories?.forEach((element) {
      if(element.id == (widget.existingData?.products?.categoryId??0)){
        selectedPartCategory = element.name??"";
        selectedPartCategoryId = element.id.toString();
      }
    });
    distanceType;
    priceController.text = widget.existingData?.price.toString()??"";
    expectancyController.text = widget.existingData?.lifeExpectancy.toString()??"";
    wareHouseController.text = widget.existingData?.warehouseCode??"";
    businessNameController.text = widget.existingData?.products?.name??"";
    specificationController.text = widget.existingData?.products?.descriptions??"";
    productImage = widget.existingData?.products?.imageUrl??"";

    setState(() {});
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
        child: ListView(children: [
          _buildCarDropDown(),
          const SizedBox(height: 16),
          _makeDropDown(),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("productImage".tr(),
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.submitGradiantColor1))),
          const SizedBox(height: 10),
          _buildProductImage(),
          const SizedBox(height: 16),
          technicalSpecificationTextField(),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("video".tr(),
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.submitGradiantColor1))),
          const SizedBox(height: 10),
          _buildProductVideo(),
          const SizedBox(height: 16),
          _buildBody2()
        ]));
  }

  _buildBody2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text("productDetail".tr(),
          style: AppTextStyles.boldStyle(
              AppFontSize.font_20, AppColors.submitGradiantColor1),
        ),
      ),
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
          fillColor: AppColors.whiteColor,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("AED",style: TextStyle(fontWeight: FontWeight.w800),),
            ],
          ),
        ),
      ),
      buildContainer(),
      // buildProductsPartsList(),
    ]);
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

  // businessTextField() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     color: AppColors.whiteColor,
  //     child: CustomRoundTextField(
  //       padding: const EdgeInsets.all(0),
  //       hintText: "nameOfBusiness".tr(),
  //       fillColor: AppColors.whiteColor,
  //       controller: businessNameController,
  //       onChanged: (text) {},
  //     ),
  //   );
  // }

  technicalSpecificationTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        maxLines: 5,
        minLines: 5,
        padding: const EdgeInsets.all(0),
        hintText: "technicalSpecification".tr(),
        controller: specificationController,
        fillColor: AppColors.whiteColor,
        onChanged: (text) {},
      ),
    );
  }

  productPriceTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        padding: const EdgeInsets.all(0),
        hintText: "productPrice".tr(),
        keyboardType: TextInputType.number,
        fillColor: AppColors.whiteColor,
        onChanged: (text) {},
      ),
    );
  }

  String? selectedPartCategory;
  String? selectedPartCategoryId;


  _makeDropDown() {
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
            // value: selectedPartCategory,
            iconEnabledColor: AppColors.blackColor,
            iconDisabledColor: AppColors.blackColor,
            hint: Text(selectedPartCategory??"partCategoryHint".tr(),
                style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor)),
            onChanged: (newValue) async {
              if (newValue != null) {
                setState(() {
                  selectedPartCategory = newValue.toString();
                  for (var a in value.categories!) {
                    if (a.name == newValue.toString()) {
                      selectedPartCategoryId = a.id.toString();
                    }
                  }
                });
              }
            },
            items: value.categories!.map((names) {
              return DropdownMenuItem(
                child: Text(names.name??"",
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
                value: names.name??"",
              );
            }).toList(),
          ),
        );
      },
    );
  }
  _buildDropDown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding:
          const EdgeInsets.only(top: 3, left: 10.0, right: 10.0, bottom: 3),
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
        hint: Text("partCategoryHint".tr(),
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

  _buildProductImage() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 200,
        decoration: BoxDecoration(
            color: AppColors.messageBgColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.borderColor, width: 2)),
        child: Column(
          children: [
            productImage != null
                ? Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6),
                    topLeft: Radius.circular(6)),
                child: Image.network(
                  baseImageUrl + productImage!,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Expanded(
              child: Image.asset(
                AppImages.defaultImage,
              ),
            ),
            GestureDetector(
                onTap: () {
                  _showImagePicker(context,willCrop: true);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.btnBlackColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(6),
                        bottomLeft: Radius.circular(6)),
                  ),
                  height: 40,
                  child: Text("uploadImage".tr(),
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_14, AppColors.whiteColor)),
                ))
          ],
        ));
  }

  void _showImagePicker(context,{bool willCrop = true}) {
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
                      if (willCrop) {
                        _imgFromGallery();
                      }else{
                        _imgFromGalleryWithoutCrop();
                      }
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text("camera".tr()),
                  onTap: () {
                    if (willCrop) {
                      _imgFromCamera();
                    }else{
                      _imgFromCameraWithoutCrop();
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showVideoPicker(context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text("Gallery"),
                    onTap: () {
                      _getGalleryVideo();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text("camera".tr()),
                  onTap: () {
                    _captureVideo();
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
    var response = await ApiBaseHelper().imageUploadApi(File(file!.path), "Profile");
    productImage = response;
    setState(() {});
  }

  _imgFromCameraWithoutCrop({bool getVideo = false}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    var response = await ApiBaseHelper().imageUploadApi(File(image!.path), "Profile");
    productImage = response;
    setState(() {});
  }

  _imgFromGalleryWithoutCrop() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var response = await ApiBaseHelper().imageUploadApi(File(image?.path??""), "Profile");
    productImage = response;
    setState(() {});
  }

  _imgFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var file = await cropImage(File(image!.path));
    var response = await ApiBaseHelper().imageUploadApi(File(file!.path), "Profile");
    productImage = response;
    setState(() {});
  }

  _captureVideo(){

  }
  _getGalleryVideo() async {
    final XFile? image = await _picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 3));
    uploadedVideoPath = await ApiBaseHelper().imageUploadApi(File(image?.path??""), "Profile",isVideoUploading: true);
    setState(() {
      file = File(image?.path??"");
      _videoPlayerController = VideoPlayerController.file(file!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController.play();
        });
    });
  }

  _videoPicker(){

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

  _buildProductVideo() {
    return Container(
        height: 168,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: AppColors.messageBgColor,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.borderColor, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            file != null ? Container(
                height: 120,
                width: MediaQuery.of(context)
                    .size
                    .width /
                    1.3,
                child: VideoPlayer(_videoPlayerController)):
            Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  AppImages.videoPlay,
                  height: 60,
                  width: 60,
                ),
              ],
            ),
            Column(
              children: [
                Consumer<LoadingProvider>(builder: (BuildContext context, loading, Widget? child) {
                  return (loading.isVideoUploading??false) ? LinearProgressIndicator(color: Colors.green,backgroundColor: Colors.grey.shade400):const SizedBox();
                }),
                GestureDetector(
                  onTap: (){
                    _showVideoPicker(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.btnBlackColor,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6)),
                    ),
                    height: 40,
                    child: Text("uploadVideo".tr(),
                        style: AppTextStyles.boldStyle(
                            AppFontSize.font_14, AppColors.whiteColor)),
                  ),
                )
              ],
            ),

          ],
        ));
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
                  if((selectedPartCategoryId??"").isEmpty){
                    showToastMessage("Please select Part Category");
                  }else if((productImage??"").isEmpty){
                    showToastMessage("Please select Product Image");
                  }else if(specificationController.text.trim().isEmpty){
                    showToastMessage("Specification can't be empty");
                  }else if(priceController.text.trim().isEmpty){
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
                      print(expectancySwitch.toString());
                      await context.read<ProductsProvider>().updateSoldProductApi(price: priceController.text.trim(),
                          condition: condition,expectancyType: !expectancySwitch ? "Distance" : "Time",
                          expectancy: expectancyController.text.trim(),expectancyDurationType: distanceType,businessName: businessNameController.text,
                          isProductNew: true,shouldPop: true,wareHouseCode: wareHouseController.text.trim(),
                          productId: widget.existingData?.productId.toString()??"",description: specificationController.text.trim(),
                        subCategoryId: selectedPartCategoryId, productImage: productImage,recordId: widget.existingData?.id.toString()??"",
                      ).then((value) {
                        if(value){
                          Navigator.pop(context,"update");
                        }
                      });
                    }else{
                      await context.read<ProductsProvider>().sellProductApi(price: priceController.text.trim(),
                        condition: condition,expectancyType: !expectancySwitch ? "Distance" : "Time",
                        expectancy: expectancyController.text.trim(),expectancyDurationType: distanceType,
                        isProductNew: true,shouldPop: true,wareHouseCode: wareHouseController.text.trim(),
                        productId: "",description: specificationController.text.trim(),subCategoryId: selectedPartCategoryId,
                        productImage: productImage,
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
    businessNameController.text = "";
    selectedPartCategory = null;
    selectedPartCategoryId = "";
    productImage = null;
    specificationController.text = "";
    file = null;
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
            Text(widget.isUpdating ? "Update Product" : "addProduct".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }
}

class ItemModel {
  bool isStatus = false;

  ItemModel({required this.isStatus});
}
