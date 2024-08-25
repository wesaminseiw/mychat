import 'package:flutter/material.dart';
import 'package:mychat/logic/services/chat_screen_service.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class SendMessageField {
  final TextEditingController messageController;
  final String receiverUserId;

  SendMessageField({
    required this.messageController,
    required this.receiverUserId,
  });

  void _sendMessage() {
    if (messageController.text.isEmpty) return;

    ChatService().sendMessage(receiverUserId, messageController.text);
    messageController.clear();
  }

  Widget sendMessageField(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child: Column(
          children: [
            height(24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    maxLines: null,
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                width(8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                    FocusScope.of(context).unfocus();
                  },
                ),
                width(8),
              ],
            ),
          ],
        ),
      );
}
