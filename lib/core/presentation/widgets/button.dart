import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:flutter/material.dart';

import '../../platform/color.dart';

class CustomButtom extends StatelessWidget {
  final Color? btnColor;
  final String? title;
  final Function()? onTap;
  final Color? textColor;
  final bool? isdisabled;
  final double? textSize;
  final double? height;
  final double? width;
  final String? assetImage;


  CustomButtom(
      {this.btnColor,
      this.title,
      this.onTap,
        this.isdisabled = false,
      this.textColor,
      this.textSize,
        this.assetImage,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isdisabled == true ? (){} : () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        if (onTap != null) {
          onTap!();
        } else {
          // // Fallback to router.pop() when onTap is not provided
          // router.pop();
        }
      },
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isdisabled == true 
            ? newprojectColor.grey.withOpacity(0.5)
            : (btnColor ?? const Color(0xFFFD9C43)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: TextHolder(
              title: title ?? "",
              size: textSize ?? 18,
              color: isdisabled == true 
                ? Colors.white.withOpacity(0.5)
                : (textColor ?? Colors.white),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


class ViewAllButton extends StatelessWidget {
  const ViewAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: newprojectColor.light_green,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: newprojectColor.green)),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 11),
          child: TextHolder(
            title: 'View All',
            color: Colors.black,
            fontWeight: FontWeight.w600,
          )
      ),
    );
  }
}

