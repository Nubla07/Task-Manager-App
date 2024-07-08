import 'package:flutter/material.dart';

class ElevatedIconButton extends StatelessWidget {
  const ElevatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(
        icon,
      ),
    );
  }
}