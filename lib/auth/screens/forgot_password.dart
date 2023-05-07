import 'package:chat_app/auth/widgets/faded_overlay.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../controllers/forget_password.dart';
import '../widgets/email_input.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        onVerticalDragEnd: (DragEndDetails details) => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(title: const Text('Quên mật khẩu')),
            body: Column(
              children: const [
                Text('Vui lòng . Nhập địa chỉ email bạn đã sử dụng để đăng ký tài khoản và chúng tôi sẽ gửi cho bạn liên kết đặt lại'),
                _EmailInput(),
                _SendResetPasswordButton(),
              ],
            )));
  }
}

class _EmailInput extends EmailInput {
  const _EmailInput({Key? key}) : super(key: key);
  @override
  RxString get email => ForgetPasswordController.inst.email;

  @override
  Rx<String?> get errorText => ForgetPasswordController.inst.emailErrorText;

  @override
  String? Function() get validator => ForgetPasswordController.inst.emailValidator;
}

class _SendResetPasswordButton extends StatelessWidget {
  const _SendResetPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FadedOverlay.showLoading(context);
        ForgetPasswordController.inst.validateAndSendResetLink();
      },
      child: const Text('Tiếp tục'),
    );
  }
}
