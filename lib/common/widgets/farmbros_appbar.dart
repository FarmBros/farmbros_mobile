import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FarmbrosAppbar extends StatelessWidget {
  final String appBarTitle;
  final GestureTapCallback? openSideBar;
  final IconData icon;
  final bool hasAction;
  final VoidCallback? appBarAction;
  final String? actionText;

  const FarmbrosAppbar(
      {super.key,
      required this.appBarTitle,
      required this.openSideBar,
      required this.icon,
      required this.hasAction,
      this.appBarAction,
      this.actionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 8,
      decoration: BoxDecoration(
          color: ColorUtils.accentBackgroundColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      child: Row(
        spacing: 5,
        children: [
          GestureDetector(
              onTap: openSideBar,
              child: Icon(
                icon,
                color: ColorUtils.secondaryBackgroundColor,
              )),
          Text(
            appBarTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          if (hasAction)
            ElevatedButton(
              onPressed: appBarAction,
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorUtils.successColor)),
              child: Text(
                actionText!,
                style:
                    TextStyle(fontSize: 12, color: ColorUtils.primaryTextColor),
              ),
            )
          else
            Icon(FluentIcons.alert_24_regular)
        ],
      ),
    );
  }
}
