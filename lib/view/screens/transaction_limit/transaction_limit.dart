import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/transaction_limit/transaction_limit_controller.dart';
import 'package:viserpay/data/repo/transaction-limit/transaction_limit_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/transaction_limit_shimmer.dart';
import 'package:viserpay/view/screens/transaction_limit/widget/daily_limit_list.dart';
import 'package:viserpay/view/screens/transaction_limit/widget/monthly_limit_list.dart';

class TransactionLimit extends StatefulWidget {
  const TransactionLimit({super.key});

  @override
  State<TransactionLimit> createState() => _TransactionLimitState();
}

class _TransactionLimitState extends State<TransactionLimit> {
  int currentPage = 0;
  @override
  void initState() {
    currentPage = 0;
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TransactionLimitRepo(apiClient: Get.find()));
    final controller = Get.put(TransactionLimitController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(title: MyStrings.transactionLimit, isTitleCenter: true),
      body: GetBuilder<TransactionLimitController>(builder: (controller) {
        return SingleChildScrollView(
          padding: Dimensions.screenPaddingHV1,
          physics: const BouncingScrollPhysics(),
          child: controller.isLoading
              ? Column(
                  children: List.generate(10, (index) => const TransactionLimitShimmer()),
                )
              : controller.transactionChargeList.isEmpty
                  ? const NoDataWidget()
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  currentPage = 0;
                                  setState(() {});
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: currentPage == 0
                                        ? const BorderDirectional(
                                            bottom: BorderSide(color: MyColor.primaryColor, width: 2),
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      MyStrings.daily.tr,
                                      style: heading,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  currentPage = 1;
                                  setState(() {});
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: currentPage == 1
                                        ? const BorderDirectional(
                                            bottom: BorderSide(color: MyColor.primaryColor, width: 2),
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      MyStrings.monthly.tr,
                                      style: heading,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        currentPage == 0 ? const DailyLimitList() : const MonthlyLimitList()
                      ],
                    ),
        );
      }),
    );
  }
}
