import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farm-logger/widgets/collection_holder.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class FarmbrosBottomsheet extends StatelessWidget {
  const FarmbrosBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(FluentIcons.filter_24_regular),
                  SizedBox(width: 8),
                  Text("Filters"),
                ],
              ),
              SizedBox(
                width: 150,
                child: DropdownMenu<String>(
                  textStyle: TextStyle(fontSize: 12),
                  label: Text(
                    "All",
                    style: TextStyle(fontSize: 14),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'A', label: 'Animals'),
                    DropdownMenuEntry(value: 'B', label: 'Crops'),
                    DropdownMenuEntry(value: 'A', label: 'Equipment'),
                    DropdownMenuEntry(value: 'B', label: 'Structures'),
                  ],
                  onSelected: (value) {},
                  menuStyle: MenuStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                          horizontal: 8), // adjust internal padding
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: const [
                  CollectionHolder(),
                  CollectionHolder(),
                  CollectionHolder(),
                  CollectionHolder(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
