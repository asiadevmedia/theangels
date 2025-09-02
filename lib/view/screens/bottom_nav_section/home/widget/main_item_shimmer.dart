import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';
import '../../../../components/shimmer/main_item_shimmer.dart';

class MainItemShimmerSections extends StatelessWidget {
  const MainItemShimmerSections({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller){
      return  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => const MainItemShimmer()),
          ),
          const SizedBox(
            height: Dimensions.space20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => const MainItemShimmer()),
          ),
        ],
      );
    });
  }
}
