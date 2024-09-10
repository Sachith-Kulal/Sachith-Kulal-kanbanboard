import 'package:flutter/material.dart';

class Priority {
  static Icon getPriorityIcon({required int priorityType, double size = 16}) {
    return Icon(
      Icons.flag,
      color: getPriorityColor(priorityType: priorityType),
      size: size,
    );
  }

  static Color getPriorityColor({required int priorityType}) {
    switch (priorityType) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;

      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
