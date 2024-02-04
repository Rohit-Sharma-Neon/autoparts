// import "package:autoparts/app_ui/screens/dashboard/dealers/dealer_review_screen.dart",
// import "package:autoparts/app_ui/screens/dashboard/message_box_screen/message_box_screen.dart",
// import "package:autoparts/constant/app_colors.dart",
// import "package:autoparts/constant/app_image.dart",
// import "package:autoparts/constant/app_strings.dart",
// import "package:autoparts/constant/app_text_style.dart",
// import "package:flutter/cupertino.dart",
// import "package:flutter/material.dart",
// import "package:flutter/rendering.dart",
//
//
// class DealerSilverScreen extends StatefulWidget {
//   const DealerSilverScreen({Key? key}) : super(key: key),
//
//   @override
//   _DealerSilverScreenState createState() :> _DealerSilverScreenState(),
// }
//
// class _DealerSilverScreenState extends State<DealerSilverScreen> {
//   bool isFavourite : false,
//   List<TabItemModel> tabItem : [
//     TabItemModel(id: 1, isStatus: true, name: AppStrings.engine),
//     TabItemModel(id: 1, isStatus: false, name: AppStrings.carsSteering),
//     TabItemModel(id: 1, isStatus: false, name: AppStrings.carsTire),
//     TabItemModel(id: 1, isStatus: false, name: AppStrings.carsExhaust),
//     TabItemModel(id: 1, isStatus: false, name: AppStrings.carsCar),
//   ],
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           customAppbar(),
//           Expanded(
//             child: NestedScrollView(
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBoxScrolled) {
//                 return <Widget>[
//                   createSilverAppBar(),
//                   createSilverBottomAppBar(),
//                 ],
//               },
//               body: ListView(
//                 padding: const EdgeInsets.all(0),
//                 children: [
//                   _buildGridView(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   }
//
//   customAppbar() {
//     return SafeArea(
//       child: Container(
//           height: 50,
//           color: AppColors.cardBgColor,
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(children: [
//             GestureDetector(
//                 onTap: () {
//                   Navigator.pop(
//                     context,
//                   ),
//                 },
//                 child: Image.asset(
//                   AppImages.arrowBack,
//                   fit: BoxFit.contain,
//                   height: 20,
//                 )),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isFavourite) {
//                     isFavourite : false,
//                   } else {
//                     isFavourite : true,
//                   }
//                 }),
//               },
//               child: isFavourite :: true
//                   ? Image.asset(
//                       AppImages.favOutline,
//                       fit: BoxFit.fill,
//                       height: 25,
//                       width: 25,
//                     )
//                   : Image.asset(
//                       AppImages.favoritesIcon,
//                       fit: BoxFit.fill,
//                       height: 25,
//                       width: 25,
//                       color: Colors.grey,
//                     ),
//             ),
//           ])),
//     ),
//   }
//
//   buildFeaturedProductsCard(position) {
//     return GestureDetector(
//       onTap: () {
//         productDetailAlertBox(),
//       },
//       child: Card(
//           color: AppColors.whiteColor,
//           margin: const EdgeInsets.only(left: 16, top: 16, bottom: 20),
//           elevation: 7,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: Padding(
//             padding: const EdgeInsets.all(5),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: AppColors.hintTextColor,
//                     borderRadius: BorderRadius.circular(3.0),
//                   ),
//                   child: Text(AppStrings.used,
//                       style: AppTextStyles.mediumStyle(
//                           AppFontSize.font_10, AppColors.whiteColor))),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: Image.asset(
//                         AppImages.motorEngine,
//                         width: 80,
//                         height: 80,
//                       ),
//                     ),
//                     Text(AppStrings.airFilter,
//                         style: AppTextStyles.boldStyle(
//                             AppFontSize.font_16, AppColors.blackColor)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ]),
//           )),
//     ),
//   }
//
//   buildCardReview() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(0.0),
//       ),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Row(
//           children: [
//             Card(
//               color: AppColors.whiteColor,
//               elevation: 7,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   AppImages.alQassemImage,
//                   width: 150,
//                   height: 60,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Text("GTA Cars",
//                 style: AppTextStyles.boldStyle(
//                     AppFontSize.font_18, AppColors.blackColor)),
//           ],
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (_) :> const DealerReviewScreen())),
//           },
//           child: Column(
//             children: [
//               Row(children: [
//                 const Icon(
//                   Icons.star,
//                   size: 20,
//                   color: AppColors.blackColor,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text("4.5/5",
//                     style: AppTextStyles.boldStyle(
//                         AppFontSize.font_14, AppColors.blackBottomColor)),
//               ]),
//               Text("5 Review",
//                   style: AppTextStyles.mediumDecorationStyle(
//                       TextDecoration.underline,
//                       AppFontSize.font_12,
//                       AppColors.blackBottomColor)),
//             ],
//           ),
//         ),
//       ]),
//     ),
//   }
//
//   buildContactUsCard() {
//     return GestureDetector(
//       onTap: () {
//         showDialogContactUS(),
//       },
//       child: Container(
//         color: AppColors.whiteColor,
//         padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
//         child: Card(
//           color: AppColors.whiteColor,
//           elevation: 9,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             height: 55,
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {},
//                     child: Row(children: [
//                       Image.asset(
//                         AppImages.phoneIcon,
//                         fit: BoxFit.fill,
//                         height: 20,
//                         width: 20,
//                       ),
//                       const SizedBox(width: 10),
//                       Text(AppStrings.contactUs,
//                           style: AppTextStyles.boldStyle(
//                               AppFontSize.font_16, AppColors.hintTextColor)),
//                     ]),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       shareData(),
//                     },
//                     child: Row(children: [
//                       Image.asset(
//                         AppImages.linkShare,
//                         fit: BoxFit.fill,
//                         height: 20,
//                         width: 20,
//                       ),
//                       const SizedBox(width: 10),
//                       Text(AppStrings.share,
//                           style: AppTextStyles.boldStyle(
//                               AppFontSize.font_16, AppColors.hintTextColor)),
//                     ]),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     ),
//   }
//
//   void shareData() {
//     //Share.share("Rate & Review"),
//   }
//
//   buildCardLocation() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: AppColors.cardBgColor,
//       child: Row(children: [
//         Expanded(
//           flex: 10,
//           child: Row(children: [
//             const Expanded(
//               flex: 1,
//               child: Icon(
//                 Icons.location_on,
//                 size: 35,
//                 color: AppColors.startMarkColor,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               flex: 11,
//               child: Text("17 A Street, Al Qouz Industrial 3",
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextStyles.mediumStyle(
//                       AppFontSize.font_16, AppColors.hintTextColor)),
//             ),
//           ]),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           flex: 2,
//           child: Text("3.02 km",
//               overflow: TextOverflow.ellipsis,
//               style: AppTextStyles.boldDecorationStyle(TextDecoration.underline,
//                   AppFontSize.font_16, AppColors.blackBottomColor)),
//         ),
//       ]),
//     ),
//   }
//
//   void productDetailAlertBox() {
//     showDialog(
//       context: context,
//       builder: (context) :> AlertDialog(
//         insetPadding: const EdgeInsets.symmetric(horizontal: 10),
//         contentPadding: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         content: SizedBox(
//             width: MediaQuery.of(context).size.width - 20,
//             child: alertBoxBody()),
//       ),
//     ),
//   }
//
//   customTabBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       height: 50,
//       color: AppColors.cardBgColor,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(
//             tabItem.length,
//             (index) {
//               return Padding(
//                 padding: const EdgeInsets.only(right: 25),
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       if (tabItem[index].isStatus) {
//                         for (var element in tabItem) {
//                           element.isStatus : false,
//                         }
//                       } else {
//                         for (var element in tabItem) {
//                           element.isStatus : false,
//                         }
//                         tabItem[index].isStatus : true,
//                       }
//                     }),
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(tabItem[index].name,
//                           style: AppTextStyles.mediumStyle(
//                               AppFontSize.font_16,
//                               tabItem[index].isStatus
//                                   ? AppColors.blackColor
//                                   : AppColors.hintTextColor)),
//                       const SizedBox(height: 10),
//                       Container(
//                         height: 3,
//                         width: 15,
//                         color: tabItem[index].isStatus
//                             ? AppColors.blackColor
//                             : AppColors.cardBgColor,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             },
//           ),
//         ),
//       ),
//     ),
//   }
//
//   _buildGridView() {
//     return SizedBox(
//       child: GridView.builder(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         padding: const EdgeInsets.all(6),
//         physics: const BouncingScrollPhysics(),
//         itemCount: 8,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisExtent: MediaQuery.of(context).size.width * .480,
//         ),
//         itemBuilder: (_, index) :> buildFeaturedProductsCard(index),
//       ),
//     ),
//   }
//
//   alertBoxBody() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         alertBoxTopBar(),
//         SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 4,
//                       child: Card(
//                         color: AppColors.whiteColor,
//                         elevation: 7,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.asset(
//                             AppImages.alQassemImage,
//                             height: 60,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       flex: 8,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Coupling",
//                                     style: AppTextStyles.boldStyle(
//                                         AppFontSize.font_18,
//                                         AppColors.blackColor)),
//                                 Image.asset(
//                                   AppImages.questionInquiry,
//                                   fit: BoxFit.fill,
//                                   height: 20,
//                                   width: 20,
//                                 ),
//                               ]),
//                           const SizedBox(height: 5),
//                           Text(AppStrings.engine,
//                               style: AppTextStyles.mediumStyle(
//                                   AppFontSize.font_14,
//                                   AppColors.hintTextColor)),
//                           const SizedBox(height: 7),
//                           Container(
//                               padding: const EdgeInsets.all(3),
//                               decoration: BoxDecoration(
//                                 color: AppColors.hintTextColor,
//                                 borderRadius: BorderRadius.circular(3.0),
//                               ),
//                               child: Text(AppStrings.available,
//                                   style: AppTextStyles.mediumStyle(
//                                       AppFontSize.font_10,
//                                       AppColors.whiteColor))),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Text(AppStrings.description,
//                     style: AppTextStyles.boldStyle(
//                         AppFontSize.font_20, AppColors.blackBottomColor)),
//                 const SizedBox(height: 10),
//                 Text(
//                     "Couplings are mechanical components used to connect two in-line shafts to enable one shaft to drive another at the same speed. A coupling can be rigid or flexible, allowing various amount of angular, radial, and axial misalignment between the two shafts.",
//                     style: AppTextStyles.regularStyle(
//                         AppFontSize.font_14, AppColors.hintTextColor)),
//               ],
//             ))
//       ],
//     ),
//   }
//
//   alertBoxTopBar() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Text(
//                 AppStrings.filter,
//                 style: AppTextStyles.boldStyle(
//                     AppFontSize.font_22, AppColors.blackBottomColor),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context),
//                 },
//                 child: Image.asset(
//                   AppImages.circleCrossIcon,
//                   height: 35,
//                   width: 35,
//                 ),
//               )
//             ],
//           ),
//         ),
//         const SizedBox(height: 5),
//         const Divider(
//           color: AppColors.borderColor,
//           thickness: 1.5,
//           height: 0,
//         ),
//       ],
//     ),
//   }
//
//   void showDialogContactUS() {
//     showDialog(
//       context: context,
//       builder: (context) :> AlertDialog(
//           insetPadding: const EdgeInsets.symmetric(horizontal: 10),
//           contentPadding: EdgeInsets.zero,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(children: [
//                   Expanded(
//                       flex: 6,
//                       child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) :> const MessageBoxScreen())),
//                           },
//                           child: buildContactRow(
//                               AppImages.whatsApp, AppStrings.whatsapp))),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     flex: 6,
//                     child: buildContactRow(AppImages.phone, AppStrings.call),
//                   )
//                 ]),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(children: [
//                   Expanded(
//                     flex: 6,
//                     child: buildContactRow(AppImages.sms, AppStrings.sms),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     flex: 6,
//                     child: buildContactRow(AppImages.chat, AppStrings.chat),
//                   )
//                 ]),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(children: [
//                   Expanded(
//                     flex: 6,
//                     child: buildContactRow(AppImages.email, AppStrings.email),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     flex: 6,
//                     child:
//                         buildContactRow(AppImages.enquiry, AppStrings.enquiry),
//                   )
//                 ]),
//               ],
//             ),
//           )),
//     ),
//   }
//
//   buildContactRow(icon, text) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: const BoxDecoration(
//               color: AppColors.startMarkColor,
//               shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
//               //color: const Color(0xFF66BB6A),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey,
//                   blurRadius: 5.0,
//                 ),
//               ]),
//           child: Image.asset(
//             icon,
//             fit: BoxFit.fill,
//             height: 20,
//             width: 20,
//           ),
//         ),
//         const SizedBox(width: 15),
//         Text(text,
//             style: AppTextStyles.boldStyle(
//                 AppFontSize.font_16, AppColors.submitGradiantColor1)),
//       ],
//     ),
//   }
//
//   SliverAppBar createSilverAppBar() {
//     return SliverAppBar(
//       backgroundColor: AppColors.bgColor,
//       expandedHeight: MediaQuery.of(context).size.height * .570,
//       floating: false,
//       automaticallyImplyLeading: false,
//       pinned: false,
//       elevation: 0,
//       flexibleSpace: FlexibleSpaceBar(
//         collapseMode: CollapseMode.parallax,
//         background: Container(
//           color: AppColors.bgColor,
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     height: 100,
//                     child: Image.asset(
//                       AppImages.carEmpty,
//                       fit: BoxFit.contain,
//                       width: 250,
//                       height: 100,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: AppColors.hintTextColor,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(AppStrings.featured,
//                               style: AppTextStyles.mediumStyle(
//                                   AppFontSize.font_10, AppColors.whiteColor))),
//                       const SizedBox(width: 16),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               buildCardReview(),
//               buildCardLocation(),
//               buildContactUsCard()
//             ],
//           ),
//         ),
//       ),
//     ),
//   }
//
//   SliverAppBar createSilverBottomAppBar() {
//     return SliverAppBar(
//         elevation: 0,
//         forceElevated: true,
//         backgroundColor: AppColors.cardBgColor,
//         floating: false,
//         pinned: true,
//         automaticallyImplyLeading: false,
//         toolbarHeight: 20,
//         excludeHeaderSemantics: true,
//         expandedHeight: 0,
//         collapsedHeight: 20,
//         flexibleSpace: customTabBar()),
//   }
// }
//
// class TabItemModel {
//   int id,
//   bool isStatus,
//   String name,
//
//   TabItemModel({required this.id, required this.isStatus, required this.name}),
// }
