import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/extensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/data/controller/qr_code/qr_code_controller.dart';
import 'package:viserpay/data/repo/qr_code/qr_code_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/custom_loader/custom_loader.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';

import '../../components/app-bar/custom_appbar.dart';

class MyQrCodeScreen extends StatefulWidget {
  const MyQrCodeScreen({super.key});

  @override
  State<MyQrCodeScreen> createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(QrCodeRepo(apiClient: Get.find()));
    final controller = Get.put(QrCodeController(qrCodeRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrCodeController>(
      builder: (controller) => Scaffold(
        appBar: CustomAppBar(
          title: MyStrings.myqrCode.toSentenceCase(),
          isShowBackBtn: true,
          isTitleCenter: true,
          action: const [
            SizedBox(width: 10),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader(loaderColor: MyColor.primaryColor)
            : Container(
                margin: const EdgeInsets.all(Dimensions.space20),
                decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: MyColor.transparentColor,
                          borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                        ),
                        child: MyImageWidget(
                          imageUrl: controller.qrCode,
                          width: context.isLandscape ? context.height : context.width,
                          height: context.isLandscape ? context.height : context.width,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: Dimensions.space30),
                      Text(
                        MyStrings.shareThisQrCode.tr,
                        style: regularDefault.copyWith(fontSize: Dimensions.fontMediumLarge, color: MyColor.getTextColor()),
                      ),
                      const SizedBox(height: Dimensions.space30),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.space10),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: MyColor.primaryColor, width: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.space10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      !controller.downloadLoading
                                          ? const Icon(
                                              Icons.download_for_offline,
                                              color: MyColor.primaryColor,
                                            )
                                          : const SizedBox.shrink(),
                                      const SizedBox(
                                        width: Dimensions.space3,
                                      ),
                                      Flexible(
                                        child: Text(
                                          controller.downloadLoading ? "${MyStrings.downloading.tr}..." : MyStrings.download.tr,
                                          overflow: TextOverflow.ellipsis,
                                          style: regularDefault.copyWith(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  if (!controller.downloadLoading) {
                                    controller.downloadImage();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.space12,
                            ),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: MyColor.primaryColor, width: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.space10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.ios_share_rounded,
                                        color: MyColor.primaryColor,
                                      ),
                                      const SizedBox(
                                        width: Dimensions.space3,
                                      ),
                                      Flexible(
                                        child: Text(
                                          MyStrings.share.tr,
                                          overflow: TextOverflow.ellipsis,
                                          style: regularDefault.copyWith(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  controller.shareImage();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.space15)
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
