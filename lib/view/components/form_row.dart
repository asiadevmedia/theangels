import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';

class FormRow extends StatelessWidget {
  final String label;
  final bool isRequired;

  const FormRow({super.key, required this.label, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Text(label.toTitleCase().tr, style: regularDefault.copyWith(color: MyColor.getTextColor())), Text(isRequired ? ' *' : '', style: boldDefault.copyWith(color: Colors.red))],
    );
  }
}
