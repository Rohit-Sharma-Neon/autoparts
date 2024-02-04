import "dart:io";
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import "package:country_code_picker/country_code_picker.dart";
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:image_cropper/image_cropper.dart';
import "package:image_picker/image_picker.dart";
import 'package:provider/provider.dart';

import '../../../api_service/api_base_helper.dart';
import '../../../api_service/api_config.dart';
import '../../../main.dart';
import '../../../models/user_profile_model.dart';
import '../../../provider/user_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../common_widget/show_dialog.dart';
import '../location/location_screen.dart';

class BecomeSellerScreen extends StatefulWidget {
  static const routeName = "/become-dealer";

  const BecomeSellerScreen({Key? key}) : super(key: key);

  @override
  _BecomeSellerScreenState createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
  TextEditingController businessNameController = TextEditingController();
  FocusNode businessNameFocusNode = FocusNode();
  bool isSeller = false;

  int group1Value = -1;
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;
  bool checkBoxValue4 = false;
  String? selectNationality;
  String imageStatus = "0";
  File? userImage;
  final ImagePicker _picker = ImagePicker();
  List<String> nationalityList = [];
  String? headerNetworkImage;
  String? businessLogoNetworkImage;
  String? tradeLicenseNetworkImage;
  String? imageUploadType = "header";
  UserProfileData? userProfileData;

  @override
  void initState() {
    nationalityList.add("India".tr());
    nationalityList.add("Pakistan".tr());
    nationalityList.add("Nepal".tr());
    isSeller = sp?.getBool(SpUtil.IS_SELLER)??false;
    if(isSeller){
      Future.microtask(() async {
        await context.read<UserProvider>().getUserProfileApi();
        userProfileData = context.read<UserProvider>().userProfileModel!.result;
        setData();
      });
    }
    super.initState();
  }

