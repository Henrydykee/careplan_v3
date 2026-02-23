import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';

class newprojectBackButton extends StatelessWidget {
  final Function()? onTap;
  final Color? iconColor;

  newprojectBackButton({this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Container(
        height: 60,
        width: 50,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.chevron_left,
          size: 28,
          color: iconColor ?? CarePlanColor.grey,
        ),
      ),
    );
  }
}
