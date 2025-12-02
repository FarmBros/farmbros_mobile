class PlantACropDetailsParams {
  final String cropId;
  final String plotId;
  final String? plantingMethod;
  final double? plantingSpacing;
  final DateTime? germinationDate;
  final DateTime? transplantDate;
  final int? seedlingAge;
  final DateTime? harvestDate;
  final int? numberOfCrops;
  final double? estimatedYield;
  final String? notes;

  PlantACropDetailsParams({
    required this.cropId,
    required this.plotId,
    this.plantingMethod,
    this.plantingSpacing,
    this.germinationDate,
    this.transplantDate,
    this.seedlingAge,
    this.harvestDate,
    this.numberOfCrops,
    this.estimatedYield,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        "crop_id": cropId,
        "plot_id": plotId,
        "planting_method": plantingMethod,
        "planting_spacing": plantingSpacing,
        "germination_date": germinationDate?.toIso8601String(),
        "transplant_date": transplantDate?.toIso8601String(),
        "seedling_age": seedlingAge,
        "harvest_date": harvestDate?.toIso8601String(),
        "number_of_crops": numberOfCrops,
        "estimated_yield": estimatedYield,
        "notes": notes,
      };
}
