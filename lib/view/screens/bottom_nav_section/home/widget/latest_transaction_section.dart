import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';

import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/style.dart';
import '../../../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../../../components/no_data.dart';
import '../../../../components/shimmer/transaction_card_shimmer.dart';
import 'latest_transaction_card.dart';
import 'transaction_history_bottom_sheet.dart';

class LatestTransactionSection extends StatelessWidget {
  const LatestTransactionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return controller.isLoading
          ? SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space15), child: Column(children: List.generate(8, (index) => const TransactionCardShimmer())))
          : controller.latestTransactions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.space20),
                  child: NoDataWidget(
                    margin: 30,
                    noDataText: MyStrings.noTrnxHistory.tr,
                    isAlignmentCenter: false,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.space20),
                  child: Column(
                    children: [
                      Container(
                        color: MyColor.colorWhite,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              MyStrings.transaction.tr,
                              style: boldMediumLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      LayoutBuilder(builder: (context, box) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                          color: MyColor.colorWhite,
                          child: ListView.builder(
                            itemCount: controller.latestTransactions.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => LatestTransactionCard(
                              index: index,
                              press: () {
                                CustomBottomSheet(child: TransactionHistoryBottomSheet(index: index)).customBottomSheet(context);
                              },
                              transaction: controller.latestTransactions[index],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                );
    });
  }
}
