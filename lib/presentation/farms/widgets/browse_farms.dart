import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farms/widgets/farm_component.dart';
import 'package:flutter/cupertino.dart';

class BrowseFarms extends StatelessWidget {
  const BrowseFarms({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 5,
        children: [FarmComponent(), FarmComponent(), FarmComponent()],
      ),
    );
  }
}
