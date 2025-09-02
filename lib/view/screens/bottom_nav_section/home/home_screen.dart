import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/contact/contact_controller.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';
import 'package:viserpay/data/controller/menu/my_menu_controller.dart';
import 'package:viserpay/data/repo/auth/general_setting_repo.dart';
import 'package:viserpay/data/repo/home/home_repo.dart';
import 'package:viserpay/data/repo/menu_repo/menu_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/banner_section.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/home_screen_appbar.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/kyc_warning_section.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/latest_transaction_section.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/main_item_section.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/widget/main_item_shimmer.dart';
import 'widget/suggested_merchant_section.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> bootomNavscaffoldKey;
  const HomeScreen({super.key, required this.bootomNavscaffoldKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(HomeRepo(apiClient: Get.find()));
    Get.put(MenuRepo(apiClient: Get.find()));
    Get.put(MyMenuController(menuRepo: Get.find(), repo: Get.find()));

    Get.put(ContactController());

    final controller = Get.put(HomeController(homeRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });

    MyUtils.allScreen();
  }

  @override
  void dispose() {
    MyUtils.allScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyColor.colorWhite,
        appBar: homeScreenAppBar(context, controller, widget.bootomNavscaffoldKey),
        body: RefreshIndicator(
          backgroundColor: MyColor.colorWhite,
          color: MyColor.primaryColor,
          onRefresh: () async {
            controller.initialData(fromRefresh: true);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.space15),
                const KYCWarningSection(),
                const SizedBox(height: Dimensions.space12),
                controller.isLoading ? const MainItemShimmerSections() : const MainItemSection(),
                const SizedBox(height: Dimensions.space25 - 1),
                const BannerSection(),
                const SizedBox(height: Dimensions.space10),
                const SuggestedMerchantSection(),
                const LatestTransactionSection()
              ],
            ),
          ),
        ),
      );
    });
  }
}
