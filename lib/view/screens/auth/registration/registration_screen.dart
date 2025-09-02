// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/data/controller/auth/auth/registration_controller.dart';
import 'package:viserpay/data/repo/auth/general_setting_repo.dart';
import 'package:viserpay/data/repo/auth/signup_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/custom_no_data_found_class.dart';
import 'package:viserpay/view/components/will_pop_widget.dart';
import 'package:viserpay/view/screens/auth/registration/widget/registration_form.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late PageController pageController;
  @override
  void initState() {
    MyUtils.allScreen();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(RegistrationRepo(apiClient: Get.find()));
    final controller = Get.put(RegistrationController(registrationRepo: Get.find(), generalSettingRepo: Get.find()));
    super.initState();

    pageController = PageController(initialPage: 0, viewportFraction: 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initData();
      setState(() {
        MyUtils.allScreen();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: MyColor.primaryColor, statusBarIconBrightness: Brightness.light, systemNavigationBarColor: MyColor.screenBgColor, systemNavigationBarIconBrightness: Brightness.dark),
      child: GetBuilder<RegistrationController>(
        builder: (controller) {
          return WillPopWidget(
            nextRoute: RouteHelper.loginScreen,
            child: Scaffold(
              backgroundColor: MyColor.getScreenBgColor(isWhite: true),
              appBar: CustomAppBar(
                title: MyStrings.signUp,
                isShowBackBtn: true,
                fromAuth: true,
              ),
              body: controller.noInternet
                  ? NoDataOrInternetScreen(
                      isNoInternet: true,
                      onChanged: (value) {
                        controller.changeInternet(value);
                      },
                    )
                  : controller.isLoading
                      ? const CustomLoader()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.space30, horizontal: Dimensions.space20),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * .02),
                              Center(
                                child: Image.asset(
                                  MyImages.appColorLogo,
                                  height: 50,
                                  width: 225,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * .05),
                              const RegistrationForm(),
                              const SizedBox(height: Dimensions.space30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(MyStrings.alreadyAccount.tr, style: regularDefault.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500)),
                                  const SizedBox(width: Dimensions.space5),
                                  GestureDetector(
                                    onTap: () {
                                      controller.clearAllData();
                                      Get.offAndToNamed(RouteHelper.loginScreen);
                                    },
                                    child: Text(MyStrings.signIn.tr, style: regularDefault.copyWith(color: MyColor.getPrimaryColor(), decoration: TextDecoration.none)),
                                  )
                                ],
                              ),
                              const SizedBox(height: Dimensions.space35),
                            ],
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }
}
