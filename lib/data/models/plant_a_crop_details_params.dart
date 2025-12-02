class PlantACropDetailsParams {
  final String cropId;
  final String plotId;

  PlantACropDetailsParams({
    required this.cropId,
    required this.plotId,
  });

  Map<String, dynamic> toJson() => {
        "crop_id": cropId,
        "plot_id": plotId,
      };
}
