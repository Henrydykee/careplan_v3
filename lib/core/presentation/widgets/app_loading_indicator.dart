import 'dart:io';

import 'package:careplan/core/resources/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../platform/color.dart';

/// App-wide loading indicator matching the design pattern used in [LoaderWrapper].
/// Use for inline loading states (e.g. Center(child: AppLoadingIndicator())).
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        radius: 20,
        color: CarePlanColor.brown,
      );
    }
    return SizedBox(
      height: 40,
      width: 40,
      child: CircularProgressIndicator(
        backgroundColor: newprojectColor.grey_4,
        strokeWidth: 5,
        valueColor: const AlwaysStoppedAnimation<Color>(CarePlanColor.brown),
      ),
    );
  }
}
