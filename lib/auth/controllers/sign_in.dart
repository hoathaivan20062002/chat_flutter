import 'dart:async';

import 'package:chat_app/auth/screens/verify_page.dart';
// import 'package:chat_app/chat/services/user.dart';
import 'package:chat_app/chat/you_are_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils.dart';
import '../screens/log_in.dart';
import '../screens/sign_up.dart';
import '../services/auth.dart';
import '../widgets/faded_overlay.dart';
import '../widgets/send_verification_link_button.dart';

// TODO
// remember password
// start loading should be placed here
class SignInController extends GetxController {
  static SignInController? _inst;
  static SignInController get inst {
    _inst ??= SignInController();
    return _inst!;
  }

  //var usingEmail = true.obs;

  //#region EMAIL
  final email = ''.obs;

  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  String? emailValidator() {
    if (!emailRegex.hasMatch(email.value)) {
      return 'Vui lòng nhập email hợp lệ!';
    }

    return null;
  }

  var emailErrorText = Rx<String?>(null);
  //#endregion



  var password = ''.obs;
  // Minimum eight characters, at least one letter and one number:
  RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  String? passwordValidator() {
    if (!passwordRegex.hasMatch(password.value)) {
      return 'Mật khẩu phải có ít nhất 8 ký tự, ít nhất một chữ cái và một chữ số';
    }
    return null;
  }

  var passwordErrorText = Rx<String?>(null);
  //#endregion

  void validateEmailAndSignIn() async {
    var validationSuccess = true;
    var fullInput = true;

    // validate password
    if (password.value.isEmpty) {
      passwordErrorText.value = 'Vui lòng nhập mật khẩu !';
      fullInput = false;
      validationSuccess = false;
    } else if (passwordValidator() != null) {
      validationSuccess = false;
    }

    // validate email
    if (email.isEmpty) {
      emailErrorText.value = 'Vui lòng nhập email!';
      fullInput = false;
      validationSuccess = false;
    } else if (emailValidator() != null) {
      validationSuccess = false;
    }

    if (validationSuccess) {
      await _onSuccessValidation();
      return;
    } else {
      FadedOverlay.remove();
      if (fullInput) {
        Get.defaultDialog(
          title: 'Lỗi',
          middleText: 'ID người dùng hoặc mật khẩu sai',
          textConfirm: 'OK',
          onConfirm: () {
            Get.back();
          },
        );
      }
    }
  }

  void signOut() async {
    // reset email and password
    email('');
    password('');

    await Auth.signOut().then((_) {
      Get.offAll(() => const SignIn());
    }).catchError((e) {
      showError(e);
    });

    FadedOverlay.remove();
  }

  Future<void> _onSuccessValidation() async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      FadedOverlay.remove();
      if (!credentials.user!.emailVerified) {
        Get.off(const VerifyPage());
        // await _promptUserToVerifyEmail(credentials);
        return;
      }

      // await FbAuth.originalInst?.linkCredentials(email.value);
      // updateToken();

      Get.to(() => const YouAreIn());
    } on FirebaseAuthException catch (e) {
      FadedOverlay.remove();

      switch (e.code) {
        case 'invalid-email':
          emailErrorText.value = 'Email không hợp lệ, vui lòng thử lại';
          break;
        case 'user-disabled':
          showError(
              'Tài khoản của bạn bị vô hiệu hóa, vui lòng liên hệ với quản trị viên để được hỗ trợ.');
          break;
        case 'user-not-found':
          Get.defaultDialog(
              title: 'Chúng tôi không thể tìm thấy tài khoản của bạn',
              middleText:
                  'Có vẻ như bạn là người mới đối với chúng tôi, hãy thử đăng ký vào hệ thống của chúng tôi',
              textConfirm: 'Đăng Ký',
              onConfirm: () {
                Get.offAll(() => const SignUp());
              });
          break;
        case 'wrong-password':
          Get.defaultDialog(
            title: 'Lỗi',
            middleText: 'ID người dùng hoặc mật khẩu sai',
            textConfirm: 'OK',
            onConfirm: () {
              Get.back();
            },
          );
          break;
      }
    } catch (e) {
      FadedOverlay.remove();
      showError(e);
    }
    return;
  }
}

Future<void> _promptUserToVerifyEmail(UserCredential credential) async {
  await Get.defaultDialog(
      barrierDismissible: false,
      title: 'Xác nhận email của bạn',
      content: Column(children: const [
        Text('Vui lòng kiểm tra hộp thư của bạn ,để xác minh email của bạn'),
        _NeedHelpButton()
      ]),
      textConfirm: 'OK',
      onConfirm: () async {
        // sign out
        await FirebaseAuth.instance.signOut();
        Get.back();
      },
      onWillPop: () async {
        // sign out
        await FirebaseAuth.instance.signOut();
        return true;
      });
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
            // quit this dialog
            Get.back();

            /// show need_help dialog, sign out on pop out
            Get.defaultDialog(
                barrierDismissible: false,
                title: 'Hỗ trợ',
                content: Column(children: const [
                  Text(
                      'Bạn không tìm thấy Email? Vui lòng kiểm tra những nơi khác vd:hộp thư rác'),
                  Text('Hoặc'),
                  SendVerificationLinkButton()
                ]),
                onWillPop: () async {
                  // sign out
                  await FirebaseAuth.instance.signOut();
                  return true;
                });
          },
        ));
  }
}
