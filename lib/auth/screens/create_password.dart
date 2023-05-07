import 'package:chat_app/chat/you_are_in.dart';
import 'package:chat_app/auth/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_password.dart';
import '../widgets/faded_overlay.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tạo mật khẩu')),
        body: Column(
          children: const [
            Text('Xin chào người bạn mới '),
            Text('bạn có muốn tạo mật khẩu cho phương thức đăng nhập chính không?'),
            _PasswordInput(),
            _ContinueButton(),
            _SkipButton(),
            Text('Không sao, bạn có thể thiết lập sau')
          ],
        ));
  }
}

class _PasswordInput extends PasswordInput {
  const _PasswordInput({Key? key}) : super(key: key);
  @override
  Rx<String?> get errorText => CreatePasswordController.inst.error;

  @override
  String? get hintText => 'Mật khẩu phải có ít nhất 8 ký tự, ít nhất một chữ cái và một số';

  @override
  RxString get password => CreatePasswordController.inst.password;

  @override
  String? Function() get validator => CreatePasswordController.inst.validator;
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){
      FadedOverlay.showLoading(context);
      CreatePasswordController.inst.validateAndUpdatePassword();
    }, child: const Text('Tiếp tục'));
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Get.offAll(()=>const YouAreIn());
        },
        child: const Text('Bỏ qua'));
  }
}
