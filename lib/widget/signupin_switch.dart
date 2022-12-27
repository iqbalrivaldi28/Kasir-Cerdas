import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/shapes.dart';

class SignUpInSwitch extends StatelessWidget {
  const SignUpInSwitch({
    Key? key,
    this.onSignUp,
    this.onSignIn,
  }) : super(key: key);

  final VoidCallback? onSignUp;
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: mrRadius,
      color: const Color(0xff80D0F2),
      child: LayoutBuilder(
        builder: (_, constraint) {
          return Stack(
            children: [
              SizedBox(
                width: constraint.maxWidth / 2,
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xff00A1E4),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: onSignUp,
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onSignIn,
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
