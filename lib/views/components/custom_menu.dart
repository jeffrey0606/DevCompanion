import 'package:devcompanion/helpers/enums.dart';
import 'package:flutter/material.dart';

class CustomMenu extends StatelessWidget {
  final Widget child;
  final Function? onDismissed;
  final Function(dynamic item)? onItemSelected;
  final CustomMenuAlignment alignment;
  final bool fitContentToChildWidth;
  final EdgeInsets padding;
  final Function? onOpen;
  final List<Widget> items;

  const CustomMenu({
    Key? key,
    required this.child,
    this.onDismissed,
    this.onItemSelected,
    this.alignment = CustomMenuAlignment.right,
    this.items = const [],
    this.fitContentToChildWidth = false,
    this.padding = const EdgeInsets.symmetric(
      vertical: 5,
    ),
    this.onOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onOpen?.call();
        showCustomMenu(
          context,
          alignment,
          items,
          fitContentToChildWidth,
          padding,
        );
      },
      child: child,
    );
  }
}

void showCustomMenu(
  BuildContext context,
  CustomMenuAlignment alignment,
  List<Widget> items,
  bool fitContentToChildWidth,
  EdgeInsets padding,
) async {
  final Offset position = getPosition(
    context,
    alignment,
  );
  await showGeneralDialog(
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    context: context,
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 100),
    barrierColor: Colors.transparent,
    pageBuilder: (
      BuildContext context1,
      Animation animation,
      Animation secondaryAnimation,
    ) {
      return Material(
        type: MaterialType.transparency,
        child: CustomContextMenu(
          position: position,
          items: items,
          scaleAlignment: getScaleAlignment(alignment),
          constentWidth:
              fitContentToChildWidth ? getChildSize(context).width : 100,
          padding: padding,
        ),
      );
    },
  );
}

Size getChildSize(BuildContext context) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;

  return renderBox.size;
}

Alignment getScaleAlignment(CustomMenuAlignment customAlignment) {
  late Alignment alignment;

  switch (customAlignment) {
    case CustomMenuAlignment.bottom:
      alignment = Alignment.topCenter;
      break;
    case CustomMenuAlignment.left:
      break;
    case CustomMenuAlignment.right:
      alignment = Alignment.topLeft;
      break;
    case CustomMenuAlignment.top:
      break;
    default:
  }

  return alignment;
}

Offset getPosition(BuildContext context, CustomMenuAlignment alignment) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  Offset offset = renderBox.localToGlobal(
    Offset.zero,
  );

  final Size size = renderBox.size;

  switch (alignment) {
    case CustomMenuAlignment.bottom:
      offset += Offset(
        0,
        size.height + 3,
      );
      break;
    case CustomMenuAlignment.left:
      break;
    case CustomMenuAlignment.right:
      offset += Offset(
        size.width,
        3,
      );
      break;
    case CustomMenuAlignment.top:
      break;
    default:
  }

  return offset;
}

class CustomContextMenu extends StatefulWidget {
  final Offset position;
  final Alignment scaleAlignment;
  final List<Widget> items;
  final double constentWidth;
  final EdgeInsets padding;
  const CustomContextMenu({
    Key? key,
    required this.position,
    required this.items,
    required this.scaleAlignment,
    required this.constentWidth,
    required this.padding,
  }) : super(key: key);

  @override
  State<CustomContextMenu> createState() => _CustomContextMenuState();
}

class _CustomContextMenuState extends State<CustomContextMenu>
    with SingleTickerProviderStateMixin {
  late Animation<double> scale;
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      reverseDuration: const Duration(
        milliseconds: 200,
      ),
    );

    scale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: scale,
          builder: (context, child) {
            return Transform.translate(
              offset: widget.position,
              child: Transform.scale(
                scale: scale.value,
                alignment: widget.scaleAlignment,
                child: SizedBox(
                  // height: 200,
                  width: widget.constentWidth,
                  child: Material(
                    elevation: 2,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: widget.padding,
                        child: Wrap(
                          children: widget.items,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// class CustomMenuItem extends StatelessWidget {
//   final Function()? onTap;
//   final Widget child;
//   const CustomMenuItem({
//     Key? key,
//     this.onTap,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       splashColor: secondaryColor,
//       onTap: onTap == null
//           ? null
//           : () {
//               onTap?.call();
//               Navigator.of(context).pop();
//             },
//       child: child,
//     );
//   }
// }
