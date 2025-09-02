
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';

class MainItemSection extends StatelessWidget {
  const MainItemSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final isKycVerified = controller.isKycVerified;
        final moduleList = controller.moduleList;
        final screenWidth = MediaQuery.of(context).size.width;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.space15,
            vertical: isKycVerified ? Dimensions.space15 : Dimensions.space5,
          ),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: MyColor.colorWhite,
            border: Border(bottom: BorderSide(color: MyColor.colorGrey, width: 0.09)),
          ),
          child: Column(
            children: [
              if (moduleList.length == 8)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < 4; i++) Expanded(child: moduleList[i]),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space25 - 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 4; i < 8; i++) Expanded(child: moduleList[i]),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (moduleList.length > 4)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 20.0,
                        children: [
                          for (var i = 0; i < moduleList.length; i++)
                            SizedBox(
                              width: (screenWidth - 32 - 24) / 4,
                              child: moduleList[i],
                            ),
                        ],
                      )
                    else if (moduleList.length == 4)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var i = 0; i < 4; i++) Expanded(child: moduleList[i]),
                        ],
                      )
                    else
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: [
                          for (var i = 0; i < moduleList.length; i++)
                            SizedBox(
                              width: (screenWidth - 32 - 24) / 4,
                              child: moduleList[i],
                            ),
                        ],
                      ),
                  ],
                ),
              const SizedBox(height: Dimensions.space15),
            ],
          ),
        );
      },
    );
  }
}
