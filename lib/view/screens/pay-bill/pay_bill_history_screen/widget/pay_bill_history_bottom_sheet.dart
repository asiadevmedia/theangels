// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/text/bottom_sheet_header_text.dart';

class PaybillHistoryCardBottomSheet extends StatelessWidget {
  final int index;
  bool isHome;

  PaybillHistoryCardBottomSheet({super.key, required this.index, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaybillController>(builder: (controller) {
      return isHome
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [BottomSheetHeaderText(text: MyStrings.details.tr), const BottomSheetCloseButton()],
                ),
                const CustomDivider(space: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.transactionId.tr,
                      body: controller.paybillHistory[index].trx ?? "",
                    ),
                    CardColumn(
                      alignmentEnd: true,
                      header: MyStrings.date.tr,
                      body: "${DateConverter.isoStringToLocalDateTime(controller.paybillHistory[index].createdAt ?? "")} ",
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.utility.tr,
                      body: "${(controller.paybillHistory[index].setupUtilityBill?.name ?? "")} ",
                    ),
                    CardColumn(
                      // alignmentEnd: true,
                      header: MyStrings.amount.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.paybillHistory[index].transaction?.beforeCharge ?? "")}",
                    )
                  ],
                ),
                const SizedBox(height: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.charge.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.paybillHistory[index].transaction?.charge ?? "")} ",
                    ),
                    CardColumn(
                      alignmentEnd: true,
                      header: MyStrings.finalAmount.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.paybillHistory[index].transaction?.amount ?? "")}",
                    )
                  ],
                ),
                const SizedBox(height: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.remainingBalance.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.paybillHistory[index].transaction?.postBalance ?? "")} ",
                    ),
                  ],
                ),
                controller.paybillHistory[index].userData != null && controller.paybillHistory[index].userData!.isNotEmpty
                    ? const SizedBox(
                        height: Dimensions.space20,
                      )
                    : const SizedBox.shrink(),
                controller.paybillHistory[index].userData != null && controller.paybillHistory[index].userData!.isNotEmpty
                    ? SizedBox(
                        // height: context.height / 3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.paybillHistory[index].userData?.length ?? 0,
                          itemBuilder: (ctx, i) {
                            // return Text(controller.paybillHistory[index].userData![i].name ?? '');
                            return controller.paybillHistory[index].userData![i].type == "file"
                                ? InkWell(
                                    splashColor: MyColor.primaryColor.withOpacity(0.2),
                                    onTap: () {
                                      controller.downloadAttachment(controller.paybillHistory[index].userData![i].value ?? '', context);
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          (controller.paybillHistory[index].userData![i].name.toString().capitalizeFirst ?? '').tr,
                                          style: lightDefault.copyWith(color: MyColor.bodytextColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.file_download,
                                              size: 17,
                                              color: MyColor.primaryColor,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              MyStrings.attachment.tr,
                                              style: regularDefault.copyWith(color: MyColor.primaryColor),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: i % 2 == 0 ? Alignment.topLeft : Alignment.topRight,
                                    child: CardColumn(
                                      alignmentEnd: i % 2 == 0 ? false : true,
                                      header: (controller.paybillHistory[index].userData![i].name ?? '').tr,
                                      body: (controller.paybillHistory[index].userData![i].value ?? '').tr,
                                    ),
                                  );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                controller.paybillHistory[index].adminFeedback == "" ? const SizedBox.shrink() : const SizedBox(height: Dimensions.space15),
                controller.paybillHistory[index].adminFeedback == ""
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MyStrings.rejectReason.tr,
                            style: regularSmall.copyWith(color: MyColor.getTextColor().withOpacity(0.6)),
                          ),
                          Text(
                            controller.paybillHistory[index].adminFeedback ?? '',
                            style: regularSmall.copyWith(
                              color: MyColor.getTextColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BottomSheetBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [BottomSheetHeaderText(text: MyStrings.details.tr), const BottomSheetCloseButton()],
                ),
                const CustomDivider(space: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.transactionId.tr,
                      body: controller.billHistoryList[index].trx ?? "",
                    ),
                    CardColumn(
                      alignmentEnd: true,
                      header: MyStrings.date.tr,
                      body: "${DateConverter.isoStringToLocalDateTime(controller.billHistoryList[index].createdAt ?? "")} ",
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.utility.tr,
                      body: "${(controller.billHistoryList[index].setupUtilityBill?.name ?? "")} ",
                    ),
                    CardColumn(
                      // alignmentEnd: true,
                      header: MyStrings.amount.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.billHistoryList[index].transaction?.beforeCharge ?? "")}",
                    )
                  ],
                ),
                const SizedBox(height: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.charge.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.billHistoryList[index].transaction?.charge ?? "")} ",
                    ),
                    CardColumn(
                      alignmentEnd: true,
                      header: MyStrings.finalAmount.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.billHistoryList[index].transaction?.amount ?? "")}",
                    )
                  ],
                ),
                const SizedBox(height: Dimensions.space15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.remainingBalance.tr,
                      body: "${controller.curSymbol}${Converter.formatNumber(controller.billHistoryList[index].transaction?.postBalance ?? "")} ",
                    ),
                  ],
                ),
                controller.billHistoryList[index].userData != null && controller.billHistoryList[index].userData!.isNotEmpty
                    ? const SizedBox(
                        height: Dimensions.space20,
                      )
                    : const SizedBox.shrink(),
                controller.billHistoryList[index].userData != null && controller.billHistoryList[index].userData!.isNotEmpty
                    ? SizedBox(
                        // height: context.height / 3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.billHistoryList[index].userData?.length ?? 0,
                          itemBuilder: (ctx, i) {
                            // return Text(controller.billHistory[index].userData![i].name ?? '');
                            return controller.billHistoryList[index].userData![i].type == "file"
                                ? InkWell(
                                    onTap: () {
                                      String url = "${controller.filePath}/${controller.billHistoryList[index].userData![i].value}";

                                      controller.downloadAttachment(url, context);
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          (controller.billHistoryList[index].userData![i].name.toString().capitalizeFirst ?? '').tr,
                                          style: lightDefault.copyWith(color: MyColor.bodytextColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.file_download,
                                              size: 17,
                                              color: MyColor.primaryColor,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              MyStrings.attachment.tr,
                                              style: regularDefault.copyWith(color: MyColor.primaryColor),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: i.isOdd ? Alignment.topLeft : Alignment.topRight,
                                    child: CardColumn(
                                      alignmentEnd: i.isOdd ? false : true,
                                      header: controller.billHistoryList[index].userData![i].name ?? '',
                                      body: controller.billHistoryList[index].userData![i].value ?? '',
                                    ),
                                  );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                controller.billHistoryList[index].adminFeedback == "" ? const SizedBox.shrink() : const SizedBox(height: Dimensions.space15),
                controller.billHistoryList[index].adminFeedback == ""
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MyStrings.rejectReason.tr,
                            style: regularSmall.copyWith(color: MyColor.getTextColor().withOpacity(0.6)),
                          ),
                          Text(
                            controller.billHistoryList[index].adminFeedback ?? '',
                            style: regularSmall.copyWith(
                              color: MyColor.getTextColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ],
            );
    });
  }
}
