import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kasir_cerdas/model/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    this.onPageChanged,
    this.currentIndex = 0,
  }) : super(key: key);

  final ValueChanged<int>? onPageChanged;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: Row(
          children: NavItem.list.mapIndexed(
        (i, e) {
          return Expanded(
            child: SizedBox(
              child: InkWell(
                onTap: () {
                  onPageChanged?.call(i);
                },
                child: Column(
                  children: [
                    Image.asset(
                      e.image,
                      height: 24,
                      color: i == currentIndex ? Colors.blue : Colors.black54,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        color: i == currentIndex ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList()),
    );
  }
}
