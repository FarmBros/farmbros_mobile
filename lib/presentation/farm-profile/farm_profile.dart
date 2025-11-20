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
  Widget build(BuildContext context) {
    Logger logger = Logger();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
                  // Farm Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ColorUtils.primaryTextColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Farm Icon
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorUtils.secondaryColor,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                            ColorUtils.secondaryColor.withOpacity(0.1),
                            child: Icon(
                              FluentIcons.plant_grass_28_regular,
                              size: 50,
                              color: ColorUtils.secondaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Farm Name
                        Text(
                          farm["name"]?.toString() ?? "Farm Name",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Farm Description
                        Text(
                          farm["description"]?.toString() ??
                              "No description available",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: FluentIcons.resize_large_24_regular,
                            label: "Size",
                            value: _getAreaDisplay(farm["area_sqm"]),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: FluentIcons.grid_24_regular,
                            label: "Plots",
                            value: "12",
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: FluentIcons.location_24_regular,
                            label: "Location",
                            value: "Nairobi",
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Farm Details Section
                  _SectionContainer(
                    title: "Farm Details",
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: FluentIcons.resize_large_24_regular,
                          label: "Dimensions/Size",
                          value: _getAreaDisplay(farm["area_sqm"]),
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          icon: FluentIcons.location_24_regular,
                          label: "Location",
                          value: "Nairobi, Kenya",
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          icon: FluentIcons.grid_24_regular,
                          label: "Total Plots",
                          value: "12 Plots",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Flora & Fauna Overview Section
                  _SectionContainer(
                    title: "Flora & Fauna Overview",
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _MonitorCard(
                          icon: FluentIcons.plant_grass_24_regular,
                          title: "Crops",
                          subtitle: "15 Types",
                          color: Colors.green,
                        ),
                        _MonitorCard(
                          icon: FluentIcons.animal_cat_24_regular,
                          title: "Animals",
                          subtitle: "8 Types",
                          color: Colors.orange,
                        ),
                        _MonitorCard(
                          icon: FluentIcons.building_24_regular,
                          title: "Structures",
                          subtitle: "6 Buildings",
                          color: Colors.blue,
                        ),
                        _MonitorCard(
                          icon: FluentIcons.wrench_24_regular,
                          title: "Equipment",
                          subtitle: "20 Items",
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Map Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            "Farm Boundary",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: GoogleMap(
                              onMapCreated: (controller) {
                                _mapController = controller;
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
                  const SizedBox(height: 32),
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

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.primaryTextColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Section Container Widget
class _SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionContainer({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.primaryTextColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorUtils.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: ColorUtils.secondaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Monitor Card Widget
class _MonitorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _MonitorCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorUtils.primaryTextColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}