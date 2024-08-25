import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/logic/services/chat_screen_service.dart';
import 'package:mychat/presentation/screens/chat/receiver_info/receiver_info_screen.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/text_fields/send_message_field.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserId;
  final String receiverDisplayName;
  final String receiverProfileImage;

  const ChatScreen({
    required this.receiverUsername,
    required this.receiverUserId,
    required this.receiverDisplayName,
    required this.receiverProfileImage,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus(context),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.receiverProfileImage),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    width(16),
                    Expanded(
                      child: Text(
                        widget.receiverDisplayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: context.brightness == Brightness.light
                              ? primaryColor
                              : teritaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        push(
                          context,
                          page: ReceiverInfoScreen(
                            receiverUsername: widget.receiverUsername,
                            receiverUserId: widget.receiverUserId,
                            receiverDisplayName: widget.receiverDisplayName,
                            receiverProfileImage: widget.receiverProfileImage,
                          ),
                        );
                        print(widget.receiverUsername);
                        print(widget.receiverUserId);
                        print(widget.receiverDisplayName);
                        print(widget.receiverProfileImage);
                      },
                      icon: const Icon(Icons.info_outline_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getMessages(
                    currentUser!.uid,
                    widget.receiverUserId,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No messages yet."));
                    }
                    return _chatService.displayMessages(snapshot, currentUser);
                  },
                ),
              ),
              SendMessageField(
                messageController: _messageController,
                receiverUserId: widget.receiverUserId,
              ).sendMessageField(context),
            ],
          ),
        ),
      ),
    );
  }
}
