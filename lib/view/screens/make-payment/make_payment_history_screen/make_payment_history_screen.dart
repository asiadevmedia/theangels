import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';

import 'package:viserpay/data/controller/make_payment/make_payment_controller.dart';

import 'package:viserpay/data/repo/money_discharge/make_payment/make_payment_repo.dart';

import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/transaction_card_shimmer.dart';

import 'package:viserpay/view/screens/make-payment/make_payment_history_screen/widget/make_payement_history_card.dart';
import 'package:viserpay/view/screens/make-payment/make_payment_history_screen/widget/make_payement_history_card_bottom_sheet.dart';

class MakePaymentHistoryScreen extends StatefulWidget {
  const MakePaymentHistoryScreen({super.key});

  @override
  State<MakePaymentHistoryScreen> createState() => _MakePaymentHistoryScreenState();
}

class _MakePaymentHistoryScreenState extends State<MakePaymentHistoryScreen> {
  ScrollController scrollController = ScrollController();
  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<MakePaymentController>().hasNext()) {
        Get.find<MakePaymentController>().getPaymentHistory();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MakePaymentRepo(apiClient: Get.find()));
    final controller = Get.put(MakePaymentController(
      makePaymentRepo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.clearPageData();
      controller.getPaymentHistory();
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
    return GetBuilder<MakePaymentController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          title: MyStrings.makePayment,
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
              : controller.paymentHistoryList.isEmpty && controller.isLoading == false
                  ? const Center(
                      child: NoDataWidget(
                          // noDataText: MyStrings.noTrnxHistory.tr,
                          // margin: controller.isSearch ? 10 : 4,
                          ))
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: controller.paymentHistoryList.length + 1,
                      separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) {
                        if (controller.paymentHistoryList.length == index) {
                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                        }

                        return MakePaymentHistoryCard(
                          index: index,
                          press: () {
                            CustomBottomSheet(
                              child: MakePaymentHistoryCardBottomSheet(
                                index: index,
                              ),
                            ).customBottomSheet(context);
                          },
                          transaction: controller.paymentHistoryList[index],
                          currencySym: controller.currencySym,
                        );
                      },
                    ),
        ),
      );
    });
  }
}
