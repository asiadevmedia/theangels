import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/transaction/transaction_history_controller.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:viserpay/view/components/card/bottom_sheet_card.dart';

showTrxBottomSheet(List<String>? list, int callFrom, {required BuildContext context}) {
  if (list != null && list.isNotEmpty) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          String header = '';
          if (callFrom == 1) {
            header = MyStrings.trxType;
          } else if (callFrom == 2) {
            header = MyStrings.remark;
          }
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 20, top: 8),
                margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height * 0.2),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, //MyColor.colorWhite,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.space2),
                    BottomSheetHeaderRow(
                      header: header,
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              String selectedValue = list[index];

                              final controller = Get.find<TransactionHistoryController>();
                              if (callFrom == 1) {
                                controller.setSelectedTransactionType(selectedValue);
                                controller.filterData();
                              } else if (callFrom == 2) {
                                controller.setSelectedRemark(selectedValue);
                                controller.filterData();
                              }
                              Navigator.pop(context);
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: BottomSheetCard(
                              child: Text(
                                '${callFrom == 2 ? Converter.replaceUnderscoreWithSpace(list[index].capitalizeFirst ?? '').tr : callFrom == 3 ? MyUtils.getOperationTitle(list[index]) : list[index].tr}',
                                style: regularDefault,
                              ),
                            ),
                          );
                        })
                  ],
                )),
          );
        });
  }
}

showRemarkBottomSheet(List<String>? list, {required BuildContext context}) {
  if (list != null && list.isNotEmpty) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          String header = '';
          header = MyStrings.remark;
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 20, top: 8),
                margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height * 0.2),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, //MyColor.colorWhite,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.space2),
                    BottomSheetHeaderRow(
                      header: header,
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              String selectedValue = list[index].toString();

                              final controller = Get.find<TransactionHistoryController>();

                              controller.setSelectedRemark(selectedValue);
                              controller.filterData();

                              Navigator.pop(context);
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: BottomSheetCard(
                              child: Text(
                                Converter.replaceUnderscoreWithSpace(list[index].capitalizeFirst ?? '').tr,
                                style: regularDefault,
                              ),
                            ),
                          );
                        })
                  ],
                )),
          );
        });
  }
}

showTimeBottomSheet(List<String>? list, {required BuildContext context}) {
  if (list != null && list.isNotEmpty) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          String header = '';
          header = MyStrings.historyFrom;
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 20, top: 8),
                margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height * 0.2),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, //MyColor.colorWhite,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.space2),
                    BottomSheetHeaderRow(
                      header: header,
                    ),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: list.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              String selectedValue = list[index].toString();

                              final controller = Get.find<TransactionHistoryController>();

                              controller.setSelectedHistoryFrom(selectedValue);
                              controller.filterData();

                              Navigator.pop(context);
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: BottomSheetCard(
                              child: Text(
                                Converter.replaceUnderscoreWithSpace(list[index].capitalizeFirst ?? '').tr,
                                style: regularDefault,
                              ),
                            ),
                          );
                        })
                  ],
                )),
          );
        });
  }
}
