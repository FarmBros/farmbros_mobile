import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/material.dart';

class ItemHolder extends StatefulWidget {
  const ItemHolder({super.key});

  @override
  State<ItemHolder> createState() => _ItemHolderState();
}

class _ItemHolderState extends State<ItemHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: ColorUtils.lightBackgroundColor),
          borderRadius: BorderRadius.circular(5)),
      height: 70,
      width: 60,
      child: Column(
        children: [
          Image(
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              image: AssetImage("assets/images/goat.png")),
          Text(
            "Item name",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}
