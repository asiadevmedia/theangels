// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/view/screens/add-money/add_money/widget/webview_widget.dart';

class MyWebViewScreen extends StatefulWidget {
  String url;
  MyWebViewScreen({super.key, required this.url});

  @override
  State<MyWebViewScreen> createState() => _MyWebViewScreenState();
}

class _MyWebViewScreenState extends State<MyWebViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.url = Get.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MyWebViewWidget(url: widget.url),
      ),
    );
  }
}
