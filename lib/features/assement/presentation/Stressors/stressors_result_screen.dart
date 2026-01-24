import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StressorsResultScreen extends StatelessWidget {
  const StressorsResultScreen({super.key});

  static const _mockAbilityToCope = "6";
  static const _mockStressors = ["Work", "Finances", "Relationship"];

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
                  title: "Stressors",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: "See all current stressors",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
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
                        title: "💡 Take the Stressors Test",
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
                      title: "Update",
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
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextHolder(
                          title: "Ability to cope",
                          fontWeight: FontWeight.w500,
                          size: 12,
                        ),
                        TextHolder(
                          title: _mockAbilityToCope,
                          fontWeight: FontWeight.w700,
                          size: 18,
                          color: CarePlanColor.brown,
                        ),
                      ],
                    ),
                  ),
                ),
                StressorsCard(stressors: _mockStressors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StressorsCard extends StatelessWidget {
  final List<String> stressors;

  const StressorsCard({super.key, this.stressors = const []});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stressors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            if (stressors.isEmpty)
              const Text(
                "No stressors reported.",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              )
            else
              ...List.generate(stressors.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: CarePlanColor.black_3.withValues(alpha: 0.2),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CarePlanColor.brown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        stressors[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
