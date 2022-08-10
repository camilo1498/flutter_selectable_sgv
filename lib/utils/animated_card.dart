import 'package:flutter/material.dart';
import 'dart:math';

class FlipCard extends StatefulWidget {
  /// used to control the flip
  final AnimationCardController controller;

  /// The Front side widget of the card
  final Widget frontWidget;

  /// The Back side widget of the card
  final Widget backWidget;

  const FlipCard(
      {Key? key,
        required this.frontWidget,
        required this.backWidget,
        required this.controller,
      }) : super(key: key);

  @override
  FlipCardState createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  /// instances
  final flipCardController = AnimationCardController();
  /// variables
  late AnimationController animationController;
  bool isFront = true;
  double anglePlus = 0;

  @override
  void initState() {
    super.initState();
    /// init animation controller
    animationController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    widget.controller.state = this;
    flipCardController.state = this;
  }

  @override
  void dispose() {
    /// close animation controller
    animationController.dispose();
    super.dispose();
  }

  /// Flip the card
  flipWidget() async {
    if (animationController.isAnimating) return;
    isFront = !isFront;
     return await animationController.forward(from: 0).then((value) => anglePlus = pi);
  }

  /// validate current card side
  bool isFrontWidget(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;
    return angle <= degrees90 || angle >= degrees270;
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        double piValue = 0.0;
        piValue = pi;
        double angle = animationController.value * piValue;
        late Matrix4 transform;
        late Matrix4 transformForBack;
        if (isFront) angle += anglePlus;
        transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        transformForBack = Matrix4.identity()..rotateY(pi);

        return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: isFrontWidget(angle.abs())
                ? widget.frontWidget
                : Transform(
              transform: transformForBack,
              alignment: Alignment.center,
              child: widget.backWidget,
            ));
      });
}

class AnimationCardController {
  FlipCardState? state;

  /// Flip the card
  Future flipCard() async => state?.flipWidget();
}