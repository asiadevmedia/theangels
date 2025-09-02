// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:viserpay/view/components/image/my_image_widget.dart';

class BillIcon extends StatelessWidget {
  Color color;
  final String imageUrl;
  final double height;
  final double width;
  final BoxShape shape;
  final double radius;

  BillIcon({
    super.key,
    required this.color,
    required this.imageUrl,
    this.height = 28,
    this.width = 28,
    this.radius = 0,
    this.shape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
          shape: radius > 0 ? BoxShape.rectangle : BoxShape.circle,
          border: Border.all(
            width: 1,
            color: color,
          ),
          color: color.withOpacity(.1),
        ),
        child: MyImageWidget(
          radius: radius,
          imageUrl: imageUrl,
          height: height,
          width: width,
          color: color,
        ),
      ),
    );
  }
}
