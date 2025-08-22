import 'package:farmbros_mobile/presentation/farm-logger/widgets/item_holder.dart';
import 'package:flutter/material.dart';

class CollectionHolder extends StatefulWidget {
  const CollectionHolder({super.key});

  @override
  State<CollectionHolder> createState() => _CollectionHolderState();
}

class _CollectionHolderState extends State<CollectionHolder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Collection name"),
        Wrap(
          runSpacing: 5,
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            ItemHolder(),
            ItemHolder(),
            ItemHolder(),
            ItemHolder(),
            ItemHolder()
          ],
        )
      ],
    );
  }
}
