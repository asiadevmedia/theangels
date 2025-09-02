import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';

import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/transaction/transaction_history_controller.dart';
import 'package:viserpay/data/repo/transaction/transaction_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/action_button_icon_widget.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/transaction_card_shimmer.dart';
import 'package:viserpay/view/screens/transaction/widget/filters_field.dart';
import 'package:viserpay/view/screens/transaction/widget/transaction_card.dart';
import 'package:viserpay/view/screens/transaction/widget/transaction_history_bottom_sheet.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late String trxType;

  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<TransactionHistoryController>().hasNext()) {
        Get.find<TransactionHistoryController>().loadTransactionData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TransactionRepo(apiClient: Get.find()));
    final controller = Get.put(TransactionHistoryController(transactionRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      trxType = MyStrings.allType;
      controller.loadDefaultData(trxType);
      controller.isSearch = false;
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryController>(builder: (controller) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: MyColor.colorWhite, statusBarIconBrightness: Brightness.dark, systemNavigationBarColor: MyColor.screenBgColor, systemNavigationBarIconBrightness: Brightness.dark),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColor.colorWhite,
          appBar: CustomAppBar(
            title: MyStrings.transactionsHistory,
            isShowBackBtn: Get.previousRoute != RouteHelper.bottomNavBar || Get.arguments != null ? true : false,
            isTitleCenter: true,
            backButtonOnPress: () {
              Get.offAllNamed(RouteHelper.bottomNavBar);
            },
            action: [
              ActionButtonIconWidget(pressed: () => controller.changeSearchIcon(), icon: controller.isSearch ? Icons.clear : Icons.filter_alt_sharp, backgroundColor: MyColor.primaryColor.withOpacity(0.1), iconColor: MyColor.primaryColor),
              const SizedBox(width: 10),
            ],
          ),
          body: controller.isLoading
              ? SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.only(top: Dimensions.space20, start: Dimensions.space15, end: Dimensions.space15),
                  child: Column(children: List.generate(20, (index) => const TransactionCardShimmer())),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsetsDirectional.only(top: Dimensions.space20, start: Dimensions.space15, end: Dimensions.space15),
                    controller: scrollController,
                    child: Column(
                      children: [
                        Visibility(
                          visible: controller.isSearch,
                          child: const FiltersField(),
                        ),
                        controller.transactionList.isEmpty && controller.filterLoading == false
                            ? Center(
                                child: NoDataWidget(
                                noDataText: MyStrings.noTrnxHistory.tr,
                                margin: controller.isSearch ? 10 : 4,
                              ))
                            : controller.filterLoading
                                ? const CustomLoader()
                                : Expanded(
                                    flex: 0,
                                    child: ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: controller.transactionList.length + 1,
                                      separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                                      itemBuilder: (context, i) {
                                        if (controller.transactionList.length == i) {
                                          return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                                        }

                                        return TransactionCard(
                                          index: i,
                                          press: () => CustomBottomSheet(child: TransactionHistoryBottomSheet(index: i)).customBottomSheet(context),
                                          transaction: controller.transactionList[i],
                                        );
                                      },
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
