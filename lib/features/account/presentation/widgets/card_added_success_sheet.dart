import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<void> showCardAddedSuccessSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const Gap(22),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: CarePlanColor.green.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: CarePlanColor.green,
                    size: 36,
                  ),
                ),
              ),
              const Gap(16),
              TextHolder(
                title: 'Card added',
                color: CarePlanColor.grey,
                size: 18,
                fontWeight: FontWeight.w800,
                align: TextAlign.center,
              ),
              const Gap(8),
              TextHolder(
                title: 'Your card was saved successfully.',
                color: CarePlanColor.grey_3,
                size: 13,
                fontWeight: FontWeight.w400,
                align: TextAlign.center,
              ),
              const Gap(22),
              CustomButtom(
                title: 'Done',
                onTap: () {
                  router.pop();
                  router.pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
