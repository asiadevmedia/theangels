// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/repo/recharge/recharge_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/card/account_details_card.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/rechange_image_widget.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';

class RechargePinScreen extends StatefulWidget {
  const RechargePinScreen({super.key});

  @override
  State<RechargePinScreen> createState() => _RechargePinScreenState();
}

class _RechargePinScreenState extends State<RechargePinScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RechargeRepo(apiClient: Get.find()));
    final controller = Get.put(RechargeContrller(rechargeRepo: Get.find(), contactController: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.pinController.clear();
      controller.changeInfoWidget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.mobileRecharge,
        isTitleCenter: true,
        elevation: 0.1,
      ),
      body: GetBuilder<RechargeContrller>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleCard(
                        title: MyStrings.for_.tr.toTitleCase().toString(),
                        onlyBottom: true,
                        widget: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: controller.selectedMethod == 1
                              ? UserCard(
                                  title: controller.selectedContact?.name ?? controller.numberController.text,
                                  subtitle: controller.selectedContact?.number.toString() ?? "",
                                  rightWidget: RechargeImageWidget(
                                    imageUrl: controller.selectedoperator?.getImage.toString() ?? "",
                                    height: 45,
                                    width: 60,
                                    boxFit: BoxFit.contain,
                                  ),
                                )
                              : UserCard(
                                  title: controller.numberController.text,
                                  subtitle: controller.numberController.text,
                                  rightWidget: RechargeImageWidget(
                                    imageUrl: controller.selectedoperator?.getImage.toString() ?? "",
                                    height: 45,
                                    width: 60,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.space16,
                      ),
                      AccountDetailsCard(
                        amount: controller.currency + controller.amountController.text,
                        charge: controller.currency + controller.charge,
                        total: controller.currency + controller.payableText,
                      ),
                      const SizedBox(
                        height: Dimensions.space20,
                      ),
                      controller.otpTypeList.isNotEmpty ? Text(MyStrings.selectOptType.tr, style: mediumDefault.copyWith()) : const SizedBox.shrink(),
                      controller.otpTypeList.isNotEmpty
                          ? SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  controller.otpTypeList.length,
                                  (index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: controller.selectedOtpType == controller.otpTypeList[index] ? true : false,
                                            onChanged: (p) {
                                              controller.selectotpType(controller.otpTypeList[index]);
                                            },
                                            shape: const CircleBorder(),
                                            activeColor: MyColor.primaryDark,
                                          ),
                                          Text(
                                            controller.otpTypeList[index].toUpperCase(),
                                            style: semiBoldDefault.copyWith(
                                              color: controller.selectedOtpType.toLowerCase() == controller.otpTypeList[index].toLowerCase() ? MyColor.colorBlack : MyColor.primaryDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      CustomPinField(
                        onChanged: (p) {
                          MyUtils.vibrate();
                        },
                        controller: controller.pinController,
                        needOutlineBorder: true,
                        labelText: "",
                        hintText: MyStrings.enterYourPIN.tr,
                        isShowSuffixIcon: true,
                        textInputType: TextInputType.number,
                        inputAction: TextInputAction.done,
                        prefixicon: const SizedBox(
                          width: 22,
                          height: 22,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.lock,
                              color: MyColor.primaryColor,
                            ),
                          ),
                        ),
                        suffixWidget: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            submitDialog(controller);
                          },
                          child: const SizedBox(
                            width: 22,
                            height: 22,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_right_alt_sharp,
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        onSubmit: () {
                          submitDialog(controller);
                        },
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  void submitDialog(RechargeContrller controller) {
    String newBalance = Converter.minus(controller.currentBalance, controller.payableText);

    if (controller.otpTypeList.isNotEmpty && controller.selectedOtpType == 'null') {
      CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp.tr]);
      return;
    }
    if (!MyUtils().validatePinCode(controller.pinController.text)) {
      return;
    }

    AppDialog().confirmDialog(
      context,
      title: MyStrings.recharge.tr,
      userDetails: UserCard(
        title: controller.selectedContact?.name ?? controller.numberController.text,
        subtitle: controller.selectedContact?.number.toString() ?? "",
        rightWidget: RechargeImageWidget(
          imageUrl: controller.selectedoperator?.getImage.toString() ?? "",
          height: 45,
          width: 60,
          boxFit: BoxFit.contain,
        ),
      ),
      cashDetails: CashDetailsColumn(
        total: controller.currency + controller.payableText,
        newBalance: controller.currency + newBalance,
        charge: MyUtils.getChargeText("${controller.currency}${controller.charge}"),
      ),
      onfinish: () {},
      onwaiting: () {
        controller.submitRechage();
      },
    );
  }
}
