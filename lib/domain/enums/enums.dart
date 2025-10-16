import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum StructureType {
  farm(
      'Farm',
      'The farm is the main area where all your crop/animal farming take place. It is the larger area surrounding everything in your farm',
      Colors.purple,
      Icons.agriculture),
  field(
      'Field',
      'A field is a section of your farm that is under use for planting or animal keeping. It is located anywhere around your farm',
      Colors.cyan,
      Icons.grid_on),
  greenhouse(
      'Green House',
      'A green house is a structure on your farm that you use to grow crops/plants under. It is located anywhere on the farm',
      Colors.green,
      Icons.home_outlined),
  cowShed(
      'Cow Shed',
      'A cow shed is a structure on your farm that is used to store your cows or produces. It is denoted by this symbol.',
      Colors.red,
      Icons.warehouse_outlined),
  barn(
      'Barn/Store/Structure',
      'A barn/store is a structure on your farm that is used to store your animals or produces. It is denoted by this symbol. The color can be customized for different crops/animals',
      Colors.red,
      Icons.warehouse_outlined),
  pasture(
      'Pasture',
      'A pasture is a structure on your farm that is used to store your animals or produces. It is denoted by this symbol. The color can be customized for different crops/animals',
      Colors.red,
      Icons.grass_outlined),
  chickenPen(
      'Chicken Pen',
      'A chicken pen is a structure for housing poultry. It is located anywhere on the farm',
      Colors.orange,
      Icons.egg_outlined),
  waterSource(
      'Water Source',
      'Water sources like ponds, wells, or irrigation systems on your farm',
      Colors.blue,
      Icons.water_drop_outlined),
  fishPond(
      'Fish Pond',
      'A fish pond is an artificial water body you setup to breed fish for consumption/sale',
      Colors.cyan,
      FluentIcons.food_fish_20_filled),
  residence('Residence', 'Living area of the farmer and his family',
      Colors.brown, Icons.circle_outlined),
  naturalArea('Natural Area', 'Open field with no particular activity.',
      Colors.brown, Icons.nature_outlined);

  final String displayName;
  final String description;
  final Color color;
  final IconData icon;

  const StructureType(
      this.displayName, this.description, this.color, this.icon);
}

enum SummaryStripType {
  activePlots("Active Plots", Colors.green, FluentIcons.live_24_regular),
  inActivePlots(
      "In-active Plots", Colors.orange, FluentIcons.open_off_24_regular),
  riskPlots("Risk Plots", Colors.purple, FluentIcons.warning_24_regular);

  final String stripText;
  final Color stripColor;
  final IconData stripIcon;

  const SummaryStripType(this.stripText, this.stripColor, this.stripIcon);
}

enum CreatePlotInputType {
  plotName("Plot Name", FluentIcons.location_24_filled, false, false, false),
  plotNumber("Plot Number", FluentIcons.number_circle_0_24_regular, false,
      false, false),
  notes("Plot Notes", FluentIcons.note_24_regular, false, true, false),
  plotType("Plot Type", FluentIcons.grid_24_filled, false, false, true);

  final String inputLabel;
  final IconData inputIcon;
  final bool isPassword;
  final bool isTextArea;
  final bool isDropDownField;

  const CreatePlotInputType(
    this.inputLabel,
    this.inputIcon,
    this.isPassword,
    this.isTextArea,
    this.isDropDownField,
  );
}
