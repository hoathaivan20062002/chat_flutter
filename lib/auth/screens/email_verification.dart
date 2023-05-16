import 'package:chat_app/auth/screens/create_password.dart';
import 'package:chat_app/auth/screens/log_in.dart';
import 'package:chat_app/chat/you_are_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth.dart';
import '../widgets/send_verification_link_button.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({Key? key, this.isNewUser = false}) : super(key: key);
  final bool isNewUser;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Email xác thực'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Vui lòng kiểm tra hộp thư của bạn để biết liên kết để đăng nhập'),
                const _NeedHelpButton(),
                ElevatedButton(
                    onPressed: () async {
                      // check if the email is verified
                      await FirebaseAuth.instance.currentUser!.reload();
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        if (isNewUser) {
                          Get.offAll(() => const CreatePassword());
                        } else {
                          Get.offAll(() => const YouAreIn());
                        }
                      } else {
                        Get.snackbar('Lỗi xác thực', 'Vui lòng thử lại');
                      }
                    },
                    child: const Text('Xong ,đến trang đăng nhập'))
              ],
            )));
  }
}

Future<bool> _onWillPop() async {
  await Auth.signOut();
  Get.offAll(() => const SignIn());
  return true;
}

class _NeedHelpButton extends StatelessWidget {
  const _NeedHelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text('Cần giúp đỡ?'),
        onPressed: () {
          Get.defaultDialog(
            barrierDismissible: false,
            title: 'Hỗ trợ',
            content: Column(children: const [
              Text('Bạn chưa nhận được EMAIL ,Vui lòng kiểm tra  hộp thư '),
              Text('Hoặc'),
              SendVerificationLinkButton()
            ]),
          );
        },
      ),
    );
  }
}
