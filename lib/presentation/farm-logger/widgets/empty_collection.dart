import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';

class EmptyCollection extends StatelessWidget {
  final String collectionName;

  const EmptyCollection({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Ooops!",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: ColorUtils.secondaryColor,
                fontSize: 24),
          ),
          Image(image: AssetImage("assets/images/empty.png")),
          Text(
              textAlign: TextAlign.center,
              "How Empty, Add some "
              "$collectionName to log them on this screen. "
              "Use “Drag to Show” below.")
        ],
      ),
    );
  }
}
