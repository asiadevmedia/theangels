import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/payBill/paybill_controller.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/model/paybill/paybill_success_model.dart';
import 'package:viserpay/data/repo/paybill/pay_bill_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/card/cash_2colum.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/divider/custom_divider.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';
import 'package:viserpay/view/components/will_pop_widget.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/screens/pay-bill/widget/paybill_icon_widget.dart';

class PaybillSuccessScreen extends StatefulWidget {
  const PaybillSuccessScreen({super.key});

  @override
  State<PaybillSuccessScreen> createState() => _PaybillSuccessScreenState();
}

class _PaybillSuccessScreenState extends State<PaybillSuccessScreen> {
  PaybillSuccessResponseModel? paybillSuccessResponseModel;
  bool isLoading = true;

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PaybillRepo(apiClient: Get.find()));
    final controller = Get.put(PaybillController(paybillRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ResponseModel responseModel = Get.arguments[0];

      setState(() {
        isLoading = true;
      });

      PaybillSuccessResponseModel model = PaybillSuccessResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status == "success") {
        if (model.data != null) {
          setState(() {
            paybillSuccessResponseModel = model;
            isLoading = false;
          });
          String date = DateConverter.localNumberdateOnly(model.data?.transaction?.createdAt.toString() ?? "");
          String time = DateConverter.localTimeOnly(model.data?.transaction?.createdAt.toString() ?? "");

          AppDialog().pendingDialog(
            context,
            onTap: () {},
            title: MyStrings.billPaymentTitle.tr,
            subTitle: MyStrings.billPaymentSubTitle.tr,
            hideYour: true,
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
                            secondTitle: MyStrings.transactionId.tr,
                            total: "$time $date",
                            newBalance: "#${model.data?.transaction?.trx.toString() ?? ""}",
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
                            total: "${controller.curSymbol}${Converter.formatNumber(model.data?.transaction?.amount.toString() ?? "")}",
                            newBalance: "${controller.curSymbol}${Converter.formatNumber(model.data?.transaction?.postBalance ?? "")}",
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
                            Clipboard.setData(ClipboardData(text: paybillSuccessResponseModel?.data?.transaction?.trx.toString() ?? "")).then((value) {
                              CustomSnackBar.success(successList: [MyStrings.successfullyCopied.tr]);
                            });
                          },
                          child: const CustomSvgPicture(image: MyIcon.copy),
                        ),
                      ),
                    )
                  ],
                )),
            userDetails: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BillIcon(
                    imageUrl: "${paybillSuccessResponseModel?.data?.utility?.setupUtilityBill?.getImage.toString()}",
                    color: MyColor.getSymbolColor(0),
                    radius: 8,
                  ),
                  const SizedBox(
                    width: Dimensions.space10,
                  ),
                  Text(
                    paybillSuccessResponseModel?.data?.utility?.setupUtilityBill?.name.toString() ?? "",
                    style: title.copyWith(fontSize: 16),
                  )
                ],
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
    return GetBuilder<PaybillController>(builder: (controller) {
      return const WillPopWidget(
        nextRoute: RouteHelper.bottomNavBar,
        child: Scaffold(
          backgroundColor: MyColor.successBG,
          body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: CustomLoader(
                isFullScreen: true,
              )),
        ),
      );
    });
  }
}
