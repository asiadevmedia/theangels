import 'package:flutter/material.dart';
import 'package:viserpay/core/utils/dimensions.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/core/utils/style.dart';
import 'package:viserpay/core/utils/util.dart';

class NoDataCard extends StatelessWidget {

  final double topMargin;
  final double bottomMargin;
  final double width;
  final String title;
  const NoDataCard({super.key,this.topMargin = 25, this.bottomMargin = 25,required this.width,this.title = MyStrings.noDataFound});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(top: topMargin,bottom: bottomMargin),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space17,vertical: Dimensions.space20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        boxShadow: MyUtils.getCardShadow(),
        border: Border.all(color: MyColor.borderColor.withOpacity(.6),width: .5)
      ),
      child: Text( title,style: heading,textAlign: TextAlign.center,)
    );
  }
}
