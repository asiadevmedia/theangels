import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/core/utils/my_images.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/view/components/buttons/rounded_button.dart';

import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/components/swipe-button/swipe_animated_button.dart';
import 'package:viserpay/view/components/will_pop_widget.dart';

class AppDialog {
  confirmDialog(BuildContext context, {required Function onfinish, required Function onwaiting, required String title, required Widget userDetails, required Widget cashDetails}) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.zero,
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(builder: (context, constraint) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.only(end: Dimensions.space5, start: Dimensions.space5, top: Dimensions.space30, bottom: Dimensions.space20),
                  margin: const EdgeInsets.all(Dimensions.space16),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: MyColor.borderColor,
                      width: 0.6,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight / 2),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                              height: Dimensions.space20,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: title.tr,
                                        style: heading.copyWith(
                                          color: MyColor.primaryColor,
                                        ))
                                  ],
                                  text: "${MyStrings.confirmTo.tr} ",
                                  style: regularExtraLarge,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.space30,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16),
                              child: userDetails,
                            ),
                            const SizedBox(
                              height: Dimensions.space20,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: Dimensions.space20, end: Dimensions.space20),
                              child: cashDetails,
                            ),
                            const SizedBox(
                              height: Dimensions.space25,
                            ),
                            Directionality(textDirection: TextDirection.ltr, child: SwipeAnimatedButton(onFinish: onfinish, onWaiting: onwaiting))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: MyColor.colorRed,
                      size: 30,
                    ),
                  ),
                )
              ],
            );
          }),
        );
      },
    );
  }

  successDialog(
    BuildContext context, {
    String? text,
    required Function onTap,
    required String title,
    required Widget userDetails,
    required Widget cashDetails,
    bool willPop = true,
  }) {
    return showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        barrierColor: MyColor.transparentColor,
        builder: (_) {
          return WillPopWidget(
            nextRoute: RouteHelper.bottomNavBar,
            child: Dialog(
              surfaceTintColor: MyColor.transparentColor,
              insetPadding: EdgeInsets.zero,
              backgroundColor: MyColor.transparentColor,
              elevation: 0,
              child: LayoutBuilder(builder: (context, constraint) {
                return Container(
                  // height: MediaQuery.of(context).size.height / 1.4,
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16, top: Dimensions.space30, bottom: Dimensions.space20),
                  margin: const EdgeInsets.all(Dimensions.space10),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: MyColor.borderColor,
                      width: 0.6,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight / 2),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${MyStrings.your.tr} ${title.tr}",
                                      style: regularMediumLarge.copyWith(
                                          // fontSize: Dimensions.fontExtraLarge+1,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: Dimensions.space2,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: " ${text ?? MyStrings.is_.tr} ",
                                        children: [
                                          TextSpan(
                                            text: MyStrings.successfully.tr,
                                            style: regularMediumLarge.copyWith(fontSize: 20, color: MyColor.colorGreen),
                                          )
                                        ],
                                        style: boldDefault.copyWith(
                                          fontSize: Dimensions.fontExtraLarge + 1,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const CustomSvgPicture(
                                    image: MyIcon.successCircle,
                                    color: MyColor.colorGreen,
                                    height: 40,
                                    width: 40,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.space30,
                            ),
                            userDetails,
                            const SizedBox(
                              height: Dimensions.space40,
                            ),
                            cashDetails,
                            const SizedBox(
                              height: Dimensions.space30,
                            ),
                            const Spacer(),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.offAndToNamed(RouteHelper.bottomNavBar);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                                  decoration: const BoxDecoration(
                                    color: MyColor.primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 7),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(29, 111, 251, 0.20),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF2176FF), Color(0xFF0A55EB)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        MyStrings.backToHome.tr,
                                        style: regularDefault.copyWith(
                                          color: MyColor.colorWhite,
                                          fontSize: Dimensions.fontMediumLarge - 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: Dimensions.space10),
                                      const CustomSvgPicture(
                                        image: MyIcon.arrowRight,
                                        color: MyColor.colorWhite,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        });
  }

  pendingDialog(
    BuildContext context, {
    required Function onTap,
    required String title,
    required String subTitle,
    required Widget userDetails,
    required Widget cashDetails,
    bool? hideYour = false,
  }) {
    return showDialog(
        context: context,
        useSafeArea: true,
        barrierDismissible: false,
        barrierColor: MyColor.transparentColor,
        builder: (_) {
          return WillPopWidget(
            nextRoute: RouteHelper.bottomNavBar,
            child: Dialog(
              surfaceTintColor: MyColor.transparentColor,
              elevation: 0.0,
              insetPadding: EdgeInsets.zero,
              backgroundColor: MyColor.transparentColor,
              insetAnimationCurve: Curves.easeIn,
              insetAnimationDuration: const Duration(milliseconds: 100),
              child: LayoutBuilder(builder: (context, constraint) {
                return Container(
                  // height: MediaQuery.of(context).size.height / 1.4,
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16, top: Dimensions.space30, bottom: Dimensions.space20),
                  margin: const EdgeInsets.all(Dimensions.space10),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: MyColor.borderColor,
                      width: 0.6,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight / 2),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  !hideYour!
                                      ? Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${MyStrings.your.tr} ${title.tr}".tr,
                                                style: regularMediumLarge.copyWith(
                                                    // fontSize: Dimensions.fontExtraLarge+1,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: Dimensions.space2,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: " ${MyStrings.is_.tr} ",
                                                  children: [
                                                    TextSpan(
                                                      text: MyStrings.pending.tr,
                                                      style: regularMediumLarge.copyWith(
                                                        fontSize: Dimensions.fontExtraLarge + 1,
                                                        color: MyColor.pendingColor,
                                                      ),
                                                    )
                                                  ],
                                                  style: boldDefault.copyWith(
                                                    fontSize: Dimensions.fontExtraLarge + 1,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: Dimensions.space5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  subTitle,
                                                  style: lightDefault.copyWith(color: MyColor.bodytextColor),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: title.tr,
                                                children: [
                                                  TextSpan(
                                                    text: MyStrings.pending.tr,
                                                    style: regularMediumLarge.copyWith(
                                                      fontSize: Dimensions.fontExtraLarge + 1,
                                                      color: MyColor.pendingColor,
                                                    ),
                                                  )
                                                ],
                                                style: semiBoldDefault.copyWith(
                                                  fontSize: Dimensions.fontExtraLarge + 1,
                                                ),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: Dimensions.space5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                subTitle.tr,
                                                style: lightDefault.copyWith(color: MyColor.bodytextColor),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.space30,
                            ),
                            userDetails,
                            const SizedBox(
                              height: Dimensions.space40,
                            ),
                            cashDetails,
                            const Spacer(),
                            const SizedBox(
                              height: Dimensions.space40,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.offAndToNamed(RouteHelper.bottomNavBar);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                                  decoration: const BoxDecoration(
                                    color: MyColor.primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 7),
                                        blurRadius: 12,
                                        color: Color.fromRGBO(29, 111, 251, 0.20),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF2176FF), Color(0xFF0A55EB)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        MyStrings.backToHome.tr,
                                        style: regularDefault.copyWith(
                                          color: MyColor.colorWhite,
                                          fontSize: Dimensions.fontMediumLarge - 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: Dimensions.space10),
                                      const CustomSvgPicture(
                                        image: MyIcon.arrowRight,
                                        color: MyColor.colorWhite,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        });
  }

  bankRemove(
    BuildContext context, {
    required Function onPressYes,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: MyColor.transparentColor,
          surfaceTintColor: MyColor.transparentColor,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16, top: Dimensions.space30, bottom: Dimensions.space20),
                margin: const EdgeInsets.all(Dimensions.space20),
                decoration: BoxDecoration(
                  color: MyColor.colorWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: MyColor.borderColor,
                    width: 0.6,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.space10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${MyStrings.deleteAccount.tr} ?",
                            style: boldMediumLarge.copyWith(
                              color: MyColor.colorRed,
                            ),
                          )
                        ],
                        text: MyStrings.areYouSureWantToDeleteAccount.tr,
                        style: regularMediumLarge,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: Dimensions.space20,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: MyColor.borderColor,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              MyStrings.no.tr,
                              style: regularDefault.copyWith(color: MyColor.colorBlack, fontWeight: FontWeight.w600, fontSize: Dimensions.fontMediumLarge + 1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: Dimensions.space25,
                        ),
                        ElevatedButton(
                          onPressed: () => onPressYes(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 40),
                            backgroundColor: MyColor.colorRed,
                          ),
                          child: Text(
                            MyStrings.yes.tr,
                            style: regularDefault.copyWith(color: MyColor.colorWhite),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimensions.space5,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        MyStrings.afterDeleteYouCanBack.tr,
                        style: mediumSmall.copyWith(color: MyColor.colorGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: MyColor.colorRed,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  unaValableQrCode(String subTitle) {
    return showDialog(
      context: Get.context!,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.zero,
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight / 3),
                child: Container(
                  // height: MediaQuery.of(Get.context!).size.height / 3,
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16, top: Dimensions.space30, bottom: Dimensions.space20),
                  margin: const EdgeInsets.all(Dimensions.space20),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: MyColor.borderColor,
                      width: 0.6,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.space10),
                        Text(MyStrings.qrCodeWrong.tr, style: heading),
                        const SizedBox(height: Dimensions.space20),
                        Text(
                          subTitle.tr,
                          style: regularDefault.copyWith(fontSize: Dimensions.fontDefault),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              MyStrings.tryAgain.tr,
                              style: boldDefault.copyWith(color: MyColor.primaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void warningAlertDialog(BuildContext context, VoidCallback press) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              surfaceTintColor: MyColor.transparentColor,
              backgroundColor: MyColor.getCardBgColor(),
              insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: Dimensions.space40, bottom: Dimensions.space15, left: Dimensions.space15, right: Dimensions.space15),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          /*  Text(
                            MyStrings.areYouSure_.tr,
                            style: semiBoldLarge.copyWith(color: MyColor.colorRed),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),*/
                          const SizedBox(height: Dimensions.space15),
                          Text(
                            MyStrings.bankWarningSubtitle.tr,
                            style: regularDefault.copyWith(color: MyColor.getTextColor()),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          const SizedBox(height: Dimensions.space20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: RoundedButton(
                                  text: MyStrings.no.tr,
                                  press: () {
                                    Navigator.pop(context);
                                  },
                                  horizontalPadding: 3,
                                  verticalPadding: 3,
                                  color: MyColor.getScreenBgColor(),
                                  textColor: MyColor.getTextColor(),
                                ),
                              ),
                              const SizedBox(width: Dimensions.space10),
                              Expanded(
                                child: RoundedButton(text: MyStrings.yes.tr, press: press, horizontalPadding: 3, verticalPadding: 3, color: MyColor.redCancelTextColor, textColor: MyColor.colorWhite),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      left: MediaQuery.of(context).padding.left,
                      right: MediaQuery.of(context).padding.right,
                      child: Image.asset(
                        MyImages.warningImage,
                        height: 60,
                        width: 60,
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

//
  permissonQrCode() {
    return showDialog(
      context: Get.context!,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.zero,
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight / 3),
                child: Container(
                  // height: MediaQuery.of(Get.context!).size.height / 3,
                  padding: const EdgeInsetsDirectional.only(start: Dimensions.space16, end: Dimensions.space16, top: Dimensions.space30, bottom: Dimensions.space20),
                  margin: const EdgeInsets.all(Dimensions.space20),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      color: MyColor.borderColor,
                      width: 0.6,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(MyStrings.qrPermissonTitle.tr, style: heading),
                        const SizedBox(height: Dimensions.space20),
                        Text(
                          MyStrings.qrPermissonSubTitle.tr,
                          style: regularDefault.copyWith(fontSize: Dimensions.fontDefault),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  MyStrings.cancel.tr,
                                  style: boldDefault.copyWith(color: MyColor.colorRed),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.space20),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                openAppSettings();
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  MyStrings.appSettings.tr,
                                  style: boldDefault.copyWith(color: MyColor.pendingColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
  //
}
