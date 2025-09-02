// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/view/components/text/label_text.dart';

class CustomPinField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color fillColor;
  final bool isRequired;
  final Widget? prefixicon;
  final Widget? suffixWidget;
  final BoxConstraints? suffixIconConstraints;
  final bool? isDense;
  final bool? isPin;
  final VoidCallback? onSubmit;
  final double radius;
  final bool shadowBox;

  const CustomPinField({
    super.key,
    this.labelText,
    this.readOnly = false,
    this.fillColor = MyColor.transparentColor,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.needRequiredSign = false,
    this.maxLines = 1,
    this.animatedLabel = false,
    this.isRequired = false,
    this.prefixicon,
    this.suffixWidget,
    this.suffixIconConstraints,
    this.isDense,
    this.isPin = true,
    this.onSubmit,
    this.shadowBox = false,
    this.radius = Dimensions.defaultRadius,
  });

  @override
  State<CustomPinField> createState() => _CustomPinFieldState();
}

class _CustomPinFieldState extends State<CustomPinField> {
  bool obscureText = true;

// build the state
  @override
  Widget build(BuildContext context) {
    return widget.needOutlineBorder
        ? widget.animatedLabel
            ? widget.shadowBox == false
                ? TextFormField(
                    enableInteractiveSelection: false,
                    maxLines: widget.maxLines,
                    readOnly: widget.readOnly,
                    style: regularDefault.copyWith(color: MyColor.getTextColor()),
                    //textAlign: TextAlign.left,
                    cursorColor: MyColor.getTextColor(),
                    controller: widget.controller,
                    autofocus: false,
                    textInputAction: widget.inputAction,
                    enabled: widget.isEnable,
                    focusNode: widget.focusNode,
                    validator: widget.validator,
                    keyboardType: widget.textInputType,
                    obscureText: widget.isPin ?? false,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]'),
                      ),
                      FilteringTextInputFormatter.digitsOnly
                    ],

                    decoration: InputDecoration(
                        contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 15, end: 15, bottom: 5),
                        labelText: widget.labelText?.tr ?? '',
                        labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
                        fillColor: widget.fillColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()),
                          borderRadius: BorderRadius.circular(widget.radius),
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldEnableBorder()), borderRadius: BorderRadius.circular(widget.radius)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(widget.radius)),
                        suffixIconConstraints: widget.suffixIconConstraints,
                        suffixIcon: widget.suffixWidget),
                    onFieldSubmitted: (text) => widget.nextFocus != null
                        ? FocusScope.of(context).requestFocus(widget.nextFocus)
                        : widget.onSubmit != null
                            ? widget.onSubmit!()
                            : null,
                    onChanged: (text) => widget.onChanged!(text),
                  )
                : Stack(
                    children: [
                      Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: MyColor.getCardBgColor(),
                          borderRadius: BorderRadius.circular(widget.radius + 2),
                          boxShadow: MyUtils.getShadow2(blurRadius: 5),
                        ),
                      ),
                      TextFormField(
                        enableInteractiveSelection: false,
                        maxLines: widget.maxLines,
                        readOnly: widget.readOnly,
                        style: regularDefault.copyWith(color: MyColor.getTextColor()),
                        //textAlign: TextAlign.left,
                        cursorColor: MyColor.getTextColor(),
                        controller: widget.controller,
                        autofocus: false,
                        textInputAction: widget.inputAction,
                        enabled: widget.isEnable,
                        focusNode: widget.focusNode,
                        validator: widget.validator,
                        keyboardType: widget.textInputType,
                        obscureText: widget.isPin ?? false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]'),
                          ),
                          FilteringTextInputFormatter.digitsOnly
                        ],

                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 15, end: 15, bottom: 5),
                            labelText: widget.labelText?.tr ?? '',
                            labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
                            fillColor: widget.fillColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()),
                              borderRadius: BorderRadius.circular(widget.radius),
                            ),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldEnableBorder()), borderRadius: BorderRadius.circular(widget.radius)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(widget.radius)),
                            suffixIconConstraints: widget.suffixIconConstraints,
                            suffixIcon: widget.suffixWidget),
                        onFieldSubmitted: (text) => widget.nextFocus != null
                            ? FocusScope.of(context).requestFocus(widget.nextFocus)
                            : widget.onSubmit != null
                                ? widget.onSubmit!()
                                : null,
                        onChanged: (text) => widget.onChanged!(text),
                      )
                    ],
                  )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    text: widget.labelText.toString(),
                    isRequired: widget.isRequired,
                  ),
                  const SizedBox(height: Dimensions.textToTextSpace),
                  TextFormField(
                    enableInteractiveSelection: false,
                    maxLines: widget.maxLines,
                    readOnly: widget.readOnly,
                    style: boldMediumLarge.copyWith(color: MyColor.getTextColor()),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]'),
                      ),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    cursorColor: MyColor.getTextColor(),
                    controller: widget.controller,
                    autofocus: false,
                    textInputAction: widget.inputAction,
                    enabled: widget.isEnable,
                    focusNode: widget.focusNode,
                    validator: widget.validator,
                    keyboardType: widget.textInputType,
                    obscureText: widget.isPin ?? false,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 15, end: 15, bottom: 5),
                        hintText: widget.hintText != null ? widget.hintText!.tr : '',
                        hintStyle: regularLarge.copyWith(
                          color: MyColor.getHintTextColor().withOpacity(0.7),
                        ),
                        fillColor: MyColor.transparentColor,
                        filled: true,
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldEnableBorder()), borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                        prefixIcon: widget.prefixicon,
                        isDense: widget.isDense,
                        suffixIconConstraints: widget.suffixIconConstraints,
                        suffixIcon: widget.suffixWidget),
                    onFieldSubmitted: (text) => widget.nextFocus != null
                        ? FocusScope.of(context).requestFocus(widget.nextFocus)
                        : widget.onSubmit != null
                            ? widget.onSubmit!()
                            : null,
                    onChanged: (text) => widget.onChanged!(text),
                  )
                ],
              )
        : TextFormField(
            enableInteractiveSelection: false,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            style: regularDefault,
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
              LengthLimitingTextInputFormatter(4),
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9]'),
              ),
              FilteringTextInputFormatter.digitsOnly
            ],

            //textAlign: TextAlign.left,
            cursorColor: MyColor.getHintTextColor(),
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
                isDense: widget.isDense,
                contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 0, end: 0, bottom: 5),
                labelText: widget.labelText?.tr,
                labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
                fillColor: MyColor.transparentColor,
                filled: true,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()),
                ),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldEnableBorder())),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder())),
                suffixIcon: widget.suffixWidget),
            onFieldSubmitted: (text) => widget.nextFocus != null
                ? FocusScope.of(context).requestFocus(widget.nextFocus)
                : widget.onSubmit != null
                    ? widget.onSubmit!()
                    : null,
            onChanged: (text) => widget.onChanged!(text),
          );
  }
}
