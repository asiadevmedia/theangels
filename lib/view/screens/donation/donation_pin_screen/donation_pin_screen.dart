import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/donation/donation_controller.dart';
import 'package:viserpay/data/repo/donation/donation_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/card/account_details_card.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/customPinText.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';

import '../../../components/image/my_image_widget.dart';

class DonationPinScreen extends StatefulWidget {
  const DonationPinScreen({super.key});

  @override
  State<DonationPinScreen> createState() => _DonationPinScreenState();
}

class _DonationPinScreenState extends State<DonationPinScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DonationRepo(apiClient: Get.find()));
    final controller = Get.put(DonationController(donationRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.selectedDonation == null) {
        Get.back();
      }
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
        title: MyStrings.donation,
        isTitleCenter: true,
        elevation: 0.1,
      ),
      body: GetBuilder<DonationController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleCard(
                  title: MyStrings.to.tr,
                  onlyBottom: true,
                  widget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: Dimensions.space8,
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: MyImageWidget(
                              imageUrl: controller.selectedDonation?.getImage ?? '',
                              height: 50,
                              width: 50,
                              boxFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: Dimensions.space8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.selectedDonation?.name.toString() ?? "",
                                style: title.copyWith(fontSize: 16),
                              ),
                              Text(
                                controller.selectedDonation?.address.toString() ?? "",
                                maxLines: 3,
                                style: regularDefault.copyWith(fontSize: 14, color: MyColor.greyText.withOpacity(0.6)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space16,
                ),
                AccountDetailsCard(
                  amount: controller.currency + controller.amountController.text,
                  charge: "0.00",
                  total: controller.currency + controller.amountController.text,
                ),
                const SizedBox(
                  height: Dimensions.space10,
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
                  needOutlineBorder: true,
                  onChanged: (val) {},
                  controller: controller.pinController,
                  focusNode: controller.pinFocusNode,
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
                    onTap: () {
                      String newBalance = Converter.minus(controller.currentBalance, controller.amountController.text);

                      if (controller.otpTypeList.isNotEmpty && controller.selectedOtpType == 'null') {
                        if (controller.selectedOtpType == 'null') {
                          CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp.tr]);
                        }
                      } else {
                        if (MyUtils().validatePinCode(controller.pinController.text)) {
                          submitData(context, controller, newBalance);
                        }
                      }
                    },
                    child: const SizedBox(
                      width: 22,
                      height: 22,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_right_alt_sharp,
                          color: MyColor.colorBlack,
                        ),
                      ),
                    ),
                  ),
                  onSubmit: () {
                    FocusScope.of(context).unfocus();

                    String newBalance = Converter.minus(controller.currentBalance, controller.amountController.text);

                    if (controller.otpTypeList.isNotEmpty && controller.selectedOtpType == 'null') {
                      if (controller.selectedOtpType == 'null') {
                        CustomSnackBar.error(errorList: [MyStrings.pleaseSelectOtp.tr]);
                      }
                    } else {
                      if (MyUtils().validatePinCode(controller.pinController.text)) {
                        submitData(context, controller, newBalance);
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

  void submitData(BuildContext context, DonationController controller, String newBalance) {
    AppDialog().confirmDialog(
      context,
      title: MyStrings.donate.tr,
      userDetails: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(controller.selectedDonation?.getImage ?? ''),
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6),
            ),
            height: 50,
            width: 60,
          ),
          const SizedBox(
            width: Dimensions.space8,
          ),
          Expanded(
            child: Text(
              controller.selectedDonation?.name.toString() ?? "",
              style: title.copyWith(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      cashDetails: CashDetailsColumn(
        total: controller.currency + controller.amountController.text,
        newBalance: controller.currency + newBalance,
        charge: '+${controller.currency}0.00',
        hideCharge: true,
      ),
      onfinish: () {},
      onwaiting: () {
        controller.submitDonation();
      },
    );
  }
}
