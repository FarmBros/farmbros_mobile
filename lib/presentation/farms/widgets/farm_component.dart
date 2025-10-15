import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class FarmComponent extends StatelessWidget {
  final Map farm;

  const FarmComponent({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    logger.log(Logger.level, "${Routes.farms}/${farm['uuid']}");

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ColorUtils.primaryBorderColor),
          color: ColorUtils.secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    height: 80,
                    width: 80,
                    image: AssetImage("assets/images/farmbros-logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farm["name"] ?? "FarmName",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorUtils.secondaryColor),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            FluentIcons.space_3d_20_regular,
                            size: 16,
                            color: ColorUtils.inActiveColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Area ${double.parse(farm["area_sqm"].toString()).floor().toString()} (Sq km)",
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorUtils.inActiveColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.go("${Routes.farms}/${farm['uuid']}",
                    extra: {"coordinates": farm["boundary"]["coordinates"]});
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: ColorUtils.accentBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View Farm",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.secondaryBackgroundColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      FluentIcons.arrow_right_16_filled,
                      size: 16,
                      color: ColorUtils.secondaryBackgroundColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
