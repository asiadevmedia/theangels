// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/view/components/shimmer/shimmer_widget.dart';

class PaybillHistoryCardShimmer extends StatelessWidget {
  bool isPdfShow = false;
  PaybillHistoryCardShimmer({super.key, this.isPdfShow = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            MyShimmerWidget(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                height: isPdfShow ? 30 : 50,
                width: isPdfShow ? 30 : 50,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyShimmerWidget(
                  child: Container(
                    decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(1)),
                    height: 15,
                    width: context.width / 4,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                MyShimmerWidget(
                  child: Container(
                    decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(1)),
                    height: 15,
                    width: context.width / 3,
                  ),
                ),
              ],
            ),
          ],
        ),
        isPdfShow
            ? MyShimmerWidget(
                child: Container(
                  decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(1)),
                  height: 24,
                  width: 24,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyShimmerWidget(
                    child: Container(
                      decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(1)),
                      height: 15,
                      width: context.width / 6,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyShimmerWidget(
                    child: Container(
                      decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(1)),
                      height: 15,
                      width: context.width / 5,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
