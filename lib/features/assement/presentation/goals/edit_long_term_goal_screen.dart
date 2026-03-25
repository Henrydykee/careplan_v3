import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditLongTermGoalScreen extends StatefulWidget {
  final String? initialGoal;

  const EditLongTermGoalScreen({super.key, this.initialGoal});

  @override
  State<EditLongTermGoalScreen> createState() => _EditLongTermGoalScreenState();
}

class _EditLongTermGoalScreenState extends State<EditLongTermGoalScreen> {
  late final TextEditingController _goalController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController(text: widget.initialGoal ?? '');
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
        appBar: CustomAppBar(
          showBackIcon: true,
          color: CarePlanColor.brown,
          backButtonColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHolder(
                title: "Edit Long Term Goal",
                size: 20,
                fontWeight: FontWeight.w700,
                color: CarePlanColor.grey,
              ),
              const Gap(8),
              TextHolder(
                title: "Update your long term goal below.",
                size: 14,
                fontWeight: FontWeight.w500,
                color: CarePlanColor.grey,
              ),
              const Gap(20),
              TextField(
                controller: _goalController,
                minLines: 6,
                maxLines: 8,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Type your long term goal here",
                  hintStyle: const TextStyle(color: CarePlanColor.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CarePlanColor.brown),
                  ),
                ),
              ),
              const Spacer(),
              CustomButtom(
                title: "Save Goal",
                onTap: _submit,
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final longTermGoal = _goalController.text.trim();
    if (longTermGoal.isEmpty) {
      showErrorDialog(context, 'Validation Error', 'Long term goal cannot be empty.');
      return;
    }

    final payload = <String, dynamic>{
      'longTermGoal': longTermGoal,
    };

    debugPrint('LongTermGoal upsert payload: ${jsonEncode(payload)}');

    setState(() => _isLoading = true);
    try {
      final dataSource = AssessmentRemoteDataSourceImpl(inject());
      await dataSource.sendAssessment(body: payload);
      if (!mounted) return;
      Navigator.of(context).pop(longTermGoal);
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'LongTermGoal Submission Error', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

