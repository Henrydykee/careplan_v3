import 'dart:convert';

import 'package:careplan/core/di/di_config.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/button.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/presentation/widgets/error_component.dart';
import 'package:careplan/core/presentation/widgets/loader_wrapper.dart';
import 'package:careplan/core/resources/assets.dart';
import 'package:careplan/core/resources/color.dart';
import 'package:careplan/core/resources/string.dart';
import 'package:careplan/features/assement/data/datasources/assessment_remote_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class SelectStressAreasScreen extends StatefulWidget {
  final List<String> initialStressors;
  final String initialAbilityToCope;

  const SelectStressAreasScreen({
    super.key,
    this.initialStressors = const [],
    this.initialAbilityToCope = '5',
  });

  @override
  State<SelectStressAreasScreen> createState() => _SelectStressAreasScreenState();
}

class _SelectStressAreasScreenState extends State<SelectStressAreasScreen> {
  static const List<String> _stressorOptions = [
    'Work',
    'Relationship',
    'Finances',
    'Physical health or pain',
    'Alcohol or drugs',
    'Trauma',
    'Housing',
    'School',
  ];

  late final Set<String> _selectedStressors;
  late String _selectedCopeRating;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStressors = widget.initialStressors.toSet();
    _selectedCopeRating = widget.initialAbilityToCope;
  }

  void _toggleStressor(String stressor, bool value) {
    setState(() {
      if (value) {
        _selectedStressors.add(stressor);
      } else {
        _selectedStressors.remove(stressor);
      }
    });
  }

  Map<String, dynamic> _buildPayload() {
    final stressorsMap = <String, bool>{};
    for (final stressor in _stressorOptions) {
      final key = _stressorToServerKey(stressor);
      stressorsMap[key] = _selectedStressors.contains(stressor);
    }
    return {
      'stressors': stressorsMap,
      'rating': int.tryParse(_selectedCopeRating) ?? 1,
    };
  }

  String _stressorToServerKey(String stressor) {
    switch (stressor) {
      case 'Work':
        return 'work';
      case 'Relationship':
        return 'relationship';
      case 'Finances':
        return 'finances';
      case 'Physical health or pain':
        return 'physicalhealth';
      case 'Alcohol or drugs':
        return 'alcohol';
      case 'Trauma':
        return 'trauma';
      case 'Housing':
        return 'housing';
      case 'School':
        return 'school';
      default:
        return stressor.toLowerCase().replaceAll(' ', '');
    }
  }

  Future<void> _submitStressors() async {
    if (_selectedStressors.isEmpty) {
      GlobalSnackBar.show(
        context,
        'Please select at least one stressor.',
      );
      return;
    }

    final dataSource = AssessmentRemoteDataSourceImpl(inject());
    final payload = _buildPayload();
    debugPrint('Stressors upsert payload: ${jsonEncode(payload)}');
    setState(() => _isLoading = true);
    try {
      await dataSource.sendAssessment(body: payload);
      if (!mounted) return;
      Navigator.of(context).pop(
        StressorsSelectionResult(
          stressors: _selectedStressors.toList(),
          abilityToCope: _selectedCopeRating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'Stressors Submission Error', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderWrapper(
      isLoading: _isLoading,
      view: Scaffold(
        appBar: CustomAppBar(
          showBackIcon: true,
          color: Colors.white,
          backButtonColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CarePlanColor.light_orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHolder(
                              title: "Identify your stressors",
                              size: 20,
                              fontWeight: FontWeight.w800,
                              color: CarePlanColor.brown,
                            ),
                            const Gap(6),
                            TextHolder(
                              title:
                                  "Select all areas affecting you today, then rate how well you can cope.",
                              size: 14,
                              fontWeight: FontWeight.w500,
                              color: CarePlanColor.grey,
                            ),
                          ],
                        ),
                      ),
                      const Gap(14),
                      Center(child: SvgPicture.asset(Assets.stress_image, height: 120)),
                      const Gap(14),
                      TextHolder(
                        title: "Areas of stress",
                        size: 16,
                        fontWeight: FontWeight.w700,
                        color: CarePlanColor.grey,
                      ),
                      const Gap(10),
                      ...List.generate(_stressorOptions.length, (index) {
                        final title = _stressorOptions[index];
                        final isSelected = _selectedStressors.contains(title);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _StressArea(
                            title: title,
                            value: isSelected,
                            onChanged: (value) => _toggleStressor(title, value),
                          ),
                        );
                      }),
                      const Gap(14),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE6E6E6)),
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHolder(
                              title: "Ability to cope (1-10)",
                              color: CarePlanColor.grey,
                              fontWeight: FontWeight.w700,
                              size: 14,
                            ),
                            const Gap(8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: CarePlanColor.orange),
                                borderRadius: BorderRadius.circular(8),
                                color: CarePlanColor.light_orange.withValues(alpha: 0.25),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: DropdownButton<String>(
                                value: _selectedCopeRating,
                                isExpanded: true,
                                underline: const SizedBox(),
                                style: const TextStyle(
                                  color: CarePlanColor.brown,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                iconEnabledColor: CarePlanColor.brown,
                                items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
                                    .map<DropdownMenuItem<String>>(
                                      (v) => DropdownMenuItem(value: v, child: Text(v)),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() => _selectedCopeRating = value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                ),
                padding: const EdgeInsets.only(top: 14, bottom: 20),
                child: CustomButtom(
                  title: Strings.cotinue,
                  onTap: _submitStressors,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StressArea extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _StressArea({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: value ? CarePlanColor.light_orange : Colors.white,
            border: Border.all(
              color: value ? CarePlanColor.orange : const Color(0xFFE3E3E3),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (newValue) => onChanged(newValue ?? false),
                activeColor: CarePlanColor.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: TextHolder(
                  title: title,
                  color: CarePlanColor.grey,
                  size: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StressorsSelectionResult {
  final List<String> stressors;
  final String abilityToCope;

  const StressorsSelectionResult({
    required this.stressors,
    required this.abilityToCope,
  });
}
