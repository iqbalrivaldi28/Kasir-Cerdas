import 'package:flutter/material.dart';

class MySeparator extends StatelessWidget {
  const MySeparator({
    Key? key,
    this.height = 1,
    this.color = Colors.black,
    this.width = 5,
    this.padding = 8,
  }) : super(key: key);
  final double height;
  final Color color;
  final double width;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * width)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: SizedBox(
                width: width,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
