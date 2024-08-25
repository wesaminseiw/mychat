import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/logic/services/home_screen_services/home_screen_service.dart';
import 'package:mychat/presentation/styles/colors.dart';
import 'package:mychat/presentation/widgets/background_shape.dart';
import 'package:mychat/presentation/widgets/paddings.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class ReceiverInfoScreen extends StatefulWidget {
  final String receiverUsername;
  final String receiverUserId;
  final String receiverDisplayName;
  final String receiverProfileImage;

  const ReceiverInfoScreen({
    super.key,
    required this.receiverUsername,
    required this.receiverUserId,
    required this.receiverDisplayName,
    required this.receiverProfileImage,
  });

  @override
  State<ReceiverInfoScreen> createState() => _ReceiverInfoScreenState();
}

class _ReceiverInfoScreenState extends State<ReceiverInfoScreen> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    currentUserProfileImageBuilder(
                      image: null,
                      imageUrl: widget.receiverProfileImage,
                      radius: 100,
                    ),
                  ],
                ),
                height(24),
                Padding(
                  padding: defaultSidePadding * 2,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.brightness == Brightness.dark
                            ? teritaryColor
                            : quaternaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: defaultSidePadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(36),
                            Text(
                              'Name: ${widget.receiverDisplayName}',
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: primaryColor,
                                fontSize: 18,
                              ),
                            ),
                            height(36),
                            Text(
                              'Username: ${widget.receiverUsername}',
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: primaryColor,
                                fontSize: 18,
                              ),
                            ),
                            height(36),
                            Text(
                              'UID: ${widget.receiverUserId}',
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            height(36),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
