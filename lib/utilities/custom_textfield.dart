import 'package:flutter/material.dart';
import '../theme.dart';

class MyCustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final VoidCallback? suffixOnPress;
  final VoidCallback? onTap;
  // final String labelText;
  final IconData? prefixIcon;
  final Color borderColor;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final Color? hintColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool? enabled;
  final bool? errorBool;
  final bool readOnly;
  final String? errorText;
  final int? maxLines;
  // final double? elevation;
  const MyCustomTextField({
    super.key,
    this.hintText,
    required this.borderColor,
    this.onTap,
    this.labelText,
    this.enabled,
    this.errorBool,
    this.readOnly = false,
    this.errorText,
    this.fontWeight,
    this.hintColor,
    this.textColor,
    this.suffixIcon,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixOnPress,
    // this.elevation,
    this.textInputType,
    this.controller,
    this.maxLines,
  });

  @override
  State<MyCustomTextField> createState() => _MyCustomTextFieldState();
}

class _MyCustomTextFieldState extends State<MyCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          TextField(
            onTap: widget.onTap,
            controller: widget.controller,
            keyboardType: widget.textInputType,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            style: TextStyle(color: widget.textColor),
            decoration: InputDecoration(
              labelText: widget.labelText,
              suffixIcon: IconButton(onPressed: widget.suffixOnPress, icon: Icon(widget.suffixIcon)),
              focusColor: Colors.grey,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: widget.hintColor, fontWeight: widget.fontWeight,fontSize: 12),
            ),
          ),
          if (widget.errorBool == true)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: redColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: p / 2, horizontal: p),
              child: Text(
                widget.errorText ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
