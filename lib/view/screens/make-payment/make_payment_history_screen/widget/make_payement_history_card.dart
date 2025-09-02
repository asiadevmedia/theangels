// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/make_payment/make_payment_controller.dart';
import 'package:viserpay/data/model/make_payment/make_payment_response_modal.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';

class MakePaymentHistoryCard extends StatelessWidget {
  final int index;
  final VoidCallback press;
  LatestMakePaymentHistory transaction;
  String currencySym;
  MakePaymentHistoryCard({
    super.key,
    required this.index,
    required this.press,
    required this.transaction,
    required this.currencySym,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MakePaymentController>(builder: (controller) {
      return GestureDetector(
        onTap: press,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space10),
          decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      alignment: Alignment.center,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: transaction.trxType == "-" ? MyColor.colorRed.withOpacity(0.2) : MyColor.colorGreen.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: MyImageWidget(
                          imageUrl: transaction.receiverUser?.getImage.toString() ?? '',
                          radius: 50,
                          isProfile: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.space10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${transaction.remark}".replaceAll("_", " ").toTitleCase().tr,
                            style: regularDefault.copyWith(
                              color: MyColor.getTextColor(),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: Dimensions.space5),
                          SizedBox(
                            width: 150,
                            child: Text(
                              transaction.trx.toString(),
                              style: regularSmall.copyWith(color: MyColor.getTextColor().withOpacity(0.5)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: CardColumn(
                  header: "${transaction.trxType}$currencySym${Converter.formatNumber(transaction.amount.toString())}",
                  body: DateConverter.formatDateMonthYear(transaction.createdAt.toString()),
                  alignmentEnd: true,
                  headerTextStyle: boldDefault.copyWith(
                    fontSize: Dimensions.fontMediumLarge - 1,
                    fontWeight: FontWeight.w500,
                    color: transaction.trxType == "-" ? MyColor.colorRed : MyColor.colorGreen,
                  ),
                  bodyTextStyle: lightMediumLarge.copyWith(color: MyColor.getGreyText(), fontSize: Dimensions.fontDefault - 1),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
