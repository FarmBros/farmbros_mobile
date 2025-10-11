import 'package:farmbros_mobile/common/bloc/farm_bros_map/farm_bros_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/onboarding/onboarding_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/repository/auth_repository_impl.dart';
import 'package:farmbros_mobile/data/repository/save_farm_details_impl.dart';
import 'package:farmbros_mobile/data/repository/server_status_repository_impl.dart';
import 'package:farmbros_mobile/data/source/auth_api_service.dart';
import 'package:farmbros_mobile/data/source/farm_api_service.dart';
import 'package:farmbros_mobile/data/source/server_status_api_service.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/domain/repository/farm_details_repository.dart';
import 'package:farmbros_mobile/domain/repository/server_status_repository.dart';
import 'package:farmbros_mobile/domain/usecases/save_farm_use_case.dart';
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
  sl.registerLazySingleton<FarmBrosStateCubit>(() => FarmBrosStateCubit());

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<ServerStatusApiService>(ServerStatusApiServiceImpl());
  sl.registerSingleton<FarmApiService>(FarmApiServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ServerStatusRepository>(ServerStatusRepositoryImpl());
  sl.registerSingleton<FarmDetailsRepository>(SaveFarmDetailsImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());

  // server up usecase
  sl.registerSingleton<ServerStatusUsecase>(
    ServerStatusUsecase(sl<ServerStatusApiService>()),
  );

  sl.registerSingleton<SaveFarmUseCase>(
    SaveFarmUseCase(),
  );
}
