import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showLogoutConfirmationSheet({
  required BuildContext context,
  required Future<void> Function() onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (sheetContext) {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: 20,
              bottom: 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "Log out?",
                  color: CarePlanColor.brown,
                  size: 20,
                  fontWeight: FontWeight.w700,
                ),
                const Gap(10),
                TextHolder(
                  title:
                      "You will need to sign in again to access your account.",
                  color: CarePlanColor.grey_3,
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
                const Gap(24),
                CustomButtom(
                  title: "Cancel",
                  btnColor: CarePlanColor.grey_5,
                  textColor: CarePlanColor.grey,
                  onTap: () => Navigator.of(sheetContext).pop(),
                ),
                const Gap(12),
                CustomButtom(
                  title: "Log out",
                  btnColor: Colors.red.shade700,
                  textColor: Colors.white,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await onConfirm();
                  },
                ),
                const Gap(30),
              ],
            ),
          ),
        ],
      );
    },
  );
}
