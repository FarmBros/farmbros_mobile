import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class FarmbrosMap extends StatefulWidget {
  const FarmbrosMap({super.key});

  @override
  State<FarmbrosMap> createState() => _FarmbrosMapState();
}

class _FarmbrosMapState extends State<FarmbrosMap> {
  MapboxMap? mapBoxMapController;
  List<Position> _polylinePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          CupertinoIcons.chevron_back,
          color: ColorUtils.secondaryColor,
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: MapWidget(
            onMapCreated: (controller) {
              _onMapCreated(controller);
            },
          ),
        ),
      ),
    );
  }

  void _onMapCreated(MapboxMap controller) async {
    setState(() {
      mapBoxMapController = controller;
    });

    // Enable location
    mapBoxMapController!.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );

    // 👇 Listen for map clicks
    mapBoxMapController!.gestures.addOnMapClickListener(_onMapClick);

    // Fly to Nairobi by default
    await mapBoxMapController!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(36.8219, -1.2921)), // Nairobi
        zoom: 10.0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  // Called when map is clicked
  void _onMapClick(ScreenCoordinate coordinate) async {
    print("------------CLICKED-----------");
    var point = await mapBoxMapController!.coordinateForPixel(coordinate);
    if (point != null && point is Point) {
      setState(() {
        _polylinePoints.add(point.coordinates);
      });

      _drawPolyline();
    }
  }

  // Draw line on map
  Future<void> _drawPolyline() async {
    if (_polylinePoints.length < 2) return;

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
  }

  // Build GeoJSON for polyline
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

  @override
  void dispose() {
    mapBoxMapController?.gestures.removeOnMapClickListener(_onMapClick);
    super.dispose();
  }
}

extension on GesturesSettingsInterface {
  void removeOnMapClickListener(
      void Function(ScreenCoordinate coordinate) onMapClick) {}

  void addOnMapClickListener(
      void Function(ScreenCoordinate coordinate) onMapClick) {}
}
