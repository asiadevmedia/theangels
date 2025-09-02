import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/view/components/dialog/exit_dialog.dart';

class WillPopWidget extends StatelessWidget {
  final Widget child;
  final String nextRoute;

  const WillPopWidget({super.key, required this.child, this.nextRoute = ''});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        if (nextRoute.isEmpty) {
          showExitDialog(context);
        } else {
          Get.offAndToNamed(nextRoute);
        }
      },
      child: child
    );
  }
}
