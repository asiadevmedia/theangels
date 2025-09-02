// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/send_money/sendmoney_controller.dart';
import 'package:viserpay/data/repo/send_money/rend_money_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/card/account_details_card.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';

import 'package:viserpay/view/components/dialog/app_dialog.dart';

class SendMoneyPinScreen extends StatefulWidget {
  const SendMoneyPinScreen({super.key});

  @override
  State<SendMoneyPinScreen> createState() => _SendMoneyPinScreenState();
}

class _SendMoneyPinScreenState extends State<SendMoneyPinScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SendMoneyRepo(apiClient: Get.find()));
    final controller = Get.put(SendMoneyContrller(
      sendMoneyRepo: Get.find(),
      contactController: Get.find(),
    ));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.pinController.clear();
      controller.changeInfoWidget();
    });
  }

  @override
  void dispose() {
    super.dispose();
    MyUtils.allScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.sendMoney,
        isTitleCenter: true,
        elevation: 0.1,
      ),
      body: GetBuilder<SendMoneyContrller>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleCard(
                        title: "${MyStrings.to.tr} ",
                        onlyBottom: true,
                        widget: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: UserCard(
                            title: controller.selectedContact?.name ?? controller.numberController.text,
                            subtitle: controller.selectedContact?.number.toString() ?? "",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.space16,
                      ),
                      AccountDetailsCard(
                        amount: controller.currencySym + controller.mainAmount.toString(),
                        charge: controller.currencySym + controller.charge,
                        total: controller.currencySym + controller.payableText.toString(),
                      ),
                      const SizedBox(
                        height: Dimensions.space20,
                      ),
                      controller.otpType.isNotEmpty ? Text(MyStrings.selectOptType.tr, style: mediumDefault.copyWith()) : const SizedBox.shrink(),
                      controller.otpType != null
                          ? SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  controller.otpType.length,
                                  (index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: controller.selectedOtpType == controller.otpType[index] ? true : false,
                                            onChanged: (p) {
                                              controller.selectotopType(controller.otpType[index]);
                                            },
                                            shape: const CircleBorder(),
                                            activeColor: MyColor.primaryDark,
                                          ),
                                          Text(
                                            controller.otpType[index].toUpperCase(),
                                            style: semiBoldDefault.copyWith(
                                              color: controller.selectedOtpType.toLowerCase() == controller.otpType[index].toLowerCase() ? MyColor.colorBlack : MyColor.primaryDark,
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
                        focusNode: controller.pinFocusNode,
                        needOutlineBorder: true,
                        labelText: "",
                        hintText: MyStrings.enterYourPIN,
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
                          onTap: () {
                            String newBalance = Converter.minus(controller.currentBalance, controller.payableText);
                            if (controller.otpType.isEmpty) {
                              if (controller.validatePinCode()) {
                                submitDialog(context, controller, newBalance);
                              }
                            } else {
                              if (controller.validatePinCode() == true) {
                                if (controller.selectedOtpType == 'null') {
                                  CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp.tr]);
                                } else {
                                  submitDialog(context, controller, newBalance);
                                }
                              }
                            }
                          },
                          child: const SizedBox(
                            width: 22,
                            height: 22,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.arrow_right_alt_sharp,
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        onSubmit: () {
                          String newBalance = Converter.minus(controller.currentBalance, controller.payableText);
                          if (controller.otpType.isEmpty) {
                            if (controller.validatePinCode()) {
                              submitDialog(context, controller, newBalance);
                            }
                          } else {
                            if (controller.validatePinCode() == true) {
                              if (controller.selectedOtpType == 'null') {
                                CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp.tr]);
                              } else {
                                submitDialog(context, controller, newBalance);
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  void submitDialog(BuildContext context, SendMoneyContrller controller, String newBalance) {
    AppDialog().confirmDialog(
      context,
      title: MyStrings.sendMoney.tr,
      userDetails: UserCard(
        title: controller.selectedContact?.name ?? controller.numberController.text,
        subtitle: controller.selectedContact?.number.toString() ?? "",
      ),
      cashDetails: CashDetailsColumn(
        total: controller.currencySym + controller.payableText,
        newBalance: controller.currencySym + newBalance,
        charge: MyUtils.getChargeText("${controller.currencySym}${controller.charge}"),
      ),
      onfinish: () {},
      onwaiting: () {
        controller.submitSendMoney();
      },
    );
  }
}
