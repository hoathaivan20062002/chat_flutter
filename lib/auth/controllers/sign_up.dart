import 'package:chat_app/auth/screens/verify_page.dart';
import 'package:chat_app/chat/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../utils.dart';
import '../widgets/faded_overlay.dart';
import 'sign_in.dart';

class SignUpController extends GetxController {
  static SignUpController? _inst;
  static SignUpController get inst {
    _inst ??= SignUpController();
    return _inst!;
  }

  //#region NAME
  var name = ''.obs;
  // final RegExp nameRegex = RegExp(
  //     r'(^[A-Za-z]{3,16})([ ]{0,1})([A-Za-z]{3,16})?([ ]{0,1})?([A-Za-z]{3,16})?([ ]{0,1})?([A-Za-z]{3,16})');
  String? nameValidator() {
    // if (!nameRegex.hasMatch(name.value)) {
    if (name.value.isEmpty) {
      return 'Vui lòng nhập tên hợp lệ! ';
    }
    return null;
  }

  var nameErrorText = Rx<String?>(null);
  //#endregion

  //#region EMAIL
  var email = ''.obs;

  String? emailValidator() {
    if (!SignInController.inst.emailRegex.hasMatch(email.value)) {
      return 'Vui lòng nhập Gmail hợp lệ!';
    }

    return null;
  }

  var emailErrorText = Rx<String?>(null);
  //#endregion

  //#region PASSWORD
  var password = ''.obs;

  String? passwordValidator() {
    if (!SignInController.inst.passwordRegex.hasMatch(password.value)) {
      return passwordHint;
    }
    return null;
  }

  var passwordErrorText = Rx<String?>(null);
  final String passwordHint = 'Mậtkhẩucó8chữvàsố'; ///gợi ý password
  //#endregion

  void validateAndSignUp() async {
    var validationSuccess = true;

    // validate password
    if (password.value.isEmpty) {
      passwordErrorText.value = 'Vui lòng nhập mật khẩu của bạn!';
      validationSuccess = false;
    } else {
      passwordErrorText.value = passwordValidator();
      if (passwordErrorText.value != null) {
        validationSuccess = false;
      }
    }

    // validate email
    if (email.isEmpty) {
      emailErrorText.value = 'Vui lòng nhập Gmail của bạn!';
      validationSuccess = false;
    } else {
      emailErrorText.value = emailValidator();
      if (emailErrorText.value != null) {
        validationSuccess = false;
      }
    }

    // validate name
    if (name.isEmpty) {
      nameErrorText.value = 'Vui lòng nhập tên của bạn!';
      validationSuccess = false;
    } else {
      nameErrorText.value = nameValidator();
      if (nameErrorText.value != null) {
        validationSuccess = false;
      }
    }

    if (validationSuccess) {
      await _onSuccessValidation();
      return;
    } else {
      FadedOverlay.remove();
    }
  }

  void resetData() {
    name.value = '';
    nameErrorText.value = null;

    email.value = '';
    emailErrorText.value = null;

    password.value = '';
    passwordErrorText.value = null;
  }

  Future<void> _onSuccessValidation() async {
    try {
      var credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      await credentials.user!.sendEmailVerification();
      updateToken();
      if (credentials.additionalUserInfo!.isNewUser) {
        createNewUserData(name: name.value);
      }
      // await FirebaseAuth.instance.signOut();
      FadedOverlay.remove();
      Get.off(const VerifyPage());
      // show dialog for success registration, press btn to confirm and then navigate to sign in screen
      // await Get.defaultDialog(
      //     title: 'Successful registration',
      //     middleText: 'Please check your mail box to verify your email',
      //     onWillPop: () async {
      //       Get.offAll(() => const SignIn());
      //       return true;
      //     });
    } on FirebaseAuthException catch (e) {
      FadedOverlay.remove();
      switch (e.code) {
        case 'email-already-in-use':
          emailErrorText.value = 'Email này đã được sử dụng, hãy thử một email khác.';
          break;
        case 'invalid-email':
          emailErrorText.value = 'Email không hợp lệ, hãy thử một email khác';
          break;
        case 'weak-password':
          passwordErrorText.value = 'Mật khẩu yếu, hãy thử một mật khẩu khác';
          break;
      }
    } catch (e) {
      FadedOverlay.remove();
      showError(e);
    }

    return;
  }
}
