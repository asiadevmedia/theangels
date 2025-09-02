import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:viserpay/core/utils/style.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';

class OTPFieldWidget extends StatelessWidget {
  const OTPFieldWidget({super.key, required this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
        length: 6,
        textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
        obscureText: false,
        obscuringCharacter: '*',
        blinkWhenObscuring: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderWidth: .5,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 38,
            fieldWidth: 38,
            fieldOuterPadding: const EdgeInsetsDirectional.only(start: 2),
            inactiveColor: MyColor.primaryColor.withOpacity(.3),
            inactiveFillColor: MyColor.getScreenBgColor(),
            activeFillColor: MyColor.getScreenBgColor(),
            activeColor: MyColor.getPrimaryColor(),
            selectedFillColor: MyColor.getScreenBgColor(),
            selectedColor: MyColor.getPrimaryColor()),
        cursorColor: MyColor.colorBlack,
        animationDuration: const Duration(milliseconds: 100),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        beforeTextPaste: (text) {
          return true;
        },
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
}
