// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class Infocard extends StatelessWidget {
  String icon, title, subtitle;
  VoidCallback ontap;
  bool? isSvg;
  Infocard({
    super.key,
    required this.ontap,
    this.isSvg = true,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  isSvg!
                      ? CustomSvgPicture(
                          image: icon,
                          color: MyColor.colorBlack,
                          width: 24,
                          height: 24,
                        )
                      : Image.asset(
                          icon,
                          color: MyColor.colorBlack,
                          width: 24,
                          height: 24,
                        ),
                  const SizedBox(
                    width: Dimensions.space15,
                  ),
                  Expanded(
                    child: CardColumn(
                      header: title,
                      body: subtitle,
                      bodyMaxLine: 8,
                      headerTextStyle: boldDefault.copyWith(fontSize: 16),
                      bodyTextStyle: regularDefault.copyWith(color: MyColor.colorGrey),
                    ),
                  )
                ],
              ),
            ),
            const CustomSvgPicture(
              image: MyIcon.arrowRightIos,
              color: MyColor.colorBlack,
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
