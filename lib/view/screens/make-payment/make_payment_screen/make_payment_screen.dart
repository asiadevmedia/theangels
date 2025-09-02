import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/make_payment/make_payment_controller.dart';
import 'package:viserpay/data/model/contact/user_contact_model.dart';
import 'package:viserpay/data/repo/money_discharge/make_payment/make_payment_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/components/global/history_icon_widget.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({super.key});

  @override
  State<MakePaymentScreen> createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MakePaymentRepo(apiClient: Get.find()));
    final controller = Get.put(MakePaymentController(makePaymentRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.makePayment.tr,
        isTitleCenter: true,
        elevation: 0.3,
        action: [
          HistoryWidget(routeName: RouteHelper.makePaymentHistoryScreen),
          const SizedBox(
            width: Dimensions.space20,
          ),
        ],
      ),
      body: GetBuilder<MakePaymentController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : StatefulBuilder(builder: (context, setState) {
                void filterContact(String q) {
                  setState((() {}));
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: Dimensions.defaultPaddingHV,
                    child: Column(
                      children: [
                        CustomTextField(
                          needOutlineBorder: true,
                          inputAction: TextInputAction.done,
                          focusColor: controller.isValidNumber ? MyColor.primaryColor : MyColor.getGreyText(),
                          onChanged: (val) {
                            filterContact(val);
                          },
                          labelText: MyStrings.merchantNumber.tr,
                          hintText: MyStrings.enterMerchantNumber.tr,
                          controller: controller.numberController,
                          focusNode: controller.numberFocusNode,
                          isShowSuffixIcon: true,
                          onSubmit: () {
                            controller.checkMarchantExist();
                          },
                          suffixWidget: GestureDetector(
                            onTap: () {
                              controller.checkMarchantExist();
                            },
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_right_alt_sharp,
                                  color: controller.isValidNumber ? MyColor.primaryColor : MyColor.getGreyText(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        controller.numberController.text.isNotEmpty
                            ? Row(
                                children: [
                                  const Icon(
                                    Icons.info,
                                    color: MyColor.primaryColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: Dimensions.space5),
                                  Flexible(
                                    child: Text(
                                      MyStrings.pleaseEnterNumberWithCountrycode.tr,
                                      style: regularSmall.copyWith(color: MyColor.pendingColor),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(
                          height: Dimensions.space16,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            await MyUtils().isCameraPemissonGranted().then((value) {
                              if (value == PermissionStatus.granted) {
                                Get.toNamed(RouteHelper.qrCodeScanner, arguments: [
                                  MyStrings.expectedMerchant,
                                  RouteHelper.makePaymentAmountScreen, // 0 for expectedUserType 1 for nextRoute
                                ]);
                              } else {
                                AppDialog().permissonQrCode();
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.space8),
                            decoration: BoxDecoration(border: Border.all(color: MyColor.primaryColor, width: 1.3), borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  MyImages.menuQrCode,
                                  height: 24,
                                  color: MyColor.primaryColor,
                                ),
                                const SizedBox(
                                  width: Dimensions.space10,
                                ),
                                Text(
                                  MyStrings.tapToScanQrCode.tr,
                                  style: regularDefault.copyWith(
                                    color: MyColor.primaryColor,
                                    fontSize: Dimensions.fontLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.space25,
                        ),
                        controller.makePaymentHistory.isNotEmpty
                            ? TitleCard(
                                title: MyStrings.recent.tr,
                                widget: Column(
                                  children: List.generate(
                                    controller.makePaymentHistory.length > 3 ? 3 : controller.makePaymentHistory.length,
                                    (i) => controller.makePaymentHistory[i].receiverUser != null
                                        ? GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              controller.selectContact(
                                                UserContactModel(name: controller.makePaymentHistory[i].receiverUser?.username ?? '', number: controller.makePaymentHistory[i].receiverUser?.mobile ?? ''),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: UserCard(
                                                title: controller.makePaymentHistory[i].receiverUser?.username ?? MyStrings.username.tr,
                                                subtitle: controller.makePaymentHistory[i].receiverUser?.mobile ?? MyStrings.mobileNumber.tr,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                );
              });
      }),
    );
  }
}
