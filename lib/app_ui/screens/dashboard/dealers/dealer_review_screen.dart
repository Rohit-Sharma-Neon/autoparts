import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/models/review_rating_response.dart';
import 'package:autoparts/provider/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../../../api_service/api_config.dart';

class DealerReviewScreen extends StatefulWidget {
  static const routeName = "/dealer-review";
  const DealerReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<DealerReviewScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<UserProvider>().getReviewRatingsApi();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          children: [customAppbar(), _buildBody()],
        ));
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
            const SizedBox(
              width: 20,
            ),
            Text("reviewRating".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackBottomColor)),
          ])),
    );
  }

  _buildBody() {
    return Expanded(
      child: Consumer<UserProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Column(
                children: List.generate(
                  value.reviewRatingResponse?.result?.length??0,
                      (position) {
                    return buildUserCard(value.reviewRatingResponse!.result![position]);
                  },
                ),
              ),
              const SizedBox(height: 16),
              buildCarImages(),
            ],
          );
        },
      ),
    );
  }

    String dateParse({date, output}) {
      if (date == null || date == "") return "";
      const formatFull = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
      DateTime parseDate = DateFormat(formatFull).parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat(output);
      var outputDate = outputFormat.format(inputDate);
      return outputDate;
      }


  buildUserCard(RatingsData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(right: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    (data.user?.image??"").isNotEmpty
                        ? baseImageUrl + (data.user?.image??"")
                        : demoImageUrlOLd,
                  ),
                  fit: BoxFit.fill,
                )
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 6,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(data.user?.name??"",
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_18, AppColors.blackColor)),
                  Text(dateParse(
                    date: data.createdAt,
                    output: "dd/MM/yyyy",
                  ),
                      style: AppTextStyles.regularStyle(
                          AppFontSize.font_12, AppColors.hintTextColor)),
                ]),
                const SizedBox(height: 5),
                buildRatingBar((data.rating??0).toDouble()),
                const SizedBox(height: 5),
                Text(data.review??"",
                    style: AppTextStyles.regularStyle(
                        AppFontSize.font_14, AppColors.hintTextColor)),
                const SizedBox(height: 10),
          ]),
        ),
      ]),
    );
  }

  buildRatingBar(double rating){
    return   RatingBar.builder(
      initialRating: rating,
      minRating: 0,
      ignoreGestures: true,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 28.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: AppColors.startMarkColor,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  buildCarImages() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: AppColors.cardBgColor,
          borderRadius: BorderRadius.circular(10.0),
          image: const DecorationImage(
              image:  AssetImage( AppImages.sliderImage),
              fit: BoxFit.fitHeight
          )
      ),

    );
  }
}
