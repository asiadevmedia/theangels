import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/global/history_icon_widget.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/paybill_history_card_shimmer.dart';
import 'package:viserpay/view/components/shimmer/roundedImage_text_shimmer.dart';
import 'package:viserpay/view/screens/add-money/add_money_history/widget/status_widget.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_history_screen/widget/pay_bill_history_bottom_sheet.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_history_screen/widget/pay_bill_item.dart';
import 'package:viserpay/view/screens/pay-bill/widget/paybill_icon_widget.dart';

import '../../../components/no_data/no_data_card.dart';

class PaybillHomeScreen extends StatefulWidget {
  const PaybillHomeScreen({super.key});

  @override
  State<PaybillHomeScreen> createState() => _PaybillHomeScreenState();
}

class _PaybillHomeScreenState extends State<PaybillHomeScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaybillRepo(apiClient: Get.find()));
    final controller = Get.put(PaybillController(paybillRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.appBarColor,
      appBar: CustomAppBar(
        title: MyStrings.paybill,
        isTitleCenter: true,
        elevation: 0.01,
        action: [
          HistoryWidget(routeName: RouteHelper.paybillHistory),
          const SizedBox(
            width: Dimensions.space20,
          ),
        ],
      ),
      body: GetBuilder<PaybillController>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.initialValue();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: RefreshIndicator(
              backgroundColor: MyColor.colorWhite,
              color: MyColor.primaryColor,
              onRefresh: () async {
                controller.initialValue();
              },
              child: Padding(
                padding: Dimensions.defaultPaddingHV,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!controller.isLoading && controller.utility.isEmpty) ...[
                      const NoDataCard(
                        width: double.infinity,
                      )
                    ],
                    controller.isLoading
                        ? Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 18, // horizontal space
                            runSpacing: 18, //vertical space
                            children: List.generate(
                              12,
                              (index) => const RoundedWidgetTextShimmer(
                                height: 30,
                                width: 30,
                                showBottom: false,
                              ),
                            ),
                          )
                        : Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 24, // horizontal space
                            runSpacing: 24, //vertical space
                            children: List.generate(
                              controller.utility.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectUtils(controller.utility[index]);
                                  },
                                  child: BillPayItem(
                                    name: controller.utility[index].name.toString(),
                                    image: controller.utility[index].getImage.toString(),
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ),
                    const CustomDivider(
                      space: Dimensions.space20,
                    ),
                    controller.isLoading
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                MyStrings.billingHistory.tr,
                                style: semiBoldDefault,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(RouteHelper.paybillHistory);
                                },
                                child: Text(
                                  MyStrings.seeall.tr,
                                  style: regularDefault.copyWith(color: MyColor.primaryColor),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: Dimensions.space5,
                    ),
                    controller.isLoading
                        ? SingleChildScrollView(
                            child: Column(
                              children: List.generate(10, (index) => PaybillHistoryCardShimmer()),
                            ),
                          )
                        : controller.paybillHistory.isEmpty
                            ? const NoDataWidget(
                                isAlignmentCenter: false,
                                margin: 9,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.paybillHistory.length > 10 ? 10 : controller.paybillHistory.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      CustomBottomSheet(
                                          child: PaybillHistoryCardBottomSheet(
                                        index: index,
                                        isHome: true,
                                      )).customBottomSheet(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: Dimensions.space12, horizontal: Dimensions.space12),
                                      child: UserCard(
                                        title: controller.paybillHistory[index].setupUtilityBill?.name ?? "",
                                        subtitle: controller.paybillHistory[index].trx ?? "",
                                        imgWidget: BillIcon(
                                          imageUrl: controller.paybillHistory[index].setupUtilityBill?.getImage ?? "",
                                          height: 20,
                                          width: 20,
                                          color: MyColor.getSymbolColor(index),
                                          shape: BoxShape.circle,
                                          radius: 8,
                                        ),
                                        isAsset: controller.paybillHistory[index].setupUtilityBill?.getImage == null ? true : false,
                                        imgHeight: 40,
                                        subtitleStyle: semiBoldDefault,
                                        rightWidget: Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                DateConverter.formatDateMonthYear(controller.paybillHistory[index].createdAt.toString()),
                                                style: dateTextStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: Dimensions.space5 + 8,
                                            ),
                                            StatusWidget(
                                              status: controller.getStatus(controller.paybillHistory[index].status.toString()),
                                              color: controller.getStatusColor(controller.paybillHistory[index].status.toString()),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}