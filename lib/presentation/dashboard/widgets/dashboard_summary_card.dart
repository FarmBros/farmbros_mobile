import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardSummaryCard extends StatelessWidget {
  final String title;
  final String? dropdownValue;
  final List<SummaryItem> items;
  final VoidCallback? onDropdownChanged;

  const DashboardSummaryCard({
    super.key,
    required this.title,
    this.dropdownValue,
    required this.items,
    this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          // Header with dropdown
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
              if (dropdownValue != null)
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
                        dropdownValue!,
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
          const Gap(16),

          // Summary Items
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(12),
                    // Label
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: item.labelColor ?? const Color(0xFF008000),
                        ),
                      ),
                    ),
                    // Value
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: item.valueColor ?? Colors.black87,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class SummaryItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;

  SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.labelColor,
    this.valueColor,
  });
}
