import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/bank_transfer/bank_tranfer_controller.dart';
import 'package:viserpay/data/repo/bank_tansfer/bank_transfer_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/cash-card/title_card.dart';
import 'package:viserpay/view/components/column_widget/card_column.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/components/global/history_icon_widget.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/bank_card_shimmer.dart';
import 'package:viserpay/view/components/text-form-field/custom_text_field.dart';

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BankTransferRepo(apiClient: Get.find()));
    final controller = Get.put(BankTransferController(bankTransferRepo: Get.find()));
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
        title: MyStrings.bankTransfer,
        isTitleCenter: true,
        elevation: 0.3,
        action: [
          HistoryWidget(routeName: RouteHelper.bankTransferhistroyScreen),
          const SizedBox(
            width: Dimensions.space20,
          ),
        ],
      ),
      body: GetBuilder<BankTransferController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: Dimensions.defaultPaddingHV,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    needOutlineBorder: true,
                    labelText: MyStrings.bankName,
                    hintText: MyStrings.enterBankName,
                    onChanged: (p) {
                      if (!controller.isSearching) {
                        controller.filterData(p);
                      }
                    },
                    controller: controller.searchController,
                    focusNode: controller.searchFocusNode,
                    isShowSuffixIcon: true,
                    suffixWidget: const SizedBox(
                      width: 22,
                      height: 22,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_right_alt_sharp,
                          color: MyColor.colorBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.space20),
                  controller.isLoading
                      ? const SizedBox()
                      : TitleCard(
                          title: MyStrings.savedAccount.tr,
                          onlyBottom: true,
                          widget: controller.mySavedBankList.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: Text(
                                      MyStrings.nosavedAccountFound.tr,
                                      style: regularDefault.copyWith(color: MyColor.colorGrey),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: List.generate(controller.mySavedBankList.length, (i) {
                                    String maskingAccountNumber = MyUtils().maskSensitiveInformation(controller.mySavedBankList[i].accountNumber.toString());

                                    String img = controller.mySavedBankList[i].bank?.getImage ?? "";
                                    String title = "${controller.mySavedBankList[i].bank?.name?.toString() ?? ""}  (${controller.mySavedBankList[i].accountHolder ?? ""})";
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.only(top: 0, end: 8, start: 8, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () {
                                                controller.selectMyBank(controller.mySavedBankList[i]);
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  MyImageWidget(
                                                    imageUrl: img,
                                                    height: 40,
                                                    width: 40,
                                                    boxFit: BoxFit.contain,
                                                  ),
                                                  const SizedBox(width: Dimensions.space10),
                                                  Expanded(
                                                    child: CardColumn(
                                                      header: title,
                                                      maxLine: 1,
                                                      body: maskingAccountNumber,
                                                      headerTextStyle: heading,
                                                      bodyTextStyle: regularDefault,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: Dimensions.space10),
                                          controller.deletingBankIndex == i
                                              ? const SizedBox(
                                                  height: Dimensions.space20,
                                                  width: Dimensions.space20,
                                                  child: CircularProgressIndicator(
                                                    color: MyColor.primaryColor,
                                                    strokeWidth: 3,
                                                  ))
                                              : InkWell(
                                                  onTap: () {
                                                    AppDialog().warningAlertDialog(context, () {
                                                      controller.removeAddedBank(i, userBankID: controller.mySavedBankList[i].id.toString());
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.close_sharp,
                                                    size: 20,
                                                    color: MyColor.colorRed,
                                                  ),
                                                )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                        ),
                  const SizedBox(height: Dimensions.space25),
                  Text(MyStrings.allBank.tr, style: regularMediumLarge),
                  const SizedBox(height: Dimensions.space10),
                  controller.isLoading
                      ? SingleChildScrollView(
                          child: Column(
                            children: List.generate(4, (index) => const BankCardShimmer()),
                          ),
                        )
                      : controller.filteredBankList.isEmpty
                          ? const NoDataWidget(
                              margin: 14,
                              isAlignmentCenter: false,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.filteredBankList.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  splashColor: MyColor.primaryColor.withOpacity(0.1),
                                  onTap: () {
                                    /* controller.bankNameController.text = controller.filteredBankList[i].name ?? "";*/
                                    controller.selectBank(controller.filteredBankList[i]);
                                    controller.changeSelectedMethod();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.space8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: MyImageWidget(
                                            imageUrl: controller.filteredBankList[i].getImage ?? "",
                                            height: 55,
                                            // width: 80,
                                            boxFit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: Dimensions.space10,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            (controller.filteredBankList[i].name ?? '').tr,
                                            style: title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
