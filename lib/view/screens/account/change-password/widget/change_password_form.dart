import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/account/change_password_controller.dart';
import 'package:viserpay/view/components/buttons/gradient_rounded_button.dart';

import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      builder: (controller) => Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              animatedLabel: true,
              needOutlineBorder: true,
              labelText: MyStrings.currentPin.tr,
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              textInputType: TextInputType.phone,
              onChanged: (value) {
                return;
              },
              validator: (value) {
                if (value.toString().isEmpty) {
                  return MyStrings.enterCurrentPass.tr;
                } else {
                  return null;
                }
              },
              controller: controller.currentPassController,
              isShowSuffixIcon: true,
              isPassword: true,
            ),
            const SizedBox(height: Dimensions.space20),
            CustomTextField(
              animatedLabel: true,
              needOutlineBorder: true,
              labelText: MyStrings.newPin.tr,
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              textInputType: TextInputType.phone,
              onChanged: (value) {
                return;
              },
              validator: (value) {
                if (value.toString().isEmpty) {
                  return MyStrings.enterNewPass.tr;
                } else {
                  return null;
                }
              },
              controller: controller.passController,
              isShowSuffixIcon: true,
              isPassword: true,
            ),
            const SizedBox(height: Dimensions.space20),
            CustomTextField(
              animatedLabel: true,
              needOutlineBorder: true,
              labelText: MyStrings.confirmPin.tr.toTitleCase().toString(),
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              textInputType: TextInputType.phone,
              onChanged: (value) {
                return;
              },
              validator: (value) {
                if (controller.confirmPassController.text != controller.passController.text) {
                  return MyStrings.kMatchPassError.tr;
                } else {
                  return null;
                }
              },
              controller: controller.confirmPassController,
              isShowSuffixIcon: true,
              isPassword: true,
            ),
            const SizedBox(height: Dimensions.space25),
            GradientRoundedButton(
              showLoadingIcon: controller.submitLoading,
              text: MyStrings.submit,
              press: () {
                if (formKey.currentState!.validate()) {
                  controller.changePassword();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
