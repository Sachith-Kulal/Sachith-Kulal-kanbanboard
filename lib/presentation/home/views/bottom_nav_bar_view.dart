import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BottomNavBarView extends GetView {
  const BottomNavBarView(
      {super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'all'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.check_box_outline_blank),
          label: 'toDo'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.incomplete_circle_outlined),
          label: 'progress'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.done),
          label: 'done'.tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.check_circle),
          label: 'completed'.tr,
        ),
      ],
    );
  }
}
