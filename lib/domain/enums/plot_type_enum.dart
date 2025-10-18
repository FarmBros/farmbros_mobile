import 'package:farmbros_mobile/domain/enums/plot_type_field.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum PlotType {
  field("Field", "Field for crop cultivation", FluentIcons.grid_24_filled,
      Colors.cyan),
  barn("Barn", "Barn for equipment and livestock shelter",
      FluentIcons.building_24_filled, Colors.brown),
  pasture("Pasture", "Pasture for livestock grazing",
      FluentIcons.plant_grass_24_filled, Colors.green),
  greenhouse("Green House", "Greenhouse for controlled environment cultivation",
      FluentIcons.plant_cattail_24_regular, Colors.lightGreen),
  chickenpen("Chicken Pen", "Chicken pen for poultry farming",
      FluentIcons.food_egg_24_filled, Colors.orange),
  cowshed("Cow Shed", "Cow shed for cattle housing",
      FluentIcons.building_home_24_filled, Colors.red),
  fishpond("Fish Pond", "Fish pond for aquaculture",
      FluentIcons.food_fish_24_filled, Colors.blue),
  residence("Residence", "Residence for housing", FluentIcons.home_24_filled,
      Colors.deepOrange),
  naturalarea("Natural Area", "Natural area for conservation",
      FluentIcons.leaf_two_48_regular, Colors.teal),
  waterSource("Water Source", "Water source for wells, springs, etc.",
      FluentIcons.water_24_filled, Colors.lightBlue);

  final String displayName;
  final String description;
  final IconData icon;
  final Color color;

  const PlotType(this.displayName, this.description, this.icon, this.color);

  // Convert to API-compatible string format
  String toApiString() {
    switch (this) {
      case PlotType.field:
        return "field";
      case PlotType.barn:
        return "barn";
      case PlotType.pasture:
        return "pasture";
      case PlotType.greenhouse:
        return "green-house";
      case PlotType.chickenpen:
        return "chicken-pen";
      case PlotType.cowshed:
        return "cow-shed";
      case PlotType.fishpond:
        return "fish-pond";
      case PlotType.residence:
        return "residence";
      case PlotType.naturalarea:
        return "natural-area";
      case PlotType.waterSource:
        return "water-source";
    }
  }

  // Get PlotType from API string
  static PlotType? fromApiString(String apiString) {
    switch (apiString) {
      case "field":
        return PlotType.field;
      case "barn":
        return PlotType.barn;
      case "pasture":
        return PlotType.pasture;
      case "green-house":
        return PlotType.greenhouse;
      case "chicken-pen":
        return PlotType.chickenpen;
      case "cow-shed":
        return PlotType.cowshed;
      case "fish-pond":
        return PlotType.fishpond;
      case "residence":
        return PlotType.residence;
      case "natural-area":
        return PlotType.naturalarea;
      case "water-source":
        return PlotType.waterSource;
      default:
        return null;
    }
  }

  // Get specific fields required for this plot type
  List<PlotTypeField> getRequiredFields() {
    switch (this) {
      case PlotType.field:
        return [
          PlotTypeField.soilType,
          PlotTypeField.irrigationSystem,
        ];
      case PlotType.barn:
        return [
          PlotTypeField.structureType,
        ];
      case PlotType.pasture:
        return [
          PlotTypeField.status,
        ];
      case PlotType.greenhouse:
        return [
          PlotTypeField.greenhouseType,
        ];
      case PlotType.chickenpen:
        return [
          PlotTypeField.chickenCapacity,
          PlotTypeField.coopType,
          PlotTypeField.nestingBoxes,
          PlotTypeField.runAreaCovered,
          PlotTypeField.feedingSystem,
        ];
      case PlotType.cowshed:
        return [
          PlotTypeField.cowCapacity,
          PlotTypeField.milkingSystem,
          PlotTypeField.feedingSystem,
          PlotTypeField.beddingType,
          PlotTypeField.wasteManagement,
        ];
      case PlotType.fishpond:
        return [
          PlotTypeField.pondDepth,
          PlotTypeField.filtrationSystem,
          PlotTypeField.aerationSystem,
        ];
      case PlotType.residence:
        return [
          PlotTypeField.buildingType,
        ];
      case PlotType.naturalarea:
        return [
          PlotTypeField.ecosystemType,
        ];
      case PlotType.waterSource:
        return [
          PlotTypeField.sourceType,
          PlotTypeField.depth,
        ];
    }
  }
}
