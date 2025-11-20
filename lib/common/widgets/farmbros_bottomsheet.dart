import 'package:farmbros_mobile/common/bloc/farm_logger/crop_logger_state.dart';
import 'package:farmbros_mobile/common/bloc/farm_logger/crop_logger_state_cubit.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/presentation/farm-logger/widgets/collection_holder.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FarmbrosBottomsheet extends StatefulWidget {
  const FarmbrosBottomsheet({super.key});

  @override
  State<FarmbrosBottomsheet> createState() => _FarmbrosBottomsheetState();
}

class _FarmbrosBottomsheetState extends State<FarmbrosBottomsheet> {
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> crops = [];
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropLoggerStateCubit, CropLoggerState>(
        builder: (context, cropLogger) {
      if (cropLogger is CropLoggerStateSuccess) {
        crops = cropLogger.crops ?? [];
        logger.d(crops);
      } else if (cropLogger is CropLoggerStateError) {}
      return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle Bar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title with Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorUtils.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FluentIcons.filter_24_regular,
                          size: 20,
                          color: ColorUtils.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "View Collection",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Filter Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      isExpanded: false,
                      underline: const SizedBox(),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          FluentIcons.chevron_down_16_regular,
                          color: ColorUtils.secondaryColor,
                          size: 18,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedFilter = newValue;
                          });
                        }
                      },
                      items: <String>[
                        'All',
                        'Animals',
                        'Crops',
                        'Equipment',
                        'Structures'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Divider
            Divider(
              height: 1,
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            // Collections List
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 20,
                    children: [
                      if (_selectedFilter == 'All' ||
                          _selectedFilter == 'Animals')
                        CollectionHolder(
                          collectionName: 'Animals',
                          items: [],
                        ),
                      if (_selectedFilter == 'All' ||
                          _selectedFilter == 'Crops')
                        CollectionHolder(collectionName: 'Crops', items: crops),
                      if (_selectedFilter == 'All' ||
                          _selectedFilter == 'Equipment')
                        CollectionHolder(
                          collectionName: 'Equipment',
                          items: [],
                        ),
                      if (_selectedFilter == 'All' ||
                          _selectedFilter == 'Structures')
                        CollectionHolder(
                          collectionName: 'Structures',
                          items: [],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
