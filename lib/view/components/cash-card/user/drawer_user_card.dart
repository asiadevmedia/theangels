import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/image/custom_network_image.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class DrawerUserCard extends StatelessWidget {
  final String? username, fullname, subtitle;
  final String? image;
  final bool isAsset;
  final  bool noAvatar;
  final TextStyle? titleStyle, subtitleStyle;
  final Widget? rightWidget;
  final Widget? imgWidget;
  final double? imgHeight;
  final double? imgwidth;
  const DrawerUserCard({
    super.key,
    this.username,
    this.fullname,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.image = MyIcon.user,
    this.isAsset = true,
    this.noAvatar = false,
    this.rightWidget,
    this.imgHeight,
    this.imgwidth,
    this.imgWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                imgWidget == null
                    ? !noAvatar
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColor.primaryColor.withOpacity(0.2),
                            ),
                            child: const CustomSvgPicture(image: MyIcon.user),
                          )
                        : CustomNetworkImage(
                            image: image.toString(),
                            size: imgHeight ?? 40,
                          )
                    : imgWidget!,
                const SizedBox(
                  width: Dimensions.space16,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "$fullname".toCapitalized().tr,
                          style: titleStyle ??
                              heading.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontLarge + 3,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.space3,
                      ),
                      Text(
                        "@$username".tr,
                        style: titleStyle ??
                            regularDefault.copyWith(
                              fontSize: Dimensions.fontSmall,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: Dimensions.space5,
                      ),
                      Text(
                        subtitle?.tr ?? "",
                        style: subtitleStyle ?? regularDefault.copyWith(fontSize: Dimensions.fontSmall, color: MyColor.greyText.withOpacity(0.8)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          rightWidget ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
