import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../billing/billing_history_screen.dart';
import '../notes/notes_screen.dart';
import 'previous_careplan_screen.dart';

class CarePlanScreen extends StatefulWidget {
  const CarePlanScreen({super.key});

  @override
  State<CarePlanScreen> createState() => _CarePlanScreenState();
}

class _CarePlanScreenState extends State<CarePlanScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;

  final List<String> _tabs = const ["History", "Billing", "Notes"];

  @override
  void initState() {
    super.initState();
    pageChanged = 0;
  }

  void _onTabTap(int index) {
    pageController.animateToPage(
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
                title: "History",
                size: 22,
                fontWeight: FontWeight.w800,
                color: CarePlanColor.brown,
              ),
            ),
            const Gap(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextHolder(
                title: "See care plan and billing history.",
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
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    pageChanged = index;
                  });
                },
                children: const [
                  PreviousCareplanScreen(),
                  BillingHistoryScreen(),
                  NotesScreen(),
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
          final isSelected = pageChanged == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onTabTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? CarePlanColor.brown : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: CarePlanColor.brown.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: TextHolder(
                    title: _tabs[index],
                    size: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : CarePlanColor.grey_3,
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
