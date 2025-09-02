import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/date_converter.dart';
import 'package:viserpay/core/helper/string_format_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/donation/donation_controller.dart';
import 'package:viserpay/data/repo/donation/donation_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:viserpay/view/components/cash-card/user/user_card.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/no_data.dart';
import 'package:viserpay/view/components/shimmer/paybill_history_card_shimmer.dart';
import 'package:viserpay/view/screens/donation/donation_history_screen/widget/donation_history_bottom_sheet.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  //   final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<DonationController>().hasNext()) {
        Get.find<DonationController>().getDonationHistoryPaginateData();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DonationRepo(apiClient: Get.find()));
    final controller = Get.put(DonationController(donationRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.currentPage = 0;
      controller.currency = Get.find<ApiClient>().getCurrencyOrUsername(isSymbol: true);
      controller.getDonationHistory();
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
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(isWhite: true),
      appBar: CustomAppBar(
        title: MyStrings.donationHistory,
        isTitleCenter: true,
        elevation: 0.01,
        backButtonOnPress: () {
          if (Get.previousRoute == RouteHelper.donationSuccessScreen) {
            Get.offAllNamed(RouteHelper.bottomNavBar);
          } else {
            Get.back();
          }
        },
      ),
      body: GetBuilder<DonationController>(builder: (controller) {
        return controller.isLoading
            ? SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Column(
                  children: List.generate(
                      15,
                      (index) => PaybillHistoryCardShimmer(
                            isPdfShow: true,
                          )),
                ),
              )
            : controller.donationHistory.isEmpty
                ? const NoDataWidget(
                    margin: 6,
                    isAlignmentCenter: true,
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: Dimensions.space12),
                    itemCount: controller.donationHistory.length + 1,
                    itemBuilder: (context, index) {
                      if (controller.donationHistory.length == index) {
                        return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                      }
                      String amount = Converter.formatNumber(controller.donationHistory[index].amount.toString());
                      String date = DateConverter.isoStringToLocalDateOnly(controller.donationHistory[index].createdAt.toString());
                      return GestureDetector(
                        onTap: () {
                          CustomBottomSheet(child: DonationHistoryBottomSheet(index: index)).customBottomSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.space12, horizontal: Dimensions.space12),
                          child: UserCard(
                            title: controller.donationHistory[index].donationFor?.name.toString() ?? "",
                            subtitle: "${controller.currency}$amount ${MyStrings.donated.tr}",
                            subtitleStyle: lightDefault.copyWith(fontSize: 12, color: MyColor.bodytextColor),
                            maxLine: 2,
                            imgWidget: MyImageWidget(
                              imageUrl: controller.donationHistory[index].donationFor?.getImage.toString() ?? "",
                              height: 40,
                              width: 40,
                            ),
                            rightWidget: Text(
                              date,
                              style: regularDefault.copyWith(color: MyColor.getTextColor(), fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      );
                    },
                  );
      }),
    );
  }
}
