import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/farm/farms_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/farm_logger/crop_logger_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/planted_crop/planted_crop_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_profile_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/repository/auth_repository_impl.dart';
import 'package:farmbros_mobile/data/repository/farm_details_impl.dart';
import 'package:farmbros_mobile/data/repository/farm_logger_impl.dart';
import 'package:farmbros_mobile/data/repository/planted_crop_impl.dart';
import 'package:farmbros_mobile/data/repository/plot_details_impl.dart';
import 'package:farmbros_mobile/data/repository/server_status_repository_impl.dart';
import 'package:farmbros_mobile/data/source/auth_api_service.dart';
import 'package:farmbros_mobile/data/source/farm_api_service.dart';
import 'package:farmbros_mobile/data/source/farm_logger_service.dart';
import 'package:farmbros_mobile/data/source/planted_crop_service.dart';
import 'package:farmbros_mobile/data/source/plot_api_service.dart';
import 'package:farmbros_mobile/data/source/server_status_api_service.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/domain/repository/farm_details_repository.dart';
import 'package:farmbros_mobile/domain/repository/farm_logger_repository.dart';
import 'package:farmbros_mobile/domain/repository/planted_crop_repository.dart';
import 'package:farmbros_mobile/domain/repository/plot_details_repository.dart';
import 'package:farmbros_mobile/domain/repository/server_status_repository.dart';
import 'package:farmbros_mobile/domain/usecases/crop_logger_usecase.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_all_planted_crops_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farm_plots_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farm_usecase.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farms_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/plant_a_crop_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/plot_profile_use__case.dart';
import 'package:farmbros_mobile/domain/usecases/save_farm_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/save_plot_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/server_status_usecase.dart';
import 'package:farmbros_mobile/domain/usecases/sign_in_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/sign_up_use_case.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Dio
  sl.registerSingleton<DioClient>(DioClient());

  // blocs
  sl.registerLazySingleton<SessionCubit>(() => SessionCubit());
  sl.registerLazySingleton<OnboardingStateCubit>(() => OnboardingStateCubit());
  sl.registerLazySingleton<FarmsStateCubit>(() => FarmsStateCubit());
  sl.registerLazySingleton<FarmStateCubit>(() => FarmStateCubit());
  sl.registerLazySingleton<PlotStateCubit>(() => PlotStateCubit());
  sl.registerLazySingleton<PlotProfileStateCubit>(
      () => PlotProfileStateCubit());
  sl.registerLazySingleton<CropLoggerStateCubit>(() => CropLoggerStateCubit());
  sl.registerLazySingleton<PlantedCropStateCubit>(
      () => PlantedCropStateCubit());

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<ServerStatusApiService>(ServerStatusApiServiceImpl());
  sl.registerSingleton<FarmApiService>(FarmApiServiceImpl());
  sl.registerSingleton<PlotApiService>(PlotApiServiceImpl());
  sl.registerSingleton<FarmLoggerAPIService>(FarmLoggerAPIServiceImpl());
  sl.registerSingleton<PlantedCropService>(PlantedCropServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ServerStatusRepository>(ServerStatusRepositoryImpl());
  sl.registerSingleton<FarmDetailsRepository>(FarmDetailsImpl());
  sl.registerSingleton<PlotDetailsRepository>(PlotDetailsImpl());
  sl.registerSingleton<FarmLoggerRepository>(FarmLoggerImpl());
  sl.registerSingleton<PlantedCropRepository>(PlantedCropImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());

  sl.registerSingleton<ServerStatusUsecase>(
    ServerStatusUsecase(sl<ServerStatusApiService>()),
  );

  sl.registerSingleton<FetchFarmsUsecase>(
    FetchFarmsUsecase(sl<FarmApiService>()),
  );

  sl.registerSingleton<FetchFarmUsecase>(
    FetchFarmUsecase(sl<FarmApiService>()),
  );

  sl.registerSingleton<SaveFarmUseCase>(
    SaveFarmUseCase(),
  );

  sl.registerSingleton<SavePlotUseCase>(
    SavePlotUseCase(),
  );

  sl.registerSingleton<FetchFarmPlotsUsecase>(
    FetchFarmPlotsUsecase(),
  );

  sl.registerSingleton<PlotProfileUseCase>(
    PlotProfileUseCase(sl<PlotApiService>()),
  );

  sl.registerSingleton<CropLoggerUseCase>(
    CropLoggerUseCase(sl<FarmLoggerAPIService>()),
  );

  sl.registerSingleton<PlantACropUseCase>(
    PlantACropUseCase(sl<PlantedCropService>()),
  );

  sl.registerSingleton<FetchAllPlantedCropsUseCase>(
    FetchAllPlantedCropsUseCase(sl<PlantedCropService>()),
  );
}
