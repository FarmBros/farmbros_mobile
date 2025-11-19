import 'dart:convert';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:farmbros_mobile/presentation/map/widgets/farmbros_map_search_bar.dart';
import 'package:farmbros_mobile/presentation/map/widgets/structure_editor.dart';
import 'package:farmbros_mobile/presentation/map/widgets/structure_selector.dart';
import 'package:farmbros_mobile/presentation/map/widgets/structure_toggler.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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

  // Editing mode variables
  bool _isEditingMode = false;
  String? _editingStructureKey;
  int? _selectedPolyPointIndex;
  bool _isDraggingPoint = false;

  TextEditingController farmName = TextEditingController();
  TextEditingController farmDescription = TextEditingController();

  Logger logger = Logger();

  final String? _googleMapsApiKey = dotenv.env["GOOGLE_MAPS_API_KEY"];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-1.2921, 36.8219),
    zoom: 10.0,
  );

  void _loadFarmBoundary(Map<String, dynamic> boundary, String farmId) {
    if (boundary['type'] != 'Polygon' || boundary['coordinates'] == null) {
      return;
    }

    List<dynamic> coordinatesArray = boundary['coordinates'][0];

    List<LatLng> polygonPoints = coordinatesArray.map((coord) {
      double longitude = coord[0].toDouble();
      double latitude = coord[1].toDouble();
      return LatLng(latitude, longitude);
    }).toList();

    setState(() {
      _polygons.clear();
      _polygons.add(
        Polygon(
          polygonId: PolygonId('farm_$farmId'),
          points: polygonPoints,
          strokeColor: ColorUtils.successColor,
          strokeWidth: 3,
          fillColor: ColorUtils.successColor.withOpacity(0.2),
          geodesic: true,
        ),
      );
    });

    if (polygonPoints.isNotEmpty && _mapController != null) {
      _centerMapOnPolygon(polygonPoints);
    }
  }

  void _centerMapOnPolygon(List<LatLng> points) {
    if (points.isEmpty) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
    );
  }

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

    final bool isCreatingPlot =
        currentPath?.name?.contains('/plots/create_plot/map') ?? false;

    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    logger.log(Level.info, currentPath!.name);

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Google Map
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: extra != null
                  ? (controller) {
                _mapController = controller;
                if (extra['farm_boundary'] != null) {
                  _loadFarmBoundary(
                      extra['farm_boundary'], extra["farm_id"]);
                }
              }
                  : _onMapCreated,
              onTap: _isDrawingMode
                  ? _onTap
                  : (_isEditingMode ? _onMapTapWhileEditing : null),
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
                right: 0,
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

            // Structure Selection Card (when not drawing and not editing)
            if (_showStructureSelection && !_isDrawingMode && !_isEditingMode)
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
                    isCreatingPlot: isCreatingPlot,
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

            // Structure Toggler for editing existing structures
            if (_isEditingMode && !_isDrawingMode)
              Positioned(
                left: 20,
                bottom: 80,
                child: StructureToggler(
                  structures: _structures,
                  selectedStructureKey: _editingStructureKey,
                  onStructureSelected: _selectStructureForEditing,
                  onExitEditMode: _exitEditingMode,
                  onDeleteStructure: _deleteStructure,
                ),
              ),

            // Polypoint tooltip when editing
            if (_isEditingMode && _selectedPolyPointIndex != null && _editingStructureKey != null)
              _buildPolyPointTooltip(),

            // Search Bar with Map Type Toggle
            Positioned(
              bottom: 15,
              left: 20,
              right: 20,
              child: FarmbrosMapSearchBar(
                selectStructure: () {
                  setState(() {
                    _showStructureSelection = true;
                    _isEditingMode = false;
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
                },
                // Add edit mode toggle
                toggleEditMode: _structures.isNotEmpty ? () {
                  setState(() {
                    _isEditingMode = !_isEditingMode;
                    if (_isEditingMode) {
                      _showStructureSelection = false;
                      _isDrawingMode = false;
                    } else {
                      _editingStructureKey = null;
                      _selectedPolyPointIndex = null;
                    }
                  });
                } : null,
                isEditingMode: _isEditingMode,
              ),
            ),
          ],
        ),
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
      _isDrawingCardMinimized = true;
      currentDrawingPoints.clear();
      _isEditingMode = false;
      _editingStructureKey = null;
    });
  }

  void _onTap(LatLng position) {
    if (!_isDrawingMode) return;

    setState(() {
      currentDrawingPoints.add(position);
      _updateCurrentPolygon();
      _updateDrawingMarkers();
    });
  }

  void _updateDrawingMarkers() {
    // Remove all drawing markers
    _markers.removeWhere((m) => m.markerId.value.startsWith('drawing_point_'));

    // Add markers for each point in current drawing
    for (int i = 0; i < currentDrawingPoints.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('drawing_point_$i'),
          position: currentDrawingPoints[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          anchor: Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: 'Point ${i + 1}',
            snippet: 'Tap to edit',
          ),
        ),
      );
    }
  }

  void _updateEditingMarkers() {
    if (_editingStructureKey == null || !_structures.containsKey(_editingStructureKey)) {
      return;
    }

    // Remove all editing markers
    _markers.removeWhere((m) => m.markerId.value.startsWith('edit_point_'));

    final typeIndex = int.parse(_editingStructureKey!.split('_')[0]);
    final type = StructureType.values[typeIndex];

    List<LatLng> points = _structures[_editingStructureKey]!;

    // Add markers for each point in the editing structure
    for (int i = 0; i < points.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('edit_point_$i'),
          position: points[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _selectedPolyPointIndex == i
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueViolet,
          ),
          anchor: Offset(0.5, 0.5),
          consumeTapEvents: true,
          onTap: () => _selectPolyPoint(i),
        ),
      );
    }
  }

  void _onMapTapWhileEditing(LatLng position) {
    if (_isDraggingPoint && _selectedPolyPointIndex != null && _editingStructureKey != null) {
      // Update the selected point's position
      setState(() {
        _structures[_editingStructureKey]![_selectedPolyPointIndex!] = position;
        _updateAllPolygons();
        _updateEditingMarkers();
      });
    } else {
      // Deselect point
      setState(() {
        _selectedPolyPointIndex = null;
        _isDraggingPoint = false;
      });
    }
  }

  void _selectPolyPoint(int index) {
    setState(() {
      _selectedPolyPointIndex = index;
      _isDraggingPoint = false;
    });
  }

  void _removePolyPoint() {
    if (_selectedPolyPointIndex == null || _editingStructureKey == null) return;

    setState(() {
      if (_structures[_editingStructureKey]!.length > 3) {
        _structures[_editingStructureKey]!.removeAt(_selectedPolyPointIndex!);
        _selectedPolyPointIndex = null;
        _updateAllPolygons();
        _updateEditingMarkers();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Point removed'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot remove point - minimum 3 points required'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _movePolyPoint() {
    setState(() {
      _isDraggingPoint = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tap on the map to move the point to a new location'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPolyPointTooltip() {
    if (_selectedPolyPointIndex == null || _editingStructureKey == null) {
      return SizedBox.shrink();
    }

    final point = _structures[_editingStructureKey]![_selectedPolyPointIndex!];

    return Positioned(
      top: 100,
      right: 20,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Point ${_selectedPolyPointIndex! + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.secondaryColor,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: _movePolyPoint,
                  icon: Icon(Icons.open_with, size: 16),
                  label: Text('Move Point'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: _removePolyPoint,
                  icon: Icon(Icons.delete, size: 16),
                  label: Text('Remove Point'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtils.failureColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectStructureForEditing(String structureKey) {
    setState(() {
      _editingStructureKey = structureKey;
      _selectedPolyPointIndex = null;
      _updateEditingMarkers();
    });
  }

  void _exitEditingMode() {
    setState(() {
      _isEditingMode = false;
      _editingStructureKey = null;
      _selectedPolyPointIndex = null;
      _markers.removeWhere((m) => m.markerId.value.startsWith('edit_point_'));
    });
  }

  void _deleteStructure(String structureKey) {
    setState(() {
      _structures.remove(structureKey);
      if (_editingStructureKey == structureKey) {
        _editingStructureKey = null;
        _selectedPolyPointIndex = null;
      }
      _updateAllPolygons();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Structure deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _updateCurrentPolygon() {
    if (currentDrawingPoints.length < 3 || _selectedStructureType == null) {
      return;
    }

    final RouteSettings? currentPath = ModalRoute.of(context)!.settings;
    final bool isCreatingFarm =
        currentPath?.name?.contains('/farms/create_farm/map') ?? false;

    setState(() {
      if (isCreatingFarm) {
        _polygons.clear();
      }

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
      _updateDrawingMarkers();
    });
  }

  void _clearCurrentDrawing() {
    setState(() {
      currentDrawingPoints.clear();
      _updateCurrentPolygon();
      _updateDrawingMarkers();
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
      _markers.removeWhere((m) => m.markerId.value.startsWith('drawing_point_'));
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
      _markers.removeWhere((m) => m.markerId.value.startsWith('drawing_point_'));
    });
  }

  void _updateAllPolygons() {
    final RouteSettings? currentPath = ModalRoute.of(context)!.settings;
    final bool isCreatingFarm =
        currentPath?.name?.contains('/farms/create_farm/map') ?? false;

    setState(() {
      if (isCreatingFarm) {
        _polygons.clear();
      } else {
        _polygons.removeWhere((p) => p.polygonId.value != 'current_drawing');
      }

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

      context.read<FarmStateCubit>().setFarmGeoJson(farmGeoJSON);

      logger.i("Farm boundary saved (GeoJSON format):");
      logger.i(json.encode(farmGeoJSON));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Farm boundary saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      context.pop();
    } else {
      Map<String, dynamic> geoJSON = {};

      _structures.forEach((key, points) {
        final typeIndex = int.parse(key.split('_')[0]);
        final type = StructureType.values[typeIndex];
        geoJSON = _convertToGeoJSON(points, type);
      });

      logger.i("Structures to save (GeoJSON format):");
      logger.i(json.encode(geoJSON));

      context.read<PlotStateCubit>().setPlotGeoJson(geoJSON);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Structures saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      context.pop();
    }
  }

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
      "coordinates": [coordinates],
      "properties": {
        "structureType": type.displayName,
        "color": type.color.value.toRadixString(16),
      }
    };
  }

  Map<String, dynamic>? getFarmBoundaryGeoJSON() {
    String? farmKey = _structures.keys.firstWhere(
          (key) => key.startsWith('${StructureType.farm.index}_'),
      orElse: () => '',
    );

    if (farmKey.isEmpty || !_structures.containsKey(farmKey)) {
      return null;
    }

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
