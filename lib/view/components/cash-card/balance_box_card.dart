// ignore_for_file: invalid_use_of_protected_member, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class BalanceBoxCard extends StatefulWidget {
  TextEditingController textEditingController;
  FocusNode focusNode;
  VoidCallback onpress;

  BalanceBoxCard({super.key, required this.textEditingController, required this.focusNode, required this.onpress});

  @override
  State<BalanceBoxCard> createState() => _BalanceBoxCardState();
}

class _BalanceBoxCardState extends State<BalanceBoxCard> {
  String balance = "0.0";
  String currency = "";
  @override
  void initState() {
    final apiclient = Get.put(ApiClient(sharedPreferences: Get.find()));

    currency = apiclient.getCurrencyOrUsername(isSymbol: true);
    balance = apiclient.getBalance();

    super.initState();

    widget.textEditingController.clear();
    widget.focusNode.unfocus();

    widget.textEditingController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.space50, horizontal: Dimensions.space16),
      decoration: BoxDecoration(color: MyColor.primaryColor.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(shape: BoxShape.rectangle),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currency,
                        style: heading.copyWith(
                          fontSize: Dimensions.fontBalance,
                          color: widget.textEditingController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                        ),
                      ),
                      IntrinsicWidth(
                        child: TextFormField(
                          onChanged: (val) {},
                          expands: false,
                          controller: widget.textEditingController,
                          scrollPadding: EdgeInsets.zero,
                          inputFormatters: [LengthLimitingTextInputFormatter(8)],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.focusNode.hasFocus ? "0" : "0.00",
                            hintStyle: heading.copyWith(
                              fontSize: Dimensions.fontBalance,
                              color: widget.textEditingController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                            ),
                          ),
                          style: heading.copyWith(
                            fontSize: Dimensions.fontBalance,
                            color: widget.textEditingController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          selectionHeightStyle: BoxHeightStyle.includeLineSpacingTop,
                          keyboardType: TextInputType.number,
                          focusNode: widget.focusNode,
                          cursorColor: Colors.grey.shade400,
                          // textAlign: Directionality.of(context) == TextAlign.left ? TextAlign.left : TextAlign.right,
                          // cursorRadius: Radius.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    // height: Dimensions.space5,
                    ),
                RichText(
                  text: TextSpan(
                    text: "${MyStrings.availableBalance.tr}: ",
                    children: [
                      TextSpan(text: "$currency${Converter.formatNumber(balance)} ", style: regularDefault),
                    ],
                    style: boldDefault,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: widget.onpress,
                child: const CustomSvgPicture(
                  image: MyIcon.arrowRight,
                  color: MyColor.colorBlack,
                  fit: BoxFit.fitWidth,
                  height: 26,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
