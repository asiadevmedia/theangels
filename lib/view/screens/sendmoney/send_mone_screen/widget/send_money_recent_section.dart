// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/send_money/sendmoney_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';

class SendMoneyRecentSection extends StatelessWidget {
  SendMoneyContrller sendController;
  SendMoneyRecentSection({super.key, required this.sendController});

  @override
  Widget build(BuildContext context) {
    return sendController.numberController.text.isNotEmpty
        ? const SizedBox.shrink()
        : sendController.sendMoneyHistory.isNotEmpty
            ? TitleCard(
                title: MyStrings.recent.tr,
                widget: Column(
                  children: List.generate(
                    sendController.sendMoneyHistory.length > 3 ? 3 : sendController.sendMoneyHistory.length,
                    (i) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        sendController.selectContact(
                          UserContactModel(
                            name: sendController.sendMoneyHistory[i].receiverUser!.username.toString(),
                            number: sendController.sendMoneyHistory[i].receiverUser!.mobile.toString(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: Dimensions.space12,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: UserCard(
                          title: sendController.sendMoneyHistory[i].receiverUser!.username.toString(),
                          subtitle: sendController.sendMoneyHistory[i].receiverUser!.mobile.toString(),
                          imgWidget: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColor.primaryColor.withOpacity(0.2),
                            ),
                            child: const CustomSvgPicture(image: MyIcon.user),
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
            : const SizedBox.shrink();
  }
}
