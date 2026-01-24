import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'asrs_result_insight_screen.dart';

class ASRSResultHistoryScreen extends StatefulWidget {
  ASRSResultHistoryScreen({super.key});

  @override
  State<ASRSResultHistoryScreen> createState() => _ASRSResultHistoryScreenState();
}

class _ASRSResultHistoryScreenState extends State<ASRSResultHistoryScreen> {
  static const _mockDates = [
    "Monday, Jan 20, 2025",
    "Thursday, Jan 16, 2025",
    "Sunday, Jan 12, 2025",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
        color: CarePlanColor.brown,
        backButtonColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: CarePlanColor.brown,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextHolder(
                  title: "ASRS Test",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: "See results for all ASRS tests",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButtom(
                      title: "Take Test",
                      onTap: () {},
                    ),
                  ),
                  Gap(20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mockDates.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AsrsResultInsightScreen(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextHolder(
                                  title: _mockDates[index],
                                  fontWeight: FontWeight.w800,
                                  size: 13,
                                ),
                                Icon(Icons.arrow_forward_ios, color: CarePlanColor.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
