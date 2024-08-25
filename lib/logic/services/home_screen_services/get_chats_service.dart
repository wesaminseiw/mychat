import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/logic/services/chat_screen_service.dart';
import 'package:mychat/presentation/screens/chat/chat_screen.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/dialogs/show_delete_chatroom_dialog.dart';
import 'package:mychat/presentation/widgets/paddings.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

String atOn = 'at';

String? _formatTimestamp(dynamic timestamp) {
  if (timestamp == null) return '';
  if (timestamp is String) {
    timestamp = Timestamp.fromDate(DateTime.parse(timestamp));
  }
  final date = (timestamp as Timestamp).toDate();
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inHours < 24) {
    atOn = 'at';
    return DateFormat('HH:mm').format(date);
  } else {
    atOn = 'on';
    return DateFormat('MM/dd').format(date);
  }
}

Widget getChats() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ChatService chatService = ChatService();

  return StreamBuilder<QuerySnapshot>(
    stream: chatService.getUserChatRooms(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasData) {
        var chatRooms = snapshot.data!.docs;

        // Sort chatRooms by lastMessageTimestamp in descending order
        chatRooms.sort((a, b) {
          var aTimestamp = a['lastMessageTimestamp'];
          var bTimestamp = b['lastMessageTimestamp'];
          if (aTimestamp is String) {
            aTimestamp = Timestamp.fromDate(DateTime.parse(aTimestamp));
          }
          if (bTimestamp is String) {
            bTimestamp = Timestamp.fromDate(DateTime.parse(bTimestamp));
          }
          if (aTimestamp == null || bTimestamp == null) return 0;
          return (bTimestamp as Timestamp).compareTo(aTimestamp as Timestamp);
        });

        if (chatRooms.isEmpty) {
          return Padding(
            padding: defaultSidePadding * 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  elevation: 7,
                  borderRadius: BorderRadius.circular(12),
                  color: context.brightness == Brightness.light
                      ? quaternaryColor
                      : teritaryColor,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.brightness == Brightness.light
                          ? quaternaryColor
                          : teritaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No chat rooms yet.',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => height(16),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var chatRoom = chatRooms[index];
              var participants = chatRoom['participants'];
              var otherUserId =
                  participants.firstWhere((id) => id != auth.currentUser!.uid);
              String lastMessage = chatRoom['lastMessage'] ?? '';
              var lastMessageTimestamp = chatRoom['lastMessageTimestamp'];
              var lastMessageSender = chatRoom['lastMessageSender'] ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: firestore.collection('users').doc(otherUserId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const ListTile(
                      title: Text('User not found'),
                    );
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  var receiverUsername = userData['username'];
                  var receiverDisplayName = userData['displayName'];
                  var receiverProfileImage = userData['profileImageUrl'] ?? '';

                  // Determine chat room ID
                  String chatRoomId = chatRoom.id;

                  return Padding(
                    padding: defaultSidePadding,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onLongPress: () {
                          showChatRoomDeleteDialog(
                            context: context,
                            currentUser: auth.currentUser!,
                            chatRoomId: chatRoomId,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.brightness == Brightness.light
                                ? quaternaryColor
                                : teritaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: lastMessage.isEmpty
                                ? const EdgeInsets.symmetric(vertical: 16)
                                : EdgeInsets.zero,
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(receiverProfileImage),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: lastMessage.isEmpty
                                  ? Center(
                                      child: Text(
                                        receiverDisplayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.textTheme.labelMedium
                                            ?.copyWith(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      receiverDisplayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                              subtitle: lastMessage.isEmpty
                                  ? null
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        height(8),
                                        Text(
                                          lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                            color:
                                                context.colorScheme.secondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          lastMessage.isEmpty ||
                                                  lastMessageSender.isEmpty ||
                                                  lastMessageTimestamp == null
                                              ? ''
                                              : atOn == 'on'
                                                  ? 'Sent by ${lastMessageSender == receiverUsername ? lastMessageSender : 'you'} on ${_formatTimestamp(lastMessageTimestamp)} at ${DateFormat('HH:mm').format((lastMessageTimestamp as Timestamp).toDate())}'
                                                  : 'Sent by ${lastMessageSender == receiverUsername ? lastMessageSender : 'you'} at ${_formatTimestamp(lastMessageTimestamp)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                              onTap: () {
                                push(
                                  context,
                                  page: ChatScreen(
                                    receiverUsername: receiverUsername,
                                    receiverUserId: otherUserId,
                                    receiverDisplayName: receiverDisplayName,
                                    receiverProfileImage: receiverProfileImage,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      }
      return const Center(child: Text('No chat rooms yet.'));
    },
  );
}
