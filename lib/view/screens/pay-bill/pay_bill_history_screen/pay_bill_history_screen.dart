import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/paybill_history_card_shimmer.dart';
import 'package:viserpay/view/screens/pay-bill/pay_bill_history_screen/widget/pay_bill_history_bottom_sheet.dart';
import 'package:viserpay/view/screens/pay-bill/widget/paybill_icon_widget.dart';

class PaybillHistoryScreen extends StatefulWidget {
  const PaybillHistoryScreen({super.key});

  @override
  State<PaybillHistoryScreen> createState() => _PaybillHistoryScreenState();
}

class _PaybillHistoryScreenState extends State<PaybillHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<PaybillController>().hasNext()) {
        Get.find<PaybillController>().loadBillHistoryPaginationData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaybillRepo(apiClient: Get.find()));
    final controller = Get.put(PaybillController(paybillRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadBillingHistoryData();
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
      backgroundColor: MyColor.appBarColor,
      appBar: CustomAppBar(
        title: MyStrings.payBillHistory,
        isTitleCenter: true,
        elevation: 0.01,
      ),
      body: GetBuilder<PaybillController>(
        builder: (controller) {
          return controller.isLoading
              ? SingleChildScrollView(
                  padding: Dimensions.screenPaddingHV,
                  child: Column(
                    children: List.generate(15, (index) => PaybillHistoryCardShimmer(isPdfShow: true)),
                  ),
                )
              : controller.billHistoryList.isEmpty
                  ? const NoDataWidget()
                  : ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: Dimensions.space10),
                      itemCount: controller.billHistoryList.length + 1,
                      itemBuilder: (context, index) {
                        if (controller.billHistoryList.length == index) {
                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                        }

                        String amount = Converter.formatNumber(controller.billHistoryList[index].transaction?.amount ?? "0");
                        String date = DateConverter.localNumberdateOnly(controller.billHistoryList[index].createdAt.toString());

                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            CustomBottomSheet(child: PaybillHistoryCardBottomSheet(index: index)).customBottomSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.space7, horizontal: Dimensions.space12),
                            margin: const EdgeInsets.symmetric(vertical: Dimensions.space7, horizontal: Dimensions.space12),
                            decoration: BoxDecoration(color: MyColor.colorWhite, boxShadow: MyUtils.getCardShadow(), borderRadius: BorderRadius.circular(Dimensions.defaultRadius), border: Border.all(color: MyColor.borderColor, width: .4)),
                            child: UserCard(
                              title: controller.billHistoryList[index].setupUtilityBill?.name?.tr ?? "",
                              subtitle: "${controller.curSymbol}$amount ${MyStrings.paymentOn.tr} $date",
                              subtitleStyle: lightDefault.copyWith(fontSize: 12, color: MyColor.bodytextColor),
                              maxLine: 2,
                              imgWidget: BillIcon(
                                imageUrl: controller.billHistoryList[index].setupUtilityBill?.getImage.toString() ?? "",
                                height: 20,
                                width: 20,
                                color: MyColor.getSymbolColor(index),
                                shape: BoxShape.circle,
                                radius: 8,
                              ),
                              rightWidget: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  controller.downLoadId.toString() == controller.billHistoryList[index].id.toString()
                                      ? const SizedBox(
                                          width: Dimensions.space10 + 3,
                                          height: Dimensions.space10 + 3,
                                          child: CircularProgressIndicator(color: MyColor.primaryColor, strokeWidth: 2),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            controller.downloadAttachmentFile(id: controller.billHistoryList[index].id.toString(), name: "${DateTime.now()}");
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(Dimensions.space7),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: MyColor.colorWhite,
                                              boxShadow: MyUtils.getCardShadow(),
                                              border: Border.all(color: MyColor.primaryColor.withOpacity(.8), width: .5),
                                            ),
                                            child: const CustomSvgPicture(image: MyImages.file, height: 15, width: 15),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: Dimensions.space5 + 8,
                                  ),
                                  Text(controller.getStatus(controller.billHistoryList[index].status.toString()).tr, style: regularDefault.copyWith(fontSize: Dimensions.fontSmall, color: controller.getStatusColor(controller.billHistoryList[index].status.toString()))),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
