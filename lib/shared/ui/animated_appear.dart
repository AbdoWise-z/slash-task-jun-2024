
import 'package:flutter/material.dart';

///
/// a class that creates an appear animation on its child widget if
/// [animate] changes from false to true or if this is the first time
/// the widget is created and [animate] is true
///
/// [duration] the duration of the fade-in animation
/// [child] the child widget to animate
class AnimatedAppear extends StatefulWidget {
  const AnimatedAppear({super.key, required this.child, required this.animate, required this.duration});
  final Widget child;
  final bool animate;
  final Duration duration;

  @override
  State<AnimatedAppear> createState() => _AnimatedAppearState();
}

class _AnimatedAppearState extends State<AnimatedAppear> {
  bool visible = true;

  @override
  void initState() {
    super.initState();
    if (widget.animate){
      visible = false;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedAppear oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animate == false && widget.animate == true){
      setState(() {
        visible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!visible){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          visible = true;
        });
      });
    }

    return AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: widget.duration,
        child: widget.child,
    );
  }
}
