import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/logic/services/chat_screen_service.dart';
import 'package:mychat/presentation/styles/colors.dart';

Future<void> showMessageDeleteDialog({
  required BuildContext context,
  required User currentUser,
  required QueryDocumentSnapshot<Object?> messageData,
}) async {
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: teritaryColor,
        title: Text('Delete this meesage?'),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: secondaryColor,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close the dialog
              var messageId = messageData.get('messageId');
              List<String> ids = [currentUser.uid, messageData['receiverId']];
              ids.sort();
              String chatRoomId = ids.join('_');
              await ChatService().deleteMessage(chatRoomId, messageId);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ],
      );
    },
  );
}
