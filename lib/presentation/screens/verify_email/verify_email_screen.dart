import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/logic/services/email_verification_screen_service.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    isEmailVerified = user.emailVerified;

    // Periodically check email verification status
    checkEmailVerification(
      context,
      isEmailVerified: isEmailVerified,
      user: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
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
                          'Verify',
                          style: context.textTheme.headlineLarge,
                        ),
                        height(10),
                        Text(
                          'your email to proceed to MyChat',
                          style: context.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          height(64),
          context.brightness == Brightness.dark
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    Image.asset(
                      'assets/images/verify_email.png',
                      scale: 4,
                    ),
                  ],
                )
              : Image.asset(
                  'assets/images/verify_email.png',
                  scale: 4,
                ),
          height(48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              textAlign: TextAlign.center,
              'We have sent to your email a link to verify it, please check your inbox',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          height(24),
          TextButton(
            onPressed: () async {
              await sendVerificationEmail(
                context,
                canResendEmail: canResendEmail,
                user: user,
              );
            },
            child: Text(
              'Resend email verification',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
