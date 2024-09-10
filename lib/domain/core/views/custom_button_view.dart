import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../status/button_status.dart';

class CustomButtonView extends GetView {
  const CustomButtonView(
      {super.key,
      this.buttonStatus = ButtonStatus.enable,
      this.onPressed,
      this.fontSize = 25,
      this.text = "Next",
      this.fontWeight = FontWeight.w500});

  final ButtonStatus buttonStatus;
  final Function()? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      onPressed: buttonStatus == ButtonStatus.enable
          ? () {
              onPressed!();
            }
          : null,
      child: buttonStatus == ButtonStatus.loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            )
          : Center(
              child: Text(
                text,
                style: TextStyle(
                  height: 1,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
      // }
      // ),
    );
  }
}
