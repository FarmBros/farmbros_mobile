import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlotComponent extends StatelessWidget {
  final String plotName;
  final String plotContents;
  final StructureType structure;

  const PlotComponent(
      {super.key,
      required this.plotName,
      required this.plotContents,
      required this.structure});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorUtils.primaryBorderColor),
          color: ColorUtils.secondaryBackgroundColor),
      child: Row(
        spacing: 10,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 0,
              color: structure.color.withOpacity(0.3),
              child: Icon(
                structure.icon,
                color: structure.color,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plotName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: structure.color),
              ),
              Text(
                plotContents,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
          Spacer(),
          Icon(FluentIcons.ios_chevron_right_20_regular,
              color: ColorUtils.secondaryColor)
        ],
      ),
    );
  }
}
