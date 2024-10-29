// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dschat/model/message_model.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메세지 목록')),
      body: StreamBuilder<List<MessageModel>>(
        stream: streamMessages(), 
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return const Center(
              child: Text('오류가 발생했습니다.'),
            );
          } else {
            List<MessageModel> messages =
                asyncSnapshot.data!; //비동기 데이터가 존재할 경우 리스트뷰 표시
            return Column(
              mainAxisSize: MainAxisSize.max,
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
                        })),
                getInputWidget()
              ],
            );
          }
        },
      ),
    );
  }

  Widget getInputWidget() {
    return Container(
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 3)
      ], color: Theme.of(context).highlightColor),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            RawMaterialButton(
              onPressed: _onPressedSendButton,
              constraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              elevation: 2.0,
              fillColor: Theme.of(context).colorScheme.primary,
              shape: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onPressedSendButton() {
    try {
      MessageModel messageModel =
          MessageModel(content: controller.text, sendDate: Timestamp.now());

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('issue/3kTdk9bKmjx21wGeAV2L/topic')
          .add(messageModel.toMap());
    } catch (ex) {
      log('error)', error: ex.toString(), stackTrace: StackTrace.current);
    }
  }

  Stream<List<MessageModel>> streamMessages() {
    try {
      //찾고자 하는 컬렉션의 스냅샷(Stream)을 가져온다.
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('issue/3kTdk9bKmjx21wGeAV2L/topic')
          .orderBy('sendDate')
          .snapshots();
      return snapshots.map((querySnapshot) {
        List<MessageModel> messages =
            []; 
        querySnapshot.docs.forEach((element) {
          messages.add(
            MessageModel.fromMap(
              id: element.id,
              map: element.data() as Map<String, dynamic>,
            ),
          );
        });
        return messages; //QuerySnapshot에서 List<MessageModel> 로 변경이 됐으니 반환
      }); 
    } catch (ex) {
      log('error)', error: ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }
}
