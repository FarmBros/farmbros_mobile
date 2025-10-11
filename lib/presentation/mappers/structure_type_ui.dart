import 'package:flutter/material.dart';
import '../../domain/enums/enums.dart';

extension StructureTypeUI on StructureType {
  String get displayName => {
    StructureType.farm: 'Farm',
    StructureType.plot: 'Plot',
    StructureType.greenhouse: 'Green House',
    StructureType.barn: 'Barn/Store/Structure',
    StructureType.chickenPen: 'Chicken Pen',
    StructureType.waterSource: 'Water Source',
    StructureType.silo: 'Silo',
  }[this]!;

  String get description => {
    StructureType.farm:
    'The farm is the main area where all your crop/animal farming take place. It is the larger area surrounding everything in your farm',
    StructureType.plot:
    'A plot is a section of your farm that is under use for planting or animal keeping. It is located anywhere around your farm',
    StructureType.greenhouse:
    'A green house is a structure on your farm that you use to grow crops/plants under. It is located anywhere on the farm',
    StructureType.barn:
    'A barn/store is a structure on your farm that is used to store your animals or produces. It is denoted by this symbol. The color can be customized for different crops/animals',
    StructureType.chickenPen:
    'A chicken pen is a structure for housing poultry. It is located anywhere on the farm',
    StructureType.waterSource:
    'Water sources like ponds, wells, or irrigation systems on your farm',
    StructureType.silo:
    'Storage structure for grain, feed, or other bulk materials',
  }[this]!;

  Color get color => {
    StructureType.farm: Colors.purple,
    StructureType.plot: Colors.cyan,
    StructureType.greenhouse: Colors.green,
    StructureType.barn: Colors.red,
    StructureType.chickenPen: Colors.orange,
    StructureType.waterSource: Colors.blue,
    StructureType.silo: Colors.brown,
  }[this]!;

  IconData get icon => {
    StructureType.farm: Icons.agriculture,
    StructureType.plot: Icons.grid_on,
    StructureType.greenhouse: Icons.home_outlined,
    StructureType.barn: Icons.warehouse_outlined,
    StructureType.chickenPen: Icons.egg_outlined,
    StructureType.waterSource: Icons.water_drop_outlined,
    StructureType.silo: Icons.circle_outlined,
  }[this]!;
}
