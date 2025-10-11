// import 'package:farmbros_mobile/common/bloc/mapbox/map_box_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// class MapBoxStateCubit extends Cubit<MapBoxState> {
//   MapBoxStateCubit() : super(LoadingMapBox());

//   final Logger logger = Logger();

//   Future<void> initializeMapBoxInstance() async {
//     emit(LoadingMapBox());

//     try {
//       final token = dotenv.env["MAPBOX_ACCESS_TOKEN"];
//       if (token == null || token.isEmpty) {
//         throw Exception("MAPBOX_ACCESS_TOKEN is missing in .env file");
//       }

//       MapboxOptions.setAccessToken(token);

//       emit(MapBoxInitSuccess());
//     } catch (e, stack) {
//       logger.e("Failed to initialize MapBox", error: e, stackTrace: stack);
//       emit(MapBoxInitFailure(initializationError: e.toString()));
//     }
//   }
// }
