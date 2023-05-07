import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError(e) {
  Get.defaultDialog(
    title: 'Lỗi',
    middleText: e.toString(),
    textConfirm: 'OK',
    onConfirm: () {
      Get.back();
    },
  );
}

void showLoadingIndicator() {
  Get.defaultDialog(onWillPop: () async {
    return false;
  },
  barrierDismissible: false,
  backgroundColor:  Colors.transparent,
  title: '',
  middleText: '',
  );
}

