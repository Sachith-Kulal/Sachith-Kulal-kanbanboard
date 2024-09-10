import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CustomCheckBoxView extends GetView {
  const CustomCheckBoxView(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.borderColor});

  final bool value;
  final void Function(bool?) onChanged;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: value
            ? const Center(
                child: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.blue,
                ),
              )
            : null,
      ),
    );
  }
}
