
import 'package:flutter/material.dart';

class AppStyles {
  static const double buttonWidth = 170.0;
  static const double buttonHeight = 45.0;
  static const double fontSize = 16.0;
  static const double fontSizeTitle = 20.0;
  static const Color buttonColor = Color(0xFF8E97FD);

  static ButtonStyle elevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return buttonColor.withOpacity(0.4);
        }
        if (states.contains(MaterialState.hovered)) {
          return buttonColor.withOpacity(0.8);
        }
        return buttonColor;
      },
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    fixedSize: MaterialStateProperty.all(const Size(buttonWidth, buttonHeight)),
    overlayColor: MaterialStateProperty.all(buttonColor.withOpacity(0.2)),
    animationDuration: const Duration(milliseconds: 200),
  );

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: fontSizeTitle,
  );

  static const TextStyle normalTextStyle = TextStyle(
    fontSize: fontSize,
  );

  static const double dialogWidth = 480.0;
  static const double dialogHeight = 402.0;
}