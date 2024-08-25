import 'package:flutter/material.dart';
import 'package:mychat/app/utils/extensions.dart';

Widget smallHeader(
  BuildContext context, {
  required String title,
  String? content,
}) =>
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
                    title,
                    style: context.textTheme.displaySmall,
                  ),
                  content != null
                      ? Text(
                          content,
                          style: context.textTheme.labelMedium,
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
