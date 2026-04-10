import 'package:flutter/material.dart';
import '../utils/app_size_class.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: getSp(fontSize ?? AppDimensions.fontS),
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? context.appColors.textPrimary,
      ),
    );
  }
}
