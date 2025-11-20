import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farm-logger/widgets/item_holder.dart';
import 'package:flutter/material.dart';

class CollectionHolder extends StatefulWidget {
  final String collectionName;
  final List items;

  const CollectionHolder({
    super.key,
    required this.collectionName,
    required this.items,
  });

  @override
  State<CollectionHolder> createState() => _CollectionHolderState();
}

class _CollectionHolderState extends State<CollectionHolder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        // Section Header
        Text(
          widget.collectionName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        // Items Grid
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: widget.items.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                "No items added",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return ItemHolder(
                name: widget.items[index]['common_name'] ?? 'Item',
                imagePath: widget.items[index]['image'] ?? '',
              );
            },
          ),
        ),
      ],
    );
  }
}
