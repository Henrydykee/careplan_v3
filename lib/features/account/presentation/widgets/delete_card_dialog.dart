import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/card/data/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showDeleteCardDialog({
  required BuildContext context,
  required CardModel card,
  required Future<void> Function() onConfirmDelete,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card_off_rounded,
                size: 36,
                color: Colors.red.shade700,
              ),
            ),
            const Gap(20),
            TextHolder(
              title: "Remove this card?",
              color: CarePlanColor.grey,
              size: 20,
              fontWeight: FontWeight.w700,
            ),
            const Gap(10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: CarePlanColor.light_orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextHolder(
                    title: "**** ${card.lastFourDigits}",
                    fontWeight: FontWeight.w800,
                    color: CarePlanColor.brown,
                    size: 16,
                  ),
                  TextHolder(
                    title: " · ${card.cardType}",
                    fontWeight: FontWeight.w500,
                    color: CarePlanColor.brown,
                    size: 14,
                  ),
                ],
              ),
            ),
            const Gap(14),
            TextHolder(
              title:
                  "This card will be removed from your account.\nYou can add it again anytime.",
              color: CarePlanColor.grey_3,
              size: 14,
              fontWeight: FontWeight.w400,
              align: TextAlign.center,
            ),
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: CustomButtom(
                    title: "Cancel",
                    btnColor: CarePlanColor.grey_5,
                    textColor: CarePlanColor.grey,
                    onTap: () => router.pop(),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: CustomButtom(
                    title: "Remove card",
                    btnColor: Colors.red.shade700,
                    textColor: Colors.white,
                    onTap: () async {
                      router.pop();
                      await onConfirmDelete();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
