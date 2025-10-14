import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class StructureSelector extends StatelessWidget {
  final Function onPressed;
  final Function startDrawing;
  final bool isCreatingFarm;

  const StructureSelector(
      {super.key,
      required this.onPressed,
      required this.startDrawing,
      required this.isCreatingFarm});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    final List<StructureType> availableStructures = isCreatingFarm
        ? [StructureType.farm] // Only farm option
        : StructureType.values.toList(); // All options

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 320,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 1.75,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCreatingFarm
                      ? "Draw Your Farm"
                      : "Select Structure to Draw",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.secondaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...availableStructures.map((type) {
                      logger.log(Level.info, type);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: _buildStructureOption(type),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStructureOption(StructureType type) {
    return InkWell(
      onTap: () => startDrawing(type),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: type.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(type.icon, color: type.color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
