import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Plot Summary",
          style: TextStyle(fontSize: 14, color: ColorUtils.inActiveColor),
        ),
        Flex(
          direction: Axis.horizontal,
          spacing: 5,
          children: SummaryStripType.values.map((strip) {
            return _buildStripItems(
                strip.stripColor, strip.stripText, strip.stripIcon);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStripItems(
      Color stripColor, String stripText, IconData stripIcon) {
    return Expanded(
        flex: 1,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: stripColor.withOpacity(0.3),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 5,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: stripColor),
                  child: Icon(
                    stripIcon,
                    size: 30,
                    color: ColorUtils.secondaryBackgroundColor,
                  ),
                ),
                Text(
                  stripText,
                  style: TextStyle(
                      color: ColorUtils.primaryTextColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }
}
