import 'package:flutter/material.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';

class PendingCard extends StatelessWidget {
  const PendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.space20),
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: MyColor.borderColor,
          width: 0.6,
        ),
      ),
      child: const Column(
        children: [
          CashDetailsColumn(
            needBorder: false,
            total: "",
            newBalance: "",
          ),
           CustomDivider(),
          CashDetailsColumn(
            needBorder: false,
            total: "",
            newBalance: "",
          ),
        ],
      ),
    );
  }
}
