import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class PlotComponent extends StatelessWidget {
  final Map<String, dynamic> plot;

  const PlotComponent({super.key, required this.plot});

  @override
  Widget build(BuildContext context) {
    // Convert plot type to StructureType
    final structureType = (plot["plot_type"] as String).toStructureType();

    return GestureDetector(
      onTap: () {
        context.go("${Routes.plots}/${plot['uuid']}");
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorUtils.primaryBorderColor),
          color: ColorUtils.secondaryBackgroundColor,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: structureType.color.withOpacity(0.2),
                child: Icon(
                  structureType.icon,
                  color: structureType.color,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plot["name"],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Area: ${double.parse(plot["area_sqm"].toString()).floor()} sqm",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
            Spacer(),
            Icon(
              FluentIcons.ios_chevron_right_20_regular,
              color: ColorUtils.secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
