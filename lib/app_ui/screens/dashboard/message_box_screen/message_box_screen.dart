import "package:autoparts/app_ui/common_widget/custom_textfield.dart";
import 'package:autoparts/app_ui/common_widget/no_data_widget.dart';
import "package:autoparts/app_ui/screens/dashboard/message_box_screen/message_detail_screen.dart";
import 'package:autoparts/chat/chat_constants.dart';
import "package:autoparts/constant/app_colors.dart";
import "package:autoparts/constant/app_image.dart";
import "package:autoparts/constant/app_text_style.dart";
import 'package:autoparts/main.dart';
import 'package:autoparts/utils/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:shimmer/shimmer.dart';

import '../../../../api_service/api_config.dart';
import '../../../../chat/model/chat_user_model.dart';

class MessageBoxScreen extends StatefulWidget {
  static const routeName = "/message-box";
  final String? from;
  const MessageBoxScreen({Key? key,this.from}) : super(key: key);

  @override
  _MessageBoxScreenState createState() => _MessageBoxScreenState();
}

class _MessageBoxScreenState extends State<MessageBoxScreen> {
  List<MessageData> messageList = [
    MessageData(status: true),
    MessageData(status: false),
    MessageData(status: false),
    MessageData(status: false),
    MessageData(status: true),
    MessageData(status: false),
    MessageData(status: false),
    MessageData(status: false),
    MessageData(status: true),
  ];

  // late FirebaseFirestore firebaseFirestore;
  // late QuerySnapshot result;
  late Stream<QuerySnapshot<Object?>> data;

  @override
  void initState() {
    super.initState();
    // data = getFirestoreData(ChatConstants().tableName,10,"");
    // print(data);
    // firebaseFirestore = FirebaseFirestore.instance;
    // getData();
  }

  // getData() async {
  //   result = await firebaseFirestore.collection(ChatConstants().tableName)
  //       .where(ChatConstants().id, isEqualTo: sp.getString(SpUtil.USER_ID)).get();
  //   print(result);
  // }

  Future<void> updateFirestoreData(
      String collectionPath, String path, Map<String, dynamic> updateData) {
    return firebaseFirestore.collection(collectionPath).doc(path).update(updateData);
  }

  Stream<QuerySnapshot> getFirestoreData(
      String collectionPath, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .where(ChatConstants().userName, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(collectionPath)
          .limit(limit)
          .snapshots();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
       // extendBody: true,
        body: Column(
          children: [
          widget.from != null ? Container() :  customAppbar(),
            _textField(),
            /// Users
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("UserCollection").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData ? Text('PLease Wait') :
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length??0,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Object?>? users = snapshot.data?.docs[index];
                      return buildListTile(users);
                    },
                  ),
                );
              },
            ),
            // Expanded(
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     children: List.generate(messageList.length,
            //         (index) => buildListTile(messageList[index])),
            //   ),
            // ),
           // SizedBox(height: 100),
           // widget.from != null ? const SizedBox(height: 70,) : Container(),
          ],
        ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatUserModel userChat = ChatUserModel.fromDocument(documentSnapshot);
      if (userChat.id == sp.getString(SpUtil.USER_ID)) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            // if (KeyboardUtils.isKeyboardShowing()) {
            //   KeyboardUtils.closeKeyboard(context);
            // }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ChatPage(
            //           peerId: userChat.id,
            //           peerAvatar: userChat.photoUrl,
            //           peerNickname: userChat.displayName,
            //           userAvatar: firebaseAuth.currentUser!.photoURL!,
            //         )));
          },
          child: ListTile(
            leading: userChat.photoUrl.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                userChat.photoUrl,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                          color: Colors.grey,
                          value: loadingProgress.expectedTotalBytes !=
                              null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null),
                    );
                  }
                },
                errorBuilder: (context, object, stackTrace) {
                  return const Icon(Icons.account_circle, size: 50);
                },
              ),
            )
                : const Icon(
              Icons.account_circle,
              size: 50,
            ),
            title: Text(
              userChat.displayName,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
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
            Text("messageBox".tr(),
                style: AppTextStyles.boldStyle(
                    AppFontSize.font_22, AppColors.blackColor)),
          ])),
    );
  }

  buildListTile(QueryDocumentSnapshot<Object?>? users) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, MessageDetailScreen.routeName);
      },
      child: Card(
        elevation: 0,
        // color: message.status == false
        //     ? AppColors.bgColor
        //     : AppColors.selectedBgColor,
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: baseImageUrl + users?["profileImage"],
                        placeholder: (context, url) => const Center(child: SizedBox(height: 50,width: 50,child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.fill,
                        width: 80,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(users?["userName"],
                                style: AppTextStyles.boldStyle(
                                    AppFontSize.font_18, AppColors.blackColor)),
                            const Spacer(),
                            Text("5 min",
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_14,
                                    AppColors.submitGradiantColor1)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Hello! I need a help",
                                style: AppTextStyles.mediumStyle(
                                    AppFontSize.font_14, AppColors.hintTextColor)),
                            const Spacer(),
                            // message.status == true
                            //     ? Container(
                            //         padding: const EdgeInsets.all(5),
                            //         decoration: const BoxDecoration(
                            //             color: AppColors.brownColor,
                            //             shape: BoxShape.circle),
                            //         child: Text("5",
                            //             style: AppTextStyles.mediumStyle(
                            //                 AppFontSize.font_12,
                            //                 AppColors.whiteColor)),
                            //       )
                            //     : Container(),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            // message.status == false
            //     ? Container(
            //   height: 1,
            //   margin: const EdgeInsets.only(left: 85,right: 16),
            //   color: AppColors.messageBgColor,
            // ) : Container()
          ],
        ),
      ),
    );
  }

  _textField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.whiteColor,
      child: CustomRoundTextField(
        padding: const EdgeInsets.only(bottom: 16),
        hintText: "search".tr(),
        icon: const Icon(Icons.search, color: AppColors.brownColor,size: 25,),
        fillColor: AppColors.whiteColor,
      ),
    );
  }
}

class MessageData {
  bool? status;
  MessageData({this.status});
}
