import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicTextField extends StatelessWidget {
  const BasicTextField({
    Key? key,
    this.hint,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.formatter,
    this.keyboardType,
  }) : super(key: key);

  final String? hint;
  final TextEditingController? controller;
  final bool readOnly;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? formatter;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 12),
      inputFormatters: formatter,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        label: hint != null ? Text(hint!) : null,
      ),
    );
  }
}
