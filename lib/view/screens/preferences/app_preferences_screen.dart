import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/messages.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/localization/localization_controller.dart';
import 'package:viserpay/data/model/global/response_model/response_model.dart';
import 'package:viserpay/data/repo/auth/general_setting_repo.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool isAutoupdate = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      appBar: CustomAppBar(
        title: MyStrings.appPreference,
        isTitleCenter: true,
        elevation: 0.01,
      ),
      body: isLoading
          ? const CustomLoader()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: Dimensions.defaultPaddingHV,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.toNamed(RouteHelper.languageScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            MyStrings.language.tr,
                            style: regularDefault.copyWith(fontSize: Dimensions.fontExtraLarge),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(RouteHelper.languageScreen);
                            },
                            child: const CustomSvgPicture(
                              image: MyIcon.arrowRightIos,
                              color: MyColor.colorBlack,
                            ),
                          ),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       Text(
                          //         Get.find<SharedPreferences>().getString(SharedPreferenceHelper.languageCode).toString().toUpperCase() == "null".toUpperCase() ? Environment.defaultLangCode.toUpperCase() : Get.find<SharedPreferences>().getString(SharedPreferenceHelper.languageCode).toString().toUpperCase(),
                          //         style: title.copyWith(fontSize: Dimensions.fontExtraLarge),
                          //       ),
                          //       const SizedBox(
                          //         width: Dimensions.space5,
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.space25,
                    ),
                    const SizedBox(
                      height: Dimensions.space25,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String languageCode = "en";
                        final repo = Get.put(GeneralSettingRepo(apiClient: Get.find()));
                        final localizationController = Get.put(LocalizationController(sharedPreferences: Get.find()));
                        ResponseModel response = await repo.getLanguage(languageCode);
                        if (response.statusCode == 200) {
                          try {
                            Map<String, Map<String, String>> language = {};
                            var resJson = jsonDecode(response.responseJson);
                            await repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.languageListKey, response.responseJson);

                            var value = resJson['data']['data']['file'].toString() == '[]' ? {} : jsonDecode(resJson['data']['data']['file']) as Map<String, dynamic>;
                            Map<String, String> json = {};
                            value.forEach((key, value) {
                              json[key] = value.toString();
                            });

                            language['en_${'US'}'] = json;

                            Get.clearTranslations();
                            Get.addTranslations(Messages(languages: language).keys);

                            Locale local = const Locale("en", 'US');
                            localizationController.setLanguage(local);
                          } catch (e) {
                            CustomSnackBar.error(errorList: [e.toString()]);
                          }
                        } else {
                          CustomSnackBar.error(errorList: [response.message]);
                        }
                        setState(() {
                          isLoading = false;
                          isAutoupdate = true;
                        });
                      },
                      child: Text(
                        MyStrings.resetPreference.tr,
                        style: semiBoldDefault.copyWith(fontSize: 16, color: const Color(0xFFE80F0F)),
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.space25,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
