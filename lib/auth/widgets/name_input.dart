import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sign_up.dart';

class NameInput extends StatefulWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  // Not focus for default, if widget is settled to be auto focused, this init will make no sense
  bool isOnFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: (value) {
        if (value) {
          // reset error text
          SignUpController.inst.nameErrorText.value = null;

          setState(() {
            isOnFocus = !isOnFocus;
          });
        } else {
          setState(() {
            isOnFocus = false;
          });
        }
      },
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Obx(
          () => TextFormField(
            validator: (value) {
              if (!isOnFocus && value!.isNotEmpty) {
                return SignUpController.inst.nameValidator();
              }
              return null;
            },
            onChanged: SignUpController.inst.name,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              errorText: SignUpController.inst.nameErrorText.value,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.6),
              ),
              border: const UnderlineInputBorder(),
              label: const Text("Họ & tên", style: TextStyle(fontSize: 16)),
            ),
            autofillHints: const [AutofillHints.name],
            textCapitalization: TextCapitalization.words,
          ),
        ),
      ),
    );
  }
}
