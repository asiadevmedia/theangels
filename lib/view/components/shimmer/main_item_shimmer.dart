import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viserpay/core/utils/my_color.dart';

class MainItemShimmer extends StatelessWidget {
  const MainItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: MyColor.colorGrey.withOpacity(0.2),
          highlightColor: MyColor.primaryColor.withOpacity(0.7),
          child: Container(
            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
            height: 56,
            width: 56,
          ),
        ),
        Shimmer.fromColors(
          baseColor: MyColor.colorGrey.withOpacity(0.2),
          highlightColor: MyColor.primaryColor.withOpacity(0.7),
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            height: 5,
            width: context.width / 10,
          ),
        ),
      ],
    );
  }
}