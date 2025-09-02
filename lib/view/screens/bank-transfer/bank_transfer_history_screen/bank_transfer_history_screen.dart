import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/bank_transfer/bank_tranfer_controller.dart';
import 'package:viserpay/data/repo/bank_tansfer/bank_transfer_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/paybill_history_card_shimmer.dart';
import 'package:viserpay/view/screens/add-money/add_money_history/widget/status_widget.dart';
import 'package:viserpay/view/screens/bank-transfer/bank_transfer_history_screen/widget/bank_transfer_details_bottom_sheet.dart';

import '../../../components/bottom-sheet/custom_bottom_sheet.dart';

class BankTransferHistoryScreen extends StatefulWidget {
  const BankTransferHistoryScreen({super.key});

  @override
  State<BankTransferHistoryScreen> createState() => _BankTransferHistoryScreenState();
}

class _BankTransferHistoryScreenState extends State<BankTransferHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<BankTransferController>().hasNext()) {
        Get.find<BankTransferController>().getBankHistory();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BankTransferRepo(apiClient: Get.find()));
    final controller = Get.put(BankTransferController(bankTransferRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.currentPage = 0;
      controller.curSymbol = Get.find<ApiClient>().getCurrencyOrUsername(isSymbol: true);
      controller.getBankHistory();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(
        title: MyStrings.bankTransferHistory,
        isTitleCenter: true,
        elevation: 0.01,
      ),
      body: GetBuilder<BankTransferController>(builder: (controller) {
        return controller.bankHistoryLoading
            ? SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Column(
                  children: List.generate(
                      15,
                      (index) => PaybillHistoryCardShimmer(
                            isPdfShow: false,
                          )),
                ),
              )
            : controller.bankHistory.isEmpty
                ? const NoDataWidget(isAlignmentCenter: true)
                : Padding(
                    padding: const EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15),
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.bankHistory.length + 1,
                      itemBuilder: (context, index) {
                        if (controller.bankHistory.length == index) {
                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                        }

                        return GestureDetector(
                          onTap: () => CustomBottomSheet(child: BankTransferHistoryBottomSheet(index: index)).customBottomSheet(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.space12, horizontal: Dimensions.space12),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(boxShadow: MyUtils.getCardShadow(), color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                            child: UserCard(
                              title: controller.bankHistory[index].bank?.name ?? "",
                              subtitle: DateConverter.formatDateMonthYear(controller.bankHistory[index].createdAt.toString()),
                              maxLine: 2,
                              subtitleStyle: lightDefault.copyWith(fontSize: 12, color: MyColor.bodytextColor),
                              imgWidget: MyImageWidget(
                                imageUrl: controller.bankHistory[index].bank?.getImage.toString() ?? "",
                                height: 30,
                                width: 30,
                              ),
                              rightSpace: 12,
                              rightWidget: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "${Converter.formatNumber(controller.bankHistory[index].amount.toString())} ${controller.currency}",
                                      style: regularDefault.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.space15,
                                  ),
                                  StatusWidget(
                                    status: controller.getStatus(controller.bankHistory[index].status.toString()),
                                    color: controller.getStatusColor(controller.bankHistory[index].status.toString()),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
      }),
    );
  }
}
