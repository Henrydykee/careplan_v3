import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BillingSummaryCard extends StatelessWidget {
  final String amount;
  final String date;
  final String statusLabel;
  final Color statusAccent;
  final String? patientName;

  const BillingSummaryCard({
    super.key,
    required this.amount,
    required this.date,
    required this.statusLabel,
    required this.statusAccent,
    this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  children: [
                    TextHolder(
                      title: "\$$amount",
                      color: CarePlanColor.brown,
                      size: 22,
                      fontWeight: FontWeight.w900,
                    ),
                    const Gap(2),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: CarePlanColor.grey_3,
                        ),
                        const Gap(4),
                        TextHolder(
                          title: date,
                          color: CarePlanColor.grey_3,
                          size: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
          ),
          if (patientName != null && patientName!.isNotEmpty) ...[
            const Gap(14),
            Container(
              height: 1,
              color: CarePlanColor.grey_5,
            ),
            const Gap(14),
            TextHolder(
              title: "PATIENT",
              color: CarePlanColor.grey_3,
              size: 11,
              fontWeight: FontWeight.w700,
            ),
            const Gap(4),
            TextHolder(
              title: patientName!,
              color: CarePlanColor.grey,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ],
      ),
    );
  }
}

class BillingDetailsCard extends StatelessWidget {
  final List<BillingDetailRow> rows;

  const BillingDetailsCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i != rows.length - 1) {
        children.add(Container(height: 1, color: CarePlanColor.grey_5));
      }
    }
    return Container(
      width: double.infinity,
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
      child: Column(children: children),
    );
  }
}

class BillingDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? valueWeight;
  final VoidCallback? onTap;
  final bool showChevron;

  const BillingDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueWeight,
    this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: TextHolder(
              title: label,
              color: CarePlanColor.grey_3,
              size: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(12),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: TextHolder(
                    title: value,
                    color: valueColor ?? CarePlanColor.grey,
                    size: 14,
                    fontWeight: valueWeight ?? FontWeight.w600,
                    align: TextAlign.right,
                  ),
                ),
                if (showChevron) ...[
                  const Gap(4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: CarePlanColor.grey_3,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
