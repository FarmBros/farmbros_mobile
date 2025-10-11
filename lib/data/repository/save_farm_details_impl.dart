import 'package:dartz/dartz.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/data/source/farm_api_service.dart';
import 'package:farmbros_mobile/domain/repository/farm_details_repository.dart';
import 'package:farmbros_mobile/service_locator.dart';

class SaveFarmDetailsImpl extends FarmDetailsRepository {
  @override
  Future<Either> saveFarmDetails(FarmDetailsParams farmDetailsParams) async {
    return sl<FarmApiService>().saveFarmDetails(farmDetailsParams);
  }
}
