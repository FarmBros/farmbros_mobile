import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardTasksList extends StatelessWidget {
  final List<FarmTask> tasks;

  const DashboardTasksList({
    super.key,
    required this.tasks,
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
                'Farm Tasks Summary',
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

          // Task Items
          ...tasks.map((task) => Container(
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
                    // Task Type
                    Text(
                      task.type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(6),

                    // Task Description
                    Row(
                      children: [
                        Icon(
                          task.icon,
                          size: 18,
                          color: ColorUtils.secondaryColor,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),

                    // Status and Assignment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(task.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(task.status),
                            ),
                          ),
                        ),

                        // Assigned Employee
                        Row(
                          children: [
                            Text(
                              'Assigned:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Gap(6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    FluentIcons.person_24_filled,
                                    size: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                  const Gap(4),
                                  Text(
                                    task.assignedTo,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return ColorUtils.secondaryColor;
      case 'completed':
        return Colors.green;
      case 'stalled':
      case 'delayed':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

class FarmTask {
  final String type;
  final String description;
  final String status;
  final String assignedTo;
  final IconData icon;

  FarmTask({
    required this.type,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.icon,
  });
}
