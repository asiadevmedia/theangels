import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';

class RoundedButton extends StatelessWidget {
  final bool isColorChange;
  final String text;
  final VoidCallback press;
  final Color color;
  final Color? textColor;
  final double width;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final bool isOutlined;
  final Widget? child;

  const RoundedButton({
    super.key,
    this.isColorChange = false,
    this.width = 1,
    this.child,
    this.cornerRadius = 6,
    required this.text,
    required this.press,
    this.isOutlined = false,
    this.horizontalPadding = 35,
    this.verticalPadding = 18,
    this.color = MyColor.primaryColor,
    this.textColor = MyColor.colorWhite,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return child != null
        ? InkWell(
            onTap: press,
            splashColor: MyColor.getScreenBgColor(),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                width: size.width * width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(cornerRadius), color: isColorChange ? color : MyColor.getPrimaryButtonColor(), boxShadow: [BoxShadow(blurRadius: 6, color: MyColor.primaryColor.withOpacity(0.2))]),
                child: Center(child: Text(text.tr, style: TextStyle(color: isColorChange ? textColor : MyColor.getPrimaryButtonTextColor(), fontSize: Dimensions.fontLarge, fontWeight: FontWeight.w500)))),
          )
        : isOutlined
            ? Material(
                child: InkWell(
                  onTap: press,
                  splashColor: MyColor.getScreenBgColor(),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                      width: size.width * width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(cornerRadius),
                          border: Border.all(
                            color: MyColor.primaryColor,
                          )),
                      child: Center(child: Text(text.tr, style: TextStyle(color: isColorChange ? textColor : MyColor.getPrimaryButtonTextColor(), fontSize: Dimensions.fontLarge, fontWeight: FontWeight.w500)))),
                ),
              )
            : SizedBox(
                width: size.width * width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(cornerRadius),
                  child: ElevatedButton(
                    onPressed: press,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shadowColor: MyColor.transparentColor,
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                      textStyle: TextStyle(color: textColor, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.w500),
                    ),
                    child: Text(
                      text.tr,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
              );
  }
}
