import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/view/screens/edit_profile/widget/profile_image.dart';

import '../../../../../core/route/route.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_icon.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/style.dart';
import '../../../../../core/utils/util.dart';
import '../../../../../data/controller/home/home_controller.dart';
import '../../../../components/image/custom_svg_picture.dart';
import '../../../../components/image/my_image_widget.dart';

PreferredSize homeScreenAppBar(BuildContext context, HomeController controller, GlobalKey<ScaffoldState> bottomNavScaffoldKey) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width, 80),
    child: Container(
      padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MyColor.colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 2.0),
            blurRadius: 4.0,
          )
        ],
      ),
      child: AppBar(
        scrolledUnderElevation: 0,
        systemOverlayStyle: MyUtils.systemUiOverlayStyle,
        automaticallyImplyLeading: false,
        backgroundColor: MyColor.appBarColor,
        elevation: 0,
        surfaceTintColor: MyColor.transparentColor,
        title: IntrinsicWidth(
          child: Row(
            children: [
              if (controller.isLoading)
                Shimmer.fromColors(
                  baseColor: MyColor.colorGrey.withOpacity(0.2),
                  highlightColor: MyColor.primaryColor.withOpacity(0.7),
                  child: Container(
                    decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                    height: 40,
                    width: 40,
                  ),
                )
              else
                GestureDetector(
                  onTap: () => Get.toNamed(RouteHelper.profileScreen),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: MyColor.borderColor, width: 0.5), shape: BoxShape.circle),
                    height: 40,
                    width: 40,
                    child: ClipOval(
                      child: controller.userimage == "null" || controller.userimage == ""
                          ? ProfileWidget(imagePath: "", onClicked: () {})
                          : MyImageWidget(
                              imageUrl: controller.userimage,
                              boxFit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              const SizedBox(
                width: Dimensions.space10,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space2 + 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.isLoading)
                        Shimmer.fromColors(
                          baseColor: MyColor.colorGrey.withOpacity(0.2),
                          highlightColor: MyColor.primaryColor.withOpacity(0.7),
                          child: Container(
                            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                            width: Dimensions.space60 + 100,
                            height: Dimensions.fontMediumLarge,
                          ),
                        )
                      else
                        Text(
                          // controller.fullName.length > 20 ? "${controller.fullName.substring(0, 20)}..." : controller.fullName.toUpperCase(),
                          controller.fullName.toUpperCase(),
                          style: heading.copyWith(
                            fontSize: Dimensions.fontMediumLarge,
                            fontWeight: FontWeight.w600,
                            color: MyColor.getTextColor(),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      const SizedBox(
                        height: Dimensions.space5,
                      ),
                      if (controller.isLoading)
                        Shimmer.fromColors(
                          baseColor: MyColor.colorGrey.withOpacity(0.2),
                          highlightColor: MyColor.primaryColor.withOpacity(0.7),
                          child: Container(
                            decoration: BoxDecoration(color: MyColor.colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                            width: Dimensions.space60 + 50,
                            height: Dimensions.fontMediumLarge,
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///Button
                            Material(
                              type: MaterialType.canvas,
                              color: MyColor.borderColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                              child: InkWell(
                                splashColor: MyColor.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  controller.changeState();
                                },
                                child: Obx(
                                  () => Container(
                                    width: 170,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      // color: MyColor.transparentColor,
                                      color: MyColor.primaryColor.withOpacity(0.02),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedOpacity(
                                          opacity: controller.isBalanceShown.value ? 1 : 0,
                                          duration: const Duration(milliseconds: 500),
                                          child: Text(
                                            Converter.formatNumber(controller.userBalance),
                                            style: const TextStyle(color: MyColor.primaryColor, fontSize: Dimensions.fontLarge),
                                          ),
                                        ),

                                        /// tapForBalance
                                        AnimatedPositioned(
                                          duration: const Duration(milliseconds: 300),
                                          left: controller.isAnimation.value == false ? 22 : 12,
                                          child: AnimatedOpacity(
                                            opacity: controller.isBalance.value ? 1 : 0,
                                            duration: const Duration(milliseconds: 300),
                                            child: FittedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 4.0),
                                                child: Text(
                                                  MyStrings.tapForBalance.tr,
                                                  style: TextStyle(color: MyColor.primaryColor.withOpacity(0.8), fontSize: Dimensions.fontLarge),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        /// Circle
                                        AnimatedPositioned(
                                          duration: const Duration(milliseconds: 1100),
                                          left: controller.isAnimation.value == false ? 2 : 145,
                                          curve: Curves.fastOutSlowIn,
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(color: MyColor.primaryColor.withOpacity(0.8), borderRadius: BorderRadius.circular(50)),
                                            child: FittedBox(
                                              child: Text(
                                                controller.defaultCurrencySymbol,
                                                style: const TextStyle(color: Colors.white, fontSize: Dimensions.fontMediumLarge),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          const SizedBox(
            width: Dimensions.space16,
          ),
          GestureDetector(
            onTap: () {
              bottomNavScaffoldKey.currentState!.openEndDrawer();
            },
            child: const CustomSvgPicture(
              image: MyIcon.menutop,
              color: MyColor.colorBlack,
              height: 24,
            ),
          ),
          const SizedBox(
            width: Dimensions.space16,
          ),
        ],
      ),
    ),
  );
}
