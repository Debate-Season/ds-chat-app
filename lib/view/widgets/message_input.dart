import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/message_controller.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final MessageController messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 3)
      ], color: Theme.of(context).highlightColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 15.0),
                  labelText: "채팅을 입력하세요",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.black26, width: 1.0),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            RawMaterialButton(
              onPressed: () {
                messageController.sendMessage(controller.text);
                controller.clear();
              },
              constraints: BoxConstraints(minWidth: 0, minHeight: 0),
              elevation: 2.0,
              fillColor: Theme.of(context).colorScheme.primary,
              shape: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
