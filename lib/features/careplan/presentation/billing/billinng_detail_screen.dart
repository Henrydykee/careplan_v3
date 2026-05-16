import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/core/presentation/widgets/web_view_screen.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/careplan/presentation/widgets/billing_detail_components.dart';
import 'package:careplan/features/careplan/presentation/widgets/billing_status_color.dart';
import 'package:careplan/features/history/data/models/billing_history_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class BillingDetailScreen extends StatelessWidget {
  final BillingHistoryItemModel billingHistoryItem;

  const BillingDetailScreen({super.key, required this.billingHistoryItem});

  String? _cardUsed() {
    final brand = billingHistoryItem.cardType?.trim();
    final last4 = billingHistoryItem.lastFourDigits?.trim();
    if ((brand == null || brand.isEmpty) &&
        (last4 == null || last4.isEmpty)) {
      return null;
    }
    if (brand != null && brand.isNotEmpty && last4 != null && last4.isNotEmpty) {
      return "$brand •••• $last4";
    }
    if (last4 != null && last4.isNotEmpty) {
      return "•••• $last4";
    }
    return brand;
  }

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryItem;
    final formattedDate = DateFormat('d MMM yyyy').format(data.date);
    final status = data.status.trim();
    final statusLabel =
        status.isNotEmpty ? toBeginningOfSentenceCase(status) : '—';
    final statusAccent = billingStatusColor(status);
    final cardUsed = _cardUsed();
    final hasInvoice = data.invoiceURL.isNotEmpty;

    void openInvoice() {
      if (!hasInvoice) return;
      router.push(WebViewScreen(url: data.invoiceURL));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackIcon: true,
        title: "Billing Details",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BillingSummaryCard(
              amount: data.amount,
              date: formattedDate,
              statusLabel: statusLabel,
              statusAccent: statusAccent,
              patientName: data.patient?.name,
            ),
            const Gap(20),
            BillingDetailsCard(
              rows: [
                BillingDetailRow(label: "Date", value: formattedDate),
                BillingDetailRow(
                  label: "Card Used",
                  value: cardUsed ?? "—",
                ),
                BillingDetailRow(
                  label: "Status",
                  value: statusLabel,
                  valueColor: statusAccent,
                ),
                BillingDetailRow(
                  label: "Session ID",
                  value: (data.sessionId != null && data.sessionId!.isNotEmpty)
                      ? data.sessionId!
                      : "—",
                ),
                BillingDetailRow(
                  label: "Invoice",
                  value: hasInvoice ? "View" : "—",
                  valueColor:
                      hasInvoice ? CarePlanColor.orange : CarePlanColor.grey_3,
                  valueWeight: FontWeight.w700,
                  onTap: hasInvoice ? openInvoice : null,
                  showChevron: hasInvoice,
                ),
                BillingDetailRow(
                  label: "Amount",
                  value: "\$${data.amount}",
                  valueColor: CarePlanColor.brown,
                  valueWeight: FontWeight.w800,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
