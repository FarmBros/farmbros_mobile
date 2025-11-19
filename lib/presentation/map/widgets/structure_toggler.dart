import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StructureToggler extends StatelessWidget {
  final Map<String, List<LatLng>> structures;
  final String? selectedStructureKey;
  final Function(String) onStructureSelected;
  final VoidCallback onExitEditMode;
  final Function(String) onDeleteStructure;

  const StructureToggler({
    super.key,
    required this.structures,
    required this.selectedStructureKey,
    required this.onStructureSelected,
    required this.onExitEditMode,
    required this.onDeleteStructure,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 320,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Edit Structures",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.secondaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onExitEditMode,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              "Select a structure to edit its points",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Flexible(
              child: structures.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No structures available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: structures.entries.map((entry) {
                          final structureKey = entry.key;
                          final points = entry.value;
                          final typeIndex =
                              int.parse(structureKey.split('_')[0]);
                          final type = StructureType.values[typeIndex];
                          final isSelected =
                              selectedStructureKey == structureKey;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: _buildStructureCard(
                              context,
                              structureKey,
                              type,
                              points.length,
                              isSelected,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStructureCard(
    BuildContext context,
    String structureKey,
    StructureType type,
    int pointCount,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => onStructureSelected(structureKey),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? type.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? type.color.withOpacity(0.1) : Colors.white,
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
                  SizedBox(height: 2),
                  Text(
                    '$pointCount points',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              IconButton(
                icon: Icon(
                  CupertinoIcons.trash,
                  color: ColorUtils.failureColor,
                  size: 20,
                ),
                onPressed: () =>
                    _showDeleteConfirmation(context, structureKey, type),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.edit,
                color: type.color,
                size: 20,
              ),
            ] else
              Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String structureKey,
    StructureType type,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete ${type.displayName}?'),
          content: Text(
            'Are you sure you want to delete this structure? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDeleteStructure(structureKey);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.failureColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
