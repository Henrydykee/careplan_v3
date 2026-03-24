import 'package:careplan/core/presentation/widgets/loading_shimmers/base_shimmer.dart';
import 'package:flutter/material.dart';

class AppointmentListShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;

  const AppointmentListShimmer({
    super.key,
    this.itemCount = 3,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.builder(
        itemCount: itemCount,
        padding: padding,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, __) => const ShimmerBox(
          height: 100,
          margin: EdgeInsets.only(bottom: 12),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

class BillingHistoryListShimmer extends StatelessWidget {
  final int itemCount;

  const BillingHistoryListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemBuilder: (_, __) => const ShimmerBox(
          height: 120,
          margin: EdgeInsets.only(bottom: 12),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

class NotesListShimmer extends StatelessWidget {
  final int itemCount;

  const NotesListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemBuilder: (_, __) => const ShimmerBox(
          height: 120,
          margin: EdgeInsets.only(bottom: 12),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

class CareplanHistoryListShimmer extends StatelessWidget {
  final int itemCount;

  const CareplanHistoryListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.builder(
        itemCount: itemCount,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        itemBuilder: (_, __) => const ShimmerBox(
          height: 112,
          margin: EdgeInsets.only(bottom: 12),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}

class CardsListShimmer extends StatelessWidget {
  final int itemCount;

  const CardsListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (_, __) => const ShimmerBox(
          height: 84,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }
}

class HomeUpcomingAppointmentsShimmer extends StatelessWidget {
  const HomeUpcomingAppointmentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppointmentListShimmer(
      itemCount: 2,
      padding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

class HomeCarePlanShimmer extends StatelessWidget {
  const HomeCarePlanShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseShimmer(
      child: ShimmerBox(
        height: 170,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}

class AssessmentHistoryListShimmer extends StatelessWidget {
  final int itemCount;

  const AssessmentHistoryListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemBuilder: (_, __) => const ShimmerBox(
          height: 80,
          margin: EdgeInsets.only(bottom: 12),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}

class GoalsResultShimmer extends StatelessWidget {
  const GoalsResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ShimmerBox(
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            SizedBox(height: 12),
            ShimmerBox(
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}

class StressorsResultShimmer extends StatelessWidget {
  const StressorsResultShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ShimmerBox(
              height: 64,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            SizedBox(height: 12),
            ShimmerBox(
              height: 220,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }
}
