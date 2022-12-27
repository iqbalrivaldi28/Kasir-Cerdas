import 'package:flutter/material.dart';
import 'package:kasir_cerdas/constant/shapes.dart';

class CircleTextButton extends StatelessWidget {
  const CircleTextButton(
    this.text, {
    Key? key,
    this.onTap,
    this.color,
  }) : super(key: key);

  final VoidCallback? onTap;

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Material(
        color: color ?? Colors.grey,
        clipBehavior: Clip.antiAlias,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 32,
                color: color == null ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton(
    this.icon, {
    Key? key,
    this.onTap,
    this.color,
  }) : super(key: key);

  final VoidCallback? onTap;

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Material(
        color: color ?? Colors.grey,
        clipBehavior: Clip.antiAlias,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: color == null ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleExtendedButton extends StatelessWidget {
  const CircleExtendedButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 60,
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const StadiumBorder(),
        color: Colors.grey,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: const [
              mhDivider,
              Text(
                '0',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
