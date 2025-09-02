import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:viserpay/core/utils/my_animation.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/qr_code/qr_code_controller.dart';
import 'package:viserpay/data/repo/qr_code/qr_code_repo.dart';
import 'package:viserpay/data/services/api_service.dart';
import 'package:viserpay/view/components/app-bar/custom_appbar.dart';
import 'package:viserpay/view/components/snack_bar/show_custom_snackbar.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;

  bool isGlobalQrCode = false;
  String expectedType = "-1";
  String nextRouteName = "-1";

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(QrCodeRepo(apiClient: Get.find()));
    Get.put(QrCodeController(qrCodeRepo: Get.find()));

    isGlobalQrCode = Get.arguments != null ? false : true;
    if (!isGlobalQrCode) {
      expectedType = Get.arguments != null ? Get.arguments[0] : "-1";
      nextRouteName = Get.arguments != null ? Get.arguments[1] : "-1";
    }

    super.initState();
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      this.qrController = qrController;
    });
    qrController.scannedDataStream.listen((scanData) {
      result = scanData;
      String? myQrCode = result?.code != null && result!.code.toString().isNotEmpty ? result?.code.toString() : '';
      if (myQrCode != null && myQrCode.isNotEmpty) {
        manageQRData(myQrCode);
      }
    });
  }

  void manageQRData(String myQrCode) async {
    final controller = Get.find<QrCodeController>();

    qrController?.stopCamera();

    bool requestStatus = await controller.submitQrData(
      scannedData: myQrCode,
      expectedType: expectedType,
      nextRouteName: nextRouteName,
    );

    if (requestStatus) {
      qrController?.stopCamera();
    }

    // Get.back(result: myQrCode);
    // if (isGlobalQrCode) {
    // } else {}
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      qrController?.pauseCamera();
    } else if (Platform.isIOS) {
      qrController?.resumeCamera();
    }
    super.reassemble();
  }

  @override
  void dispose() {
    qrController?.dispose();
    qrController?.stopCamera();
    super.dispose();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      CustomSnackBar.error(errorList: [MyStrings.noPermissionFound.tr]);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (qrController != null && mounted) {
      qrController!.pauseCamera();
      qrController!.resumeCamera();
    }

    return GetBuilder<QrCodeController>(
      builder: (viewController) => Scaffold(
        appBar: CustomAppBar(
          title: MyStrings.qrScan.tr,
          isShowBackBtn: true,
          bgColor: MyColor.appBarColor,
        ),
        body: Stack(
          children: [
            !viewController.isScannerLoading
                ? Column(
                    children: [
                      Expanded(
                          child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        cameraFacing: CameraFacing.back,
                        overlay: QrScannerOverlayShape(
                          borderColor: MyColor.primaryColor,
                          borderRadius: 5,
                          borderLength: 30,
                          borderWidth: 10,
                          cutOutSize: (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0,
                        ),
                        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
                      )),
                    ],
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(MyAnimation.time, height: 150),
                  )
          ],
        ),
      ),
    );
  }
}
