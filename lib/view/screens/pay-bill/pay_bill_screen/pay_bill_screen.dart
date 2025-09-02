import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/checkbox/custom_check_box.dart';
import 'package:viserpay/view/components/custom_drop_down_button_with_text_field.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/custom_radio_button.dart';
import 'package:viserpay/view/components/form_row.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';
import 'package:viserpay/view/screens/auth/kyc/widget/widget/choose_file_list_item.dart';
import 'package:viserpay/view/screens/pay-bill/widget/paybill_icon_widget.dart';

class PaybillScreen extends StatefulWidget {
  const PaybillScreen({super.key});

  @override
  State<PaybillScreen> createState() => _PaybillScreenState();
}

class _PaybillScreenState extends State<PaybillScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaybillRepo(apiClient: Get.find()));
    final controller = Get.put(PaybillController(paybillRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.selectedUtils == null) {
        Get.back();
        CustomSnackBar.error(errorList: [MyStrings.selectAUtility]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.appBarColor,
      appBar: CustomAppBar(
        title: MyStrings.paybill,
        isTitleCenter: true,
        elevation: 0.09,
      ),
      body: GetBuilder<PaybillController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: Dimensions.defaultPaddingHV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: Dimensions.space25,
                      ),
                      TitleCard(
                        title: MyStrings.to.tr,
                        onlyBottom: true,
                        widget: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.space12, horizontal: Dimensions.space12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BillIcon(
                                imageUrl: controller.selectedUtils?.getImage ?? "",
                                color: MyColor.getSymbolColor(0),
                                radius: 8,
                              ),
                              const SizedBox(
                                width: Dimensions.space15,
                              ),
                              Text(
                                controller.selectedUtils?.name?.tr.toString() ?? "",
                                style: title.copyWith(fontSize: 16),
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
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: controller.formList.length,
                                itemBuilder: (ctx, index) {
                                  GlobalFormModle? model = controller.formList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        model.type == 'text'
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextField(
                                                      isRequired: model.isRequired == 'optional' ? false : true,
                                                      needOutlineBorder: true,
                                                      labelText: (model.name ?? '').toString().tr,
                                                      validator: (value) {
                                                        if (model.isRequired != 'optional ' && value.toString().isEmpty) {
                                                          return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      onChanged: (value) {
                                                        controller.changeSelectedValue(value, index);
                                                      }),
                                                  const SizedBox(height: Dimensions.space10),
                                                ],
                                              )
                                            : model.type == 'textarea'
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomTextField(
                                                          isRequired: model.isRequired == 'optional' ? false : true,
                                                          needOutlineBorder: true,
                                                          labelText: model.name.toString().tr,
                                                          // hintText: (model.name ?? '').capitalizeFirst,
                                                          validator: (value) {
                                                            if (model.isRequired != 'optional ' && value.toString().isEmpty) {
                                                              return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          onChanged: (value) {
                                                            controller.changeSelectedValue(value, index);
                                                          }),
                                                      const SizedBox(height: Dimensions.space10),
                                                    ],
                                                  )
                                                : model.type == 'select'
                                                    ? Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          FormRow(label: (model.name ?? '').tr, isRequired: model.isRequired == 'optional' ? false : true),
                                                          const SizedBox(
                                                            height: Dimensions.textToTextSpace,
                                                          ),
                                                          CustomDropDownWithTextField(
                                                            list: model.options ?? [],
                                                            onChanged: (value) {
                                                              controller.changeSelectedValue(value, index);
                                                            },
                                                            selectedValue: model.selectedValue,
                                                          ),
                                                          const SizedBox(height: Dimensions.space10)
                                                        ],
                                                      )
                                                    : model.type == 'radio'
                                                        ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              FormRow(label: (model.name ?? '').tr, isRequired: model.isRequired == 'optional' ? false : true),
                                                              CustomRadioButton(
                                                                title: model.name,
                                                                selectedIndex: controller.formList[index].options?.indexOf(model.selectedValue ?? '') ?? 0,
                                                                list: model.options ?? [],
                                                                onChanged: (selectedIndex) {
                                                                  controller.changeSelectedRadioBtnValue(index, selectedIndex);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        : model.type == 'checkbox'
                                                            ? Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  FormRow(label: (model.name ?? '').tr, isRequired: model.isRequired == 'optional' ? false : true),
                                                                  CustomCheckBox(
                                                                    selectedValue: controller.formList[index].cbSelected,
                                                                    list: model.options ?? [],
                                                                    onChanged: (value) {
                                                                      controller.changeSelectedCheckBoxValue(index, value);
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            : model.type == 'file'
                                                                ? Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      FormRow(label: (model.name ?? '').tr, isRequired: model.isRequired == 'optional' ? false : true),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                        child: InkWell(
                                                                          splashColor: MyColor.primaryColor.withOpacity(0.2),
                                                                          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                                          onTap: () {
                                                                            controller.pickFile(index);
                                                                          },
                                                                          child: ChooseFileItem(
                                                                            fileName: model.selectedValue ?? MyStrings.chooseFile.tr,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                        const SizedBox(height: Dimensions.space10),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: Dimensions.space25),
                              Center(
                                child: GradientRoundedButton(
                                  press: () {
                                    if (formKey.currentState!.validate() && controller.hasError().isEmpty) {
                                      Get.toNamed(RouteHelper.paybillAmountScreen);
                                    } else {
                                      CustomSnackBar.error(errorList: controller.hasError());
                                    }
                                  },
                                  text: MyStrings.continue_.tr,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
