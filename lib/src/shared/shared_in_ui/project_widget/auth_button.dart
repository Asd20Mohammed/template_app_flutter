import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String? submitText;
  final VoidCallback? onTab;
  final Color? color;
  final String? icon;

  const AuthButton({
    super.key,
    this.submitText,
    this.onTab,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset(icon ?? '', height: 20, width: 20),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
      ),
      onPressed: onTab,
      label: Text(
        submitText ?? '',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
