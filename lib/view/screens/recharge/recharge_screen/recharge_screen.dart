import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/contact/contact_controller.dart';
import 'package:viserpay/data/controller/recharge/recharge_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/repo/recharge/recharge_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/global/history_icon_widget.dart';
import 'package:viserpay/view/components/permisson_widget/contact_request_widget.dart';
import 'package:viserpay/view/components/shimmer/contact_card_shimmer.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';
import 'package:viserpay/view/screens/recharge/recharge_screen/widget/recharge_contact_list.dart';
import 'package:viserpay/view/screens/recharge/recharge_screen/widget/recharge_recent.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  bool showListView = false; // Flag to control whether to show the ListView

  @override
  void initState() {
    MyUtils.allScreen();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RechargeRepo(apiClient: Get.find()));
    Get.put(ContactController());
    final controller = Get.put(RechargeContrller(rechargeRepo: Get.find(), contactController: Get.find()));
    //
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.selectedContact = null;
      controller.selectedMethod = -1;
      controller.numberController.clear();
      controller.initialValue();
      controller.numberFocusNode.unfocus();
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showListView = true;
        });
      }
    });
  }

  @override
  void dispose() {
    MyUtils.allScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.mobileRecharge.tr,
        isTitleCenter: true,
        elevation: 0.3,
        action: [
          HistoryWidget(routeName: RouteHelper.rechargeHistoryScreen),
          const SizedBox(
            width: Dimensions.space20,
          ),
        ],
      ),
      body: GetBuilder<RechargeContrller>(builder: (rechargeController) {
        final controller = Get.find<ContactController>();

        return RefreshIndicator(
          onRefresh: () async {
            rechargeController.initialValue();
          },
          child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Padding(
                padding: Dimensions.defaultPaddingHV,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      needOutlineBorder: true,
                      labelText: MyStrings.for_.tr.toString().toTitleCase(),
                      hintText: MyStrings.enterUserNameOrNumber.tr,
                      onChanged: (val) {
                        // rechargeController.numberValidation(val);
                        if (!controller.isSearching) {
                          controller.filterContacts(val);
                        }
                      },
                      inputAction: TextInputAction.done,
                      isShowSuffixIcon: true,
                      controller: rechargeController.numberController,
                      focusNode: rechargeController.numberFocusNode,
                      suffixWidget: GestureDetector(
                        onTap: () {
                          rechargeController.selectContact(UserContactModel(name: rechargeController.numberController.text, number: rechargeController.numberController.text));
                        },
                        child: const SizedBox(
                          width: 22,
                          height: 22,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_right_alt_sharp,
                              color: MyColor.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.space25),
                    RechargeRecentSection(rechargeController: rechargeController, controller: controller),
                    const SizedBox(
                      height: Dimensions.space25,
                    ),
                    Text(
                      MyStrings.allContacts.tr,
                      style: boldDefault,
                    ),
                    const SizedBox(
                      height: Dimensions.space20,
                    ),
                    if (rechargeController.contactController.isPermissonGranted == false && rechargeController.contactController.isLoading == false) ...[
                      const ContactRequestWidget(),
                    ] else
                      !showListView
                          ? SingleChildScrollView(
                              child: Column(
                                children: List.generate(10, (index) => const ContactCardShimmer()),
                              ),
                            )
                          : controller.filterContact.isEmpty && controller.isLoading == false
                              ? Container(
                                  margin: EdgeInsets.only(top: context.height / 6),
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      MyStrings.noContactFound.tr,
                                      style: regularDefault.copyWith(color: MyColor.colorGrey),
                                    ),
                                  ),
                                )
                              : RechargeContactList(controller: controller, rechargeController: rechargeController),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
