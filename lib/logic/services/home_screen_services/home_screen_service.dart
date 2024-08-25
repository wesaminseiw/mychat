import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/presentation/screens/settings/settings_screen.dart';

Widget usernameBuilder(
  BuildContext context, {
  required String username,
}) {
  return Text(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    '@$username',
    style: context.textTheme.labelMedium?.copyWith(
      color: context.colorScheme.primary,
      fontSize: 16,
    ),
  );
}

Widget displayNameBuilder(
  BuildContext context, {
  required String displayName,
}) {
  return Text(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    displayName,
    style: context.textTheme.headlineSmall?.copyWith(
      color: context.colorScheme.primary,
      fontSize: 18,
    ),
  );
}

Widget currentUserProfileImageBuilder({
  required File? image,
  required String? imageUrl,
  double? radius,
}) {
  return image != null
      ? CircleAvatar(
          radius: radius ?? 30,
          backgroundImage: FileImage(image),
        )
      : imageUrl != null
          ? CircleAvatar(
              radius: radius ?? 30,
              backgroundImage: NetworkImage(imageUrl),
            )
          : CircleAvatar(
              radius: radius ?? 30,
              backgroundImage: const AssetImage(
                'assets/images/default_profile_image.png',
              ),
            );
}

Widget settingsIconBuilder(BuildContext context) {
  return IconButton(
    onPressed: () async {
      push(context, page: const SettingsScreen());
    },
    icon: Icon(
      Icons.settings_rounded,
      color: context.colorScheme.primary,
    ),
  );
}
