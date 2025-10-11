import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StructureEditor extends StatelessWidget {
  final StructureType? structureType;
  final Function toggleDrawingCardMinimize;
  final bool isDrawingCardMinimized;
  final List<LatLng> currentDrawingPoints;
  final VoidCallback undoLastPoint;
  final VoidCallback clearCurrentDrawing;
  final VoidCallback finishDrawing;
  final VoidCallback cancelDrawing;

  const StructureEditor(
      {super.key,
      required this.structureType,
      required this.toggleDrawingCardMinimize,
      required this.isDrawingCardMinimized,
      required this.currentDrawingPoints,
      required this.undoLastPoint,
      required this.clearCurrentDrawing,
      required this.finishDrawing,
      required this.cancelDrawing});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 320,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: structureType!.color,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header (Always Visible)
            InkWell(
              onTap: () {
                toggleDrawingCardMinimize();
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: structureType!.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      structureType!.icon,
                      color: structureType!.color,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          structureType!.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.secondaryColor,
                          ),
                        ),
                        Text(
                          "${currentDrawingPoints.length} points",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isDrawingCardMinimized
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: ColorUtils.secondaryColor,
                  ),
                ],
              ),
            ),

            // Expandable Content
            if (!isDrawingCardMinimized) ...[
              SizedBox(height: 12),
              Text(
                structureType!.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: undoLastPoint,
                      icon: Icon(CupertinoIcons.arrow_uturn_left, size: 16),
                      label: Text("Undo"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorUtils.secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: clearCurrentDrawing,
                      icon: Icon(CupertinoIcons.clear, size: 16),
                      label: Text("Clear"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorUtils.failureColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      currentDrawingPoints.length >= 3 ? finishDrawing : null,
                  icon: Icon(Icons.check, size: 18),
                  label: Text("Finish Drawing"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: cancelDrawing,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                  child: Text("Cancel"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
