import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/data/controller/home/home_controller.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';

class CarouselItems extends StatefulWidget {
  const CarouselItems({super.key});

  @override
  State<CarouselItems> createState() => _CarouselItemsState();
}

class _CarouselItemsState extends State<CarouselItems> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    double height = w > 560 ? 180 : 110;
    return GetBuilder<HomeController>(builder: (controller) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CarouselSlider(
              items: List.generate(
                controller.appBanners.length,
                (index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.toNamed(RouteHelper.mywebViewScreen, arguments: controller.appBanners[index].dataValues?.link.toString());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: MyImageWidget(
                      imageUrl: controller.appBanners[index].getImage ?? "",
                      boxFit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      // height: 110,
                    ),
                  ),
                ),
              ),
              options: CarouselOptions(
                autoPlay: false,
                viewportFraction: 1,
                height: height,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: Dimensions.space5,
            ),
            DotsIndicator(
              dotsCount: controller.appBanners.length,
              position: currentIndex,
              mainAxisSize: MainAxisSize.min,
              decorator: DotsDecorator(
                size: const Size.square(8),
                activeColor: MyColor.primaryColor,
                color: MyColor.primaryColor.withOpacity(0.2),
              ),
            )
          ],
        ),
      );
    });
  }
}
