import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['All Time', 'This Week', 'This Month'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                          setState(() {});
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 1.5.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = widget.selectedFilter == filter;
                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.surface
                            : AppTheme.lightTheme.colorScheme.primary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => widget.onFilterChanged(filter),
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    selectedColor: AppTheme.lightTheme.colorScheme.primary,
                    checkmarkColor: AppTheme.lightTheme.colorScheme.surface,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.borderSubtle,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
