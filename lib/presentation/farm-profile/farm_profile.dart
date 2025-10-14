import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
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

class FarmProfile extends StatelessWidget {
  final String farmId;

  const FarmProfile({super.key, required this.farmId});

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-1.2921, 36.8219),
    zoom: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();

    logger.log(Level.info, farmId);

    return BlocProvider(
      create: (context) => sl<FarmStateCubit>()
        ..execute(
          FetchFarmDetailsParams(farmId: farmId),
          sl<FetchFarmUsecase>(),
        ),
      child: Scaffold(
        backgroundColor: ColorUtils.lightBackgroundColor,
        body: BlocBuilder<FarmStateCubit, FarmState>(
          builder: (BuildContext context, state) {
            if (state is FarmStateSuccess) {
              logger.log(Level.info, state.farm);
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
                  if (state is FarmStateSuccess)
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
                                      color:
                                          ColorUtils.secondaryBackgroundColor,
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
                                            color:
                                                ColorUtils.primaryBorderColor),
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
                                      state.farm != null
                                          ? state.farm!["name"]
                                          : "Farm Name",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Gap(8),
                                    Text(
                                      state.farm != null
                                          ? state.farm!["description"]
                                          : "This is a description of the farm. It provides an overview of what the farm does and its main activities.",
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
                                "${double.parse(state.farm!["area_sqm"].toString()).floor().toString()} (Sq km)",
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
                          // Map Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              Text(
                                "Map",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: ColorUtils.secondaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: ColorUtils.primaryBorderColor),
                                ),
                                child: GoogleMap(
                                    initialCameraPosition: _initialPosition),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        drawer: FarmbrosNavigation(),
      ),
    );
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
          Icon(
            icon,
            color: ColorUtils.accentBackgroundColor,
            size: 24,
          ),
          Gap(15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorUtils.inActiveColor,
                ),
              ),
              Gap(4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          Gap(12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: ColorUtils.inActiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
