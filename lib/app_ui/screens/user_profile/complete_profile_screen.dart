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
import 'package:autoparts/provider/user_provider.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:image_picker/image_picker.dart";
import 'package:provider/src/provider.dart';

class CompleteProfileScreen extends StatefulWidget {
  static const routeName = "/complete-profile";
  final bool isNewUser;
  const CompleteProfileScreen({Key? key, this.isNewUser = false}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController selectNationalityController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  static List<CountryList>? nationalityList = [];
  int groupValue = 1;
  String? selectNationality;
  String selectGender = "Male";
  String imageStatus = "0";
  String interest = "";
  String? networkImage;
  File? userImage;
  String? imageName;
  String selectedCountry = "";
  final ImagePicker _picker = ImagePicker();
  static List<InterestRecords>? interestRecordsList = [];
  @override
  void initState() {
    Future.microtask(() async {
      await context.read<UserProvider>().getInterestListApi();
      await context.read<UserProvider>().getCountryListApi();
     setData();
    });
    super.initState();
  }

  setData(){
  setState(() {
    interestRecordsList = context.read<UserProvider?>()?.interestListModel!.result!.records;
    nationalityList = context.read<UserProvider?>()?.countryListModel!.result!;
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(
              height: 16,
            ),
            _buildArrowBack(),
            const SizedBox(
              height: 16,
            ),
            Text("welcomeText".tr(),
                style: AppTextStyles.boldStyle(AppFontSize.font_24, AppColors.blackColor)),
            const SizedBox(
              height: 10,
            ),
            Text("completeProfile".tr(),
                style: AppTextStyles.regularStyle(
                    AppFontSize.font_18, AppColors.blackColor)),
            const SizedBox(
              height: 16,
            ),
            Container(
              alignment: Alignment.topLeft,
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
                        backgroundImage:networkImage != null
                    ? NetworkImage(
                    baseImageUrl+ networkImage!,
                    ) as ImageProvider
                                : const AssetImage(AppImages.user)),
                  )),
            ),
            const SizedBox(height: 20),
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
                  focusNode: lastNameFocusNode,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  keyboardType: TextInputType.name,
                  onChanged: (text) {},
                ),
              ),
            ]),
            const SizedBox(height: 8),
            CustomRoundTextField(
              hintText: "emailAddress".tr(),
              fillColor: AppColors.whiteColor,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              focusNode: emailFocusNode,
              onChanged: (text) {},
            ),
            const SizedBox(height: 5),
            // _buildAddress(),
            // const SizedBox(height: 16),

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
            const SizedBox(height: 15),
            // Container(
            //   margin: const EdgeInsets.only(top: 20),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: Colors.grey.shade200),
            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            //   child: DropdownButton(
            //     isExpanded: true,
            //     underline: Container(),
            //     hint: Text("nationality".tr(),
            //         textAlign: TextAlign.center,
            //         style: const TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.w500,
            //         )),
            //     // Not necessary for Option 1
            //
            //     value: selectedCountry,
            //     onChanged: (newValue) {
            //       FocusScope.of(context).requestFocus(FocusNode());
            //       if (newValue != null) {
            //         setState(() {
            //           selectedCountry = newValue.toString();
            //           for (var a in value.categoryList!) {
            //             if (a.name == newValue.toString()) {
            //               selectedCategoryId = a.id.toString();
            //             }
            //           }
            //           print(selectedCategoryName);
            //         });
            //       }
            //     },
            //     items: categoryName.map((location) {
            //       return DropdownMenuItem(
            //         child: new Text(location.toString(),
            //             style: TextStyle(
            //                 fontSize: 20,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w500)),
            //         value: location.toString(),
            //       );
            //     }).toList(),
            //   ),
            // ),
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
                if (interestRecordsList!.isNotEmpty) {
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
                value: "createProfile".tr(),
                textColor: Colors.white,
                textStyle: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.whiteColor),
              ),
            ),

            const SizedBox(height: 30),
          ]),
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
        value: selectNationality,
        iconEnabledColor: AppColors.blackColor,
        iconDisabledColor: AppColors.blackColor,
        hint: Text("nationality".tr(),
            style: AppTextStyles.mediumStyle(
                AppFontSize.font_16, AppColors.blackColor)),
        //Not necessary for Option 1
        onChanged: (newValue) {
          setState(() {
            selectNationality = newValue.toString();
            print(newValue);
          });
        },
        items: nationalityList!.map((CountryList e) {
          return DropdownMenuItem(
            child: Text(e.name!,
                style: AppTextStyles.mediumStyle(
                    AppFontSize.font_16, AppColors.blackColor)),
            value: e.id.toString(),
          );
        }).toList(),
      ),
    );
  }

  // _buildDropDown(){
  //   return  Container(
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
  //                     border: const OutlineInputBorder(borderSide: BorderSide.none),
  //                     hintText: "nationality".tr(),
  //                     hintStyle: AppTextStyles.mediumStyle(
  //                         AppFontSize.font_16, AppColors.blackColor),
  //                   ),
  //                   controller: selectNationalityController
  //               ),
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
  //
  //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
  //                 constraints: BoxConstraints(
  //                   maxWidth: MediaQuery.of(context).size.width/1-35,
  //                   minWidth: MediaQuery.of(context).size.width/1-35,
  //                   maxHeight: 240,
  //                   minHeight: 100
  //                 ),
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
  //
  //         const Icon(Icons.arrow_drop_down_sharp,size: 30,),
  //         const SizedBox(width: 10),
  //       ],
  //     ),
  //   );
  // }

  static List<CountryList> getCountrySuggestions(String query) {
    List<CountryList> matches = [];
    matches.addAll(nationalityList!);
    matches.retainWhere((s) => s.name!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  _buildArrowBack() {
    return Row(
     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.bottomLeft,
            height: 20,
            width: 25,
            child: Image.asset(AppImages.arrowBack),
          ),
        ),
        //_buildSkipButton()
      ],
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
    var response = await ApiBaseHelper().imageUploadApi(File(image!.path), "Profile");
    print(response);
    setState(() {
      networkImage = response;
      sp!.putString(SpUtil.USER_IMAGE, response);
    });

  }

  _imgFromGallery() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var response = await ApiBaseHelper().imageUploadApi(File(image!.path), "Profile");
    print(response);
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
    }else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(emailController.text)) {
      showToastMessage("Please enter a valid email address.");
      FocusScope.of(context).requestFocus(emailFocusNode);
    }
    // else if ((selectNationality??"").isEmpty) {
    //   showToastMessage("Please select nationality.");
    // }
    // else if (interest == "") {
    //   showToastMessage("Please select interest.");
    // }
    else {
      await context.read<UserProvider>().updateUserProfileApi(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          selectGender,
          selectNationality.toString(),
          interest,
        widget.isNewUser,
      );
    }
  }
}