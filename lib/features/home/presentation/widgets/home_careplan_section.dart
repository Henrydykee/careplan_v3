import 'package:careplan/core/presentation/widgets/current_carplan_widget.dart';
import 'package:careplan/core/presentation/widgets/home_screen_widgets.dart';
import 'package:careplan/core/presentation/widgets/loading_shimmers/list_loading_shimmers.dart';
import 'package:careplan/features/history/data/models/care_plan_history_item_model.dart';
import 'package:careplan/features/history/presentation/state/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCareplanSection extends StatelessWidget {
  const HomeCareplanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Selector<HistoryProvider,
          ({CarePlanHistoryItemModel? carePlan, bool isLoading})>(
        selector: (_, provider) => (
          carePlan: provider.currentCarePlan,
          isLoading: provider.isLoading,
        ),
        builder: (context, state, child) {
          if (state.isLoading && state.carePlan == null) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HomeCarePlanShimmer(),
            );
          }

          if (state.carePlan != null) {
            return MentalHealthCarePlanWidget(carePlan: state.carePlan!);
          }

          return const EmptyCareplan();
        },
      ),
    );
  }
}
