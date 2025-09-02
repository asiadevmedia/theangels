// ignore_for_file: library_private_types_in_public_api

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'swipeable_widget.dart';

class SwipeableButtonView extends StatefulWidget {
  final VoidCallback onFinish;

  /// Event waiting for the process to finish
  final VoidCallback onWaitingProcess;

  /// Animation finish control
  final bool isFinished;

  /// Button is active value default : true
  final bool isActive;

  /// Button is active value default : true
  final bool isTextAnimated;
  final List<Color> animatedTextColor;

  /// Button active color value
  final Color activeColor;

  /// Button disable color value
  final Color? disableColor;

  /// Swipe button widget
  final Widget buttonWidget;

  /// Button color default : Colors.white
  final Color? buttonColor;

  /// Button center text
  final String buttonText;

  /// Button text style
  final TextStyle? buttontextstyle;

  /// Circle indicator color
  final Animation<Color?>? indicatorColor;
  const SwipeableButtonView(
      {super.key,
      required this.onFinish,
      required this.onWaitingProcess,
      required this.activeColor,
      required this.buttonWidget,
      required this.buttonText,
      this.isFinished = false,
      this.isActive = true,
      this.isTextAnimated = false,
      this.animatedTextColor = const [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      this.disableColor = Colors.grey,
      this.buttonColor = Colors.white,
      this.buttontextstyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      this.indicatorColor = const AlwaysStoppedAnimation<Color>(Colors.white)});

  @override
  _SwipeableButtonViewState createState() => _SwipeableButtonViewState();
}

class _SwipeableButtonViewState extends State<SwipeableButtonView> with TickerProviderStateMixin {
  bool isAccepted = false;
  double opacity = 1;
  bool isFinishValue = false;
  bool isStartRippleEffect = false;
  late AnimationController _controller;

  bool isScaleFinished = false;

  late AnimationController rippleController;
  late AnimationController scaleController;

  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;

  init() {
    setState(() {
      isAccepted = false;
      opacity = 1;
      isFinishValue = false;
      isStartRippleEffect = false;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      isFinishValue = widget.isFinished;
    });

    rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isFinishValue = true;
          });
          widget.onFinish();
        }
      });
    rippleAnimation = Tween<double>(begin: 60.0, end: 90.0).animate(rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          rippleController.forward();
        }
      });
    scaleAnimation = Tween<double>(begin: 1.0, end: 30.0).animate(scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isScaleFinished = true;
          });
        }
      });

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFinished) {
      setState(() {
        isStartRippleEffect = true;
        isFinishValue = true;
      });
      scaleController.forward();
    } else {
      if (isFinishValue) {
        scaleController.reverse().then((value) {
          init();
        });
      }
    }
    return Container(
      width: isAccepted ? (MediaQuery.of(context).size.width - ((MediaQuery.of(context).size.width - 60) * _controller.value)) : double.infinity,
      height: 60,
      decoration: BoxDecoration(color: widget.isActive ? widget.activeColor : widget.disableColor, borderRadius: BorderRadius.circular(30)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: opacity,
              child: widget.isTextAnimated
                  ? AnimatedTextKit(
                      animatedTexts: List.generate(
                        4,
                        (index) => ColorizeAnimatedText(widget.buttonText, textStyle: widget.buttontextstyle!, colors: widget.animatedTextColor, speed: const Duration(microseconds: 100)),
                      ),
                      isRepeatingAnimation: true,
                    )
                  : Text(
                      widget.buttonText,
                      style: widget.buttontextstyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
          !isAccepted
              ? SwipeableWidget(
                  isActive: widget.isActive,
                  height: 60.0,
                  onSwipeValueCallback: (value) {
                    setState(() {
                      opacity = value;
                    });
                  },
                  child: SizedBox(
                    height: 60.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            elevation: 2,
                            shape: const CircleBorder(),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: widget.buttonColor),
                              child: Center(
                                child: widget.buttonWidget,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onSwipeCallback: () {
                    widget.onWaitingProcess();
                    setState(() {
                      isAccepted = true;
                    });
                    _controller.animateTo(1.0, duration: const Duration(milliseconds: 600), curve: Curves.fastOutSlowIn);
                  },
                )
              : AnimatedBuilder(
                  animation: rippleAnimation,
                  builder: (context, child) => SizedBox(
                    width: rippleAnimation.value,
                    height: rippleAnimation.value,
                    child: AnimatedBuilder(
                        animation: scaleAnimation,
                        builder: (context, child) => Transform.scale(
                              scale: scaleAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.activeColor.withOpacity(0.4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.isActive ? widget.activeColor : widget.disableColor),
                                      child: Center(
                                        child: !isFinishValue ? CircularProgressIndicator(valueColor: widget.indicatorColor) : const SizedBox(),
                                      )),
                                ),
                              ),
                            )),
                  ),
                )
        ],
      ),
    );
  }
}