  setData() {
    businessNameController.text =   userProfileData?.businessName??"";
    headerNetworkImage =  userProfileData?.headerImage??"" ;
    businessLogoNetworkImage = userProfileData?.businessLogo??"" ;
    tradeLicenseNetworkImage =  userProfileData?.tradeLicense??"" ;
    if (mounted) {
      setState(() {});
    }
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
                Text(isSeller ? "manageSellerAccount".tr() : "becomeASeller".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text("750x500".tr(),
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_16, AppColors.blackColor)),
            ),
          ])),
    );
  }

  _buildBody() {
    return Consumer<UserProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              buildCarImages(),
              const SizedBox(height: 6),
              buildCardBusinessLogo(),
              const SizedBox(height: 6),
              businessTextField(),
              const SizedBox(height: 16),
              // buildFirstNameField(),
              // const SizedBox(height: 16),
              // _buildCountryPicker(),
              // const SizedBox(height: 16),
              // _buildGenderField(),
              // const SizedBox(height: 10),
              // _buildDropDown(),
              // const SizedBox(height: 16),
              // _buildInterestField(),
              // const SizedBox(height: 10),
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
              _buildAddress(),
              const SizedBox(height: 16),
              GestureDetector(
                  onTap: () {
                    completeBusinessProfile();
                  },
                  child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: SubmitButton(
                        height: 55,
                        color: AppColors.btnBlackColor,
                        value: "submit".tr().toUpperCase(),
                        textColor: Colors.white,
                        textStyle: AppTextStyles.mediumStyle(
                            AppFontSize.font_16, AppColors.whiteColor),
                      ))),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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

  _buildGenderField() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          CustomRoundTextField(
            padding: const EdgeInsets.all(0),
            hintText: "emailAddress".tr(),
            keyboardType: TextInputType.emailAddress,
            fillColor: AppColors.whiteColor,
            onChanged: (text) {},
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.topLeft,
            child: Text("gender".tr(),
                textAlign: TextAlign.left,
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_20, AppColors.blackColor)),
          ),
          Row(children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 1,
                        groupValue: group1Value,
                        onChanged: (index) {
                          setState(() {
                            group1Value = 1;
                          });
                        },
                        activeColor: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("male".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                      scale: 1.3,
                      child: Radio(
                        value: 2,
                        groupValue: group1Value,
                        onChanged: (index) {
                          setState(() {
                            group1Value = 2;
                          });
                        },
                        activeColor: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("female".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ),
            const SizedBox(
              width: 100,
            ),
          ]),
        ],
      ),
    );
  }

  _buildInterestField() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text("interest".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_20, AppColors.blackColor)),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        activeColor: AppColors.blackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        side: const BorderSide(
                            width: 1.5, color: AppColors.borderColor),
                        value: checkBoxValue1,
                        onChanged: (bool? value) {
                          setState(() {
                            checkBoxValue1 = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("item1".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        activeColor: AppColors.blackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        side: const BorderSide(
                            width: 1.5, color: AppColors.borderColor),
                        value: checkBoxValue2,
                        onChanged: (value) {
                          setState(() {
                            checkBoxValue2 = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("item2".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ),
            const SizedBox(
              width: 100,
            )
          ]),
          Row(children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        activeColor: AppColors.blackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        side: const BorderSide(
                            width: 1.5, color: AppColors.borderColor),
                        value: checkBoxValue3,
                        onChanged: (bool? value) {
                          setState(() {
                            checkBoxValue3 = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("item3".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        activeColor: AppColors.blackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        side: const BorderSide(
                            width: 1.5, color: AppColors.borderColor),
                        value: checkBoxValue4,
                        onChanged: (bool? value) {
                          setState(() {
                            checkBoxValue4 = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text("item4".tr(),
                      style: AppTextStyles.mediumStyle(
                          AppFontSize.font_16, AppColors.blackColor)),
                ],
              ),
            ),
            const SizedBox(
              width: 100,
            )
          ]),
        ],
      ),
    );
  }

  _buildDropDown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("nationality".tr(),
            style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor)),
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

  _buildCountryPicker() {
    return Container(
      height: 60,
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
                FocusScope.of(context).unfocus();
              },
              // Initial selection and favorite can be one of code ("IT") OR dial_code("+39")
              initialSelection: "IT",
              favorite: ["+971"],
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

  _buildTextField() {
    return TextField(
      autofocus: false,
      maxLength: 11,
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

  businessTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        controller: businessNameController,
        focusNode: businessNameFocusNode,
        padding: const EdgeInsets.all(0),
        hintText: "Name of Business".tr(),
        fillColor: AppColors.whiteColor,
        onChanged: (text) {},
      ),
    );
  }

  buildFirstNameField() {
    return Row(children: [
      const SizedBox(width: 16),
      Expanded(
        child: CustomRoundTextField(
          padding: const EdgeInsets.all(0),
          hintText: "firstName".tr(),
          fillColor: AppColors.whiteColor,
          onChanged: (text) {},
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: CustomRoundTextField(
          padding: const EdgeInsets.all(0),
          hintText: "lastName".tr(),
          fillColor: AppColors.whiteColor,
          onChanged: (text) {},
        ),
      ),
      const SizedBox(width: 16),
    ]);
  }

  buildCarImages() {
    return Container(
      height: 200,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          color: AppColors.bgColor,
          image: headerNetworkImage != null
              ? DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(baseImageUrl + headerNetworkImage!))
              : const DecorationImage(
              alignment: Alignment(0.5, -1),
              image: AssetImage(
                AppImages.carEmpty,

              ))),
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
              Text("headerImageUpload".tr(),
                  style: AppTextStyles.boldStyle(
                      AppFontSize.font_16, AppColors.blackColor)),
              Card(
                color: AppColors.brownColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 9,
                child: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(
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
          padding: const EdgeInsets.all(16),
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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    imageUploadType = "businessLogo";
                  });
                  _showImagePicker(context);
                },
                child: Image.asset(
                  AppImages.profileEdit,
                  width: 80,
                  height: 80,
                ),
              )),
        ]));
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
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 0);
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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
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
  _imgFromCameraWithoutCrop() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 0);
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
    } else if (tradeLicenseNetworkImage == null) {
      showToastMessage("Please upload Trade Licence Copy.");
    } else {
      await context.read<UserProvider>().createBecomeADealerApi(
            headerNetworkImage,
            businessLogoNetworkImage,
            businessNameController.text,
            tradeLicenseNetworkImage,
          );
    }
  }
}
