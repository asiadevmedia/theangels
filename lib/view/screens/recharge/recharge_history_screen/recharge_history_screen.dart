import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/repo/recharge/recharge_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/transaction_card_shimmer.dart';
import 'package:viserpay/view/screens/recharge/recharge_history_screen/widget/recharge_history_card.dart';
import 'package:viserpay/view/screens/recharge/recharge_history_screen/widget/recharge_history_card_bottom_sheet.dart';

class RechargeHistoryScreen extends StatefulWidget {
  const RechargeHistoryScreen({super.key});

  @override
  State<RechargeHistoryScreen> createState() => _RechargeHistoryScreenState();
}

class _RechargeHistoryScreenState extends State<RechargeHistoryScreen> {
  ScrollController scrollController = ScrollController();
  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<RechargeContrller>().hasNext()) {
        Get.find<RechargeContrller>().getRechargeHistory();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RechargeRepo(apiClient: Get.find()));
    final controller = Get.put(RechargeContrller(
      rechargeRepo: Get.find(),
      contactController: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.clearPageData();
      controller.getRechargeHistory();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeContrller>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          title: MyStrings.mobileRechargeHistory,
          isTitleCenter: true,
        ),
        body: Padding(
          padding: Dimensions.screenPaddingHV,
          child: controller.isLoading
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.space5),
                      width: double.infinity,
                      decoration: BoxDecoration(color: MyColor.colorGrey3, borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                      child: const TransactionCardShimmer(),
                    );
                  },
                  itemCount: 10,
                )
              : controller.rechargetHistoryList.isEmpty && controller.isLoading == false
                  ? const Center(
                      child: NoDataWidget(
                          // noDataText: MyStrings.noTrnxHistory.tr,
                          // margin: controller.isSearch ? 10 : 4,
                          ))
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: controller.rechargetHistoryList.length + 1,
                      separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) {
                        if (controller.rechargetHistoryList.length == index) {
                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                        }
                        return RechargeHistoryCard(
                          index: index,
                          press: () {
                            CustomBottomSheet(
                              child: RechargeHistoryCardBottomSheet(
                                index: index,
                              ),
                            ).customBottomSheet(context);
                          },
                          transaction: controller.rechargetHistoryList[index],
                          currencySym: controller.currency,
                        );
                      },
                    ),
        ),
      );
    });
  }
}
