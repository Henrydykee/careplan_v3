import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/web_view_screen.dart';
import 'package:careplan/features/history/data/models/billing_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class BillingDetailScreen extends StatelessWidget {
  final BillingHistoryItemModel billingHistoryItem;

  const BillingDetailScreen({super.key, required this.billingHistoryItem});

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryItem;
    final formattedDate = DateFormat('d MMM yyyy').format(data.date);

    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: data.patient?.name ?? "Billing Details",
      ),
      body: Column(
        children: [
          const Gap(20),
          if (data.invoiceURL.isNotEmpty)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(url: data.invoiceURL),
                  ),
                );
              },
              child: _buildSummaryCard(
                title: "Invoice",
                amount: "\$${data.amount}",
                subtitle: formattedDate,
                showChevron: true,
              ),
            ),
          const Gap(20),
          _buildInfoCard(
            title: "Status",
            value: data.status,
          ),
          if (data.sessionId != null) ...[
            const Gap(20),
            _buildInfoCard(
              title: "Session ID",
              value: data.sessionId!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    String? subtitle,
    bool showChevron = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextHolder(
                      title: title,
                      color: const Color(0xFF68696C),
                      fontWeight: FontWeight.w600,
                      size: 14,
                    ),
                    const Gap(4),
                    TextHolder(
                      title: amount,
                      color: const Color(0xFF68696C),
                      fontWeight: FontWeight.w700,
                      size: 18,
                    ),
                    if (subtitle != null) ...[
                      const Gap(4),
                      TextHolder(
                        title: subtitle,
                        color: const Color(0xFF848588),
                        fontWeight: FontWeight.w400,
                        size: 12,
                      ),
                    ],
                  ],
                ),
              ),
              if (showChevron) const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextHolder(
                title: title,
                color: const Color(0xFF848588),
                fontWeight: FontWeight.w500,
                size: 14,
              ),
              TextHolder(
                title: value,
                color: const Color(0xFF4E4F51),
                fontWeight: FontWeight.w600,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
