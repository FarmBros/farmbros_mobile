import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum PlotTypeField {
  // Field plot type fields
  soilType("Soil Type", FluentIcons.weather_partly_cloudy_day_24_filled, false,
      false, false),
  irrigationSystem(
      "Irrigation System", FluentIcons.water_24_filled, false, false, false),

  // Barn plot type fields
  structureType(
      "Structure Type", FluentIcons.building_24_filled, false, false, false),

  // Pasture plot type fields
  status("Status", FluentIcons.status_24_filled, false, false, false),

  // Greenhouse plot type fields
  greenhouseType("Greenhouse Type", FluentIcons.plant_cattail_24_regular, false,
      false, false),

  // Chicken pen plot type fields
  chickenCapacity("Chicken Capacity", FluentIcons.number_symbol_24_filled,
      false, false, false),
  coopType(
      "Coop Type", FluentIcons.building_home_24_filled, false, false, false),
  nestingBoxes("Nesting Boxes", FluentIcons.box_24_filled, false, false, false),
  runAreaCovered(
      "Run Area Covered", FluentIcons.ruler_24_filled, false, false, false),

  // Cow shed plot type fields
  cowCapacity(
      "Cow Capacity", FluentIcons.number_symbol_24_filled, false, false, false),
  milkingSystem(
      "Milking System", FluentIcons.beaker_24_filled, false, false, false),
  beddingType("Bedding Type", FluentIcons.bed_24_filled, false, false, false),
  wasteManagement(
      "Waste Management", FluentIcons.delete_24_filled, false, false, false),

  // Fish pond plot type fields
  pondDepth(
      "Pond Depth", FluentIcons.arrow_down_24_filled, false, false, false),
  filtrationSystem(
      "Filtration System", FluentIcons.filter_24_filled, false, false, false),
  aerationSystem("Aeration System", FluentIcons.weather_blowing_snow_24_filled,
      false, false, false),

  // Residence plot type fields
  buildingType(
      "Building Type", FluentIcons.home_24_filled, false, false, false),

  // Natural area plot type fields
  ecosystemType(
      "Ecosystem Type", FluentIcons.leaf_two_48_regular, false, false, false),

  // Water source plot type fields
  sourceType("Source Type", FluentIcons.water_24_filled, false, false, false),
  depth("Depth", FluentIcons.arrow_down_24_filled, false, false, false),

  // Shared fields
  feedingSystem(
      "Feeding System", FluentIcons.food_24_filled, false, false, false),
  notes("Notes", FluentIcons.note_24_filled, false, true, false);

  final String label;
  final IconData icon;
  final bool isPassword;
  final bool isTextArea;
  final bool isDropDownField;

  const PlotTypeField(
    this.label,
    this.icon,
    this.isPassword,
    this.isTextArea,
    this.isDropDownField,
  );

  // Convert to API-compatible field name
  String toApiFieldName() {
    switch (this) {
      case PlotTypeField.soilType:
        return "soil_type";
      case PlotTypeField.irrigationSystem:
        return "irrigation_system";
      case PlotTypeField.structureType:
        return "structure_type";
      case PlotTypeField.status:
        return "status";
      case PlotTypeField.greenhouseType:
        return "greenhouse_type";
      case PlotTypeField.chickenCapacity:
        return "chicken_capacity";
      case PlotTypeField.coopType:
        return "coop_type";
      case PlotTypeField.nestingBoxes:
        return "nesting_boxes";
      case PlotTypeField.runAreaCovered:
        return "run_area_covered";
      case PlotTypeField.cowCapacity:
        return "cow_capacity";
      case PlotTypeField.milkingSystem:
        return "milking_system";
      case PlotTypeField.beddingType:
        return "bedding_type";
      case PlotTypeField.wasteManagement:
        return "waste_management";
      case PlotTypeField.pondDepth:
        return "pond_depth";
      case PlotTypeField.filtrationSystem:
        return "filtration_system";
      case PlotTypeField.aerationSystem:
        return "aeration_system";
      case PlotTypeField.buildingType:
        return "building_type";
      case PlotTypeField.ecosystemType:
        return "ecosystem_type";
      case PlotTypeField.sourceType:
        return "source_type";
      case PlotTypeField.depth:
        return "depth";
      case PlotTypeField.feedingSystem:
        return "feeding_system";
      case PlotTypeField.notes:
        return "notes";
    }
  }
}
