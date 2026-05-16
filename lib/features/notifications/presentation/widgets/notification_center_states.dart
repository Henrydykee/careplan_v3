import 'package:careplan/core/presentation/widgets/loading_shimmers/base_shimmer.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationLoadingShimmer extends StatelessWidget {
  const NotificationLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(
              height: 16,
              width: 60,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            const Gap(12),
            ...List.generate(
              6,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ShimmerBox(
                  height: 88,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NotificationErrorState({
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const Gap(20),
              TextHolder(
                title: "Couldn't load notifications",
                color: CarePlanColor.grey,
                size: 16,
                fontWeight: FontWeight.w600,
                align: TextAlign.center,
              ),
              const Gap(8),
              TextHolder(
                title: message,
                color: CarePlanColor.grey_3,
                size: 13,
                align: TextAlign.center,
              ),
              const Gap(24),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: CarePlanColor.brown,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextHolder(
                    title: "Try again",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    size: 14,
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

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CarePlanColor.light_orange,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: CarePlanColor.orange,
                  size: 40,
                ),
              ),
              const Gap(20),
              TextHolder(
                title: "No notifications yet",
                color: CarePlanColor.grey,
                size: 18,
                fontWeight: FontWeight.w700,
                align: TextAlign.center,
              ),
              const Gap(8),
              TextHolder(
                title: "You're all caught up!",
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
