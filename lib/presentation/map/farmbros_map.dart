import 'dart:convert';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class FarmbrosMap extends StatefulWidget {
  const FarmbrosMap({super.key});
  @override
  State<FarmbrosMap> createState() => _FarmbrosMapState();
}

class _FarmbrosMapState extends State<FarmbrosMap> {
  MapboxMap? mapBoxMapController;
  final List<Position> _polylinePoints = [];
  final TextEditingController _searchController = TextEditingController();

  Logger logger = Logger();
  bool _hasAddedSource = false;

  final String? _mapboxAccessToken = dotenv.env["MAPBOX_ACCESS_TOKEN"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: ColorUtils.secondaryColor,
          ),
        ),
        title: Text(
          "Map your farm",
          style: TextStyle(color: ColorUtils.secondaryTextColor, fontSize: 14),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "Save Sketch",
                style: TextStyle(fontSize: 12),
              ))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Map
            SizedBox.expand(
              child: MapWidget(
                onMapCreated: (controller) {
                  _onMapCreated(controller);
                },
                onTapListener: _onTap,
              ),
            ),
            // Search Bar
            Positioned(
              bottom: 15,
              left: 20,
              right: 90,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search location...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _searchLocation(value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _clearPolyline,
            backgroundColor: ColorUtils.secondaryBackgroundColor,
            child:
                Icon(CupertinoIcons.clear_fill, color: ColorUtils.failureColor),
          ),
          FloatingActionButton(
            onPressed: _undoLastPoint,
            backgroundColor: ColorUtils.secondaryBackgroundColor,
            child: Icon(CupertinoIcons.arrow_uturn_left,
                color: ColorUtils.secondaryColor),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '${_polylinePoints.length}',
                      style: TextStyle(
                        color: ColorUtils.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'points',
                      style: TextStyle(
                        color: ColorUtils.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMap controller) async {
    setState(() {
      mapBoxMapController = controller;
    });

    // mapBoxMapController!.setStyleGlyphURL(MapboxStyles.SATELLITE_STREETS);

    // Enable location
    mapBoxMapController!.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );

    // Fly to Nairobi by default
    await mapBoxMapController!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(36.8219, -1.2921)),
        zoom: 10.0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  _onTap(MapContentGestureContext context) async {
    logger.i(
        "OnTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}");

    setState(() {
      _polylinePoints.add(context.point.coordinates);
    });

    await _drawPolyline();

    await _addPointMarker(
        context.point.coordinates, _polylinePoints.length - 1);
    logger.i(_polylinePoints);
  }

  // 🔎 Search Location
  Future<void> _searchLocation(String query) async {
    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$_mapboxAccessToken&limit=1";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["features"].isNotEmpty) {
        final coords = data["features"][0]["center"]; // [lng, lat]
        final double lng = coords[0];
        final double lat = coords[1];

        // Move map to searched location
        await mapBoxMapController!.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(lng, lat)),
            zoom: 13.0,
          ),
          MapAnimationOptions(duration: 1500),
        );

        // Drop a marker at searched location
        await _addPointMarker(Position(lng, lat), _polylinePoints.length);
      }
    }
  }

  Future<void> _drawPolyline() async {
    if (_polylinePoints.length < 2) {
      if (_hasAddedSource) {
        await _removeExistingPolyline();
        _hasAddedSource = false;
      }
      return;
    }

    try {
      if (_hasAddedSource) {
        await _removeExistingPolyline();
      }

      await mapBoxMapController!.style.addSource(
        GeoJsonSource(
          id: "line-source",
          data: _buildLineGeoJson(),
        ),
      );

      await mapBoxMapController!.style.addLayer(
        LineLayer(
          id: "line-layer",
          sourceId: "line-source",
          lineColor: Colors.red.value,
          lineWidth: 4.0,
        ),
      );

      _hasAddedSource = true;
    } catch (e) {
      logger.e("Error drawing polyline: $e");
    }
  }

  Future<void> _removeExistingPolyline() async {
    try {
      await mapBoxMapController!.style.removeStyleLayer("line-layer");
      await mapBoxMapController!.style.removeStyleSource("line-source");
    } catch (e) {
      logger.w("Error removing existing polyline: $e");
    }
  }

  Future<void> _addPointMarker(Position position, int index) async {
    try {
      await mapBoxMapController!.style.addSource(
        GeoJsonSource(
          id: "point-source-$index",
          data: _buildPointGeoJson(position),
        ),
      );

      await mapBoxMapController!.style.addLayer(
        CircleLayer(
          id: "point-layer-$index",
          sourceId: "point-source-$index",
          circleRadius: 6.0,
          circleColor: Colors.blue.value,
          circleStrokeColor: Colors.white.value,
          circleStrokeWidth: 2.0,
        ),
      );
    } catch (e) {
      logger.w("Error adding point marker: $e");
    }
  }

  String _buildPointGeoJson(Position position) {
    return '''
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [${position.lng}, ${position.lat}]
          }
        }
      ]
    }
    ''';
  }

  String _buildLineGeoJson() {
    final coordinates =
        _polylinePoints.map((pos) => [pos.lng, pos.lat]).toList();
    return '''
    {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": $coordinates
          }
        }
      ]
    }
    ''';
  }

  void _undoLastPoint() async {
    if (_polylinePoints.isEmpty) return;

    final lastIndex = _polylinePoints.length - 1;

    try {
      await mapBoxMapController!.style
          .removeStyleLayer("point-layer-$lastIndex");
      await mapBoxMapController!.style
          .removeStyleSource("point-source-$lastIndex");
    } catch (e) {
      logger.w("Error removing last point marker: $e");
    }

    setState(() {
      _polylinePoints.removeLast();
    });

    await _drawPolyline();
  }

  void _clearPolyline() async {
    if (_hasAddedSource) {
      await _removeExistingPolyline();
      _hasAddedSource = false;
    }

    for (int i = 0; i < _polylinePoints.length; i++) {
      try {
        await mapBoxMapController!.style.removeStyleLayer("point-layer-$i");
        await mapBoxMapController!.style.removeStyleSource("point-source-$i");
      } catch (e) {
        logger.w("Error removing point marker $i: $e");
      }
    }

    setState(() {
      _polylinePoints.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
