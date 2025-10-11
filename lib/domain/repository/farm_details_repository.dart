import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';

abstract class FarmDetailsRepository {
  Future<Either> saveFarmDetails(FarmDetailsParams farmDetailsParams);
}