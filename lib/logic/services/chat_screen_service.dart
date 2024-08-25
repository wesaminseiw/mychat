import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/data/models/message_model.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/dialogs/show_delete_message_dialog.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fetch the username for a given user ID
  Future<String> _getUsername(String userId) async {
    DocumentReference userDoc = firestore.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      throw Exception("User not found");
    }

    // Extract and return the username
    Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
    return data['username'] ?? 'No username';
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // Fetch usernames for sender
    String senderUsername = await _getUsername(currentUserId);
    String messageId = Uuid().v1();

    Message newMessage = Message(
      messageId: messageId,
      senderId: currentUserId,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
      senderUsername: senderUsername,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .set(newMessage.toMap());

    await firestore.collection('chat_rooms').doc(chatRoomId).set(
      {
        'chatRoomId': chatRoomId,
        'participants': ids,
        'lastMessage': message,
        'lastMessageTimestamp': timestamp,
        'lastMessageSender': senderUsername,
      },
      SetOptions(merge: true),
    );
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChatRooms() {
    final String currentUserId = auth.currentUser!.uid;
    return firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();

    await firestore.collection('chat_rooms').doc(chatRoomId).update({
      'lastMessage': '',
      'lastMessageSender': '',
      'lastMessageTimestamp': '',
    });
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    await firestore.collection('chat_rooms').doc(chatRoomId).delete();
  }

  Widget displayMessages(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    User? currentUser,
  ) {
    ScrollController scrollController = ScrollController();

    // Scroll to the bottom of the list after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    return ListView.builder(
      controller: scrollController,
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var messageData = snapshot.data!.docs[index];
        var isCurrentUserMessage = messageData['senderId'] == currentUser!.uid;

        return Align(
          alignment: isCurrentUserMessage
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: () async {
              if (isCurrentUserMessage) {
                showMessageDeleteDialog(
                  context: context,
                  currentUser: currentUser,
                  messageData: messageData,
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCurrentUserMessage
                    ? context.brightness == Brightness.light
                        ? primaryColor
                        : secondaryColor
                    : context.brightness == Brightness.light
                        ? quaternaryColor
                        : teritaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUserMessage)
                    Text(
                      messageData['senderUsername'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.brightness == Brightness.light
                            ? primaryColor
                            : secondaryColor,
                      ),
                    ),
                  Text(
                    messageData['message'],
                    style: TextStyle(
                      color:
                          isCurrentUserMessage ? Colors.white : Colors.black87,
                    ),
                  ),
                  height(5),
                  Text(
                    DateFormat('dd/MM/yyyy').format(
                      (messageData['timestamp'] as Timestamp).toDate(),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCurrentUserMessage
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
