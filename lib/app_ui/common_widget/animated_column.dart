import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry padding;
  const AnimatedColumn({Key? key, required this.children,this.crossAxisAlignment = CrossAxisAlignment.start,this.padding = const EdgeInsets.symmetric(horizontal: 16)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 150),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
