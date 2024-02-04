import 'dart:io';
import 'package:autoparts/api_service/api_base_helper.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import 'package:autoparts/app_ui/screens/location/location_screen.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/auth_provider.dart';
import 'package:autoparts/provider/user_provider.dart';
import "package:country_code_picker/country_code_picker.dart";
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../api_service/api_config.dart';

class BusinessProfileScreen extends StatefulWidget {
  static const routeName = "/business-profile";
  final bool isNewUser;
  const BusinessProfileScreen({Key? key,this.isNewUser = false}) : super(key: key);

  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController whatsAppNumberController = TextEditingController();
  FocusNode businessNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode whatsAppNumberFocusNode = FocusNode();
  String? countryCode;
  String? whatsAppCountryCode;
  String? headerNetworkImage;
  String? businessLogoNetworkImage;
  String? tradeLicenseNetworkImage;
  String? imageUploadType = "header";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    Future.microtask(() async {
      countryCode = context.read<AuthProvider>().countryCode;
      whatsAppCountryCode = context.read<AuthProvider>().countryCode;
      mobileController.text = context.read<AuthProvider>().phoneNumber!;
    });
    super.initState();
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

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(children: [
            Row(
              children: [
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
                Text("businessProfile".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text("750x500",
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.blackColor)),
            ),
          ])),
    );
  }

  _buildBody() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          buildCarImages(),
          const SizedBox(height: 6),
          buildCardBusinessLogo(),
          const SizedBox(height: 6),
          businessTextField(),
          // const SizedBox(height: 16),
          // _buildAddress(),
          const SizedBox(height: 16),
          _buildCountryPicker(),
          const SizedBox(height: 16),
          _buildWhatsAppCountryPicker(),
          const SizedBox(height: 16),
          emailTextField(),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.topLeft,
            child: Text("tradeLicence".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
          ),
          const SizedBox(height: 10),
          _buildProductImage(),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: () {
                completeBusinessProfile();
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16,bottom: 30),
                  child: SubmitButton(
                    height: 55,
                    color: AppColors.btnBlackColor,
                    value: "submit".tr().toUpperCase(),
                    textColor: Colors.white,
                    textStyle: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.whiteColor),
                  ))),
        ],
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
            tradeLicenseNetworkImage != null
                ? Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          topLeft: Radius.circular(6)),
                      child: Image.network(
                        baseImageUrl + tradeLicenseNetworkImage!,
                        fit: BoxFit.fill,
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
                  setState(() {
                    imageUploadType = "tradeLicense";
                  });
                  _showImagePicker(context,willCrop: false);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.blackColor,
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

  _buildCountryPicker() {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CountryCodePicker(
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.blackColor),
              flagWidth: 30,
              padding: const EdgeInsets.all(0),
              onChanged: (p) {
                print("Country Code ::: >  " + p.toString());
                setState(() {
                  countryCode = p.toString();
                });
                FocusScope.of(context).unfocus();
              },
              enabled: false,
              // Initial selection and favorite can be one of code ("IT") OR dial_code("+39")
              //initialSelection: "IT",
              initialSelection: countryCode.toString(),
              //favorite: ["+971"],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            color: AppColors.borderColor,
            width: 2,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(flex: 8, child: _buildTextField())
        ],
      ),
    );
  }

  _buildWhatsAppCountryPicker() {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 2)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CountryCodePicker(
              textStyle: AppTextStyles.mediumStyle(
                  AppFontSize.font_16, AppColors.blackColor),
              flagWidth: 30,
              padding: const EdgeInsets.all(0),
              onChanged: (p) {
                print("Country Code ::: >  " + p.toString());
                setState(() {
                  whatsAppCountryCode = p.toString();
                });
                FocusScope.of(context).unfocus();
              },
              enabled: false,
              // Initial selection and favorite can be one of code ("IT") OR dial_code("+39")
              //initialSelection: "IT",
              initialSelection: countryCode.toString(),
              //favorite: ["+971"],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            color: AppColors.borderColor,
            width: 2,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(flex: 8, child: _buildWhatsappTextField())
        ],
      ),
    );
  }

  _buildTextField() {
    return TextField(
      autofocus: false,
      maxLength: 11,
      controller: mobileController,
      focusNode: mobileFocusNode,
      enabled: false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
      ],
      keyboardType: TextInputType.number,
      cursorHeight: 20,
      style:
          AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "mobileNumberHint".tr(),
          helperStyle: AppTextStyles.mediumStyle(
              AppFontSize.font_16, AppColors.hintTextColor),
          counterText: ""),
    );
  }

  _buildWhatsappTextField() {
    return TextField(
      autofocus: false,
      maxLength: 11,
      controller: whatsAppNumberController,
      focusNode: whatsAppNumberFocusNode,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
      ],
      keyboardType: TextInputType.number,
      cursorHeight: 20,
      style:
          AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "whatsappNumberHint".tr(),
          helperStyle: AppTextStyles.mediumStyle(
              AppFontSize.font_16, AppColors.hintTextColor),
          counterText: ""),
    );
  }

  buildCarImages() {
    return   Container(
      height: 200,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          color: AppColors.bgColor,
          image: headerNetworkImage != null
              ? DecorationImage(
            fit: BoxFit.fill,
              image: NetworkImage(baseImageUrl + headerNetworkImage!))
              : const DecorationImage(
              alignment: Alignment(0, -0.5),
              image: AssetImage(
                "assets/images/business_car.png",
              ),scale: 3.0)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            imageUploadType = "header";
          });
          _showImagePicker(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (headerNetworkImage??"").isEmpty ?  Text("headerImageUpload".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_16, AppColors.blackColor)):const SizedBox(),
               
               Card(
                color: AppColors.brownColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 9,
                child: const Padding(
                  padding:  EdgeInsets.all(7),
                  child:  Icon(
                    Icons.edit,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildAddress() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, LocationScreen.routeName);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Row(children: [
                Image.asset(
                  AppImages.locationIcon,
                  fit: BoxFit.fill,
                  height: 25,
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("address".tr(),
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_18, AppColors.blackColor)),
              ]),
              const Spacer(),
              Image.asset(
                AppImages.btnRightArrow,
                fit: BoxFit.fill,
                height: 35,
                width: 35,
              ),
            ],
          )),
    );
  }

  buildCardBusinessLogo() {
    return Container(
        margin: const EdgeInsets.all(16),
        color: AppColors.whiteColor,
        child: Row(children: [
          Expanded(
              flex: 3,
              child: Card(
                color: AppColors.whiteColor,
                elevation: 9,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: businessLogoNetworkImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            baseImageUrl + businessLogoNetworkImage!,
                            fit: BoxFit.fill,
                            width: 50,
                            height: 60,
                          ),
                        )
                      : Image.asset(
                          AppImages.defaultImage,
                          fit: BoxFit.contain,
                          width: 50,
                          height: 60,
                        ),
                ),
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("uploadBusinessLogo".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                  Text("240x140",
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_14, AppColors.hintTextColor)),
                ],
              )),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        imageUploadType = "businessLogo";
                      });
                      _showImagePicker(context);
                    },
                    child:   Card(
                      color: AppColors.brownColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 9,
                      child: const Padding(
                        padding:  EdgeInsets.all(7),
                        child:  Icon(
                          Icons.edit,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ]));
  }

  businessTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        controller: businessNameController,
        focusNode: businessNameFocusNode,
        padding: const EdgeInsets.all(0),
        hintText: "nameOfBusiness".tr(),
        fillColor: AppColors.whiteColor,
        onChanged: (text) {},
      ),
    );
  }

  emailTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        controller: emailController,
        focusNode: emailFocusNode,
        padding: const EdgeInsets.all(0),
        hintText: "emailAddress".tr(),
        keyboardType: TextInputType.emailAddress,
        fillColor: AppColors.whiteColor,
        onChanged: (text) {},
      ),
    );
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

  _imgFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 1);
    var file = await cropImage(File(image!.path));
    var response =
        await ApiBaseHelper().imageUploadApi(File(file!.path), "Profile");
    if (imageUploadType == "header") {
      headerNetworkImage = response;
    } else if (imageUploadType == "businessLogo") {
      businessLogoNetworkImage = response;
    } else {
      tradeLicenseNetworkImage = response;
    }
    setState(() {});
  }

  _imgFromCameraWithoutCrop() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    var response = await ApiBaseHelper().imageUploadApi(File(image!.path), "Profile");
    if (imageUploadType == "header") {
      headerNetworkImage = response;
    } else if (imageUploadType == "businessLogo") {
      businessLogoNetworkImage = response;
    } else {
      tradeLicenseNetworkImage = response;
    }
    setState(() {});
  }

  _imgFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    var file = await cropImage(File(image!.path));
    var response =
        await ApiBaseHelper().imageUploadApi(File(file!.path), "Profile");
    if (imageUploadType == "header") {
      headerNetworkImage = response;
    } else if (imageUploadType == "businessLogo") {
      businessLogoNetworkImage = response;
    } else {
      tradeLicenseNetworkImage = response;
    }
    setState(() {});
  }

  _imgFromGalleryWithoutCrop() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var response = await ApiBaseHelper().imageUploadApi(File(image?.path??""), "Profile");
    if (imageUploadType == "header") {
      headerNetworkImage = response;
    } else if (imageUploadType == "businessLogo") {
      businessLogoNetworkImage = response;
    } else {
      tradeLicenseNetworkImage = response;
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

  completeBusinessProfile() async {
    if (headerNetworkImage == null) {
      showToastMessage("Please upload header image.");
    } else if (businessLogoNetworkImage == null) {
      showToastMessage("Please upload business logo.");
    } else if (businessNameController.text.isEmpty) {
      showToastMessage("Please enter business name.");
      FocusScope.of(context).requestFocus(businessNameFocusNode);
    } else if (mobileController.text.isEmpty) {
      showToastMessage("Please enter mobile number.");
      FocusScope.of(context).requestFocus(mobileFocusNode);
    } else if (whatsAppNumberController.text.isEmpty) {
      showToastMessage("Please enter whatsapp number.");
      FocusScope.of(context).requestFocus(whatsAppNumberFocusNode);
    } else if (emailController.text.isEmpty) {
      showToastMessage("Please enter email.");
      FocusScope.of(context).requestFocus(emailFocusNode);
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(emailController.text)) {
      showToastMessage("Please enter a valid email address.");
      FocusScope.of(context).requestFocus(emailFocusNode);
    } else if (tradeLicenseNetworkImage == null) {
      showToastMessage("Please upload trade license copy.");
    } else {
      await context.read<UserProvider>().updateBusinessProfileApi(
          headerNetworkImage,
          businessLogoNetworkImage,
          businessNameController.text,
          mobileController.text,
          countryCode,
          whatsAppNumberController.text,
          whatsAppCountryCode,
          emailController.text,
          tradeLicenseNetworkImage,
          widget.isNewUser);
    }
  }
}
