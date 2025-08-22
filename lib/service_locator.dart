import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/core/network/dio_client.dart';
import 'package:farmbros_mobile/data/repository/auth_repository_impl.dart';
import 'package:farmbros_mobile/data/repository/server_status_repository_impl.dart';
import 'package:farmbros_mobile/data/source/auth_api_service.dart';
import 'package:farmbros_mobile/data/source/server_status_api_service.dart';
import 'package:farmbros_mobile/domain/repository/auth_repository.dart';
import 'package:farmbros_mobile/domain/repository/server_status_repository.dart';
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

  // Services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  sl.registerSingleton<ServerStatusApiService>(ServerStatusApiServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ServerStatusRepository>(ServerStatusRepositoryImpl());

  // Usecases
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());

  // server up usecase
  sl.registerSingleton<ServerStatusUsecase>(
    ServerStatusUsecase(sl<ServerStatusApiService>()),
  );
}
