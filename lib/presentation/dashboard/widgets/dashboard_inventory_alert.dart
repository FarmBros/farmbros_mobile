import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardInventoryAlert extends StatelessWidget {
  final List<InventoryAlertItem> alerts;

  const DashboardInventoryAlert({
    super.key,
    required this.alerts,
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventory Alert',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Row(
                children: [
                  Icon(
                    FluentIcons.filter_24_regular,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  const Gap(12),
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
                          'all',
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
            ],
          ),
          const Gap(16),

          // Alert Items
          ...alerts.map((alert) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory Warning',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(6),
                    Row(
                      children: [
                        Icon(
                          FluentIcons.warning_24_filled,
                          size: 18,
                          color: ColorUtils.secondaryColor,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            alert.message,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(alert.severity)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            alert.severity,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getSeverityColor(alert.severity),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Remaining:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Gap(4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    ColorUtils.secondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    FluentIcons.archive_24_filled,
                                    size: 12,
                                    color: ColorUtils.secondaryColor,
                                  ),
                                  const Gap(4),
                                  Text(
                                    alert.remaining,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: ColorUtils.secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'low':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }
}

class InventoryAlertItem {
  final String message;
  final String severity;
  final String remaining;

  InventoryAlertItem({
    required this.message,
    required this.severity,
    required this.remaining,
  });
}
