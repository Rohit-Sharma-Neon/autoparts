// import 'package:autoparts/chat/model/provider/chat_provider.dart';
// import "package:autoparts/constant/app_colors.dart";
// import "package:autoparts/constant/app_image.dart";
// import "package:autoparts/constant/app_text_style.dart";
// import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:flutter/material.dart";
// import 'package:fluttertoast/fluttertoast.dart';
//
// class MessageDetailScreen extends StatefulWidget {
//   static const routeName = "/message-detail";
//   const MessageDetailScreen({Key? key}) : super(key: key);
//
//   @override
//   _MessageDetailScreenState createState() => _MessageDetailScreenState();
// }
//
// class _MessageDetailScreenState extends State<MessageDetailScreen> {
//
//   TextEditingController messageController = TextEditingController();
//
//   ChatProvider chatProvider = ChatProvider();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.cardBgColor,
//       appBar: customAppbar(),
//       body: _buildBody(),
//     );
//   }
//
//   _buildBody() {
//     return Stack(
//       children: <Widget>[
//         Flexible(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: chatProvider.getChatMessage(groupChatId, 10),
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//
//             },
//             child: ListView.builder(
//               reverse: true,
//                 padding: const EdgeInsets.fromLTRB(16,16,16,50),
//                 itemCount: messages.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return buildNotificationCard(messages[index]);
//                 }),
//           ),
//         ),
//         sendMessageBottom()
//       ],
//     );
//   }
//
//   buildNotificationCard(ChatMessage messages) {
//     return GestureDetector(
//       onTap: () {},
//       child: Column(
//         crossAxisAlignment: (messages.messageType  == "receiver" ? CrossAxisAlignment.start :  CrossAxisAlignment.end) ,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width/2,
//               margin: const EdgeInsets.only(bottom: 16),
//             decoration: BoxDecoration(
//               borderRadius:  BorderRadius.only(
//                 topLeft: const Radius.circular(12.0),
//                 topRight: const Radius.circular(12.0),
//                 bottomLeft: messages.messageType  == "receiver" ? const Radius.circular(0) : const Radius.circular(12.0),
//                 bottomRight: messages.messageType  == "receiver" ? const Radius.circular(12.0) : const Radius.circular(0)
//               ),
//               color: (messages.messageType  == "receiver" ? AppColors.whiteColor :  AppColors.selectedBgColor),
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(messages.messageContent,
//                     style: AppTextStyles.mediumStyle(
//                         AppFontSize.font_14, AppColors.submitGradiantColor1),),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                       Text("10:27 pm",
//                       style: AppTextStyles.mediumStyle(
//                           AppFontSize.font_12, AppColors.hintTextColor))
//                       ],
//                     )
//
//               ],
//             )
//             ),
//         ],
//       ),
//     );
//   }
//
//   sendMessageBottom() {
//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         height: 60,
//         width: double.infinity,
//         color: AppColors.submitGradiantColor1,
//         child: Row(
//           children: <Widget>[
//              Expanded(
//               child: TextField(
//                 controller: messageController,
//                 style:  AppTextStyles.regularStyle(
//                     AppFontSize.font_16, AppColors.whiteColor),
//                 decoration: InputDecoration(
//                     hintText: "Write a Message...",
//                     hintStyle:  AppTextStyles.regularStyle(
//                         AppFontSize.font_16, AppColors.whiteColor),
//                     border: InputBorder.none),
//               ),
//             ),
//             GestureDetector(
//                 onTap: () {},
//                 child: Image.asset(
//                   AppImages.attachmentIcon,
//                   height: 25,
//                 )),
//             const SizedBox(
//               width: 15,
//             ),
//             GestureDetector(
//                 onTap: () {
//                   onSendMessage(messageController.text, 1);
//                 },
//                 child: Image.asset(
//                   AppImages.sendIcon,
//                   height: 25,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   customAppbar() {
//     return  PreferredSize(
//       preferredSize: const Size.fromHeight(75.0), // here the desired height
//       child: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         flexibleSpace: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: <Widget>[
//                 GestureDetector(
//                     onTap: () {
//                       Navigator.pop(
//                         context,
//                       );
//                     },
//                     child: Image.asset(
//                       AppImages.arrowBack,
//                       fit: BoxFit.contain,
//                       height: 20,
//                     )),
//                 const SizedBox(width: 16),
//                 Image.asset(
//                   AppImages.user,
//
//                 ),
//                 const SizedBox(width: 16),
//                 Text("Etefin Emir",
//                     style: AppTextStyles.boldStyle(
//                         AppFontSize.font_22, AppColors.blackColor)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<ChatMessage> messages = [
//     ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
//     ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
//     ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
//     ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
//     ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
//     ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
//     ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
//     ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
//     ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
//     ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
//   ];
//
//   void onSendMessage(String content, int type) {
//     if (content.trim().isNotEmpty) {
//       messageController.clear();
//       chatProvider.sendChatMessage(content, type, groupChatId, currentUserId, widget.peerId);
//       scrollController.animateTo(0,
//           duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
//     } else {
//       Fluttertoast.showToast(
//           msg: 'Nothing to send', backgroundColor: Colors.grey);
//     }
//   }
//
//   // checking if received message
//   bool isMessageReceived(int index) {
//     if ((index > 0 && listMessages[index - 1].get(FirestoreConstants.idFrom) == currentUserId) ||  index == 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   // checking if sent message
//   bool isMessageSent(int index) {
//     if ((index > 0 && listMessages[index - 1].get(FirestoreConstants.idFrom) != currentUserId) ||  index == 0) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }
//
// class ChatMessage{
//   String messageContent;
//   String messageType;
//   ChatMessage({required this.messageContent, required this.messageType});
// }