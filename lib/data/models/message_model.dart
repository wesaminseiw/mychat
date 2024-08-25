import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String message;
  final String senderUsername;
  final String messageId;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.message,
    required this.senderUsername,
    required this.messageId,
  });

  // Convert Message to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'message': message,
      'senderUsername': senderUsername,
      'messageId': messageId,
    };
  }

  // Create Message from Firestore Map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      timestamp: map['timestamp'],
      message: map['message'],
      senderUsername: map['senderUsername'],
      messageId: map['messageId'],
    );
  }
}
