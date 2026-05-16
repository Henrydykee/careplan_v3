import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/careplan/presentation/billinng_detail_screen.dart';
import 'package:careplan/features/careplan/presentation/widgets/billing_status_color.dart';
import 'package:careplan/features/history/data/models/billing_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class BillingHistoryCard extends StatelessWidget {
  final BillingHistoryItemModel billingHistoryItem;

  const BillingHistoryCard({super.key, required this.billingHistoryItem});

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryItem;
    final formattedDate = DateFormat('d MMM yyyy').format(data.date);
    final status = (data.status).trim();
    final statusLabel =
        status.isNotEmpty ? toBeginningOfSentenceCase(status) : '';
    final statusAccent = billingStatusColor(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BillingDetailScreen(
                  billingHistoryItem: data,
                ),
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: CarePlanColor.grey_5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: CarePlanColor.light_orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: CarePlanColor.brown,
                      size: 22,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextHolder(
                                title: "\$${data.amount}",
                                color: CarePlanColor.brown,
                                size: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (statusLabel.isNotEmpty) ...[
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusAccent.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextHolder(
                                  title: statusLabel,
                                  color: statusAccent,
                                  size: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const Gap(4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: CarePlanColor.grey_3,
                            ),
                            const Gap(4),
                            TextHolder(
                              title: formattedDate,
                              color: CarePlanColor.grey_3,
                              size: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            if (data.sessionId != null &&
                                data.sessionId!.isNotEmpty) ...[
                              const Gap(8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: CarePlanColor.grey_3,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const Gap(8),
                              Flexible(
                                child: TextHolder(
                                  title: "Session #${data.sessionId}",
                                  color: CarePlanColor.grey_3,
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: CarePlanColor.grey_3,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
