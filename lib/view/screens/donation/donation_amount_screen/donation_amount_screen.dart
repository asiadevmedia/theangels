import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/donation/donation_controller.dart';
import 'package:viserpay/data/repo/donation/donation_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';

class DonationAmountScreen extends StatefulWidget {
  const DonationAmountScreen({super.key});

  @override
  State<DonationAmountScreen> createState() => _DonationAmountScreenState();
}

class _DonationAmountScreenState extends State<DonationAmountScreen> {
  final formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.donation.tr,
        isTitleCenter: true,
        elevation: 0.3,
      ),
      body: GetBuilder<DonationController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              children: [
                const SizedBox(
                  height: Dimensions.space25,
                ),
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
                  height: Dimensions.space25,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: MyStrings.name,
                        isRequired: true,
                        needOutlineBorder: true,
                        animatedLabel: false,
                        onChanged: (val) {},
                        controller: controller.nameController,
                        focusNode: controller.nameFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyStrings.enterYourname.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: Dimensions.space30,
                      ),
                      CustomTextField(
                        labelText: MyStrings.email,
                        isRequired: true,
                        needOutlineBorder: true,
                        animatedLabel: false,
                        onChanged: (val) {},
                        controller: controller.emailController,
                        focusNode: controller.emailFocusNode,
                        inputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return MyStrings.enterYourEmail.tr;
                          } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
                            return MyStrings.invalidEmailMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: Dimensions.space10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Checkbox(
                              value: controller.hideIdentity,
                              onChanged: (val) => controller.changehideIdentity(val ?? false),
                              shape: const CircleBorder(),
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.space8,
                          ),
                          Text(
                            MyStrings.donotWantToDiscloseMyIdentity.tr,
                            style: regularDefault,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.space20,
                      ),
                      CustomTextField(
                        labelText: MyStrings.amount,
                        animatedLabel: false,
                        isRequired: true,
                        needOutlineBorder: true,
                        onChanged: (val) {},
                        controller: controller.amountController,
                        focusNode: controller.amountFocusNode,
                        textInputType: TextInputType.number,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyStrings.enteryourAmount.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: Dimensions.space20,
                      ),
                      CustomTextField(
                        labelText: MyStrings.reference,
                        animatedLabel: false,
                        isRequired: false,

                        needOutlineBorder: true,
                        onChanged: (val) {},
                        controller: controller.referanceController,
                        // focusNode: controller.amountFocusNode,
                        textInputType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        validator: (value) {
                          return;
                        },
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      GradientRoundedButton(
                        text: MyStrings.donate.tr,
                        press: () {
                          if (formKey.currentState!.validate()) {
                            double currntBalance = NumberFormat.decimalPattern().parse(controller.currentBalance).toDouble();

                            if (controller.amountController.text.trim().isNotEmpty) {
                              if (controller.amountController.text.trim().isNotEmpty) {
                                if (MyUtils().balanceValidation(currentBalance: currntBalance, amount: double.tryParse(controller.amountController.text) ?? 0)) {
                                  Get.toNamed(RouteHelper.donationPinScreen);
                                }
                              } else {
                                CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                              }
                            } else {
                              CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
