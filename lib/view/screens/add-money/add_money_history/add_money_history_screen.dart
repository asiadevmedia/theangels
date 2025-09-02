import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/add_money/add_money_history_controller.dart';
import 'package:viserpay/data/repo/add_money/add_money_history_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/screens/add-money/add_money_history/widget/add_money_history_card.dart';
import 'package:viserpay/view/screens/add-money/add_money_history/widget/add_money_history_filter_widget.dart';

class AddMoneyHistoryScreen extends StatefulWidget {
  const AddMoneyHistoryScreen({super.key});

  @override
  State<AddMoneyHistoryScreen> createState() => _AddMoneyHistoryScreenState();
}

class _AddMoneyHistoryScreenState extends State<AddMoneyHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<AddMoneyHistoryController>().hasNext()) {
        Get.find<AddMoneyHistoryController>().loadPaginationData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(AddMoneyHistoryRepo(apiClient: Get.find()));
    final controller = Get.put(AddMoneyHistoryController(addMoneyHistoryRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialSelectedValue();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: MyColor.colorWhite),
      child: GetBuilder<AddMoneyHistoryController>(
        builder: (controller) => Scaffold(
          backgroundColor: MyColor.screenBgColor,
          appBar: CustomAppBar(
            title: MyStrings.addMoneyHistory,
            isTitleCenter: true,
            isShowBackBtn: true,
            actionIcon: controller.isSearch ? Icons.clear : Icons.search,
            isActionImage: false,
            actionPress: () {
              controller.changeSearchStatus();
            },
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : Padding(
                  padding: const EdgeInsetsDirectional.only(top: Dimensions.space20, start: Dimensions.space15, end: Dimensions.space15),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: [
                        Visibility(
                          visible: controller.isSearch,
                          child: const AddMoneyHistoryFilterWidget(),
                        ),
                        controller.depositList.isEmpty && controller.filterLoading == false
                            ? Center(
                                child: NoDataWidget(noDataText: MyStrings.emptyAddMoneyTitle.tr),
                              )
                            : controller.filterLoading
                                ? const CustomLoader()
                                : Expanded(
                                    flex: 0,
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.depositList.length + 1,
                                        separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                                        itemBuilder: (context, index) {
                                          if (controller.depositList.length == index) {
                                            return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                                          }
                                          return AddMoneyHistoryCard(index: index);
                                        }),
                                  ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
