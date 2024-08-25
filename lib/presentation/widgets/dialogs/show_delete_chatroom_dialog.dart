import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/logic/services/chat_screen_service.dart';
import 'package:mychat/presentation/styles/colors.dart';

Future<void> showChatRoomDeleteDialog({
  required BuildContext context,
  required User currentUser,
  required String chatRoomId,
}) async {
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: teritaryColor,
        title: Text('Delete this chat room?'),
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

              try {
                // Call the deleteChatRoom method to delete the chat room
                await ChatService().deleteChatRoom(chatRoomId);

                // Optionally, you can show a success message or handle further logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat room deleted successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                // Handle errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting chat room: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
