import 'package:farmbros_mobile/common/bloc/planted_crop/planted_crop_state.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/planted_crop/planted_crop_state_cubit.dart'; // Add this line
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/data/models/plant_a_crop_details_params.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farm_plots_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/plant_a_crop_use_case.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class CropDetailsCard extends StatefulWidget {
  final Map<String, dynamic> cropData;
  final List<dynamic> farms;

  const CropDetailsCard({
    super.key,
    required this.cropData,
    required this.farms,
  });

  @override
  State<CropDetailsCard> createState() => _CropDetailsCardState();
}

class _CropDetailsCardState extends State<CropDetailsCard> {
  bool _isCropDetailsExpanded = true;
  bool _isPlantCropExpanded = false;
  String? _selectedFarm;
  String? _selectedPlot;

  String? _plantingMethod;
  double? _plantingSpacing;
  DateTime? _germinationDate;
  DateTime? _transplantDate;
  int? _seedlingAge;
  DateTime? _harvestDate;
  int? _numberOfCrops;
  double? _estimatedYield;
  String? _notes;

  List<dynamic> _farms = [];
  List<Map<String, dynamic>> _plots = [];

  @override
  void initState() {
    super.initState();
    _farms = widget.farms;
    if (_farms.isNotEmpty) {
      _selectedFarm = _farms.first['uuid'];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PlotStateCubit>().execute(
              FetchPlotDetailsParams(
                  farmId: _selectedFarm!,
                  includeGeoJson: false,
                  skip: 0,
                  limit: 10),
              sl<FetchFarmPlotsUsecase>(),
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlantedCropStateCubit, PlantedCropState>(
        listener: (context, plantedCropState) {
          if (plantedCropState is PlantedCropStateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${widget.cropData['common_name']} planted successfully!',
                ),
                backgroundColor: ColorUtils.secondaryColor,
              ),
            );
            Navigator.of(context).pop();
          } else if (plantedCropState is PlantedCropStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error planting ${widget.cropData['common_name']}: ${plantedCropState.errorMessage}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocListener<PlotStateCubit, PlotState>(
            listener: (context, plotState) {
              if (plotState is PlotStateSuccess) {
                setState(() {
                  _plots = (plotState.data!["data"] as List)
                      .map((e) => e as Map<String, dynamic>)
                      .toList();
                  if (_plots.isNotEmpty && _selectedPlot == null) {
                    _selectedPlot = _plots.first['uuid'];
                  }
                });
              }
            },
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Section with Image and Close Button
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ColorUtils.secondaryColor.withOpacity(0.08),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Crop Image
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: ColorUtils.secondaryColor
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColorUtils.secondaryColor
                                        .withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/crop-images/${widget.cropData['common_name']?.toString().toLowerCase().replaceAll(' ', '_')}.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        FluentIcons.plant_grass_24_regular,
                                        color: ColorUtils.secondaryColor,
                                        size: 32,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Crop Name and Scientific Name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.cropData['common_name'] ??
                                          'Unknown Crop',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.cropData['scientific_name'] ?? '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildBadge(
                                      widget.cropData['lifecycle'] ?? 'unknown',
                                      FluentIcons.leaf_one_24_regular,
                                    ),
                                  ],
                                ),
                              ),

                              // Close Button
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  FluentIcons.dismiss_24_regular,
                                  color: Colors.grey.shade700,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Crop Details Section
                            _buildCollapsibleSection(
                              title: 'Crop Details',
                              icon: FluentIcons.info_24_regular,
                              isExpanded: _isCropDetailsExpanded,
                              onToggle: () {
                                setState(() {
                                  _isCropDetailsExpanded =
                                      !_isCropDetailsExpanded;
                                });
                              },
                              child: _buildCropDetailsContent(),
                            ),

                            const SizedBox(height: 16),

