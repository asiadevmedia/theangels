import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class HelpNsupportScreen extends StatelessWidget {
  const HelpNsupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.helpSupport.tr,
        isTitleCenter: true,
        elevation: 0.01,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: Dimensions.defaultPaddingHV,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.faqScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardColumn(
                      header: MyStrings.faqTitle.tr,
                      body: "",
                      isOnlyHeader: true,
                      headerTextStyle: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontMediumLarge - 1, fontWeight: FontWeight.w500),
                    ),
                    const CustomSvgPicture(
                      image: MyIcon.arrowRightIos,
                      color: MyColor.colorBlack,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Dimensions.space25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardColumn(
                    header: MyStrings.userGuideAndTutorials.tr,
                    body: "",
                    isOnlyHeader: true,
                    headerTextStyle: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontMediumLarge - 1, fontWeight: FontWeight.w500),
                  ),
                  const CustomSvgPicture(
                    image: MyIcon.arrowRightIos,
                    color: MyColor.colorBlack,
                  ),
                ],
              ),
              const SizedBox(
                height: Dimensions.space25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
