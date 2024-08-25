import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';
import 'package:mychat/app/utils/functions.dart';
import 'package:mychat/logic/services/login_register_screen_service.dart';
import 'package:mychat/presentation/screens/login/login_screen.dart';
import 'package:mychat/presentation/widgets/default_button.dart';
import 'package:mychat/presentation/widgets/sized_boxes.dart';
import 'package:mychat/presentation/widgets/text_fields/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocus(context),
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                                'Register',
                                style: context.textTheme.headlineLarge,
                              ),
                              height(10),
                              Text(
                                'to start your journey in MyChat',
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      textField(
                        context: context,
                        controller: usernameController,
                        prefixIcon: Icons.person_rounded,
                        hintText: 'Username',
                        keyboardType: TextInputType.name,
                      ),
                      height(16),
                      textField(
                        context: context,
                        controller: emailController,
                        prefixIcon: Icons.alternate_email_rounded,
                        hintText: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      height(16),
                      textField(
                        context: context,
                        controller: passwordController,
                        prefixIcon: Icons.password_rounded,
                        hintText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isVisible,
                        suffixIcon: isVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        suffixOnPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                height(16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: defaultButton(
                    context: context,
                    width: double.infinity,
                    height: kToolbarHeight,
                    onPressed: () async {
                      registerProcess(
                        context,
                        email: emailController.text,
                        password: passwordController.text,
                        username: usernameController.text,
                      );
                    },
                    label: 'Next',
                  ),
                ),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      TextSpan(
                        text: 'Login.',
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            push(context, page: LoginScreen());
                          },
                      ),
                    ],
                  ),
                ),
                height(36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
