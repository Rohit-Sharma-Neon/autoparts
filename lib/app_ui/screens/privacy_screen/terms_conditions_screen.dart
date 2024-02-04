import 'package:autoparts/app_ui/screens/privacy_screen/web_view_widget.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
class StaticPage extends StatefulWidget {
  static const routeName = "/terms_conditions";
  final String? type;
  final String? headingName;
  const StaticPage({Key? key,this.type,this.headingName}) : super(key: key);

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {

  var htmlData;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<AuthProvider>().getStaticPage(type: widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, value, Widget? child) {
        htmlData = value.staticPageResponse?.result??"";
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppImages.arrowBack,
                    fit: BoxFit.fitWidth,
                    height: 20,
                  ),
                )),
            title: Text(widget.headingName??"",
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ),
          body: SingleChildScrollView(
            child: Html(data: htmlData,),
          )
        );
      },
    );
  }
}
