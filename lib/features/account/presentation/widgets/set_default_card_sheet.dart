import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/card/data/models/card_model.dart';
import 'package:careplan/features/card/presentation/state/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

void showSetDefaultCardSheet({
  required BuildContext context,
  required CardModel card,
  required Future<bool> Function() onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    builder: (sheetContext) {
      bool isSubmitting = false;
      String? errorText;

      return StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          Future<void> handleConfirm() async {
            if (isSubmitting) return;
            setSheetState(() {
              isSubmitting = true;
              errorText = null;
            });

            final success = await onConfirm();
            if (!context.mounted) return;

            if (success) {
              if (Navigator.of(sheetCtx).canPop()) {
                Navigator.of(sheetCtx).pop();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Default card updated'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            final provider = context.read<CardProvider>();
            setSheetState(() {
              isSubmitting = false;
              errorText = provider.errorMessage.isNotEmpty
                  ? provider.errorMessage
                  : 'Could not update default card. Please try again.';
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
            ),
            child: WillPopScope(
              onWillPop: () async => !isSubmitting,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
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
                      const Gap(18),
                      TextHolder(
                        title: 'Set as default card?',
                        color: CarePlanColor.grey,
                        size: 18,
                        fontWeight: FontWeight.w800,
                        align: TextAlign.center,
                      ),
                      const Gap(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      const Gap(12),
                      TextHolder(
                        title:
                            'We’ll use this card by default for future payments.',
                        color: CarePlanColor.grey_3,
                        size: 13,
                        fontWeight: FontWeight.w400,
                        align: TextAlign.center,
                      ),
                      if (errorText != null) ...[
                        const Gap(12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextHolder(
                            title: errorText!,
                            color: Colors.red.shade700,
                            size: 13,
                            fontWeight: FontWeight.w500,
                            align: TextAlign.center,
                          ),
                        ),
                      ],
                      const Gap(18),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButtom(
                              title: "Cancel",
                              btnColor: CarePlanColor.grey_5,
                              textColor: CarePlanColor.grey,
                              onTap: isSubmitting
                                  ? null
                                  : () => Navigator.of(sheetCtx).pop(),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: CustomButtom(
                              title:
                                  isSubmitting ? "Setting..." : "Set default",
                              onTap: handleConfirm,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
