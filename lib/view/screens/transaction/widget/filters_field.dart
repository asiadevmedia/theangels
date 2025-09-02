// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/transaction/transaction_history_controller.dart';
import 'package:viserpay/view/screens/transaction/widget/bottom_sheet.dart';
import 'package:viserpay/view/screens/transaction/widget/filter_row_widget.dart';

class FiltersField extends StatefulWidget {
  const FiltersField({super.key});

  @override
  State<FiltersField> createState() => _FiltersFieldState();
}

class _FiltersFieldState extends State<FiltersField> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsetsDirectional.only(bottom: Dimensions.space15),
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
        decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.transactionType.tr, style: regularSmall.copyWith(color: MyColor.colorGrey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: Dimensions.space10),
                      SizedBox(
                        width: 150,
                        child: FilterRowWidget(
                          fromTrx: true,
                          text: controller.selectedTransactionType.isEmpty ? MyStrings.trxType : controller.selectedTransactionType,
                          press: () {
                            showTrxBottomSheet(controller.transactionTypeList, 1, context: context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: Dimensions.space10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.remark.tr, style: regularSmall.copyWith(color: MyColor.colorGrey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: Dimensions.space10),
                      SizedBox(
                        width: 150,
                        child: FilterRowWidget(
                          fromTrx: false,
                          text: controller.selectedTransactionType.isEmpty ? MyStrings.remark : Converter.replaceUnderscoreWithSpace(controller.selectedRemark),
                          press: () {
                            showRemarkBottomSheet(controller.remarkList, context: context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: Dimensions.space10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.historyFrom.tr, style: regularSmall.copyWith(color: MyColor.colorGrey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: Dimensions.space10),
                      SizedBox(
                        width: 150,
                        child: FilterRowWidget(
                          fromTrx: false,
                          text: controller.selectedHistoryFrom.isEmpty ? MyStrings.any : controller.selectedHistoryFrom,
                          press: () {
                            showTimeBottomSheet(controller.historyFormList, context: context);
                            print("press");
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.transactionNo.tr, style: regularSmall.copyWith(color: MyColor.colorGrey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: Dimensions.space5),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          cursorColor: MyColor.primaryColor,
                          style: regularSmall.copyWith(color: MyColor.colorBlack),
                          keyboardType: TextInputType.text,
                          controller: controller.trxController,
                          decoration: InputDecoration(
                              hintText: MyStrings.enterTransactionNo.tr,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              hintStyle: regularSmall.copyWith(color: MyColor.hintTextColor),
                              filled: true,
                              fillColor: MyColor.transparentColor,
                              border: const OutlineInputBorder(borderSide: BorderSide(color: MyColor.textFieldDisableBorderColor, width: 0.5)),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: MyColor.textFieldDisableBorderColor, width: 0.5)),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: MyColor.primaryColor, width: 0.5))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Dimensions.space10),
                InkWell(
                  onTap: () {
                    controller.filterData();
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: MyColor.primaryColor),
                    child: const Icon(Icons.search_outlined, color: MyColor.colorWhite, size: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
