import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../data/mock_billing_data.dart';
import 'billing_modal_sheet.dart';

class BillingDetailScreen extends StatelessWidget {
  final MockBillingHistory? billingHistoryData;

  const BillingDetailScreen({super.key, this.billingHistoryData});

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryData ?? MockBillingData.billingHistory.first;

    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        title: data.patientName ?? "Billing Details",
      ),
      body: Column(
        children: [
          const Gap(20),
          if ((data.type?.toLowerCase() ?? "") != "no claim")
            InkWell(
              onTap: () => billingModalBottomSheet(
                context,
                billingHistoryData: data,
              ),
              child: _buildSummaryCard(
                title: (data.type?.toLowerCase() ?? "") != "no claim"
                    ? "Medicare Summary"
                    : "No Rebate",
                amount: "\$${data.totalAmount ?? 0}",
                imagePath: (data.type?.toLowerCase() ?? "") != "no claim"
                    ? "assets/images/medicare.png"
                    : null,
              ),
            ),
          const Gap(20),
          if ((data.type?.toLowerCase() == "medicare") ||
              (data.dateOfBilling?.isNotEmpty == true))
            InkWell(
              onTap: () {
                if ((data.source?.toLowerCase() ?? "") == "session") {
                  pinPaymentModalBottomSheet(
                    context,
                    billingHistoryData: data,
                  );
                } else {
                  stripeModalBottomSheet(
                    context,
                    billingHistoryData: data,
                  );
                }
              },
              child: _buildSummaryCard(
                title: "Bill Summary",
                amount: "\$${data.totalCardAmount ?? 0}",
                imagePath: (data.cardType?.toLowerCase() ?? "") == "mastercard"
                    ? "assets/images/master_card.svg"
                    : (data.cardType?.toLowerCase() ?? "") == "visa"
                        ? "assets/images/visa_card.svg"
                        : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    String? imagePath,
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
              Column(
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
                  const Gap(4),
                  if (imagePath != null)
                    imagePath.endsWith('.svg')
                        ? SvgPicture.asset(imagePath)
                        : Image.asset(imagePath),
                ],
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
