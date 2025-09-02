import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';

class ContactCardShimmer extends StatelessWidget {
  const ContactCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: MyColor.colorGrey.withOpacity(0.2),
          highlightColor: MyColor.primaryColor.withOpacity(0.7),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
            height: Dimensions.space40,
            width: Dimensions.space40,
          ),
        ),
        const SizedBox(
          width: Dimensions.space10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: MyColor.colorGrey.withOpacity(0.2),
              highlightColor: MyColor.primaryColor.withOpacity(0.7),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                height: Dimensions.space15,
                width: context.width / 3,
              ),
            ),
            Shimmer.fromColors(
              baseColor: MyColor.colorGrey.withOpacity(0.2),
              highlightColor: MyColor.primaryColor.withOpacity(0.7),
              child: Container(
                decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                height: Dimensions.space20,
                width: context.width / 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
