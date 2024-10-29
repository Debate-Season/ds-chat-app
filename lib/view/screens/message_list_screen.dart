import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/message_controller.dart';
import '../../model/user/message_model.dart';
import '../widgets/message_input.dart';

class MessageListScreen extends StatelessWidget {
  final MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메세지 목록')),
      body: StreamBuilder<List<MessageModel>>(
        stream: messageController.streamMessages(),
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          } else {
            List<MessageModel> messages = asyncSnapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].content),
                        subtitle: Text(messages[index]
                            .sendDate
                            .toDate()
                            .toLocal()
                            .toString()
                            .substring(5, 16)),
                      );
                    },
                  ),
                ),
                MessageInput(),
              ],
            );
          }
        },
      ),
    );
  }
}
