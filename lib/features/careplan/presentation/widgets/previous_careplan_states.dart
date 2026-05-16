import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PreviousCareplanEmptyState extends StatelessWidget {
  const PreviousCareplanEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined,
                  size: 56, color: CarePlanColor.grey_3),
              const Gap(16),
              TextHolder(
                title: "No Care Plan History",
                color: CarePlanColor.grey,
                size: 16,
                fontWeight: FontWeight.w800,
                align: TextAlign.center,
              ),
              const Gap(8),
              TextHolder(
                title: "Your care plan history will appear here",
                color: CarePlanColor.grey_3,
                size: 14,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PreviousCareplanErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PreviousCareplanErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: Colors.red.withValues(alpha: 0.7)),
              const Gap(16),
              TextHolder(
                title: "Error loading care plan history",
                color: CarePlanColor.grey,
                size: 16,
                fontWeight: FontWeight.w700,
              ),
              const Gap(8),
              TextHolder(
                title: message,
                color: CarePlanColor.grey_3,
                size: 14,
                align: TextAlign.center,
              ),
              const Gap(24),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: CarePlanColor.brown,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextHolder(
                    title: "Retry",
                    color: Colors.white,
                    size: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
