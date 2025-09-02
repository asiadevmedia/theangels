import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/cash_out/cash_out_controller.dart';
import 'package:viserpay/data/repo/cashout/cashout_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/transaction_card_shimmer.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_history_screen/widget/cash_out_history_card.dart';
import 'package:viserpay/view/screens/cash-out/cash_out_history_screen/widget/cash_out_history_card_bottom_sheet.dart';

class CashoutHistoryScreen extends StatefulWidget {
  const CashoutHistoryScreen({super.key});

  @override
  State<CashoutHistoryScreen> createState() => _CashoutHistoryScreenState();
}

class _CashoutHistoryScreenState extends State<CashoutHistoryScreen> {
  ScrollController scrollController = ScrollController();
  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<CashOutController>().hasNext()) {
        Get.find<CashOutController>().getCashoutHistory();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CashoutRepo(apiClient: Get.find()));
    final controller = Get.put(CashOutController(
      cashoutRepo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.clearPageData();
      controller.getCashoutHistory();
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
    return GetBuilder<CashOutController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          title: MyStrings.cashOutHistory,
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
              : controller.cashOutHistoryList.isEmpty && controller.isLoading == false
                  ? const Center(
                      child: NoDataWidget(
                          // noDataText: MyStrings.noTrnxHistory.tr,
                          // margin: controller.isSearch ? 10 : 4,
                          ))
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: controller.cashOutHistoryList.length + 1,
                      separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                      itemBuilder: (context, index) {
                        if (controller.cashOutHistoryList.length == index) {
                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                        }

                        return CashOutHistoryCard(
                          index: index,
                          press: () {
                            CustomBottomSheet(
                              child: CashoutHistoryCardBottomSheet(
                                index: index,
                              ),
                            ).customBottomSheet(context);
                          },
                          transaction: controller.cashOutHistoryList[index],
                          currencySym: controller.curSymbol,
                        );
                      },
                    ),
        ),
      );
    });
  }
}
