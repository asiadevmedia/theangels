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
import 'package:viserpay/core/utils/util.dart';
import 'package:viserpay/view/components/dialog/app_dialog.dart';
import 'package:viserpay/view/components/image/custom_svg_picture.dart';
import 'package:viserpay/view/screens/bottom_nav_section/home/home_screen.dart';
import 'package:viserpay/view/screens/transaction/transaction_history_screen.dart';
import '../../screens/bottom_nav_section/home/widget/my_drawer.dart';
import '../will_pop_widget.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey<ScaffoldState> _bootomNavscaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(bootomNavscaffoldKey: _bootomNavscaffoldKey),
      const TransactionHistoryScreen(),
    ];
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      // nextRoute: Get.previousRoute == ,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _bootomNavscaffoldKey,
        endDrawer: MyDrawer(onDrawerItemTap: _closeDrawer),
        body: screens[currentIndex],
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 65,
            width: 65,
            child: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              hoverColor: MyColor.primaryColor.withOpacity(0.2),
              shape: const OvalBorder(),
              onPressed: () async {
                await MyUtils().isCameraPemissonGranted().then((value) {
                  if (value == PermissionStatus.granted) {
                    Get.toNamed(RouteHelper.qrCodeScanner);
                  } else {
                    AppDialog().permissonQrCode();
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(Dimensions.space20),
                decoration: BoxDecoration(
                  color: MyColor.colorWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.6,
                      spreadRadius: 0.2,
                      color: MyColor.primaryColor.withOpacity(0.3),
                    )
                  ],
                ),
                child: Image.asset(MyImages.scan, color: MyColor.primaryColor, width: 65, height: 65),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: MyColor.colorWhite,
          elevation: 6,
          shadowColor: MyColor.colorBlack,
          surfaceTintColor: MyColor.transparentColor,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navBarItem(MyIcon.bottomHome, 0, MyStrings.home.tr),
              const SizedBox(
                width: 40,
              ),
              navBarItem(
                MyIcon.bottomHistory,
                1,
                MyStrings.history.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  navBarItem(String imagePath, int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(Dimensions.space5),
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                // color: index == currentIndex ? MyColor.transparentColor : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: CustomSvgPicture(
                image: imagePath,
                color: index == currentIndex ? MyColor.primaryColor : MyColor.iconColor.withOpacity(0.8),
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: Dimensions.space3 + 1),
            Text(label.tr, textAlign: TextAlign.center, style: regularSmall.copyWith(color: index == currentIndex ? MyColor.primaryColor : MyColor.iconColor.withOpacity(0.8), fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}
