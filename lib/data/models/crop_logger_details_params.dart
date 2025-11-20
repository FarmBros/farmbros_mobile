class CropLoggerDetailsParams {
  final int skip;
  final int limit;

  CropLoggerDetailsParams({
    required this.skip,
    required this.limit,
  });

  Map<String, dynamic> toJson() => {
        "skip": skip,
        "limit": limit,
  };
}
