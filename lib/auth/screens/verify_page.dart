import 'dart:async';
import 'package:chat_app/auth/controllers/on_will_pop.dart';
import 'package:chat_app/chat/you_are_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool isEmailVerify = false;
  bool canResendEmail = false;
  Timer? timer;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerify) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerify) {
      timer!.cancel();
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      setState(() => canResendEmail = false);
      Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => onWillPop(
          action: (now) => currentBackPressTime = now,
          currentBackPressTime: currentBackPressTime,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: [
                const Text(
                  "Xác nhận Email",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  isEmailVerify
                      ? 'Chúc mừng email của bạn đã được xác minh'
                      : 'Vui lòng kiểm tra email của bạn ,xác minh email của bạn',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  isEmailVerify
                      ? 'assets/images/email.png'
                      : 'assets/images/gmail.png',
                  width: 120,
                ),
                const SizedBox(height: 20),
                if (isEmailVerify)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.off(const YouAreIn());
                      },
                      icon: const Icon(FontAwesomeIcons.house),
                      label: const Text(
                        "Vào ứng dụng",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(252, 107, 104, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                if (!isEmailVerify)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: canResendEmail
                          ? () {
                              sendVerificationEmail();
                            }
                          : null,
                      icon: const Icon(FontAwesomeIcons.envelope),
                      label: const Text("Gửi lại email",
                          style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(252, 107, 104, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                if (!isEmailVerify) const SizedBox(height: 10),
                if (!isEmailVerify)
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                    child: const Text(
                      "Hủy bỏ",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
