import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/logic/services/get_user_properties.dart';
import 'package:mychat/logic/services/home_screen_services/home_screen_service.dart';
import 'package:mychat/logic/services/login_register_screen_service.dart';
import 'package:mychat/logic/services/profile_image_service.dart';
import 'package:mychat/presentation/widgets/default_button.dart';
import 'package:mychat/presentation/widgets/headers.dart';
import 'package:mychat/presentation/widgets/paddings.dart';
import 'package:mychat/presentation/widgets/dialogs/show_account_delete_dialog.dart';
import 'package:mychat/presentation/widgets/dialogs/show_error_dialog.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';
import 'package:mychat/presentation/widgets/text_fields/text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  File? image;
  final ImagePicker picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? imageUrl;
  Color usernameCheckColor = Colors.green.shade800;
  Color displayNameCheckColor = Colors.green.shade800;

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
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      var usernameSnapshot = await getUsername(username: "");
      var displayNameSnapshot = await getDisplayName(displayName: "");

      setState(() {
        usernameController.text = usernameSnapshot.exists
            ? usernameSnapshot['username']
            : 'Username not found';
        displayNameController.text = displayNameSnapshot.exists
            ? displayNameSnapshot['displayName']
            : 'Display name not found';
      });
    } catch (e) {
      setState(() {
        usernameController.text = 'Error loading username';
        displayNameController.text = 'Error loading display name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus(context),
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                smallHeader(
                  context,
                  title: 'Settings',
                ),
                height(36),
                Padding(
                  padding: defaultSidePadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customization',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.drive_file_rename_outline_rounded,
                        size: 36,
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                height(36),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pickImageService(
                          picker: picker,
                          auth: auth,
                          onImageUrlChanged: (url) {
                            setState(() {
                              imageUrl = url;
                              image = null; // Reset local image file
                            });
                          },
                        );
                      },
                      child: currentUserProfileImageBuilder(
                        image: image,
                        imageUrl: imageUrl,
                        radius: 100,
                      ),
                    ),
                  ],
                ),
                height(36),
                Padding(
                  padding: defaultSidePadding,
                  child: textField(
                    context: context,
                    controller: usernameController,
                    prefixIcon: Icons.alternate_email_rounded,
                    hintText: 'Username',
                    suffixIcon: Icons.check_circle_rounded,
                    suffixIconColor: usernameCheckColor,
                    onChanged: (value) async {
                      setState(() {
                        usernameCheckColor = Colors.grey;
                      });

                      final usernameQuery = await FirebaseFirestore.instance
                          .collection('users')
                          .where('username', isEqualTo: usernameController.text)
                          .get();

                      if (usernameQuery.docs.isNotEmpty) {
                        showErrorDialog(
                          context: context,
                          title: 'Username already taken',
                        );
                        return;
                      }

                      DocumentReference users = FirebaseFirestore.instance
                          .collection('users')
                          .doc(auth.currentUser?.uid);
                      await users.update({
                        'username': usernameController.text,
                      });

                      setState(() {
                        usernameCheckColor = Colors.green.shade800;
                      });
                    },
                  ),
                ),
                height(24),
                Padding(
                  padding: defaultSidePadding,
                  child: textField(
                    context: context,
                    controller: displayNameController,
                    prefixIcon: Icons.person_rounded,
                    hintText: 'Display Name',
                    suffixIcon: Icons.check_circle_rounded,
                    suffixIconColor: displayNameCheckColor,
                    onChanged: (value) async {
                      setState(() {
                        displayNameCheckColor = Colors.grey;
                      });

                      if (displayNameController.text.isNotEmpty) {
                        DocumentReference user = firestore
                            .collection('users')
                            .doc(auth.currentUser?.uid);

                        await user.update({
                          'displayName': displayNameController.text,
                        });

                        setState(() {
                          displayNameCheckColor = Colors.green.shade800;
                        });
                      } else {
                        showErrorDialog(
                          context: context,
                          title: 'Display name is empty',
                        );
                      }
                    },
                  ),
                ),
                height(36),
                Padding(
                  padding: defaultSidePadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.gpp_maybe_rounded,
                        size: 36,
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                height(36),
                Padding(
                  padding: defaultSidePadding,
                  child: defaultButton(
                    context: context,
                    width: double.infinity,
                    height: kToolbarHeight,
                    onPressed: () {
                      signOutProcess(context);
                    },
                    label: 'Log out',
                  ),
                ),
                height(24),
                Padding(
                  padding: defaultSidePadding,
                  child: defaultButton(
                    context: context,
                    width: double.infinity,
                    height: kToolbarHeight,
                    onPressed: () {
                      showAccountDeleteDialog(
                        context: context,
                        title: 'Delete account',
                        currentUser: auth.currentUser!,
                      );
                    },
                    label: 'DELETE ACCOUNT',
                  ),
                ),
                height(150),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'All rights reserved for ',
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      TextSpan(
                        text: 'Mee®',
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                height(16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
