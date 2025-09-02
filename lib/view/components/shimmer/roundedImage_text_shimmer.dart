// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';

class RoundedWidgetTextShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? showBottom;
  const RoundedWidgetTextShimmer({
    super.key,
    this.height,
    this.width,
    this.showBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: MyColor.colorGrey.withOpacity(0.2),
          highlightColor: MyColor.primaryColor.withOpacity(0.7),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            width: width ?? 60,
            height: height ?? 60,
          ),
        ),
        if (showBottom == true) ...[
          const SizedBox(height: Dimensions.space5),
          Shimmer.fromColors(
            baseColor: MyColor.colorGrey.withOpacity(0.2),
            highlightColor: MyColor.primaryColor.withOpacity(0.7),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(1)),
              width: 60,
              height: 10,
            ),
          ),
        ]
      ],
    );
  }
}
