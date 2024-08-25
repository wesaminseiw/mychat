import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/logic/services/chat_screen_service.dart';
import 'package:mychat/logic/services/home_screen_services/get_chats_service.dart';
import 'package:mychat/logic/services/get_user_properties.dart';
import 'package:mychat/logic/services/home_screen_services/home_screen_service.dart';
import 'package:mychat/logic/services/profile_image_service.dart';
import 'package:mychat/presentation/widgets/background_shape.dart';
import 'package:mychat/presentation/widgets/paddings.dart';
import 'package:mychat/presentation/widgets/text_fields/read_only_search_bar.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class HomePage extends StatefulWidget {
  bool hasBeenUpdated = false;
  HomePage({super.key, required this.hasBeenUpdated});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ChatService chatService = ChatService();
  String? imageUrl;
  File? image;
  var username;
  var displayName;

  @override
  void initState() {
    super.initState();
    loadProfileImage(
      auth: auth,
      onImageUrlLoaded: (url) {
        setState(() {
          imageUrl = url;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: CustomShapePainter(context: context),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: 16,
                  ),
                  child: Row(
                    children: [
                      currentUserProfileImageBuilder(
                        image: image,
                        imageUrl: imageUrl,
                      ),
                      width(12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder(
                            future: getDisplayName(displayName: displayName),
                            builder: (context, snapshot) {
                              if (widget.hasBeenUpdated == true &&
                                  snapshot.hasData) {
                                var displayName = snapshot.data!['displayName'];
                                return displayNameBuilder(
                                  context,
                                  displayName: displayName,
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...',
                                  style: context.textTheme.headlineSmall,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: context.textTheme.headlineSmall,
                                );
                              } else if (!snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return Text(
                                  'Display name not found',
                                  style: context.textTheme.headlineSmall,
                                );
                              } else {
                                var displayName = snapshot.data!['displayName'];
                                return displayNameBuilder(
                                  context,
                                  displayName: displayName,
                                );
                              }
                            },
                          ),
                          FutureBuilder(
                            future: getUsername(username: username),
                            builder: (context, snapshot) {
                              if (widget.hasBeenUpdated == true &&
                                  snapshot.hasData) {
                                var username = snapshot.data!['username'];
                                return usernameBuilder(context,
                                    username: username);
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...',
                                  style: context.textTheme.labelMedium,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: context.textTheme.labelMedium,
                                );
                              } else if (!snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return Text(
                                  'Username not found',
                                  style: context.textTheme.labelMedium,
                                );
                              } else {
                                var username = snapshot.data!['username'];
                                return usernameBuilder(context,
                                    username: username);
                              }
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      settingsIconBuilder(context),
                    ],
                  ),
                ),
                height(24),
                Padding(
                  padding: defaultSidePadding,
                  child: readOnlySearchBar(context),
                ),
                height(24),
                Expanded(
                  child: getChats(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
