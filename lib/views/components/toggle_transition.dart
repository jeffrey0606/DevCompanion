import 'package:flutter/material.dart';

class ToggleTransition extends StatelessWidget {
  /// [firstChild] is visible When [expanded] is true
  const ToggleTransition({
    Key? key,
    required this.expanded,
    required this.firstChild,
    required this.secondChild,
    required this.duration,
  }) : super(key: key);

  final bool expanded;
  final Widget firstChild;
  final Widget secondChild;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      child: expanded
          ? Container(
              child: firstChild,
              key: const ValueKey("remove"),
            )
          : Container(
              child: secondChild,
              key: const ValueKey("add"),
            ),
      duration: duration,
      transitionBuilder: (child, animate) {
        final removeTurns =
            Tween<double>(begin: -1 / 2, end: 0).animate(animate);

        final addTurns = Tween<double>(begin: 0, end: -1 / 4).animate(animate);
        //2 * pi (if you want to end with pi/2 then = [(pi/2) * 1/(2*pi)])

        if (child.key == const ValueKey("remove")) {
          return AnimationStatusListenableBuilder(
            builder: (context, status, child) {
              return Opacity(
                opacity: status == AnimationStatus.completed
                    ? 1
                    : expanded
                        ? 0
                        : 1,
                child: RotationTransition(
                  turns: removeTurns,
                  child: child,
                ),
              );
            },
            animation: removeTurns,
            child: child,
          );
        } else {
          return AnimationStatusListenableBuilder(
            builder: (context, status, child) {
              return Opacity(
                opacity: status == AnimationStatus.completed
                    ? 1
                    : expanded
                        ? 1
                        : 0,
                child: RotationTransition(
                  turns: addTurns,
                  child: child,
                ),
              );
            },
            animation: addTurns,
            child: child,
          );
          // return RotationTransition(
          //   turns: addTurns,
          //   child: child,
          // );
        }
      },
    );
  }
}

class AnimationStatusListenableBuilder extends StatefulWidget {
  /// Creates a [AnimationStatusListenableBuilder].
  ///
  /// The [valueListenable] and [builder] arguments must not be null.
  /// The [child] is optional but is good practice to use if part of the widget
  /// subtree does not depend on the value of the [valueListenable].
  const AnimationStatusListenableBuilder({
    Key? key,
    required this.animation,
    required this.builder,
    this.child,
  }) : super(key: key);
  final Animation animation;
  final ValueWidgetBuilder<AnimationStatus> builder;
  final Widget? child;

  @override
  State<StatefulWidget> createState() =>
      AnimationStatusListenableBuilderState();
}

class AnimationStatusListenableBuilderState
    extends State<AnimationStatusListenableBuilder> {
  late AnimationStatus value;

  @override
  void initState() {
    super.initState();
    value = widget.animation.status;
    widget.animation.addStatusListener(_valueChanged);
  }

  @override
  void didUpdateWidget(AnimationStatusListenableBuilder oldWidget) {
    if (oldWidget.animation != widget.animation) {
      oldWidget.animation.removeStatusListener(_valueChanged);
      value = widget.animation.status;
      widget.animation.addStatusListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged(AnimationStatus status) {
    setState(() {
      value = widget.animation.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}
