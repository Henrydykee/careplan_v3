import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/view_pager.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'billing_history_screen.dart';
import 'notes_screen.dart';
import 'previous_careplan_screen.dart';

class CarePlanScreen extends StatefulWidget {
  const CarePlanScreen({super.key});

  @override
  State<CarePlanScreen> createState() => _CarePlanScreenState();
}

class _CarePlanScreenState extends State<CarePlanScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;

  @override
  void initState() {
    super.initState();
    pageChanged = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: false,
        title: "",
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHolder(
                    title: "Care Plan",
                    size: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF3A3B3C),
                  ),
                  const Gap(5),
                  TextHolder(
                    title: "See care plan and billing history.",
                    size: 15,
                    color: const Color(0xFF68696C),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: _carePlanViewPager(),
          ),
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
    );
  }

  Widget _carePlanViewPager() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ViewPagerHeader(
              title: "History",
              textColor: pageChanged == 0 ? CarePlanColor.brown : const Color(0xFF3A3B3C),
              color: pageChanged == 0 ? const Color(0xFFFD9C42) : Colors.white,
              borderColor: pageChanged == 0 ? CarePlanColor.orange : Colors.grey.withValues(alpha: 0.3),
              onTap: () => pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeIn,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ViewPagerHeader(
              title: "Billing",
              textColor: pageChanged == 1 ? CarePlanColor.brown : const Color(0xFF3A3B3C),
              color: pageChanged == 1 ? const Color(0xFFFD9C42) : Colors.white,
              borderColor: pageChanged == 1 ? CarePlanColor.orange : Colors.grey.withValues(alpha: 0.3),
              onTap: () => pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeIn,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ViewPagerHeader(
              title: "Notes",
              textColor: pageChanged == 2 ? CarePlanColor.brown : const Color(0xFF3A3B3C),
              color: pageChanged == 2 ? const Color(0xFFFD9C42) : Colors.white,
              borderColor: pageChanged == 2 ? CarePlanColor.orange : Colors.grey.withValues(alpha: 0.3),
              onTap: () => pageController.animateToPage(
                2,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
