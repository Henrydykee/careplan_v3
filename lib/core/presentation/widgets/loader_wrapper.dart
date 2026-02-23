import 'package:careplan/core/presentation/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';

import '../../platform/color.dart';

class LoaderWrapper extends StatefulWidget {
  final bool? isLoading;
  final Widget? view;

  LoaderWrapper({Key? key, this.isLoading, this.view}) : super(key: key);

  @override
  _LoaderWrapperState createState() => _LoaderWrapperState();
}

class _LoaderWrapperState extends State<LoaderWrapper> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.view!,
      if (widget.isLoading ?? false)
        Scaffold(
          backgroundColor: Colors.transparent,
          body: IgnorePointer(
            ignoring: true,
            child: Container(
              color: newprojectColor.dark_blue.withOpacity(0.76),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: newprojectColor.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const AppLoadingIndicator(),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
