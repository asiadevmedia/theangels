
import 'package:flutter/material.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_icon.dart';
import 'package:viserpay/view/components/image/circle_shape_image.dart';

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final Color backgroundColor;
  final Color? imageColor;
  final double size;
  final bool isSvg;

  const CustomNetworkImage({
    super.key,
    this.backgroundColor = MyColor.screenBgColor,
    this.imageColor,
    this.size = 35,
    required this.image,
    this.isSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(Dimensions.space10),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Image.network(
        image,
        color: imageColor,
        height: size / 2,
        width: size / 2,
        errorBuilder: (context, error, stackTrace) {
          return const CircleShapeImage(
            image: MyIcon.user,
            isSvgImage: true,
            backgroundColor: MyColor.primaryColor,
          );
        },
      ),
    );
  }
}
