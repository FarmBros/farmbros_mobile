import 'dart:convert';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/farm_bros_map/farm_bros_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:farmbros_mobile/domain/usecases/save_farm_use_case.dart';
import 'package:farmbros_mobile/presentation/map/widgets/farmbros_map_search_bar.dart';
import 'package:farmbros_mobile/presentation/map/widgets/structure_editor.dart';
import 'package:farmbros_mobile/presentation/map/widgets/structure_selector.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:farmbros_mobile/service_locator.dart';

class FarmbrosMap extends StatefulWidget {
  const FarmbrosMap({super.key});

  @override
  State<FarmbrosMap> createState() => _FarmbrosMapState();
}

class _FarmbrosMapState extends State<FarmbrosMap> {
  GoogleMapController? _mapController;
  MapType _currentMapType = MapType.hybrid;
  final Map<String, List<LatLng>> _structures = {};
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _searchSuggestions = [];
  bool _showSuggestions = false;

  StructureType? _selectedStructureType;
  bool _isDrawingMode = false;
  bool _showStructureSelection = false;
  bool _isDrawingCardMinimized = false;
  List<LatLng> currentDrawingPoints = [];
  String? _currentStructureName;

  TextEditingController farmName = TextEditingController();
  TextEditingController farmDescription = TextEditingController();

  Logger logger = Logger();