                            // Plant Crop Section
                            _buildCollapsibleSection(
                              title: 'Plant Crop',
                              icon: FluentIcons.add_circle_24_regular,
                              isExpanded: _isPlantCropExpanded,
                              onToggle: () {
                                setState(() {
                                  _isPlantCropExpanded = !_isPlantCropExpanded;
                                });
                              },
                              child: _buildPlantCropContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorUtils.secondaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: ColorUtils.secondaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ColorUtils.secondaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorUtils.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: ColorUtils.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? FluentIcons.chevron_up_16_regular
                        : FluentIcons.chevron_down_16_regular,
                    color: ColorUtils.secondaryColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCropDetailsContent() {
    return Column(
      children: [
        // Growth Information
        _buildInfoCard(
          title: 'Growth Information',
          items: [
            _buildInfoRow('Crop Group', widget.cropData['crop_group'] ?? 'N/A'),
            _buildInfoRow('Genus', widget.cropData['genus'] ?? 'N/A'),
            _buildInfoRow('Species', widget.cropData['species'] ?? 'N/A'),
            _buildInfoRow('Lifecycle', widget.cropData['lifecycle'] ?? 'N/A'),
          ],
        ),

        const SizedBox(height: 12),

        // Timeline Information
        _buildInfoCard(
          title: 'Timeline',
          items: [
            _buildInfoRow(
              'Germination',
              '${widget.cropData['germination_days'] ?? 'N/A'} days',
              icon: FluentIcons.clock_24_regular,
            ),
            _buildInfoRow(
              'Days to Transplant',
              widget.cropData['days_to_transplant'] != null
                  ? '${widget.cropData['days_to_transplant']} days'
                  : 'N/A',
              icon: FluentIcons.arrow_move_24_regular,
            ),
            _buildInfoRow(
              'Days to Maturity',
              '${widget.cropData['days_to_maturity'] ?? 'N/A'} days',
              icon: FluentIcons.checkmark_circle_24_regular,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Planting Information
        _buildInfoCard(
          title: 'Planting Details',
          items: [
            _buildInfoRow(
              'Planting Method',
              widget.cropData['planting_methods'] ?? 'N/A',
            ),
            _buildInfoRow(
              'Seedling Type',
              widget.cropData['seedling_type'] ?? 'N/A',
            ),
            _buildInfoRow(
              'Planting Spacing',
              widget.cropData['planting_spacing_m'] != null
                  ? '${widget.cropData['planting_spacing_m']} m'
                  : 'N/A',
            ),
            if (widget.cropData['row_spacing_m'] != null)
              _buildInfoRow(
                'Row Spacing',
                '${widget.cropData['row_spacing_m']} m',
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Yield Information
        _buildInfoCard(
          title: 'Yield Information',
          items: [
            _buildInfoRow(
              'Yield per Plant',
              widget.cropData['yield_per_plant'] != null
                  ? '${widget.cropData['yield_per_plant']} kg'
                  : 'N/A',
            ),
            if (widget.cropData['yield_per_area'] != null)
              _buildInfoRow(
                'Yield per Area',
                '${widget.cropData['yield_per_area']} kg/m²',
              ),
          ],
        ),

        // Notes Section
        if (widget.cropData['notes'] != null &&
            widget.cropData['notes'].toString().isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorUtils.secondaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorUtils.secondaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FluentIcons.note_24_regular,
                  size: 16,
                  color: ColorUtils.secondaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.cropData['notes'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ColorUtils.secondaryColor,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCropContent() {
    final logger = Logger();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Farm Dropdown
        _buildDropdown(
          label: 'Select Farm',
          icon: FluentIcons.building_home_24_regular,
          value: _selectedFarm,
          items: _farms,
          onChanged: (value) {
            setState(() {
              _selectedFarm = value;
              _selectedPlot = null; // Reset plot when farm changes
            });
            if (value != null) {
              context.read<PlotStateCubit>().execute(
                FetchPlotDetailsParams(
                    farmId: value, includeGeoJson: false, skip: 0, limit: 10),
                sl<FetchFarmPlotsUsecase>(),
              );
            }
          },
        ),

        const SizedBox(height: 16),

        // Plot Dropdown
        _buildDropdown(
          label: 'Select Plot',
          icon: FluentIcons.grid_24_regular,
          value: _selectedPlot,
          items: _plots,
          onChanged: (value) {
            setState(() {
              _selectedPlot = value;
            });
          },
          enabled: _selectedFarm != null,
        ),

        const SizedBox(height: 16),

        // Planting Method
        _buildTextField(
          label: 'Planting Method',
          icon: FluentIcons.leaf_one_24_regular,
          onChanged: (value) {
            setState(() {
              _plantingMethod = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // Notes
        _buildTextField(
          label: 'Notes',
          icon: FluentIcons.note_24_regular,
          maxLines: 3,
          onChanged: (value) {
            setState(() {
              _notes = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // Planting Spacing
        _buildTextField(
          label: 'Planting Spacing (m)',
          icon: FluentIcons.ruler_24_regular,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _plantingSpacing = double.tryParse(value);
            });
          },
        ),

        const SizedBox(height: 16),

        // Number of Crops
        _buildTextField(
          label: 'Number of Crops',
          icon: FluentIcons.number_row_24_regular,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _numberOfCrops = int.tryParse(value);
            });
          },
        ),

        const SizedBox(height: 16),

        // Estimated Yield
        _buildTextField(
          label: 'Estimated Yield (kg)',
          icon: FluentIcons.box_24_regular,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _estimatedYield = double.tryParse(value);
            });
          },
        ),

        const SizedBox(height: 16),

        // Seedling Age
        _buildTextField(
          label: 'Seedling Age (days)',
          icon: FluentIcons.leaf_one_24_regular,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _seedlingAge = int.tryParse(value);
            });
          },
        ),

        const SizedBox(height: 16),

        // Germination Date
        _buildDatePickerField(
          label: 'Germination Date',
          icon: FluentIcons.calendar_ltr_24_regular,
          selectedDate: _germinationDate,
          onDateSelected: (date) {
            setState(() {
              _germinationDate = date;
            });
          },
        ),

        const SizedBox(height: 16),

        // Transplant Date
        _buildDatePickerField(
          label: 'Transplant Date',
          icon: FluentIcons.calendar_ltr_24_regular,
          selectedDate: _transplantDate,
          onDateSelected: (date) {
            setState(() {
              _transplantDate = date;
            });
          },
        ),

        const SizedBox(height: 16),

        // Harvest Date
        _buildDatePickerField(
          label: 'Harvest Date',
          icon: FluentIcons.calendar_ltr_24_regular,
          selectedDate: _harvestDate,
          onDateSelected: (date) {
            setState(() {
              _harvestDate = date;
            });
          },
        ),

        const SizedBox(height: 20),

        // Plant Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _selectedFarm != null && _selectedPlot != null
                ? () {
                    final plantCropParams = PlantACropDetailsParams(
                      cropId: widget.cropData['uuid'],
                      plotId: _selectedPlot!,
                      plantingMethod: _plantingMethod,
                      plantingSpacing: _plantingSpacing,
                      germinationDate: _germinationDate,
                      transplantDate: _transplantDate,
                      seedlingAge: _seedlingAge,
                      harvestDate: _harvestDate,
                      numberOfCrops: _numberOfCrops,
                      estimatedYield: _estimatedYield,
                      notes: _notes,
                    );
                    context.read<PlantedCropStateCubit>().plantACrop(
                        plantCropParams, sl<PlantACropUseCase>());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorUtils.secondaryColor,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.plant_grass_24_filled,
                  size: 20,
                  color: _selectedFarm != null && _selectedPlot != null
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  'Plant Crop',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _selectedFarm != null && _selectedPlot != null
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<dynamic> items, // Changed type to List<Map<String, dynamic>>
    required Function(String?) onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: enabled ? ColorUtils.secondaryColor : Colors.grey.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: enabled ? Colors.black87 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
            border: Border.all(
              color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Choose $label',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  FluentIcons.chevron_down_16_regular,
                  color: enabled
                      ? ColorUtils.secondaryColor
                      : Colors.grey.shade400,
                  size: 18,
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              onChanged: enabled ? onChanged : null,
              items: items.map<DropdownMenuItem<String>>((dynamic item) {
                return DropdownMenuItem<String>(
                  value: item['uuid'],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(item['name']),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: ColorUtils.secondaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorUtils.secondaryColor, width: 2),
            ),
            fillColor: Colors.grey.shade50,
            filled: true,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: ColorUtils.secondaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: ColorUtils.secondaryColor, // header background color
                      onPrimary: Colors.white, // header text color
                      onSurface: Colors.black, // body text color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: ColorUtils.secondaryColor, // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != selectedDate) {
              onDateSelected(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Select $label'
                        : '${selectedDate.toLocal().year}-${selectedDate.toLocal().month.toString().padLeft(2, '0')}-${selectedDate.toLocal().day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDate == null
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  FluentIcons.calendar_ltr_24_regular,
                  size: 18,
                  color: ColorUtils.secondaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
