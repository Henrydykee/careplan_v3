
import 'package:careplan/core/presentation/widgets/router.dart';
import 'package:careplan/features/assement/presentation/k10/k10_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:gap/gap.dart';

class SelectAssementHistoryScreen extends StatefulWidget {
  const SelectAssementHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectAssementHistoryScreen> createState() => _SelectAssementHistoryScreenState();
}

class _SelectAssementHistoryScreenState extends State<SelectAssementHistoryScreen> {

  Widget _buildOptionCard(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CarePlanColor.brown,
        automaticallyImplyLeading: false,
        elevation: 0,
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
                  title: "Assessments",
                  size: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                TextHolder(
                  title: "Your assessment history",
                  size: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Gap(25),
          Column(
            children: [
              _buildOptionCard(context, 'K10', onTap: () {
                router.push(K10ResultScreen());
              }),
              _buildOptionCard(context, 'ASRS'),
              _buildOptionCard(context, 'Goals'),
              _buildOptionCard(context, 'Areas of Stress'),
            ],
          ),

        ],
      ),
    );
  }
}
