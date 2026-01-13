

import 'package:careplan/core/utils/color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: isActive? 9: 8,
      width:  isActive? 30: 8,
      decoration: BoxDecoration(
          //border: Border.all(color: MFMColors.Seagreen),
          color: isActive ? CarePlanColor.orange : Color(0xFF9D9FAD),
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}

// ignore: must_be_immutable
class HomeSlideDots extends StatelessWidget {
  bool isActive;
  HomeSlideDots(this.isActive);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: isActive? 8: 8,
      width:  isActive? 8: 8,
      decoration: BoxDecoration(
          //border: Border.all(color: MFMColors.Seagreen),
          color: isActive ? Color(0xFF6A451A): Color(0xFF9D9FAD),
          borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}