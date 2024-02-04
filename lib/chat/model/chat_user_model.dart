import 'package:autoparts/chat/chat_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatUserModel extends Equatable {
  final String id;
  final String photoUrl;
  final String displayName;

  const ChatUserModel(
      {required this.id,
        required this.photoUrl,
        required this.displayName,
        });

  Map<String, dynamic> toJson() {
    return {
      ChatConstants().id: id,
      ChatConstants().profileImage: photoUrl,
      ChatConstants().userName: displayName,
    };
  }

  factory ChatUserModel.fromDocument(DocumentSnapshot documentSnapshot) {
    String id = documentSnapshot.get(ChatConstants().id);
    String photo = documentSnapshot.get(ChatConstants().profileImage);
    String name = documentSnapshot.get(ChatConstants().userName);

    return ChatUserModel(
      id: id,
      photoUrl: photo,
      displayName: name,
    );
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
