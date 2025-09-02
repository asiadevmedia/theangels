import 'package:flutter/material.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../data/controller/bank_transfer/bank_tranfer_controller.dart';
import 'package:get/get.dart';

import '../../../../components/bottom-sheet/bottom_sheet_close_button.dart';
import '../../../../components/column_widget/card_column.dart';
import '../../../../components/divider/custom_divider.dart';
import '../../../../components/text/bottom_sheet_header_text.dart';

class BankTransferHistoryBottomSheet extends StatelessWidget {
  final int index;
  const BankTransferHistoryBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankTransferController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomSheetBar(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [BottomSheetHeaderText(text: MyStrings.details), BottomSheetCloseButton()],
          ),
          const CustomDivider(space: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.transactionId.tr,
                body: controller.bankHistory[index].trx ?? "",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.date.tr,
                body: DateConverter.convertIsoToString(controller.bankHistory[index].createdAt ?? ""),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.amount.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.bankHistory[index].trxData?.beforeCharge ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.charge.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.bankHistory[index].trxData?.charge ?? "")}",
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardColumn(
                header: MyStrings.finalAmount.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.bankHistory[index].trxData?.amount ?? "")}",
              ),
              CardColumn(
                alignmentEnd: true,
                header: MyStrings.remainingBalance.tr,
                body: "${controller.curSymbol}${Converter.formatNumber(controller.bankHistory[index].trxData?.postBalance ?? "")}",
              ),
            ],
          ),
          controller.bankHistory[index].userData != null && controller.bankHistory[index].userData!.isNotEmpty ? const SizedBox(height: Dimensions.space15) : const SizedBox.shrink(),
          controller.bankHistory[index].userData != null && controller.bankHistory[index].userData!.isNotEmpty
              ? SizedBox(
                  // height: context.height / 3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.bankHistory[index].userData?.length ?? 0,
                    itemBuilder: (ctx, i) {
                      // return Text(controller.paybillHistory[index].userData![i].name ?? '');
                      return controller.bankHistory[index].userData![i].type == "file"
                          ? InkWell(
                              onTap: () {
                                String url = "${controller.filePath}/${controller.bankHistory[index].userData![i].value}";
                                controller.downloadAttachment(url, context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    (controller.bankHistory[index].userData![i].name.toString().capitalizeFirst ?? '').tr,
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
                                header: controller.bankHistory[index].userData![i].name ?? '',
                                body: controller.bankHistory[index].userData![i].value ?? '',
                              ),
                            );
                    },
                  ),
                )
              : const SizedBox.shrink(),
          controller.bankHistory[index].adminFeedback != null && controller.bankHistory[index].adminFeedback!.isNotEmpty ? const SizedBox(height: Dimensions.space15) : const SizedBox.shrink(),
          controller.bankHistory[index].adminFeedback != null && controller.bankHistory[index].adminFeedback!.isNotEmpty
              ? CardColumn(
                  header: MyStrings.details.tr,
                  body: "${controller.bankHistory[index].adminFeedback}",
                  bodyMaxLine: 80,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
