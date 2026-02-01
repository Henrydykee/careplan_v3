import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/web_view_screen.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../data/mock_billing_data.dart';

void billingModalBottomSheet(
  BuildContext context, {
  MockBillingHistory? billingHistoryData,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  TextHolder(
                    title: "${billingHistoryData?.type ?? "Billing"} Summary",
                    fontWeight: FontWeight.w700,
                    size: 18,
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  TextHolder(
                    title: "MEDICARE NUMBER",
                    fontWeight: FontWeight.w500,
                    size: 12,
                  ),
                  TextHolder(
                    title: billingHistoryData?.medicareNum ?? "N/A",
                    fontWeight: FontWeight.w600,
                    size: 14,
                    color: const Color(0xFF4E4F51),
                  ),
                  const Gap(8),
                  TextHolder(
                    title: "Claim ID",
                    fontWeight: FontWeight.w500,
                    size: 12,
                  ),
                  TextHolder(
                    title: billingHistoryData?.claimId ?? "N/A",
                    fontWeight: FontWeight.w600,
                    size: 14,
                    color: const Color(0xFF4E4F51),
                  ),
                  const Gap(8),
                  TextHolder(
                    title: "Individual Reference Number (IRN)",
                    fontWeight: FontWeight.w500,
                    size: 12,
                  ),
                  TextHolder(
                    title: billingHistoryData?.irn ?? "N/A",
                    fontWeight: FontWeight.w600,
                    size: 14,
                    color: const Color(0xFF4E4F51),
                  ),
                  const Gap(8),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Claim Type",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.type ?? "N/A",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Transaction ID",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.transactionId ?? "",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Claim Amount",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: "\$${billingHistoryData?.totalAmount ?? 0}",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Medicare Status",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.status ?? "N/A",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Date of Services",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.dateOfBilling ?? "N/A",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: _OutlinedButton(
                  title: (billingHistoryData?.type?.toLowerCase() ?? "") == "bulkbill"
                      ? "View DB4 Benefit Assignment Form"
                      : "View Lodgement Form",
                  onTap: () {
                    Navigator.of(context).pop();
                    final url = billingHistoryData?.claimPdfUrl ?? "https://example.com";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(url: url),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _OutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _OutlinedButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: CarePlanColor.orange),
        ),
        child: Center(
          child: TextHolder(
            title: title,
            size: 18,
            color: CarePlanColor.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

void pinPaymentModalBottomSheet(
  BuildContext context, {
  MockBillingHistory? billingHistoryData,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  TextHolder(
                    title: "Card Billing",
                    fontWeight: FontWeight.w700,
                    size: 18,
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Date Paid",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.dateOfBilling ?? "N/A",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Payment Method",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.cardType != null
                            ? "${billingHistoryData?.cardType}....${billingHistoryData?.lastFourDigits}"
                            : "",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Total Charge Amount",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: "\$${billingHistoryData?.totalAmount ?? 0}",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(30),
              _OutlinedButton(
                title: "View Provider Tax Invoice",
                onTap: () {
                  Navigator.of(context).pop();
                  final url = billingHistoryData?.providerTaxURL ?? "https://example.com";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(url: url),
                    ),
                  );
                },
              ),
              const Gap(30),
            ],
          ),
        ),
      );
    },
  );
}

void stripeModalBottomSheet(
  BuildContext context, {
  MockBillingHistory? billingHistoryData,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(16),
                  TextHolder(
                    title: "Card Billing",
                    fontWeight: FontWeight.w700,
                    size: 18,
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Date Paid",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.dateOfBilling ?? "N/A",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Session Amount",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: "",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Payment Method",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: billingHistoryData?.cardType == null
                            ? "N/A"
                            : "${billingHistoryData?.cardType}.....${billingHistoryData?.lastFourDigits}",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                  const Gap(16),
                  const Divider(),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHolder(
                        title: "Total Charge Amount",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: const Color(0xFF848588),
                      ),
                      TextHolder(
                        title: "\$${billingHistoryData?.totalCardAmount ?? 0}",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: const Color(0xFF4E4F51),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(30),
              _OutlinedButton(
                title: "View Receipt",
                onTap: () {
                  Navigator.of(context).pop();
                  final receiptUrl = billingHistoryData?.receiptURL;
                  if (receiptUrl != null && receiptUrl.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(url: receiptUrl),
                      ),
                    );
                  }
                },
              ),
              const Gap(30),
            ],
          ),
        ),
      );
    },
  );
}
