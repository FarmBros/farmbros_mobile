import 'package:flutter/cupertino.dart';

class FilterOption {
  final String optionName;
  final IconData optionIcon;
  final Color iconColor;
  final dynamic value; // The actual value this option represents

  const FilterOption({
    required this.optionName,
    required this.optionIcon,
    required this.iconColor,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    "option_name": optionName,
    "option_icon": optionIcon.codePoint,
    "option_color": iconColor.value,
    "value": value,
  };
}

class FilterCategory {
  final String filterName;
  final List<FilterOption> filterOptions;
  final Color containerBackground;
  final String filterKey; // Unique identifier for this filter

  const FilterCategory({
    required this.filterName,
    required this.filterOptions,
    required this.containerBackground,
    required this.filterKey,
  });

  Map<String, dynamic> toJson() => {
    "filter_name": filterName,
    "filter_key": filterKey,
    "container_background": containerBackground.value,
    "filter_options": filterOptions.map((option) => option.toJson()).toList(),
  };
}