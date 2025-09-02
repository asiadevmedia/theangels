import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/extensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/contact/contact_controller.dart';
import 'package:viserpay/data/controller/send_money/sendmoney_controller.dart';
import 'package:viserpay/data/repo/send_money/rend_money_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/components/global/history_icon_widget.dart';
import 'package:viserpay/view/components/permisson_widget/contact_request_widget.dart';
import 'package:viserpay/view/components/shimmer/contact_card_shimmer.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';
import 'package:viserpay/view/screens/sendmoney/send_mone_screen/widget/send_money_contact_list.dart';
import 'package:viserpay/view/screens/sendmoney/send_mone_screen/widget/send_money_recent_section.dart';

class SendmoneyScreen extends StatefulWidget {
  const SendmoneyScreen({super.key});

  @override
  State<SendmoneyScreen> createState() => _SendmoneyScreenState();
}

class _SendmoneyScreenState extends State<SendmoneyScreen> {
  bool showListView = false; // Flag to control whether to show the ListView
  bool isSearching = false;

  @override
  void initState() {
    MyUtils.allScreen();

    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SendMoneyRepo(apiClient: Get.find()));
    final controller = Get.put(SendMoneyContrller(
      sendMoneyRepo: Get.find(),
      contactController: Get.find(),
    ));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.numberFocusNode.unfocus();
      controller.numberController.text = '';
      controller.numberController.clear();
      controller.initialValue();
    });

    Timer(const Duration(seconds: 3), () {
      // Ensure that the widget is still mounted before updating the state
      if (mounted) {
        setState(() {
          // Set the flag to true to show the ListView
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
        title: MyStrings.sendMoney,
        isTitleCenter: true,
        elevation: 0.1,
        action: [
          HistoryWidget(routeName: RouteHelper.sendMoneyHistoryScreen),
          const SizedBox(
            width: Dimensions.space20,
          ),
        ],
      ),
      body: GetBuilder<SendMoneyContrller>(
        builder: (sendController) {
          final controller = Get.find<ContactController>();
          return sendController.isLoading
              ? const CustomLoader()
              : RefreshIndicator(
                  onRefresh: () async {
                    sendController.initialValue();
                  },
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      void filterContact(String query) {
                        setState(() {
                          isSearching = true;
                        });
                        if (query.isEmpty) {
                          controller.filterContact = controller.contacts;
                        } else {
                          setState(() {
                            controller.filterContact = controller.contacts.where((country) => country.displayName.toLowerCase().contains(query.toLowerCase())).toList();
                          });
                        }
                        setState(() {
                          isSearching = false;
                        });
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        child: Padding(
                          padding: Dimensions.defaultPaddingHV,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                needOutlineBorder: true,
                                labelText: MyStrings.to.tr,
                                onChanged: (val) {
                                  // sendController.numberValidation(val);
                                  if (!isSearching) {
                                    filterContact(val);
                                  }
                                },
                                inputAction: TextInputAction.go,
                                hintText: MyStrings.enterUserNameOrNumber.toSentenceCase(),
                                controller: sendController.numberController,
                                focusNode: sendController.numberFocusNode,
                                isShowSuffixIcon: true,
                                onSubmit: () {
                                  sendController.changeSelectedMethod();
                                  sendController.checkUserExist();
                                },
                                suffixWidget: GestureDetector(
                                  onTap: () {
                                    sendController.changeSelectedMethod();
                                    sendController.checkUserExist();
                                  },
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_right_alt_sharp,
                                        color: sendController.isValidNumber ? MyColor.primaryColor : MyColor.getGreyText(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.space2),
                              sendController.numberController.text.isNotEmpty
                                  ? Row(
                                      children: [
                                        const Icon(
                                          Icons.info,
                                          color: MyColor.primaryColor,
                                          size: 14,
                                        ),
                                        const SizedBox(width: Dimensions.space5),
                                        Text(
                                          MyStrings.pleaseEnterNumberWithCountrycode.tr,
                                          style: regularSmall.copyWith(color: MyColor.pendingColor),
                                        )
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: Dimensions.space20),
                              SendMoneyRecentSection(sendController: sendController),
                              const SizedBox(
                                height: Dimensions.space20,
                              ),
                              Text(
                                MyStrings.allContacts.tr,
                                style: boldDefault,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: Dimensions.space20,
                              ),
                              if (sendController.contactController.isPermissonGranted == false && sendController.contactController.isLoading == false) ...[
                                const ContactRequestWidget(),
                              ] else ...[
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
                                        : SendMoneyContactList(controller: controller, sendController: sendController)
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.colorWhite,
        onPressed: () async {
          await MyUtils().isCameraPemissonGranted().then((value) {
            if (value == PermissionStatus.granted) {
              Get.toNamed(RouteHelper.qrCodeScanner, arguments: [
                MyStrings.expectedUser,
                RouteHelper.sendMoneyAmountScreen,
              ]);
            } else {
              AppDialog().permissonQrCode();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.space12),
          child: Image.asset(
            MyImages.scan,
            color: MyColor.primaryColor,
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}
