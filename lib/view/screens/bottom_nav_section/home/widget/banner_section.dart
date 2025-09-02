import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';

import '../../../../../core/utils/my_color.dart';
import 'carousel_items.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return controller.isLoading ? Shimmer.fromColors(
          baseColor: MyColor.colorGrey.withOpacity(0.2),
          highlightColor: MyColor.primaryColor.withOpacity(0.7),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            width: context.width,
            height: 110,
          ),
        )
      : controller.appBanners.isNotEmpty
          ? const CarouselItems()
          : const SizedBox.shrink();
    });
  }
}
