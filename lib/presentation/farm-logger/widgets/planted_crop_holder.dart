import 'dart:ui';

import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PlantedCropHolder extends StatelessWidget {
  final List<dynamic> plantedCrops;

  const PlantedCropHolder({
    super.key,
    required this.plantedCrops,
  });

  @override
  Widget build(BuildContext context) {
    if (plantedCrops.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.plant_grass_24_regular,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const Gap(16),
            Text(
              'No crops planted yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: plantedCrops.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        final crop = plantedCrops[index];
        return _CropListCard(crop: crop);
      },
    );
  }
}

class _CropListCard extends StatelessWidget {
  final dynamic crop;

  const _CropListCard({required this.crop});

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'healthy':
      case 'growing':
        return Colors.green;
      case 'harvested':
        return ColorUtils.secondaryColor;
      case 'diseased':
      case 'pest':
        return Colors.red;
      case 'dormant':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  int _getDaysSincePlanting(String? plantedDate) {
    if (plantedDate == null) return 0;
    try {
      final planted = DateTime.parse(plantedDate);
      return DateTime.now().difference(planted).inDays;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropName = crop['crop_id'] ?? 'Unknown Crop';
    final plotName = crop['plot_id'] ?? 'Unknown Plot';
    final quantity = crop['number_of_crops'] ?? 0;
    final status = 'Healthy';
    final plantedDate = crop['created_at'] ?? DateTime.now().toString();
    final daysSincePlanting = _getDaysSincePlanting(plantedDate);
    final statusColor = _getStatusColor(status);
    // final statusIcon = _getStatusIcon(status);

    return Container(
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
      child: Row(
        children: [
          // Crop Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FluentIcons.plant_grass_24_filled,
              size: 28,
              color: statusColor,
            ),
          ),
          const Gap(12),
          // Crop Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cropName.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(
                      FluentIcons.location_24_regular,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const Gap(4),
                    Text(
                      plotName.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(12),
                    Icon(
                      FluentIcons.calendar_24_regular,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const Gap(4),
                    Text(
                      '$daysSincePlanting days',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status & Quantity
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const Gap(4),
              Text(
                '$quantity plants',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
