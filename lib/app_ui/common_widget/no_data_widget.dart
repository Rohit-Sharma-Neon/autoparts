import 'package:autoparts/constant/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        AppStrings.notFoundAssets,
        repeat: true,
        fit: BoxFit.cover,
      ),
    );
  }
}
