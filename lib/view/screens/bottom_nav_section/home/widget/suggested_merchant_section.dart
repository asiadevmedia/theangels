import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';
import '../../../../../core/route/route.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/style.dart';
import '../../../../components/cash-card/title_card.dart';
import '../../../../components/image/my_image_widget.dart';
import '../../../../components/shimmer/roundedImage_text_shimmer.dart';

class SuggestedMerchantSection extends StatelessWidget {
  const SuggestedMerchantSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return controller.isLoading
          ? Container(
              margin: const EdgeInsets.only(top: Dimensions.space20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) => const RoundedWidgetTextShimmer()),
                ),
              ),
            )
          : controller.merchants.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TitleCard(
                    title: MyStrings.suggestedMerchant.tr, // note: view all showed when api connected
                    titleStyle: boldDefault.copyWith(
                      fontSize: Dimensions.fontLarge,
                    ),
                    widget: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsetsDirectional.only(bottom: Dimensions.space20),
                      child: Row(
                        children: List.generate(
                          controller.merchants.length,
                          (index) => GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                RouteHelper.makePaymentAmountScreen,
                                arguments: [controller.merchants[index].username, controller.merchants[index].mobile],
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: Dimensions.space10,
                                  ),
                                  MyImageWidget(
                                    imageUrl: controller.merchants[index].getImage ?? "",
                                    height: 60,
                                    boxFit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: Dimensions.space5,
                                  ),
                                  Text(
                                    controller.merchants[index].username?.toCapitalized() ?? MyStrings.merchant.tr,
                                    style: heading.copyWith(
                                      fontSize: Dimensions.fontLarge,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink();
    });
  }
}
