import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/add_money/add_money_method_controller.dart';
import 'package:viserpay/data/model/add_money/add_money_method_response_model.dart';
import 'package:viserpay/data/repo/add_money/add_money_method_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:viserpay/view/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/card/bottom_sheet_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/text-form-field/custom_amount_text_field.dart';
import 'package:viserpay/view/components/text/label_text.dart';
import 'package:viserpay/view/screens/add-money/add_money/widget/add_money_info_widget.dart';
import 'package:viserpay/view/screens/transaction/widget/filter_row_widget.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  @override
  void initState() {
    MyUtils.allScreen();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(AddMoneyMethodRepo(apiClient: Get.find()));
    final controller = Get.put(AddMoneyMethodController(addMoneyMethodRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    MyUtils.allScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddMoneyMethodController>(
        builder: (controller) => Scaffold(
              backgroundColor: MyColor.getScreenBgColor(isWhite: true),
              appBar: CustomAppBar(
                title: MyStrings.addMoney,
                isTitleCenter: true,
                action: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.addMoneyHistoryScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColor.primaryColor.withOpacity(.1),
                      ),
                      child: const CustomSvgPicture(
                        image: MyIcon.history,
                        height: 15,
                        width: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Dimensions.space20,
                  ),
                ],
              ),
              body: controller.isLoading
                  ? const CustomLoader()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: Dimensions.screenPaddingHV,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.space20),
                          const LabelText(
                            text: MyStrings.selectGateway,
                            isRequired: true,
                          ),
                          const SizedBox(height: Dimensions.textToTextSpace),
                          FilterRowWidget(
                            borderColor: controller.selectedPaymentMethods.id.toString() == "-1" ? MyColor.textFieldDisableBorderColor : MyColor.textFieldEnableBorderColor,
                            text: controller.selectedPaymentMethods.id.toString() == "-1" ? MyStrings.selectGateway : controller.selectedPaymentMethods.name?.tr.toString() ?? "",
                            fromTrx: false,
                            press: () {
                              FocusScope.of(context).unfocus();
                              CustomBottomSheet(
                                  child: Column(
                                children: [
                                  const BottomSheetBar(),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [BottomSheetCloseButton()],
                                  ),
                                  const SizedBox(height: Dimensions.space15),
                                  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: controller.paymentMethodsList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            final controller = Get.find<AddMoneyMethodController>();
                                            PaymentMethods selectedValue = controller.paymentMethodsList[index];
                                            controller.selectPaymentMethod(selectedValue);
                                            Navigator.pop(context);

                                            FocusScopeNode currentFocus = FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                          },
                                          child: BottomSheetCard(
                                            child: Text(
                                              controller.paymentMethodsList[index].name?.tr.toString() ?? "",
                                              style: regularDefault,
                                            ),
                                          ),
                                        );
                                      })
                                ],
                              )).customBottomSheet(context);
                            },
                          ),
                          const SizedBox(height: Dimensions.space20),
                          CustomAmountTextField(
                            isRequired: true,
                            labelText: MyStrings.amount.tr,
                            hintText: MyStrings.amountHint.tr,
                            currency: controller.currency,
                            controller: controller.amountController,
                            onChanged: (value) {
                              if (value.toString().isEmpty) {
                                controller.changeInfoWidgetValue(0);
                              } else {
                                double amount = double.tryParse(value.toString()) ?? 0;
                                controller.changeInfoWidgetValue(amount);
                              }
                            },
                          ),
                          const SizedBox(height: Dimensions.space5),
                          controller.selectedPaymentMethods.id == -1
                              ? const SizedBox.shrink()
                              : Text(
                                  "${MyStrings.depositLimit.tr}: ${controller.minLimit} - ${controller.maxLimit} ${controller.currency}",
                                  style: regularExtraSmall.copyWith(color: MyColor.getPrimaryColor(), fontWeight: FontWeight.w400),
                                ),
                          const SizedBox(height: Dimensions.space20),
                          controller.mainAmount > 0 ? const AddMoneyInfoWidget() : const SizedBox(),
                          const SizedBox(height: Dimensions.space30),
                          GradientRoundedButton(
                            showLoadingIcon: controller.submitLoading,
                            press: () {
                              controller.submitData();
                            },
                            text: MyStrings.proceed,
                          )
                        ],
                      ),
                    ),
            ));
  }
}
