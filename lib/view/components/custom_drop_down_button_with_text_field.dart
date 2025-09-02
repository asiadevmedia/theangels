// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:get/get.dart';

class CustomDropDownWithTextField extends StatefulWidget {
  String? title, selectedValue;
  final List<String>? list;
  final ValueChanged? onChanged;
  final double borderWidth;

  CustomDropDownWithTextField({
    super.key,
    this.title,
    this.selectedValue,
    this.list,
    this.onChanged,
    this.borderWidth = 1.0
  });

  @override
  State<CustomDropDownWithTextField> createState() => _CustomDropDownWithTextFieldState();
}

class _CustomDropDownWithTextFieldState extends State<CustomDropDownWithTextField> {
  @override
  void initState() {
    log(widget.list?.first.toString() ?? "");
    widget.selectedValue = widget.selectedValue;

    setState(() {
      // widget.selectedValue = widget.list?.first.toString();
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    widget.list?.removeWhere((element) => element.isEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
              color: MyColor.transparentColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.mediumRadius),
              ),
              border: Border.all(color: MyColor.textFieldDisableBorderColor,width: widget.borderWidth)),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 5, start: 15, end: 15, bottom: 5),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: Container(),
              hint: Text(
                widget.selectedValue?.tr ?? '',
                style: regularDefault.copyWith(color: MyColor.getTextColor()),
              ), // Not necessary for Option 1
              value: widget.selectedValue,
              dropdownColor: MyColor.colorWhite,
              onChanged: widget.onChanged,
              items: widget.list!.toList().map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.tr,
                    style: regularDefault.copyWith(color: MyColor.colorBlack),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
