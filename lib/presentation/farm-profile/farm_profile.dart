import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loading_state.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_details_params.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farm_usecase.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class FarmProfile extends StatefulWidget {
  final String farmId;

  const FarmProfile({super.key, required this.farmId});

  @override
  State<FarmProfile> createState() => _FarmProfileState();
}

class _FarmProfileState extends State<FarmProfile> {
  GoogleMapController? _mapController;
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmStateCubit>().execute(
            FetchFarmDetailsParams(farmId: widget.farmId),
            sl<FetchFarmUsecase>(),
          );
    });
  }

  /// Convert boundary GeoJSON to Google Maps Polygon
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
  Widget build(BuildContext context) {
    Logger logger = Logger();

    return Scaffold(
      backgroundColor: ColorUtils.lightBackgroundColor,
      body: BlocBuilder<FarmStateCubit, FarmState>(
        builder: (BuildContext context, state) {
          if (state is FarmStateLoading) {
            return FarmBrosLoadingState();
          } else if (state is FarmStateSuccess) {
            final farm = state.farm;

            if (farm == null) {
              return _buildErrorState("Farm data not found", context);
            }

            logger.log(Level.info, farm);

            // Load boundary when farm data is available
            if (farm['boundary'] != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadFarmBoundary(farm['boundary'], widget.farmId);
              });
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  FarmbrosAppbar(
                    icon: FluentIcons.ios_arrow_24_regular,
                    appBarTitle: "Farm Profile",
                    openSideBar: () {
                      context.pop();
                    },
                    hasAction: false,
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Farmer Avatar and Farm Name Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor:
                                      ColorUtils.accentBackgroundColor,
                                  child: Icon(
                                    FluentIcons.person_24_filled,
                                    size: 40,
                                    color: ColorUtils.secondaryBackgroundColor,
                                  ),
                                ),
                                Gap(10),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          ColorUtils.secondaryBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ColorUtils.primaryBorderColor),
                                    ),
                                    child: Text(
                                      "Farmer Profile",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    farm["name"]?.toString() ?? "Farm Name",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Gap(8),
                                  Text(
                                    farm["description"]?.toString() ??
                                        "No description available",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorUtils.inActiveColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Farm Details Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              "Farm Details",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildDetailItem(
                              FluentIcons.resize_large_24_regular,
                              "Dimensions/Size",
                              _getAreaDisplay(farm["area_sqm"]),
                            ),
                            _buildDetailItem(
                              FluentIcons.location_24_regular,
                              "Location",
                              "Nairobi, Kenya",
                            ),
                            _buildDetailItem(
                              FluentIcons.grid_24_regular,
                              "Plots",
                              "12 Plots",
                            ),
                          ],
                        ),
                        // Flora & Fauna Overview Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 0,
                          children: [
                            Text(
                              "Flora & Fauna Overview",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: [
                                _buildMonitorCard(
                                  FluentIcons.plant_grass_24_regular,
                                  "Crops",
                                  "15 Types",
                                  ColorUtils.secondaryColor,
                                ),
                                _buildMonitorCard(
                                  FluentIcons.animal_cat_24_regular,
                                  "Animals",
                                  "8 Types",
                                  ColorUtils.secondaryColor,
                                ),
                                _buildMonitorCard(
                                  FluentIcons.building_24_regular,
                                  "Structures",
                                  "6 Buildings",
                                  ColorUtils.secondaryColor,
                                ),
                                _buildMonitorCard(
                                  FluentIcons.wrench_24_regular,
                                  "Equipment",
                                  "20 Items",
                                  ColorUtils.secondaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Map Section with Boundary
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              "Farm Boundary",
                              style: TextStyle(
                                fontSize: 18,
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
                                      width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: GoogleMap(
                                  onMapCreated: (controller) {
                                    _mapController = controller;
                                    // Reload boundary after map is ready
                                    if (farm['boundary'] != null) {
                                      _loadFarmBoundary(
                                          farm['boundary'], widget.farmId);
                                    }
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      farm["centroid"]["coordinates"][1],
                                      farm["centroid"]["coordinates"][0],
                                    ),
                                    zoom: 17.25,
                                  ),
                                  polygons: _polygons,
                                  mapType: MapType.hybrid,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is FarmStateError) {
            return _buildErrorState("Failed to load farm details", context);
          } else {
            return FarmBrosLoadingState();
          }
        },
      ),
      drawer: FarmbrosNavigation(),
    );
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Column(
      children: [
        FarmbrosAppbar(
          icon: FluentIcons.ios_arrow_24_regular,
          appBarTitle: "Farm Profile",
          openSideBar: () {},
          hasAction: false,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FluentIcons.error_circle_24_regular,
                    size: 64, color: Colors.red),
                Gap(16),
                Text("Error",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Gap(8),
                Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorUtils.inActiveColor)),
                Gap(16),
                ElevatedButton(
                    onPressed: () => context.pop(), child: Text("Go Back")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getAreaDisplay(dynamic areaSqm) {
    try {
      if (areaSqm == null) return "N/A";
      final area = double.tryParse(areaSqm.toString());
      return area != null ? "${area.floor().toString()} m²" : "N/A";
    } catch (e) {
      return "N/A";
    }
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorUtils.primaryBorderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorUtils.accentBackgroundColor, size: 24),
          Gap(15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      TextStyle(fontSize: 12, color: ColorUtils.inActiveColor)),
              Gap(4),
              Text(value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonitorCard(
      IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorUtils.primaryBorderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          Gap(12),
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Gap(4),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: ColorUtils.inActiveColor)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
