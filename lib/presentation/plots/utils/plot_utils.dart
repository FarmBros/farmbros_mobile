import 'package:farmbros_mobile/data/models/filter_model.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';

class PlotUtils {
  static final List<FilterCategory> $filters = [
    FilterCategory(
      filterKey: 'status',
      filterName: 'Status',
      containerBackground: CupertinoColors.systemGrey6,
      filterOptions: [
        FilterOption(
          optionName: 'Active',
          optionIcon: FluentIcons.checkmark_circle_24_regular,
          iconColor: CupertinoColors.systemGreen,
          value: 'active',
        ),
        FilterOption(
          optionName: 'Inactive',
          optionIcon: FluentIcons.circle_24_regular,
          iconColor: CupertinoColors.systemRed,
          value: 'inactive',
        ),
      ],
    ),
    FilterCategory(
      filterKey: 'type',
      filterName: 'Type',
      containerBackground: CupertinoColors.systemGrey6,
      filterOptions: [
        FilterOption(
          optionName: 'Crops',
          optionIcon: FluentIcons.leaf_two_48_regular,
          iconColor: CupertinoColors.systemGreen,
          value: 'crops',
        ),
        FilterOption(
          optionName: 'Livestock',
          optionIcon: FluentIcons.animal_rabbit_24_regular,
          iconColor: CupertinoColors.systemBrown,
          value: 'livestock',
        ),
      ],
    ),
    FilterCategory(
      filterKey: 'season',
      filterName: 'Season',
      containerBackground: CupertinoColors.systemGrey6,
      filterOptions: [
        FilterOption(
          optionName: 'Spring',
          optionIcon: FluentIcons.weather_sunny_24_regular,
          iconColor: CupertinoColors.systemYellow,
          value: 'spring',
        ),
        FilterOption(
          optionName: 'Summer',
          optionIcon: FluentIcons.weather_sunny_24_regular,
          iconColor: CupertinoColors.systemOrange,
          value: 'summer',
        ),
      ],
    ),
  ];


}
