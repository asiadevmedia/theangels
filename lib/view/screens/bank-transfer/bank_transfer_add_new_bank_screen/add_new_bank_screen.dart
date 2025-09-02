import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/bank_transfer/bank_tranfer_controller.dart';
import 'package:viserpay/data/model/global/formdata/global_keyc_formData.dart';
import 'package:viserpay/data/repo/bank_tansfer/bank_transfer_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/checkbox/custom_check_box.dart';
import 'package:viserpay/view/components/custom_drop_down_button_with_text_field.dart';
import 'package:viserpay/view/components/custom_radio_button.dart';
import 'package:viserpay/view/components/form_row.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';
import 'package:viserpay/view/screens/auth/kyc/widget/widget/choose_file_list_item.dart';

class AddNewBankScreen extends StatefulWidget {
  const AddNewBankScreen({super.key});

  @override
  State<AddNewBankScreen> createState() => _AddNewBankScreenState();
}

class _AddNewBankScreenState extends State<AddNewBankScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BankTransferRepo(apiClient: Get.find()));
    final controller = Get.put(BankTransferController(bankTransferRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.accountNameController.clear();
      controller.accountNumberController.clear();
      if (controller.selectedBank == null) {
        Get.back();
        CustomSnackBar.error(errorList: [MyStrings.selectAbank]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.addBankAccount.tr,
        isTitleCenter: true,
        elevation: 0.3,
      ),
      body: GetBuilder<BankTransferController>(builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: Dimensions.defaultPaddingHV,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleCard(
                  title: MyStrings.addNewBank,
                  onlyBottom: false,
                  widget: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImageWidget(
                          imageUrl: controller.selectedBank?.getImage.toString() ?? "",
                          height: 40,
                          width: 40,
                          boxFit: BoxFit.contain,
                        ),
                        const SizedBox(
                          width: Dimensions.space12,
                        ),
                        Expanded(
                          child: Text(
                            controller.bankNameController.text,
                            style: title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space16,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        isRequired: true,
                        needOutlineBorder: true,
                        labelText: MyStrings.accountHolderName,
                        // hintText: MyStrings.enterBankHolderName.toCapitalized().toString().tr,
                        controller: controller.accountNameController,
                        textInputType: TextInputType.text,
                        isShowSuffixIcon: true,
                        onChanged: (val) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyStrings.enteraccountHolderName.tr;
                          } else {
                            return null;
                          }
                        },
                        onSubmit: () {},
                      ),
                      const SizedBox(
                        height: Dimensions.space16,
                      ),
                      CustomTextField(
                        needOutlineBorder: true,
                        isRequired: true,
                        labelText: MyStrings.accountNumber,
                        // hintText: MyStrings.enteraccountNumber.toCapitalized().toString().tr,
                        controller: controller.accountNumberController,
                        focusNode: controller.bankNameFocusNode,
                        textInputType: TextInputType.text,
                        isShowSuffixIcon: true,
                        onChanged: (val) {},
                        onSubmit: () {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyStrings.enterYouraccountNumber.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: Dimensions.space16,
                      ),
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
                                            // hintText: (model.name ?? '').toString().capitalizeFirst,
                                            needOutlineBorder: true,
                                            labelText: (model.name ?? '').tr,
                                            validator: (value) {
                                              if (model.isRequired != 'optional ' && value.toString().isEmpty) {
                                                return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {
                                              controller.changeSelectedValue(value, index);
                                            },
                                          ),
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
                                                labelText: (model.name ?? '').tr,
                                                // hintText: (model.name ?? '').tr,
                                                validator: (value) {
                                                  if (model.isRequired != 'optional ' && value.toString().isEmpty) {
                                                    return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onChanged: (value) {
                                                  controller.changeSelectedValue(value, index);
                                                },
                                              ),
                                              const SizedBox(height: Dimensions.space10),
                                            ],
                                          )
                                        : model.type == 'select'
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  FormRow(
                                                    label: (model.name ?? '').tr,
                                                    isRequired: model.isRequired == 'optional' ? false : true,
                                                  ),
                                                  const SizedBox(
                                                    height: Dimensions.textToTextSpace,
                                                  ),
                                                  model.options == null
                                                      ? const SizedBox.shrink()
                                                      : CustomDropDownWithTextField(
                                                          list: model.options,
                                                          onChanged: (value) {
                                                            controller.changeSelectedValue(value, index);
                                                          },
                                                          selectedValue: model.selectedValue == '' ? model.options?.first.toString() : model.selectedValue,
                                                        ),
                                                  const SizedBox(height: Dimensions.space10)
                                                ],
                                              )
                                            : model.type == 'radio'
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      FormRow(
                                                        label: (model.name ?? '').tr,
                                                        isRequired: model.isRequired == 'optional' ? false : true,
                                                      ),
                                                      CustomRadioButton(
                                                        title: (model.name ?? '').tr,
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
                                                                  borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                                  onTap: () {
                                                                    controller.pickFile(index);
                                                                  },
                                                                  child: ChooseFileItem(fileName: model.selectedValue ?? MyStrings.chooseFile),
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
                          showLoadingIcon: controller.submitLoading,
                          press: () {
                            if (formKey.currentState!.validate()) {
                              controller.addNewBank();
                            }
                            // else {
                            //   CustomSnackBar.error(errorList: controller.hasError());
                            // }
                          },
                          text: MyStrings.addAccount.tr,
                        ),
                      ),
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
