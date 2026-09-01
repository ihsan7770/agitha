import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  final double width;
  final double height;
  final double iconSize;
  final double textSize;
  final String text;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const NoInternetWidget({
    super.key,
    required this.width,
    required this.height,
    this.iconSize = 30,
    this.textSize = 8,
    this.text = "No Internet",
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.iconColor = Colors.grey,
    this.textColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(height: 6),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
