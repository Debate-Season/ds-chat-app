import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String content;
  final Timestamp sendDate;

  MessageModel({
    this.id = '',
    this.content = '',
    Timestamp? sendDate,
  }) : sendDate = sendDate ??
            Timestamp(
              0,
              0,
            );

  factory MessageModel.fromMap(
      {required String id, required Map<String, dynamic> map}) {
    return MessageModel(
        id: id,
        content: map['content'] ?? '',
        sendDate: map['sendDate'] ??
            Timestamp(
              0,
              0,
            ));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['content'] = content;
    data['sendDate'] = sendDate;
    return data;
  }
}
