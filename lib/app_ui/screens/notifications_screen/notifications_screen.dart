import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_strings.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/provider/loading_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/notification_list_model.dart';
import '../../../provider/notofication_provider.dart';
import '../../../utils/time_ago.dart';
import '../../common_widget/show_dialog.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = "/notifications";

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<NotificationProvider>().getNotificationListApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Consumer<NotificationProvider>(
          builder: (BuildContext context, value, Widget? child) {
          return Scaffold(backgroundColor: AppColors.cardBgColor, body: _buildBody(value));
        }
      );
  }

  _buildBody(NotificationProvider value) {
    return Consumer<LoadingProvider>(
      builder: (BuildContext context, loading, Widget? child) {
        return Column(
          children: [
            customAppbar(),
            (loading.isHomeLoading??false) ?
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: AppColors.selectedBgColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade400,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: 200,
                                        height: 10,
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade400,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: 100,
                                        height: 10,
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                  ]),
                            ),
                          ));
                    })) :
            value.notificationListData != null
                ? Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: value.notificationListData?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return buildNotificationCard(index,value);
                    }))
                :
            Expanded(
              child: Center(
                child: Lottie.asset(
                  AppStrings.notFoundAssets,
                  repeat: true,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                Text("notifications".tr(),
                    style: AppTextStyles.boldStyle(
                        AppFontSize.font_22, AppColors.blackColor)),
              ],
            ),
            const Spacer(),
            PopupMenuButton(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: AppColors.hintTextColor, width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),

              color: Colors.white,
              onSelected: (result) {
                if (result == 0) {
                  showActionDialog(context, "NotificationsDeleteAlert".tr(), ()async {
                    Navigator.of(context).pop(false);
                    await context.read<NotificationProvider>().notificationDeleteApi(true, "");
                     context.read<NotificationProvider>().getNotificationListApi();

                  });
                }
                if (result == 1) {
                  showActionDialog(context, "NotificationsReadAlert".tr(), () async{
                    Navigator.of(context).pop(false);
                    await context.read<NotificationProvider>().notificationReadApi(true, "");
                    context.read<NotificationProvider>().getNotificationListApi();

                  });
                }
                if (result == 2) {
                  showActionDialog(context, "NotificationsUnreadAlert".tr(), () async {
                    Navigator.of(context).pop(false);
                    await  context.read<NotificationProvider>().notificationUnreadApi();
                     context.read<NotificationProvider>().getNotificationListApi();

                  });
                }
              },
              offset: const Offset(0, 20),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 15),
                        dense: true,
                        title: Text(
                          "clearAll".tr(),
                          style: const TextStyle(
                              color:AppColors.brownColor, fontSize: 16,fontWeight: FontWeight.w700),
                        ),
                      )),
                  PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.only(left: 15),
                        title: Text("markAsAllRead".tr(),
                            style: const TextStyle(
                                color: AppColors.brownColor, fontSize: 16,fontWeight: FontWeight.w700)),
                      )),
                  PopupMenuItem<int>(
                      value: 2,
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.only(left: 15),
                        title: Text("MarkAsAllUnread".tr(),
                            style: const TextStyle(
                                color: AppColors.brownColor, fontSize: 16,fontWeight: FontWeight.w700)),
                      )),
                ];
              },
              child: Image.asset(
                AppImages.horizontalDots,
                fit: BoxFit.fill,
                color: AppColors.blackColor,
                height: 8,
                width: 30,
              ),
            ),
          ])),
    );
  }

  buildNotificationCard(index,value) {
    return GestureDetector(
      onTap: () {
        if (value.notificationListData![index].isRead == false) {
          setState(() {
            value. notificationListData![index].isRead = true;
          });
          context
              .read<NotificationProvider>()
              .notificationReadApi(false,value.notificationListData![index].id.toString());
        }
      },
      child: Card(
          margin: const EdgeInsets.only(bottom: 15),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: value.notificationListData?[index].isRead ?? false
              ? AppColors.whiteColor
              : AppColors.selectedBgColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Slidable(
                key: UniqueKey(),
                closeOnScroll: true,
                endActionPane: ActionPane(
                  dismissible: DismissiblePane(onDismissed: () {
                    setState(() {
                      value.notificationListData?.removeWhere(
                          (item) => item.id == value.notificationListData?[index].id);
                    });
                    context.read<NotificationProvider>().notificationDeleteApi(false, value.notificationListData![index].id.toString());
                  }),
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (v) {
                        context
                            .read<NotificationProvider>()
                            .notificationDeleteApi(false,
                            value.notificationListData![index].id.toString());
                        setState(() {
                          value.notificationListData?.removeWhere(
                              (item) => item.id == value.notificationListData?[index].id);
                        });
                      },
                      backgroundColor: AppColors.brownColor,
                      foregroundColor: Colors.white,
                      flex: 20,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                              value.notificationListData![index].description ?? "",
                              style: value.notificationListData![index].isRead ?? false
                                  ? AppTextStyles.regularStyle(
                                      AppFontSize.font_16,
                                      AppColors.submitGradiantColor1)
                                  : AppTextStyles.mediumStyle(
                                      AppFontSize.font_16,
                                      AppColors.submitGradiantColor1)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            TimeAgo.timeAgoSinceDate(
                                value.notificationListData![index].createdAt.toString()),
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_12, AppColors.hintTextColor)),
                      ]),
                )),
          )),
    );
  }

}
