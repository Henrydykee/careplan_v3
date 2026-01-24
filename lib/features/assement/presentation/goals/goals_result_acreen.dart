import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GoalsResultScreen extends StatelessWidget {
  const GoalsResultScreen({super.key});

  static const _mockShortTermGoal =
      "Improve sleep schedule and get at least 7 hours of rest each night.";
  static const _mockLongTermGoal =
      "Complete professional certification within the next 12 months.";

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
                  title: "Goals",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: "See your current goals",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/take_test_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHolder(
                        title: "💡 Edit goals",
                        size: 14,
                        fontWeight: FontWeight.w600,
                        color: CarePlanColor.brown,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CarePlanColor.orange,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextHolder(
                      title: "Edit Goals",
                      size: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ExpansionTile(
                    iconColor: CarePlanColor.brown,
                    collapsedIconColor: CarePlanColor.brown,
                    title: TextHolder(
                      title: "Short Term Goals",
                      fontWeight: FontWeight.w800,
                      size: 15,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextHolder(
                          title: _mockShortTermGoal,
                          fontWeight: FontWeight.w500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Card(
                  child: ExpansionTile(
                    iconColor: CarePlanColor.brown,
                    collapsedIconColor: CarePlanColor.brown,
                    title: TextHolder(
                      title: "Long Term Goals",
                      fontWeight: FontWeight.w800,
                      size: 15,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextHolder(
                            title: _mockLongTermGoal,
                            fontWeight: FontWeight.w500,
                            align: TextAlign.left,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
