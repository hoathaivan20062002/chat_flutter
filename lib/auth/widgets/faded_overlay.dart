import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

// loading  khi đăng nhập
class FadedOverlay {
  static OverlayEntry? _overlayEntry;
  static double opacity = 0.5;

  static void show(BuildContext context, Widget widget) {
    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
              backgroundColor: Colors.white.withOpacity(opacity),
              body: Center(child: widget),
            ));
    overlayState.insert(_overlayEntry!);
  }

  static void showLoading(BuildContext context) {
    FadedOverlay.show(
        context,
        Center(
          child: CircularProgressIndicator(),
        ));
  }

  static void remove() {
    if (_overlayEntry != null) _overlayEntry!.remove();
  }
}
