import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/model/cash_out/cash_out_submit_response.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/will_pop_widget.dart';

class CashoutSuccessScreen extends StatefulWidget {
  const CashoutSuccessScreen({super.key});

  @override
  State<CashoutSuccessScreen> createState() => _CashoutSuccessScreenState();
}

class _CashoutSuccessScreenState extends State<CashoutSuccessScreen> {
  Cashout? cashout;
  bool isLoading = false;
  String currency = "";

  @override
  void initState() {
    MyUtils.allScreen();

    ResponseModel data = Get.arguments[0];
    Get.put(ApiClient(sharedPreferences: Get.find()));
    currency = Get.find<ApiClient>().getCurrencyOrUsername(isSymbol: true);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = true;
      });
      CashoutSubmitResponseModal modal = CashoutSubmitResponseModal.fromJson(jsonDecode(data.responseJson));
      if (modal.status == "success") {
        if (modal.data != null) {
          setState(() {
            cashout = modal.data!.cashout;
            isLoading = false;
          });
          String date = DateConverter.localNumberdateOnly(modal.data?.cashout?.createdAt.toString() ?? "");
          String time = DateConverter.localTimeOnly(modal.data?.cashout?.createdAt.toString() ?? "");
          AppDialog().successDialog(
            context,
            onTap: () {},
            title: MyStrings.cashOut.tr,
            cashDetails: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColor.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        IntrinsicHeight(
                          child: CashDetailsColumn(
                            needBorder: false,
                            firstTitle: MyStrings.time.tr,
                            secondTitle: MyStrings.referenceID.tr,
                            total: "$time $date",
                            newBalance: "#${cashout?.trx.toString() ?? ""}",
                            totalStyle: semiBoldDefault.copyWith(
                              fontWeight: FontWeight.w500,
                              color: MyColor.getTextColor(),
                            ),
                            newBalanceStyle: semiBoldDefault.copyWith(),
                            space: 10,
                          ),
                        ),
                        const CustomDivider(),
                        IntrinsicHeight(
                          child: CashDetailsColumn(
                            needBorder: false,
                            firstTitle: MyStrings.total.tr,
                            secondTitle: MyStrings.newBalance.tr,
                            total: "$currency${Converter.formatNumber(cashout?.amount.toString() ?? "")}",
                            newBalance: "$currency${Converter.formatNumber(cashout?.postBalance ?? "")}",
                            space: 10,
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      left: 45,
                      top: 45,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: cashout?.trx.toString() ?? "")).then((value) {
                              CustomSnackBar.success(successList: [MyStrings.successfullyCopied.tr]);
                            });
                          },
                          child: const CustomSvgPicture(image: MyIcon.copy),
                        ),
                      ),
                    )
                  ],
                )),
            userDetails: UserCard(
              title: cashout?.receiverUser?.username.toString() ?? "",
              subtitle: cashout?.receiverUser?.mobile.toString() ?? "",
              imgWidget: MyImageWidget(
                imageUrl: cashout?.receiverUser?.getImage ?? "",
                height: 45,
                width: 45,
                boxFit: BoxFit.contain,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    MyUtils.allScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.bottomNavBar,
      child: Scaffold(
          backgroundColor: MyColor.successBG,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CustomLoader(
                isFullScreen: true,
              ),
            ),
          )),
    );
  }
}
