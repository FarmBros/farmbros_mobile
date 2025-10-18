import 'package:farmbros_mobile/common/bloc/plot/plot_profile_state.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_profile_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loading_state.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/plot_profile_details_params.dart';
import 'package:farmbros_mobile/domain/enums/plot_type_enum.dart';
import 'package:farmbros_mobile/domain/enums/plot_type_field.dart';
import 'package:farmbros_mobile/domain/usecases/plot_profile_use__case.dart';
import 'package:farmbros_mobile/presentation/plot-profile/widgets/plot_data_component.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class PlotProfile extends StatefulWidget {
  final String plotId;

  const PlotProfile({super.key, required this.plotId});

  @override
  State<PlotProfile> createState() => _PlotProfileState();
}

class _PlotProfileState extends State<PlotProfile> {
  Future<void> _onRefresh() async {}
  Logger logger = Logger();
  Map<String, dynamic> plot = {};

  GoogleMapController? _mapController;
  final Set<Polygon> _polygons = {};

  void _loadFarmBoundary(Map<String, dynamic> boundary, String farmId) {
    if (boundary['type'] != 'Polygon' || boundary['coordinates'] == null) {
      return;
    }

    // Extract coordinates from GeoJSON format [[[lng, lat], [lng, lat], ...]]
    List<dynamic> coordinatesArray = boundary['coordinates'][0];

    // Convert to List<LatLng> - NOTE: GeoJSON is [lng, lat] but LatLng is (lat, lng)
    List<LatLng> polygonPoints = coordinatesArray.map((coord) {
      double longitude = coord[0].toDouble();
      double latitude = coord[1].toDouble();
      return LatLng(latitude, longitude); // Swap order!
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

    // Center camera on the farm boundary
    if (polygonPoints.isNotEmpty && _mapController != null) {
      _centerMapOnPolygon(polygonPoints);
    }
  }

  /// Center the map camera on polygon bounds
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlotProfileStateCubit>().execute(
          PlotProfileDetailsParams(plotId: widget.plotId),
          sl<PlotProfileUseCase>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlotProfileStateCubit, PlotProfileState>(
        builder: (context, plotProfileState) {
      if (plotProfileState is PlotProfileStateLoading) {
        return FarmBrosLoadingState();
      }

      if (plotProfileState is PlotProfileStateSuccess) {
        logger.log(Level.info, plotProfileState.data);
        plot = plotProfileState.data!["data"] ?? [];
      }

      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  spacing: 10,
                  children: [
                    FarmbrosAppbar(
                      icon: FluentIcons.ios_arrow_24_regular,
                      appBarTitle: "Plot Profile",
                      openSideBar: () {
                        context.pop();
                      },
                      hasAction: false,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  plotProfileState is PlotProfileStateSuccess &&
                                          plot.isNotEmpty
                                      ? plot["name"]
                                      : "Plot name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(FluentIcons.pen_24_regular),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.brown.withOpacity(0.3),
                                        child: Icon(
                                          FluentIcons
                                              .building_lighthouse_16_filled,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Area: ${double.parse(plot["area_sqm"].toString()).floor()} sqm",
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    FluentIcons.image_24_regular,
                                    size: 32,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height / 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ColorUtils.primaryBorderColor,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                plotProfileState is PlotProfileStateSuccess &&
                                        plot.isNotEmpty &&
                                        plot["notes"] != null
                                    ? plot["notes"]
                                    : "Here is a note",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ColorUtils.secondaryBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorUtils.primaryBorderColor,
                                ),
                              ),
                              child: Text(
                                "Notes",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            "Farm Boundary",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorUtils.primaryBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: GoogleMap(
                                onMapCreated: (controller) {
                                  _mapController = controller;
                                  // Reload boundary after map is ready
                                  if (plot['boundary'] != null) {
                                    _loadFarmBoundary(
                                        plot['boundary'], widget.plotId);
                                  }
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    plot["centroid"]["coordinates"][1],
                                    plot["centroid"]["coordinates"][0],
                                  ),
                                  zoom: 50,
                                ),
                                polygons: _polygons,
                                mapType: MapType.hybrid,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            "Plot Type Information",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (plot.isNotEmpty && plot["plot_type"] != null)
                            _buildPlotTypeHeader(
                                (plot["plot_type"] as String).toPlotType()!),
                          SizedBox(height: 10),
                          Text(
                            "Plot Data",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildPlotDataFields(plot),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPlotTypeHeader(PlotType plotType) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: plotType.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: plotType.color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            plotType.icon,
            color: plotType.color,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plotType.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  plotType.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlotDataFields(Map<String, dynamic> plot) {
    // Check if plot data exists
    if (plot.isEmpty || plot["plot_type"] == null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "No plot data available",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Convert the plot_type string to PlotType enum
    final plotType = (plot["plot_type"] as String).toPlotType();

    if (plotType == null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Unknown plot type: ${plot["plot_type"]}",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Check if plot_type_data exists
    final plotTypeData = plot["plot_type_data"];
    if (plotTypeData == null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "No specific data available for this ${plotType.displayName}",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Get the required fields for this plot type
    final requiredFields = plotType.getRequiredFields();

    if (requiredFields.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "No specific fields configured for this plot type",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    // Build a list of PlotDataComponent widgets
    List<Widget> dataWidgets = [];

    for (var field in requiredFields) {
      // Get the API field name to fetch from plot_type_data
      final apiFieldName = field.toApiFieldName();

      // Get the value from the plot_type_data
      final value = plotTypeData[apiFieldName];

      // Skip if value is null or empty
      if (value == null || (value is String && value.isEmpty)) {
        continue;
      }

      // Format the value based on type
      String displayValue;
      if (field.valueType == FieldValueType.integer) {
        displayValue = value.toString();
      } else {
        displayValue = value.toString();
      }

      dataWidgets.add(
        PlotDataComponent(
          icon: field.icon,
          plotLabel: field.label,
          plotValue: displayValue,
        ),
      );
    }

    // If no valid data found, show message
    if (dataWidgets.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "No data has been entered for this ${plotType.displayName} yet",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      spacing: 12,
      children: dataWidgets,
    );
  }
}
