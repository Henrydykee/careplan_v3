import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../data/mock_billing_data.dart';
import 'billinng_detail_screen.dart';

class BillingHistoryScreen extends StatelessWidget {
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = MockBillingData.billingHistory;

    if (history.isEmpty) {
      return Center(
        child: TextHolder(
          title: "You don't have any history",
          color: Colors.black,
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: history.length,
          itemBuilder: (context, i) => BillingHistoryComponent(
            billingHistoryData: history[i],
          ),
        ),
      ),
    );
  }
}

class BillingHistoryComponent extends StatelessWidget {
  final MockBillingHistory? billingHistoryData;

  const BillingHistoryComponent({super.key, this.billingHistoryData});

  @override
  Widget build(BuildContext context) {
    final data = billingHistoryData;
    if (data?.totalAmount == null || data?.totalAmount == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillingDetailScreen(
                billingHistoryData: data,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: data?.practitionerName ?? "",
                  size: 16,
                  color: const Color(0xFF68696C),
                  fontWeight: FontWeight.w600,
                ),
                const Gap(4),
                TextHolder(
                  title: "\$${data?.totalAmount}",
                  size: 18,
                  color: const Color(0xFF4E4F51),
                  fontWeight: FontWeight.w700,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHolder(
                      title: data?.dateOfBilling ?? "",
                      size: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: TextHolder(
                          title: toBeginningOfSentenceCase(data?.type ?? ""),
                          size: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB17F34),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
