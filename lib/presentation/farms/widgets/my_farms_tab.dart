import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farms/widgets/farm_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class MyFarmsTab extends StatelessWidget {
  final List farms;

  const MyFarmsTab({super.key, required this.farms});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();

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
