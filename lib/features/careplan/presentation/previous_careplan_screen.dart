import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../data/mock_billing_data.dart';
import 'care_plan_summary_screen.dart';

String _formatDate(String? dateStr) {
  final d = FormatUtils.dateTimeFormatter(dateStr, format: "d MMM yyyy");
  return d.isNotEmpty ? d : "N/A";
}

class PreviousCareplanScreen extends StatelessWidget {
  const PreviousCareplanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = MockBillingData.carePlanHistory;

    if (history.isEmpty) {
      return Center(
        child: TextHolder(
          title: "You don't have any history",
          color: Colors.black,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, i) {
          final item = history[i];
          return _PreviousCareplanComponent(
            date: _formatDate(item.createdAt),
            id: item.sId,
            doctorType: item.doctorType,
          );
        },
      ),
    );
  }
}

class _PreviousCareplanComponent extends StatelessWidget {
  final String? date;
  final String? id;
  final String? doctorType;

  const _PreviousCareplanComponent({
    this.date,
    this.id,
    this.doctorType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CareplanSummaryScreen(careplanId: id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHolder(
                          title: "Created on:",
                          size: 13,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.grey_2.withValues(alpha: 0.7),
                        ),
                        TextHolder(
                          title: date ?? "N/A",
                          size: 13,
                          fontWeight: FontWeight.w800,
                          color: CarePlanColor.grey_2,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/brown_check_icon.svg"),
                    const Gap(5),
                    TextHolder(
                      title: doctorType ?? "",
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: CarePlanColor.grey_2.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
