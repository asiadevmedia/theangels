// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/contact/contact_controller.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class RechargeContactList extends StatelessWidget {
  ContactController controller;
  RechargeContrller rechargeController;
  RechargeContactList({super.key, required this.controller, required this.rechargeController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.filterContact.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (controller.filterContact[i].phones.isNotEmpty) {
              rechargeController.selectContact(
                UserContactModel(
                  name: controller.filterContact[i].displayName.toString(),
                  number: controller.filterContact[i].phones.first.number.toString(),
                ),
              );
            } else {
              CustomSnackBar.error(errorList: [MyStrings.selectAvailableNumberPlease]);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: Dimensions.space10,
            ),
            child: UserCard(
              title: controller.filterContact[i].displayName.toString(),
              subtitle: controller.filterContact[i].phones.isNotEmpty ? controller.filterContact[i].phones.first.number.toString() : "--",
              rightWidget: null,
              image: MyIcon.user,
              isAsset: true,
            ),
          ),
        );
      },
    );
  }
}
