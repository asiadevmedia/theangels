// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';

class LabelColumn extends StatelessWidget {
  final String header;
  final String body;
  TextStyle? headerTextDecoration;
  TextStyle? bodyTextDecoration;
  final bool alignmentEnd;
  final bool lastTextRed;
  final bool isSmallFont;
  LabelColumn({
    super.key,
    this.isSmallFont = false,
    this.lastTextRed = false,
    this.alignmentEnd = false,
    required this.header,
    required this.body,
    this.headerTextDecoration,
    this.bodyTextDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignmentEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          header.tr,
          style: headerTextDecoration ?? regularSmall.copyWith(color: MyColor.getTextColor().withOpacity(0.6)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          body.tr,
          style: bodyTextDecoration ??
              regularSmall.copyWith(
                color: MyColor.getTextColor(),
                fontWeight: FontWeight.w500,
              ),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}
