import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: ValidationBuilder().minLength(6).build(),
      decoration: InputDecoration(
        hintText: 'Masukkan Kata Sandi Anda',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
          icon: Icon(
            isHidden ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      obscureText: isHidden,
      style: const TextStyle(fontSize: 12),
    );
  }
}
