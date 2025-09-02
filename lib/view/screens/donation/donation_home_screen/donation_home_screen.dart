import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/donation/donation_controller.dart';
import 'package:viserpay/data/repo/donation/donation_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/action_button_icon_widget.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/global/history_icon_widget.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';
import 'package:viserpay/view/components/no_data.dart';

class DonationHomeScreen extends StatefulWidget {
  const DonationHomeScreen({super.key});

  @override
  State<DonationHomeScreen> createState() => _DonationHomeScreenState();
}

class _DonationHomeScreenState extends State<DonationHomeScreen> {
  bool isSearching = false;
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DonationRepo(apiClient: Get.find()));
    final controller = Get.put(DonationController(donationRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DonationController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColor.colorWhite,
        appBar: isSearching
            ? PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 60),
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0, 2.0),
                        blurRadius: 4.0,
                      )
                    ],
                  ),
                  child: AppBar(
                    elevation: 0,
                    titleSpacing: 0,
                    backgroundColor: MyColor.colorWhite,
                    automaticallyImplyLeading: false,
                    surfaceTintColor: MyColor.transparentColor,
                    title: Row(
                      children: [
                        const SizedBox(
                          width: Dimensions.space40,
                        ),
                        Expanded(
                          child: AnimatedOpacity(
                            opacity: isSearching ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: TextField(
                              controller: controller.searchController,
                              focusNode: controller.searchFocusNode,
                              onChanged: (val) {
                                controller.filterData(val);
                              },
                              decoration: InputDecoration(
                                hintText: MyStrings.donationSearchHintText.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(
                                    color: MyColor.primaryColor.withOpacity(0.1),
                                    width: .5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(
                                    color: MyColor.primaryColor.withOpacity(0.7),
                                    width: .5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                focusColor: MyColor.colorBlack,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              style: regularDefault.copyWith(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: Dimensions.space10,
                        ),
                      ],
                    ),
                    actions: [
                      ActionButtonIconWidget(
                        pressed: () {
                          setState(() {
                            controller.searchController.text = "";
                            isSearching = false;
                            controller.searchFocusNode.unfocus();
                            controller.filterData("");
                          });
                        },
                        icon: Icons.clear,
                        backgroundColor: MyColor.primaryColor.withOpacity(0.1),
                        iconColor: MyColor.primaryColor,
                      ),
                      const SizedBox(
                        width: Dimensions.space10,
                      ),
                    ],
                  ),
                ),
              )
            : CustomAppBar(
                title: MyStrings.donation.tr,
                isTitleCenter: true,
                elevation: 0.3,
                action: [
                  ActionButtonIconWidget(
                    pressed: () {
                      setState(() {
                        isSearching = true;
                        controller.searchFocusNode.requestFocus();
                      });
                    },
                    icon: Icons.search,
                    backgroundColor: MyColor.primaryColor.withOpacity(0.1),
                    iconColor: MyColor.primaryColor,
                  ),
                  HistoryWidget(routeName: RouteHelper.donationHistoryScreen),
                  const SizedBox(
                    width: Dimensions.space20,
                  ),
                ],
              ),
        body: controller.isLoading
            ? const CustomLoader()
            : controller.tempOrganizations.isEmpty
                ? const NoDataWidget(
                    margin: 4,
                    // margin: controller.searchFocusNode.hasFocus ? 6 : 4,
                    isAlignmentCenter: false,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.tempOrganizations.length,
                    itemBuilder: (context, i) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.space8),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.space8),
                        child: Material(
                          type: MaterialType.canvas,
                          color: MyColor.getCardBgColor(),
                          borderRadius: BorderRadius.circular(Dimensions.space10),
                          child: InkWell(
                            splashColor: MyColor.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Dimensions.space10),
                            onTap: () {
                              controller.selectDonation(controller.tempOrganizations[i]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColor.getCardBgColor(),
                                borderRadius: BorderRadius.circular(Dimensions.space10),
                                boxShadow: MyUtils.getShadow2(blurRadius: 14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.space16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: Dimensions.space10,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: MyImageWidget(
                                        imageUrl: controller.tempOrganizations[i].getImage ?? '',
                                        height: 50,
                                        width: 50,
                                        boxFit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.space10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          controller.tempOrganizations[i].name.toString().tr,
                                          maxLines: 3,
                                          style: title.copyWith(fontSize: 16),
                                        ),
                                        Text(
                                          controller.tempOrganizations[i].address.toString().tr,
                                          maxLines: 3,
                                          style: regularDefault.copyWith(fontSize: 14, color: MyColor.greyText.withOpacity(0.6)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      );
    });
  }
}
