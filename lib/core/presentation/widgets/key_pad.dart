import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';

class CarePlanKeyPad extends StatelessWidget {
  final onKeyPress;
  final Function? biometricOnTap;
  final bool visible;
  final Widget? leftAction;
  final Widget? rightAction;

  CarePlanKeyPad({
    required this.onKeyPress,
    this.visible = false,
    this.biometricOnTap,
    this.leftAction,
    this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          for (final keyRow in keyValues)
            TableRow(
              children: List.generate(
                keyRow.length,
                (index) {
                  final keyCell = keyRow[index];
                  if (keyCell == 'right') {
                    return leftAction ??
                        EquityKeyCell.withChild(
                          value: 'backspace',
                          onTap: (val) {
                            onKeyPress(val);
                          },
                          child: Icon(
                            Icons.backspace,
                            color: Colors.black,
                          ),
                        );
                  }
                  if (keyCell == 'left') {
                    return rightAction ?? SizedBox();
                  }
                  return EquityKeyCell(
                    value: keyCell,
                    onTap: (val) {
                      onKeyPress(val);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class EquityKeyCell extends StatelessWidget {
  final onTap;
  final Widget? child;
  final String? value;
  final bool _hasChild;

  EquityKeyCell({
    this.onTap,
    required this.value,
  })  : child = Offstage(),
        _hasChild = false;

  EquityKeyCell.withChild({
    this.onTap,
    this.child,
    this.value,
  }) : _hasChild = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(value!),
      onTap: () {
        if (onTap != null) {
          onTap(value);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Center(
          child: _hasChild
              ? child
              : Text(
                  value ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: CarePlanColor
                    .grey_2.withValues(alpha: 0.7)
                  ),
                ),
        ),
      ),
    );
  }
}

List<List<String>> get keyValues {
  return [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['left', '0', 'right'],
  ];
}