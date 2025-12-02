import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farm-logger/widgets/crop_details_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ItemHolder extends StatefulWidget {
  final String name;
  final String imagePath;
  final Map<String, dynamic> cropData;
  final List<dynamic> farms;

  const ItemHolder({
    super.key,
    required this.name,
    required this.imagePath,
    required this.cropData,
    required this.farms,
  });

  @override
  State<ItemHolder> createState() => _ItemHolderState();
}

class _ItemHolderState extends State<ItemHolder> {
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.d(widget.cropData);
        showDialog(
          context: context,
          builder: (context) => CropDetailsCard(
            cropData: widget.cropData,
            farms: widget.farms,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.primaryTextColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: ColorUtils.secondaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: AssetImage(
                      'assets/crop-images/${widget.imagePath.toLowerCase().replaceAll(' ', '_')}.jpg'),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey.shade400,
                      size: 24,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Item Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
