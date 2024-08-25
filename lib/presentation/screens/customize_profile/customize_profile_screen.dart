import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/screens/verify_email/verify_email_screen.dart';
import 'package:mychat/presentation/widgets/default_button.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';
import 'package:mychat/presentation/widgets/text_fields/text_field.dart';
import 'package:mychat/logic/services/profile_image_service.dart';

class CustomizeProfileScreen extends StatefulWidget {
  const CustomizeProfileScreen({super.key});

  @override
  _CustomizeProfileScreenState createState() => _CustomizeProfileScreenState();
}

class _CustomizeProfileScreenState extends State<CustomizeProfileScreen> {
  TextEditingController displayNameController = TextEditingController();
  File? image;
  final ImagePicker picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? imageUrl;

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

  Future<void> pickImage() async {
    await pickImageService(
      picker: picker,
      auth: auth,
      onImageUrlChanged: (url) {
        setState(() {
          imageUrl = url;
          image = null; // Reset local image file
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus(context),
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(380),
                      bottomLeft: Radius.elliptical(120, 10),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 50,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Customize',
                                style: context.textTheme.headlineLarge,
                              ),
                              height(10),
                              Text(
                                'how you want to be presented',
                                style: context.textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                height(36),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    GestureDetector(
                      onTap: pickImage,
                      child: image != null
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: FileImage(image!),
                            )
                          : imageUrl != null
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundImage: NetworkImage(imageUrl!),
                                )
                              : Image.asset(
                                  'assets/images/default_profile_image.png',
                                  scale: 3.5,
                                ),
                    ),
                  ],
                ),
                height(36),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: textField(
                    context: context,
                    controller: displayNameController,
                    prefixIcon: Icons.person_pin_rounded,
                    hintText: 'Display name',
                  ),
                ),
                height(24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: defaultButton(
                    context: context,
                    width: double.infinity,
                    height: kToolbarHeight,
                    onPressed: () async {
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      String displayName = displayNameController.text;
                      if (currentUser != null) {
                        DocumentReference user = FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid);
                        await user.set(
                          {
                            'displayName': displayName,
                          },
                          SetOptions(merge: true),
                        );
                        currentUser.sendEmailVerification();
                        pushNoReturn(
                          context,
                          page: VerifyEmailScreen(),
                        );
                      } else {
                        print('========== CURRENTUSER IS NULL! ==========');
                      }
                    },
                    label: 'Sign Up',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