  final String? _googleMapsApiKey = dotenv.env["GOOGLE_MAPS_API_KEY"];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-1.2921, 36.8219),
    zoom: 10.0,
  );

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final RouteSettings? currentPath = ModalRoute.of(context)!.settings;
    final bool isCreatingFarm =
        currentPath?.name?.contains('/farms/create_farm/map') ?? false;

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: _onMapCreated,
            onTap: _isDrawingMode ? _onTap : null,
            polygons: _polygons,
            markers: _markers,
            mapType: _currentMapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FarmbrosAppbar(
                  appBarTitle: isCreatingFarm
                      ? "Map your Farm"
                      : "Map your Plots & Structures",
                  openSideBar: () {
                    context.pop();
                  },
                  icon: FluentIcons.ios_arrow_24_regular,
                  hasAction: true,
                  appBarAction: _saveAllStructures,
                  actionText:
                      isCreatingFarm ? "Save Farm" : "Save Plot/Structure",
                ),
              )),

          // Structure Selection Card (when not drawing)
          if (_showStructureSelection && !_isDrawingMode)
            Positioned(
              left: 20,
              bottom: 80,
              child: StructureSelector(
                  onPressed: () {
                    setState(() {
                      _showStructureSelection = false;
                    });
                  },
                  isCreatingFarm: isCreatingFarm,
                  startDrawing: _startDrawing),
            ),

          // Active Drawing Card (Minimized/Expanded)
          if (_isDrawingMode && _selectedStructureType != null)
            Positioned(
              left: 20,
              bottom: 80,
              child: StructureEditor(
                  structureType: _selectedStructureType,
                  toggleDrawingCardMinimize: () {
                    setState(() {
                      _isDrawingCardMinimized = !_isDrawingCardMinimized;
                    });
                  },
                  isDrawingCardMinimized: _isDrawingCardMinimized,
                  currentDrawingPoints: currentDrawingPoints,
                  undoLastPoint: _undoLastPoint,
                  clearCurrentDrawing: _clearCurrentDrawing,
                  finishDrawing: _finishDrawing,
                  cancelDrawing: _cancelDrawing),
            ),

          // Search Bar with Map Type Toggle
          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: FarmbrosMapSearchBar(
                selectStructure: () {
                  setState(() {
                    _showStructureSelection = true;
                  });
                },
                showSuggestions: _showSuggestions,
                searchSuggestions: _searchSuggestions,
                selectSuggestion: _selectSuggestion,
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                searchLocation: (String query) {
                  _searchLocation(query);
                },
                onSearchChanged: _onSearchChanged,
                showStructureSelection: _showStructureSelection,
                isDrawingMode: _isDrawingMode,
                clearSearch: () {
                  _searchController.clear();
                  setState(() {
                    _searchSuggestions.clear();
                    _showSuggestions = false;
                  });
                },
                changeMapLayer: () {
                  setState(() {
                    _currentMapType = _currentMapType == MapType.hybrid
                        ? MapType.satellite
                        : MapType.hybrid;
                  });
                }),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _startDrawing(StructureType type) {
    setState(() {
      _selectedStructureType = type;
      _isDrawingMode = true;
      _showStructureSelection = false;
      _isDrawingCardMinimized = true; // Start minimized
      currentDrawingPoints.clear();
    });
  }

  void _onTap(LatLng position) {
    if (!_isDrawingMode) return;

    setState(() {
      currentDrawingPoints.add(position);
      _updateCurrentPolygon();
    });
  }

  void _updateCurrentPolygon() {
    if (currentDrawingPoints.length < 3 || _selectedStructureType == null) {
      return;
    }

    setState(() {
      _polygons.clear();

      // Add all saved structures
      _structures.forEach((key, points) {
        final typeIndex = int.parse(key.split('_')[0]);
        final type = StructureType.values[typeIndex];
        _polygons.add(
          Polygon(
            polygonId: PolygonId(key),
            points: points,
            strokeColor: type.color,
            strokeWidth: 3,
            fillColor: type.color.withOpacity(0.2),
            geodesic: true,
          ),
        );
      });

      // Add current drawing
      _polygons.add(
        Polygon(
          polygonId: PolygonId('current_drawing'),
          points: currentDrawingPoints,
          strokeColor: _selectedStructureType!.color,
          strokeWidth: 4,
          fillColor: _selectedStructureType!.color.withOpacity(0.2),
          geodesic: true,
        ),
      );
    });
  }

  void _undoLastPoint() {
    if (currentDrawingPoints.isEmpty) return;

    setState(() {
      currentDrawingPoints.removeLast();
      _updateCurrentPolygon();
    });
  }

  void _clearCurrentDrawing() {
    setState(() {
      currentDrawingPoints.clear();
      _updateCurrentPolygon();
    });
  }

  void _finishDrawing() {
    if (currentDrawingPoints.length < 3 || _selectedStructureType == null)
      return;

    final structureKey =
        '${_selectedStructureType!.index}_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _structures[structureKey] = List.from(currentDrawingPoints);
      currentDrawingPoints.clear();
      _isDrawingMode = false;
      _selectedStructureType = null;
      _isDrawingCardMinimized = false;
      _updateAllPolygons();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Structure added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _cancelDrawing() {
    setState(() {
      currentDrawingPoints.clear();
      _isDrawingMode = false;
      _selectedStructureType = null;
      _isDrawingCardMinimized = false;
      _updateAllPolygons();
    });
  }

  void _updateAllPolygons() {
    setState(() {
      _polygons.clear();
      _structures.forEach((key, points) {
        final typeIndex = int.parse(key.split('_')[0]);
        final type = StructureType.values[typeIndex];
        _polygons.add(
          Polygon(
            polygonId: PolygonId(key),
            points: points,
            strokeColor: type.color,
            strokeWidth: 3,
            fillColor: type.color.withOpacity(0.2),
            geodesic: true,
          ),
        );
      });
    });
  }

  void _onSearchChanged(String query) {
    logger.log(Level.info, _searchSuggestions);
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions.clear();
        _showSuggestions = false;
      });
      return;
    }

    _fetchSearchSuggestions(query);
  }

  Future<void> _fetchSearchSuggestions(String query) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleMapsApiKey&components=country:ke";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["predictions"] != null) {
          setState(() {
            _searchSuggestions = (data["predictions"] as List)
                .map((prediction) => {
                      'name': prediction['structured_formatting']['main_text'],
                      'address': prediction['description'],
                      'place_id': prediction['place_id'],
                    })
                .toList();
            _showSuggestions = true;
          });
        }
      }
    } catch (e) {
      logger.e("Error fetching suggestions: $e");
    }
  }

  void _selectSuggestion(Map<String, dynamic> suggestion) {
    _searchController.text = suggestion['name'];
    setState(() => _showSuggestions = false);
    _searchFocusNode.unfocus();
    _searchLocation(suggestion['address']);
  }

  Future<void> _searchLocation(String query) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$_googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logger.log(Level.info, data);
        if (data["results"].isNotEmpty) {
          final location = data["results"][0]["geometry"]["location"];
          final double lat = location["lat"];
          final double lng = location["lng"];

          await _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat, lng),
                zoom: 15.0,
              ),
            ),
          );

          setState(() {
            _markers.removeWhere((m) => m.markerId.value == 'search_result');
            _markers.add(
              Marker(
                markerId: MarkerId('search_result'),
                position: LatLng(lat, lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
                infoWindow: InfoWindow(title: query),
              ),
            );
          });
        }
      }
    } catch (e) {
      logger.e("Error searching location: $e");
    }
  }

  void _saveAllStructures() {
    final RouteSettings? currentPath = ModalRoute.of(context)!.settings;
    final bool isCreatingFarm =
        currentPath?.name?.contains('/farms/create_farm/map') ?? false;

    if (_structures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No structures to save!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (isCreatingFarm) {
      // Get the farm boundary GeoJSON
      Map<String, dynamic>? farmGeoJSON = getFarmBoundaryGeoJSON();

      if (farmGeoJSON == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please draw the farm boundary first!'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Save to Cubit state
      context.read<FarmStateCubit>().setFarmGeoJson(farmGeoJSON);

      logger.i("Farm boundary saved (GeoJSON format):");
      logger.i(json.encode(farmGeoJSON));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Farm boundary saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate back to create farm page
      context.pop();
    } else {
      // For plots.dart/structures, convert all to GeoJSON format
      List<Map<String, dynamic>> structuresGeoJSON = [];

      _structures.forEach((key, points) {
        final typeIndex = int.parse(key.split('_')[0]);
        final type = StructureType.values[typeIndex];
        Map<String, dynamic> geoJSON = _convertToGeoJSON(points, type);
        structuresGeoJSON.add(geoJSON);
      });

      logger.i("Structures to save (GeoJSON format):");
      logger.i(json.encode(structuresGeoJSON));

      // TODO: Send to backend for plots.dart/structures

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Structures saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      context.pop();
    }
  }

  // Convert List<LatLng> to GeoJSON Polygon format
  Map<String, dynamic> _convertToGeoJSON(
      List<LatLng> points, StructureType type) {
    List<List<double>> coordinates = points.map((point) {
      return [point.longitude, point.latitude];
    }).toList();

    if (coordinates.first[0] != coordinates.last[0] ||
        coordinates.first[1] != coordinates.last[1]) {
      coordinates.add([points.first.longitude, points.first.latitude]);
    }

    return {
      "type": "Polygon",
      "coordinates": [coordinates], // Wrapped in array for exterior ring
      "properties": {
        "structureType": type.displayName,
        "color": type.color.value.toRadixString(16),
      }
    };
  }

  // Get GeoJSON for a specific structure (e.g., Farm boundary)
  Map<String, dynamic>? getFarmBoundaryGeoJSON() {
    // Find the farm structure key
    String? farmKey = _structures.keys.firstWhere(
      (key) => key.startsWith('${StructureType.farm.index}_'),
      orElse: () => '',
    );

    if (farmKey.isEmpty || !_structures.containsKey(farmKey)) {
      return null;
    }

    // Extract structure type from key prefix
    final typeIndex = int.parse(farmKey.split('_')[0]);
    final type = StructureType.values[typeIndex];

    List<LatLng> farmPoints = _structures[farmKey]!;

    List<List<double>> coordinates = farmPoints.map((point) {
      return [point.longitude, point.latitude];
    }).toList();

    if (coordinates.first[0] != coordinates.last[0] ||
        coordinates.first[1] != coordinates.last[1]) {
      coordinates.add([farmPoints.first.longitude, farmPoints.first.latitude]);
    }

    return {
      "type": "Polygon",
      "coordinates": [coordinates],
      "properties": {
        "structureType": type.displayName,
        "color": type.color.value.toRadixString(16),
      }
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
