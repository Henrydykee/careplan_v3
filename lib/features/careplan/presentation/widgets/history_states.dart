import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HistoryErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const HistoryErrorState({
    super.key,
    required this.title,
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
              TextHolder(
                title: title,
                color: Colors.red,
                size: 16,
              ),
              const Gap(10),
              TextHolder(
                title: message,
                color: CarePlanColor.grey,
                size: 14,
              ),
              const Gap(20),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryEmptyState extends StatelessWidget {
  final String title;
  final String message;

  const HistoryEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextHolder(
                title: title,
                align: TextAlign.center,
                color: CarePlanColor.grey,
                size: 16,
                fontWeight: FontWeight.w800,
              ),
              const Gap(10),
              TextHolder(
                title: message,
                align: TextAlign.center,
                color: CarePlanColor.grey_2,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
