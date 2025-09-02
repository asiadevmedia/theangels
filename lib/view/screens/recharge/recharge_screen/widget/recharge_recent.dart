// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/contact/contact_controller.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/model/recharge/recharge_data_response_modal.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/image/rechange_image_widget.dart';

class RechargeRecentSection extends StatelessWidget {
  RechargeContrller rechargeController;
  ContactController controller;
  RechargeRecentSection({
    super.key,
    required this.rechargeController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return rechargeController.numberController.text.isNotEmpty
        ? const SizedBox.shrink()
        : rechargeController.rechargeHistory.isNotEmpty
            ? TitleCard(
                title: MyStrings.recent.tr,
                widget: Column(
                  children: List.generate(
                    rechargeController.rechargeHistory.length > 3 ? 3 : rechargeController.rechargeHistory.length,
                    (i) {
                      String userName = controller.getUserName(rechargeController.rechargeHistory[i].mobile.toString());

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          rechargeController.selectRecentRecharge(
                              contact: UserContactModel(
                                name: userName,
                                number: rechargeController.rechargeHistory[i].mobile.toString(),
                              ),
                              operator: MobileOperator(id: rechargeController.rechargeHistory[i].mobileOperator?.id ?? -1, getImage: rechargeController.rechargeHistory[i].mobileOperator?.getImage.toString() ?? ""));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.space10,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: UserCard(
                            image: MyIcon.user,
                            isAsset: true,
                            title: userName,
                            subtitle: rechargeController.rechargeHistory[i].mobile.toString(),
                            rightWidget: RechargeImageWidget(
                              imageUrl: rechargeController.rechargeHistory[i].mobileOperator?.getImage.toString() ?? "",
                              height: 45,
                              width: 50,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const SizedBox.shrink();
  }
}
