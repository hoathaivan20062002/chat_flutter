import 'package:chat_app/auth/screens/log_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth.dart';
import '../widgets/send_verification_link_button.dart';

class NotVerified extends StatelessWidget {
  const NotVerified({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(title: const Text('Người dùng chưa được xác minh')),
            body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Tài khoản của bạn chưa được xác minh, vui lòng kiểm tra hộp thư của bạn để biết liên kết xác minh'),
              ElevatedButton(
                  onPressed: () async {
                    await _onWillPop();
                  },
                  child: const Text('Trở lại')),
              const _NeedHelpButton()
            ])));
  }
}

Future<bool> _onWillPop() async {
  await Auth.signOut();
  Get.offAll(()=>const SignIn());
  return true;
}

class _NeedHelpButton extends StatelessWidget {
  const _NeedHelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text('Bạn cần giúp đỡ?'),
        onPressed: () {
          Get.defaultDialog(
            barrierDismissible: false,
            title: 'Hỗ trợ',
            content: Column(children: const [
              Text('Bạn không tìm thấy Email? Vui lòng kiểm tra những nơi khác vd:hộp thư rác'),
              Text('Hoặc'),
              SendVerificationLinkButton()
            ]),
          );
        },
      ),
    );
  }
}
