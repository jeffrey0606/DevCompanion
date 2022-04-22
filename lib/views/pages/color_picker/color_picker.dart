import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({Key? key}) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  void initState() {
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
    // windowManager.setHasShadow(false);
    // windowManager.maximize();
    // windowManager.blur();
    setWindowEffect();
    super.initState();
  }

  void setWindowEffect() async {
    // await Window.setWindowBackgroundColorToClear();
    await Window.setEffect(
      effect: WindowEffect.transparent,
      // color: const Color(0xCC222222),
      // color: this.color,
      // dark: false,
    );
    // setState(() {});
    // if (Platform.isMacOS) {
    //   if (brightness != InterfaceBrightness.auto) {
    //     Window.overrideMacOSBrightness(
    //         dark: brightness == InterfaceBrightness.dark);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Project's Color Picker",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
