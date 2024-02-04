import "dart:io";
import 'package:autoparts/api_service/api_base_helper.dart';
import 'package:autoparts/api_service/api_config.dart';
import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/show_dialog.dart';
import "package:autoparts/app_ui/common_widget/submit_button.dart";
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/main.dart';
import 'package:autoparts/models/country_list_model.dart';
import 'package:autoparts/models/interest_list_model.dart';
import 'package:autoparts/models/user_profile_model.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:autoparts/utils/date_time_utils.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:image_picker/image_picker.dart";
import 'package:provider/src/provider.dart';
class UpdateProfileScreen extends StatefulWidget {
  static const routeName = "/update-profile";
  final bool isNewUser;
  const UpdateProfileScreen({Key? key, this.isNewUser = false}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}
class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController selectNationalityController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  static List<CountryList>? nationalityList = [];
  static List<InterestRecords>? interestRecordsList = [];
  List<String>? interestApiList = [];
  UserProfileData? userProfileData;
  int? groupValue;
  String? countryCode;
  String? userType;
  int? selectNationality;
  String selectedCountryName = "India";
  String? selectedCountryId;
  String? selectGender;
  String interest = "";
  String? networkImage;
  String? selectedDob;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    Future.microtask(() async {
      interestRecordsList = context.read<UserProvider>().interestListModel!.result!.records;
      nationalityList = context.read<UserProvider>().countryListModel!.result;
      userProfileData = context.read<UserProvider>().userProfileModel!.result;
      setData();
    });
    super.initState();
  }

  setData() {
    firstNameController.text = userProfileData!.firstName != null ? userProfileData!.firstName! : "";
    lastNameController.text = userProfileData!.lastName != null ? userProfileData!.lastName! : "";
    emailController.text = userProfileData!.email!;
    mobileController.text = userProfileData!.mobile!;
    selectGender = userProfileData!.gender;
    networkImage = userProfileData!.image;
    countryCode = userProfileData!.countryCode;
    userType = userProfileData!.userType!;
    sp!.putString(SpUtil.USER_TYPE,userType.toString());
    interestApiList = userProfileData!.interest != null
        ? userProfileData!.interest!.split(RegExp(r','))
        : [];
    selectedDob = userProfileData!.dob != null ? userProfileData!.dob! : null;
    if (userProfileData!.gender! == "Female") {
      selectGender = "Female";
      groupValue = 2;
    } else {
      selectGender = "Male";
      groupValue = 1;
    }
    selectedCountryId = userProfileData?.nationality??"";

    if ((userProfileData?.nationality??"").isNotEmpty) {
      for (var element in nationalityList??[]) {
        if (element.id.toString() == userProfileData?.nationality) {
          selectedCountryName = element.name??"";
          // selectNationality = element.id!;
        }
      }
    }
    for (var i in interestApiList??[]) {
      for (var element in interestRecordsList??[]) {
        if (element.interestId.toString() == i) {
          element.status = true;
        }
      }
    }
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

  _buildBody() {
    return Expanded(
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.hintTextColor,
                    child: CircleAvatar(
                        backgroundColor: AppColors.whiteColor,
                        radius: 57,
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                              backgroundColor: AppColors.brownColor,
                              radius: 15.0,
                              child: Icon(
                                Icons.edit,
                                size: 14.0,
                                color: Colors.white,
                              )),
                        ),
                        backgroundImage: networkImage != null
                            ? NetworkImage(
                                baseImageUrl + networkImage!,
                              ) as ImageProvider
                            : const AssetImage(AppImages.user)),
                  )),
            ),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(
                child: CustomRoundTextField(
                  hintText: "firstName".tr(),
                  fillColor: AppColors.whiteColor,
                  controller: firstNameController,
                  focusNode: firstNameFocusNode,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  keyboardType: TextInputType.name,
                  onChanged: (text) {},
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomRoundTextField(
                  hintText: "lastName".tr(),
                  fillColor: AppColors.whiteColor,
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  focusNode: lastNameFocusNode,
                  onChanged: (text) {},
                ),
              ),
            ]),
            const SizedBox(height: 8),
            CustomRoundTextField(
              hintText: "emailAddress".tr(),
              fillColor: AppColors.whiteColor,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              focusNode: emailFocusNode,
              onChanged: (text) {},
            ),
            const SizedBox(height: 5),
            _buildCountryPicker(),
            const SizedBox(height: 16),
            selectDob(),
            const SizedBox(height: 16),
            Text("gender".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_20, AppColors.blackColor)),
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
                          groupValue: groupValue,
                          onChanged: (index) {
                            setState(() {
                              groupValue = 1;
                              selectGender = "Male";
                            });
                          },
                          activeColor: AppColors.brownColor,
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
                          groupValue: groupValue,
                          onChanged: (index) {
                            setState(() {
                              groupValue = 2;
                              selectGender = "Female";
                            });
                          },
                          activeColor: AppColors.brownColor,
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
            const SizedBox(height: 16),
            _buildDropDown(),
            const SizedBox(height: 16),
            Text("interest".tr(),
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_20, AppColors.blackColor)),
            const SizedBox(height: 10),
            buildInterestGrid(),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                interest = "";
                if (interestList.isNotEmpty) {
                  for (var element in interestRecordsList!) {
                    if (element.status!) {
                      if (interest == "") {
                        interest = element.interestId.toString();
                      } else {
                        interest += "," + element.interestId.toString();
                      }
                    }
                  }
                }
                completeProfile();
              },
              child: SubmitButton(
                height: 50,
                color: AppColors.btnBlackColor,
                value: "updateProfile".tr().toUpperCase(),
                textColor: Colors.white,
                textStyle: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.whiteColor),
              ),
            ),
            const SizedBox(height: 30),
          ]),
    );
  }

  _buildCountryPicker() {
    return countryCode == null
        ? Container()
        : Container(
            height: 55,
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
                        print(p.dialCode);
                        countryCode = p.dialCode;
                      });
                      sp!.putString(SpUtil.COUNTRY_CODE, p.dialCode??"");
                      FocusScope.of(context).unfocus();
                    },
                    // Initial selection and favorite can be one of code ("IT") OR dial_code("+39")
                    // initialSelection:  "IT",
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

  _buildTextField() {
    return TextField(
      maxLength: 11,
      enabled: false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
      ],
      focusNode: mobileFocusNode,
      controller: mobileController,
      keyboardType: TextInputType.number,
      cursorHeight: 20,
      style: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.blackColor),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "mobileNumberHint".tr(),
          helperStyle: AppTextStyles.mediumStyle(AppFontSize.font_16, AppColors.hintTextColor),
          counterText: ""),
    );
  }

  _buildDropDown() {
    return Container(
      padding:
      const EdgeInsets.only(top: 0, left: 10.0, right: 10.0, bottom: 0),
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
        value: selectedCountryName,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("nationality".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        onChanged: (newValue) {
          setState(() {
            selectedCountryName = newValue.toString();
            for (var a in nationalityList??[]) {
              if (a.name == newValue.toString()) {
                selectedCountryId = a.id.toString();
                print(selectedCountryId);
              }
            }
          });
        },
        items: (nationalityList??[]).map((CountryList e) {
          return DropdownMenuItem(
            child: Text(e.name??"",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            value: e.name.toString(),
          );
        }).toList(),
      ),
    );
  }

  // _buildDropDown() {
  //   return Container(
  //     height: 55,
  //     decoration: BoxDecoration(
  //         color: AppColors.whiteColor,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: AppColors.borderColor, width: 2)),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 10),
  //             child: TypeAheadField<CountryList>(
  //               textFieldConfiguration: TextFieldConfiguration(
  //                   style: AppTextStyles.mediumStyle(
  //                       AppFontSize.font_16, AppColors.blackColor),
  //                   decoration: InputDecoration(
  //                     border:
  //                         const OutlineInputBorder(borderSide: BorderSide.none),
  //                     hintText: "nationality".tr(),
  //                     hintStyle: AppTextStyles.mediumStyle(
  //                         AppFontSize.font_16, AppColors.blackColor),
  //                   ),
  //                   controller: selectNationalityController),
  //               suggestionsCallback: (pattern) async {
  //                 return getCountrySuggestions(pattern);
  //               },
  //               transitionBuilder: (context, suggestionsBox, controller) {
  //                 return suggestionsBox;
  //               },
  //               itemBuilder: (context, CountryList suggestion) {
  //                 return ListTile(
  //                   title: Text(suggestion.name.toString()),
  //                 );
  //               },
  //               onSuggestionSelected: (CountryList suggestion) {
  //                 selectNationalityController.text = suggestion.name!;
  //                 selectNationality = suggestion.id!;
  //               },
  //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
  //                 constraints: BoxConstraints(
  //                     maxWidth: MediaQuery.of(context).size.width / 1 - 35,
  //                     minWidth: MediaQuery.of(context).size.width / 1 - 35,
  //                     maxHeight: 240,
  //                     minHeight: 100),
  //                 offsetX: 0,
  //                 elevation: 0,
  //                 shape: const RoundedRectangleBorder(
  //                     side: BorderSide(
  //                       width: 1,
  //                       color: AppColors.borderColor,
  //                     ),
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(8),
  //                     )),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const Icon(
  //           Icons.arrow_drop_down_sharp,
  //           size: 30,
  //         ),
  //         const SizedBox(width: 10),
  //       ],
  //     ),
  //   );
  // }

  static List<CountryList> getCountrySuggestions(String query) {
    List<CountryList> matches = [];
    matches.addAll(nationalityList!);
    matches.retainWhere(
        (s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: AppColors.whiteColor,
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
                Text("editProfile".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
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
    var response =
        await ApiBaseHelper().imageUploadApi(File(image!.path), "Profile");
    setState(() {
      networkImage = response;
      sp!.putString(SpUtil.USER_IMAGE, response);
    });
  }

  _imgFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var response =
        await ApiBaseHelper().imageUploadApi(File(image!.path), "Profile");
    setState(() {
      networkImage = response;
      sp!.putString(SpUtil.USER_IMAGE, response);
    });
  }

  buildInterestGrid() {
    return Wrap(
      children: [
        ...interestRecordsList!.map((e) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      activeColor: AppColors.brownColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      side: const BorderSide(
                          width: 1.5, color: AppColors.borderColor),
                      value: e.status,
                      onChanged: (bool? value) {
                        setState(() {
                          e.status = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(e.name!,
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_16, AppColors.blackColor)),
              ],
            ),
          );
        })
      ],
    );
  }

  selectDob() {
    return GestureDetector(
      onTap: () {
        DateTime currentDate = DateTime.now();
        FocusScope.of(context).unfocus();
        showDatePicker(
            context: context,
            initialDate: DateTime(currentDate.year - 18,currentDate.month,currentDate.day),
            firstDate: DateTime(1950, 1),
            lastDate: DateTime(currentDate.year - 18,currentDate.month,currentDate.day),
            //lastDate: DateTime(DateTime.now().year - 12, 1, 1),
            builder: (context, picker) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: AppColors.btnBlackColor,
                    onPrimary: Colors.white,
                    surface: Colors.grey.shade200,
                    onSurface: Colors.black,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: picker!,
              );
            }).then((date) {
          if (date != null) {
            setState(() {
              var myFormat = DateFormat('yyyy-MM-dd');
              selectedDob = myFormat.format(date);
            });
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor, width: 2)),
        child: Row(
          children: [
            Text(selectedDob == null ? "dob".tr() : selectedDob??"",
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16,
                    selectedDob == null
                        ? AppColors.hintTextColor
                        : AppColors.blackColor)),
            const Spacer(),
            Image.asset(
              AppImages.calendarBlack,
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  completeProfile() async {
    if (firstNameController.text.isEmpty) {
      showToastMessage("Please enter first name.");
      FocusScope.of(context).requestFocus(firstNameFocusNode);
    }
    // else if (lastNameController.text.isEmpty) {
    //   showToastMessage("Please enter last name.");
    //   FocusScope.of(context).requestFocus(lastNameFocusNode);
    // }
    else if (emailController.text.isEmpty) {
      showToastMessage("Please enter email.");
      FocusScope.of(context).requestFocus(emailFocusNode);
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(emailController.text)) {
      showToastMessage("Please enter a valid email address.");
      FocusScope.of(context).requestFocus(emailFocusNode);
    }
    // else if ((selectedCountryName).isEmpty) {
    //   showToastMessage("Please select nationality.");
    // }
    else if ((selectedDob??"").isEmpty) {
      showToastMessage("Please select DOB.");
    }
    // else if (interest == "") {
    //   showToastMessage("Please select interest.");
    // }
    else {
      await context.read<UserProvider>().updateUserProfileApi(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          selectGender,
          selectedCountryId,
          interest,
          widget.isNewUser,
          selectedDob,
          "edit");
    }
  }
}
class InterestModel {
  int? id;
  String? name;
  bool? status;

  InterestModel({this.id, this.name, this.status});
}