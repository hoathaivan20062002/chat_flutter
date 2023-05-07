import 'package:chat_app/auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'ChatApps',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom:50,
              left: 40,
              right: 40,
              child: Center(
                child: CustomButton(
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                  text: 'Bắt đầu',

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
