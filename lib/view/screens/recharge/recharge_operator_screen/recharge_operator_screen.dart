import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/repo/recharge/recharge_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/image/rechange_image_widget.dart';

class ReachargeOparatorScreen extends StatefulWidget {
  const ReachargeOparatorScreen({super.key});

  @override
  State<ReachargeOparatorScreen> createState() => _ReachargeOparatorScreenState();
}

class _ReachargeOparatorScreenState extends State<ReachargeOparatorScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RechargeRepo(apiClient: Get.find()));
    final controller = Get.put(RechargeContrller(rechargeRepo: Get.find(), contactController: Get.find()));
    //
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.clearOperator();
      if (controller.selectedContact == null) {
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(isWhite: true),
      appBar: CustomAppBar(
        title: MyStrings.mobileRecharge,
        isTitleCenter: true,
        elevation: 0.1,
      ),
      body: GetBuilder<RechargeContrller>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: Dimensions.defaultPaddingHV,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: Dimensions.space25,
                  ),
                  const Center(
                    child: CustomSvgPicture(
                      image: MyIcon.operator,
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: Dimensions.space16,
                  ),
                  Text(MyStrings.mobileOperator.tr, style: boldLarge.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: Dimensions.space5,
                  ),
                  Text(
                    MyStrings.selectNetwork.tr,
                    style: regularDefault.copyWith(color: MyColor.greyText),
                  ),
                  const SizedBox(
                    height: Dimensions.space25,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.operators.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.selectOperator(controller.operators[index]);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16, vertical: Dimensions.space10),
                          margin: const EdgeInsets.all(Dimensions.space10),
                          decoration: BoxDecoration(
                            color: controller.selectedoperator?.id == controller.operators[index].id ? MyColor.primaryColor.withOpacity(0.1) : MyColor.colorWhite,
                            border: Border.all(
                              color: MyColor.borderColor,
                              width: .7,
                            ),
                            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                          ),
                          child: RechargeImageWidget(
                            height: 40,
                            radius: 0,
                            imageUrl: controller.operators[index].getImage.toString(),
                            boxFit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
