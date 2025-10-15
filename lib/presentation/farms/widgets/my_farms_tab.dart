import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farms/widgets/farm_component.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class MyFarmsTab extends StatelessWidget {
  final List farms;

  const MyFarmsTab({super.key, required this.farms});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();

    logger.log(Level.info, farms);

    if (farms.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: double.infinity,
        child: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.leaf_three_20_regular,
                size: 64,
                color: ColorUtils.inActiveColor,
              ),
              Text(
                "No farms found",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Add your first farm to get started",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(top: 5),
      width: double.infinity,
      child: Column(
        spacing: 5,
        children: farms.map((farm) {
          return FarmComponent(farm: farm);
        }).toList(),
      ),
    );
  }
}
