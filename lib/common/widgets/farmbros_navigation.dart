import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FarmbrosNavigation extends StatelessWidget {
  const FarmbrosNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> navigationItems = [
      {
        "nav_label": "Dashboard",
        "nav_icon": FluentIcons.grid_24_regular,
        "nav_icon_active": FluentIcons.grid_24_filled,
        "route": Routes.dashboard,
        "type": "main"
      },
      {
        "nav_label": "Farms",
        "nav_icon": FluentIcons.leaf_three_24_regular,
        "nav_icon_active": FluentIcons.leaf_three_24_filled,
        "route": Routes.farms,
        "type": "farm"
      },
      {
        "nav_label": "Plots",
        "nav_icon": FluentIcons.location_24_regular,
        "nav_icon_active": FluentIcons.location_24_filled,
        "route": Routes.plots,
        "type": "farm"
      },
      {
        "nav_label": "Farm Logger",
        "nav_icon": FluentIcons.animal_rabbit_24_regular,
        "nav_icon_active": FluentIcons.animal_rabbit_24_filled,
        "route": "/farm_logger",
        "type": "farm"
      },
      {
        "nav_label": "Farmer Account",
        "nav_icon": FluentIcons.person_24_regular,
        "nav_icon_active": FluentIcons.person_24_filled,
        "route": Routes.farmerAccount,
        "type": "farm"
      },
      {
        "nav_label": "Task Manager",
        "nav_icon": FluentIcons.clipboard_24_regular,
        "nav_icon_active": FluentIcons.clipboard_24_filled,
        "route": "/task_manager",
        "type": "manager"
      },
      {
        "nav_label": "Staff Manager",
        "nav_icon": FluentIcons.badge_24_regular,
        "nav_icon_active": FluentIcons.badge_24_filled,
        "route": "/staff_manager",
        "type": "manager"
      },
      {
        "nav_label": "Inventory",
        "nav_icon": FluentIcons.archive_24_regular,
        "nav_icon_active": FluentIcons.archive_24_filled,
        "route": "/inventory",
        "type": "manager"
      },
      {
        "nav_label": "Settings",
        "nav_icon": FluentIcons.settings_24_regular,
        "nav_icon_active": FluentIcons.settings_24_filled,
        "route": "/settings",
        "type": "settings"
      },
      {
        "nav_label": "Notifications",
        "nav_icon": FluentIcons.alert_24_regular,
        "nav_icon_active": FluentIcons.alert_24_filled,
        "route": "/notifications",
        "type": "settings"
      }
    ];

    Map<String, List<dynamic>> groupedItems = {};
    for (var item in navigationItems) {
      String type = item["type"];
      if (!groupedItems.containsKey(type)) {
        groupedItems[type] = [];
      }
      groupedItems[type]!.add(item);
    }

    final String? currentPath = ModalRoute.of(context)!.settings.name;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
          color: ColorUtils.lightBackgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                color: ColorUtils.accentBackgroundColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Image(
                  image: AssetImage("assets/images/farmbros-logo.png"),
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                Text(
                  "FarmBros",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: groupedItems.entries.map((entry) {
                    return Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.inActiveColor),
                        ),
                        Column(
                          spacing: 5,
                          children: entry.value.map((navItem) {
                            final bool isActive = currentPath!.toLowerCase() ==
                                navItem["route"].toString().toLowerCase();
                            return _buildNavigationItem(
                                isActive
                                    ? navItem["nav_icon_active"]
                                    : navItem["nav_icon"],
                                navItem["nav_label"],
                                navItem["route"],
                                isActive,
                                context);
                          }).toList(),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(30)),
                color: ColorUtils.accentBackgroundColor),
            child: Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  backgroundColor: ColorUtils.lightBackgroundColor,
                  child: Icon(
                    FluentIcons.person_24_regular,
                    color: ColorUtils.primaryColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Farmer Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Role in farm")
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Icon(FluentIcons.arrow_exit_20_regular),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String navigationLabel,
      String route, bool isActive, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(route);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isActive
                    ? ColorUtils.activeBorderColor
                    : ColorUtils.primaryBorderColor),
            color: isActive
                ? ColorUtils.accentBackgroundColor
                : ColorUtils.secondaryBackgroundColor),
        child: Row(
          spacing: 10,
          children: [
            Icon(
              icon,
              color: ColorUtils.secondaryColor,
            ),
            Text(
              navigationLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Spacer(),
            Icon(FluentIcons.ios_chevron_right_20_regular,
                color: ColorUtils.secondaryColor)
          ],
        ),
      ),
    );
  }
}
