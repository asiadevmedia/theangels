import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/my_color.dart';

class MyShimmerWidget extends StatelessWidget {
  final Widget child;
  const MyShimmerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(baseColor: MyColor.colorGrey.withOpacity(0.2), highlightColor: MyColor.primaryColor.withOpacity(0.7), child: child);
  }
}
