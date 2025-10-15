// farmbros_filter.dart
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/filter_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FarmbrosFilter extends StatefulWidget {
  final List<FilterCategory> filters;
  final Function(Map<String, dynamic> selectedFilters) onFiltersChanged;
  final int filterCount;

  const FarmbrosFilter({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    required this.filterCount,
  });

  @override
  State<FarmbrosFilter> createState() => _FarmbrosFilterState();
}

class _FarmbrosFilterState extends State<FarmbrosFilter> {
  Map<String, dynamic> _selectedFilters = {};
  bool isExpanded = false;

  void toggleIsExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _onFilterOptionSelected(FilterCategory category, FilterOption option) {
    setState(() {
      if (_selectedFilters[category.filterKey] == option.value) {
        // Deselect if already selected
        _selectedFilters.remove(category.filterKey);
      } else {
        // Select new option
        _selectedFilters[category.filterKey] = option.value;
      }
      widget.onFiltersChanged(_selectedFilters);
    });
  }

  bool _isOptionSelected(FilterCategory category, FilterOption option) {
    return _selectedFilters[category.filterKey] == option.value;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Material(
        borderRadius: BorderRadius.circular(16),
        textStyle: TextStyle(
            color: ColorUtils.inActiveColor,
            fontWeight: FontWeight.bold,
            fontSize: 16),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              GestureDetector(
                onTap: () {
                  toggleIsExpanded();
                },
                child: Row(
                  children: [
                    const Icon(FluentIcons.filter_24_regular),
                    const SizedBox(width: 8),
                    const Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedFilters.isNotEmpty)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            _selectedFilters.clear();
                            widget.onFiltersChanged(_selectedFilters);
                          });
                        },
                        child: const Text(
                          "Clear All",
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      ),
                    Icon(isExpanded
                        ? FluentIcons.chevron_up_24_regular
                        : FluentIcons.chevron_down_24_regular)
                  ],
                ),
              ),
              if (isExpanded)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.filterCount,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: widget.filters.length,
                  itemBuilder: (context, index) {
                    final filter = widget.filters[index];
                    return _buildFilterItem(filter);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFilterItem(FilterCategory category) {
    return GestureDetector(
      onTap: () {
        print("tapped");
        _showFilterOptions(category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: category.containerBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedFilters.containsKey(category.filterKey)
                ? CupertinoColors.systemBlue
                : CupertinoColors.lightBackgroundGray,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.filter_24_regular,
              color: _selectedFilters.containsKey(category.filterKey)
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemGrey,
            ),
            const SizedBox(height: 4),
            Text(
              category.filterName,
              style: TextStyle(
                fontSize: 12,
                color: _selectedFilters.containsKey(category.filterKey)
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey,
                fontWeight: _selectedFilters.containsKey(category.filterKey)
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(FilterCategory category) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    category.filterName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CupertinoButton(
                    child: const Text('Clear'),
                    onPressed: () {
                      setState(() {
                        _selectedFilters.remove(category.filterKey);
                        widget.onFiltersChanged(_selectedFilters);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: category.filterOptions.length,
                itemBuilder: (context, index) {
                  final option = category.filterOptions[index];
                  final isSelected = _isOptionSelected(category, option);

                  return CupertinoButton(
                    onPressed: () {
                      _onFilterOptionSelected(category, option);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(
                          option.optionIcon,
                          color: option.iconColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(option.optionName),
                        ),
                        if (isSelected)
                          const Icon(
                            FluentIcons.checkmark_24_regular,
                            color: CupertinoColors.systemBlue,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
