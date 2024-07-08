import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomNavItem extends StatelessWidget {
  const CustomNavItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    return InkWell(
      onTap: () {
        onTap.call(index);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: (index == selectedIndex) ? AppColor.themeColor : AppColor.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: (index == selectedIndex) ? AppColor.themeColor : AppColor.grey,
                fontWeight: (index == selectedIndex) ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}