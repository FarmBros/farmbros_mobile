import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import '../../domain/enums/enums.dart';

extension StructureTypeUI on StructureType {
  String get displayName => {
    StructureType.farm: 'Farm',
    StructureType.field: 'Field',
    StructureType.greenhouse: 'Green House',
    StructureType.cowshed: 'Cow Shed',
    StructureType.barn: 'Barn/Store/Structure',
    StructureType.pasture: 'Pasture',
    StructureType.chickenpen: 'Chicken Pen',
    StructureType.watersource: 'Water Source',
    StructureType.fishpond: 'Fish Pond',
    StructureType.residence: 'Residence',
    StructureType.naturalArea: 'Natural Area',
  }[this]!;

  String get description => {
    StructureType.farm:
    'The farm is the main area where all your crop/animal farming take place. It is the larger area surrounding everything in your farm',
    StructureType.field:
    'A field is a section of your farm that is under use for planting or animal keeping. It is located anywhere around your farm',
    StructureType.greenhouse:
    'A green house is a structure on your farm that you use to grow crops/plants under. It is located anywhere on the farm',
    StructureType.cowshed:
    'A cow shed is a structure on your farm that is used to store your cows or produces. It is denoted by this symbol.',
    StructureType.barn:
    'A barn/store is a structure on your farm that is used to store your animals or produces. The color can be customized for different crops/animals',
    StructureType.pasture:
    'An open grazing or roaming area for animals.',
    StructureType.chickenpen:
    'A chicken pen is a structure for housing poultry. It is located anywhere on the farm',
    StructureType.watersource:
    'Water sources like ponds, wells, or irrigation systems on your farm',
    StructureType.fishpond:
    'A fish pond is an artificial water body you setup to breed fish for consumption/sale',
    StructureType.residence:
    'Living area of the farmer and his family',
    StructureType.naturalArea:
    'Open field or preserved area with no particular activity.',
  }[this]!;

  Color get color => {
    StructureType.farm: Colors.purple,
    StructureType.field: Colors.cyan,
    StructureType.greenhouse: Colors.green,
    StructureType.cowshed: Colors.red,
    StructureType.barn: Colors.red,
    StructureType.pasture: Colors.green,
    StructureType.chickenpen: Colors.orange,
    StructureType.watersource: Colors.blue,
    StructureType.fishpond: Colors.cyan,
    StructureType.residence: Colors.brown,
    StructureType.naturalArea: Colors.brown,
  }[this]!;

  IconData get icon => {
    StructureType.farm: Icons.agriculture,
    StructureType.field: Icons.grid_on,
    StructureType.greenhouse: Icons.home_outlined,
    StructureType.cowshed: Icons.warehouse_outlined,
    StructureType.barn: Icons.warehouse_outlined,
    StructureType.pasture: Icons.grass_outlined,
    StructureType.chickenpen: Icons.egg_outlined,
    StructureType.watersource: Icons.water_drop_outlined,
    StructureType.fishpond: FluentIcons.food_fish_20_filled,
    StructureType.residence: Icons.circle_outlined,
    StructureType.naturalArea: Icons.nature_outlined,
  }[this]!;
}
