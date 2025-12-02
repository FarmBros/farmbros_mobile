abstract class PlantedCropState {}

class PlantedCropStateLoading extends PlantedCropState {}

class PlantedCropStateSuccess extends PlantedCropState {}

class PlantedCropStateSetPlantedCrop extends PlantedCropState {
  final Map plantedCrop;

  PlantedCropStateSetPlantedCrop({required this.plantedCrop});
}

class PlantedCropStateSetPlantedCrops extends PlantedCropState {
  final List plantedCrops;

  PlantedCropStateSetPlantedCrops({required this.plantedCrops});
}

class PlantedCropStateError extends PlantedCropState {
  final String errorMessage;

  PlantedCropStateError({required this.errorMessage});
}
