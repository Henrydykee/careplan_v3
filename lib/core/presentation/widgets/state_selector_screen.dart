import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:careplan/core/presentation/widgets/app_bar.dart';
import 'package:careplan/core/presentation/widgets/text_field.dart';
import 'package:careplan/core/presentation/widgets/text_holder.dart';
import 'package:careplan/core/utils/color.dart';
import 'package:careplan/core/presentation/widgets/router.dart';

class StateSelectorScreen extends StatefulWidget {
  @override
  _StateSelectorScreenState createState() => _StateSelectorScreenState();
}

class _StateSelectorScreenState extends State<StateSelectorScreen> {
  List<Map<String, dynamic>> _allStates = [];
  List<Map<String, dynamic>> _filteredStates = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStates();
    _searchController.addListener(_filterStates);
  }

  Future<void> _loadStates() async {
    try {
      final String response = await rootBundle.loadString('assets/state.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allStates = List<Map<String, dynamic>>.from(data);
        _filteredStates = _allStates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterStates() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStates = _allStates;
      } else {
        _filteredStates = _allStates.where((state) {
          final name = state['name']?.toString().toLowerCase() ?? '';
          final abbreviation = state['abbreviation']?.toString().toLowerCase() ?? '';
          return name.contains(query) || abbreviation.contains(query);
        }).toList();
      }
    });
  }

  void _selectState(String stateName) {
    router.pop(stateName);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStates);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackIcon: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomTextField(
              controller: _searchController,
              hinttitle: "Search states...",
              title: "Search",
              onchanged: (value) {
                // Filter is handled by listener
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredStates.isEmpty
                    ? Center(
                        child: TextHolder(
                          title: "No states found",
                          color: CarePlanColor.grey,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredStates.length,
                        itemBuilder: (context, index) {
                          final state = _filteredStates[index];
                          final name = state['name'] ?? '';
                          final abbreviation = state['abbreviation'] ?? '';

                          return InkWell(
                            onTap: () => _selectState(name),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextHolder(
                                      title: name,
                                      size: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextHolder(
                                    title: abbreviation,
                                    size: 14,
                                    color: CarePlanColor.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
