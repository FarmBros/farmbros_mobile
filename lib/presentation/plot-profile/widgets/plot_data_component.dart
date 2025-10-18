import 'package:flutter/material.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';

class PlotDataComponent extends StatelessWidget {
  final IconData icon;
  final String plotLabel;
  final String plotValue;

  const PlotDataComponent({
    super.key,
    required this.icon,
    required this.plotLabel,
    required this.plotValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorUtils.primaryBorderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plotLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  plotValue,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
