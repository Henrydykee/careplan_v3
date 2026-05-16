import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/presentation/stressors/stressors_result_screen.dart';
import 'package:careplan/features/assement/presentation/asrs/asrs_result_screen.dart';
import 'package:careplan/features/assement/presentation/goals/goals_result_acreen.dart';
import 'package:careplan/features/assement/presentation/k10/k10_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SelectAssementHistoryScreen extends StatefulWidget {
  const SelectAssementHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectAssementHistoryScreen> createState() =>
      _SelectAssementHistoryScreenState();
}

class _SelectAssementHistoryScreenState
    extends State<SelectAssementHistoryScreen> {
  int _selectedTab = 0;
  late final PageController _pageController;

  final List<_AssessmentTabItem> _tabs = const [
    _AssessmentTabItem(title: "K10", icon: Icons.psychology_outlined),
    _AssessmentTabItem(title: "ASRS", icon: Icons.checklist_outlined),
    _AssessmentTabItem(title: "Goals", icon: Icons.flag_outlined),
    _AssessmentTabItem(title: "Stress", icon: Icons.health_and_safety_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    setState(() => _selectedTab = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextHolder(
                title: "Assessments",
                size: 22,
                fontWeight: FontWeight.w800,
                color: CarePlanColor.brown,
              ),
            ),
            const Gap(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextHolder(
                title: "Your assessment history",
                size: 14,
                color: CarePlanColor.grey_3,
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildTabBar(),
            ),
            const Gap(16),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedTab = index);
                },
                children: [
                  K10ResultScreen(),
                  ASRSResultHistoryScreen(),
                  GoalsResultScreen(),
                  StressorsResultScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CarePlanColor.grey_5,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onTabTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      isSelected ? CarePlanColor.brown : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                CarePlanColor.brown.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: TextHolder(
                    title: _tabs[index].title,
                    size: 14,
                    fontWeight: FontWeight.w700,
                    color:
                        isSelected ? Colors.white : CarePlanColor.grey_3,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AssessmentTabItem {
  final String title;
  final IconData icon;

  const _AssessmentTabItem({required this.title, required this.icon});
}
