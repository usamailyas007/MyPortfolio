import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;
  final VoidCallback onTap;
  final FontWeight fontWeight;
  final double fontSize;

  const CustomButton(
      {super.key,
        required this.fontSize,
        required this.fontWeight,
        required this.text,
        required this.width,
        required this.height,
        this.backgroundColor,
        this.textColor,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.onest(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}