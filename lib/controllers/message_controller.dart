import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/user/message_model.dart';

class MessageController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> streamMessages() {
    try {
      return firestore
          .collection('issue/3kTdk9bKmjx21wGeAV2L/topic')
          .orderBy('sendDate')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((element) {
          return MessageModel.fromMap(
            id: element.id,
            map: element.data() as Map<String, dynamic>,
          );
        }).toList();
      });
    } catch (ex) {
      log('Error streaming messages', error: ex.toString());
      return Stream.error(ex.toString());
    }
  }

  void sendMessage(String content) {
    try {
      final message = MessageModel(content: content, sendDate: Timestamp.now());
      firestore
          .collection('issue/3kTdk9bKmjx21wGeAV2L/topic')
          .add(message.toMap());
    } catch (ex) {
      log('Error sending message', error: ex.toString());
    }
  }
}
