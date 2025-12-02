import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardWeeklyChart extends StatelessWidget {
  final String title;
  final List<DailyData> weeklyData;

  const DashboardWeeklyChart({
    super.key,
    required this.title,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    final maxValue = weeklyData.fold<double>(
      0,
      (max, item) => item.value > max ? item.value : max,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorUtils.secondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'Daisy',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.secondaryColor,
                      ),
                    ),
                    const Gap(4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: ColorUtils.secondaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(24),

          // Chart
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weeklyData.map((day) {
                // Calculate bar height as percentage of max value
                final double heightPercentage =
                    maxValue > 0 ? day.value / maxValue : 0;
                final double barHeight = 150 * heightPercentage;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Value label on top of bar
                      if (day.value > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            day.value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      // Bar
                      Container(
                        height: barHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: ColorUtils.secondaryColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const Gap(8),
                      // Day label
                      Text(
                        day.day,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
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

class DailyData {
  final String day;
  final double value;

  DailyData({
    required this.day,
    required this.value,
  });
}
