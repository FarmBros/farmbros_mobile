import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_filter.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loading_state.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/fetch_farm_plots_params.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farm_plots_use_case.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farms_use_case.dart';
import 'package:farmbros_mobile/presentation/plots/utils/plot_utils.dart';
import 'package:farmbros_mobile/presentation/plots/widgets/plot_component.dart';
import 'package:farmbros_mobile/presentation/plots/widgets/summary_strip.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class Plots extends StatefulWidget {
  const Plots({super.key});

  @override
  State<Plots> createState() => _PlotsState();
}

class _PlotsState extends State<Plots> {
  Map<String, dynamic> _activeFilters = {};
  int selectedFarmIndex = 0;

  Logger logger = Logger();

  List<dynamic> farms = [];
  List<dynamic> plots = [];
  Map<String, dynamic> selectedFarm = {};

  Future<void> _onRefresh() async {
    // await context.read<FarmStateCubit>().fetch(sl<FetchFarmsUsecase>());
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    print('Active filters: $filters');
  }

  // Method to fetch plots for a specific farm
  void _fetchPlotsForFarm(String farmId) {
    context.read<PlotStateCubit>().execute(
        FetchPlotDetailsParams(
            farmId: farmId, includeGeoJson: false, skip: 0, limit: 10),
        sl<FetchFarmPlotsUsecase>());
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmStateCubit>().fetch(sl<FetchFarmsUsecase>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FarmStateCubit, FarmState>(
        builder: (context, farmState) {
      if (farmState is FarmStateLoading) {
        return FarmBrosLoadingState();
      }

      if (farmState is FarmStateSuccess) {
        farms = farmState.farms!;

        // Only set selectedFarm if it's empty (first load)
        if (selectedFarm.isEmpty && farms.isNotEmpty) {
          selectedFarm = farms.first;
          _fetchPlotsForFarm(selectedFarm['uuid']);
        }
      }

      return BlocBuilder<PlotStateCubit, PlotState>(
          builder: (context, plotState) {
        if (plotState is PlotStateLoading) {
          return FarmBrosLoadingState();
        }

        if (plotState is PlotStateSuccess) {
          logger.log(Level.info, plotState.data);
          plots = plotState.data!["data"] ?? [];
        }

        return Scaffold(
          body: Builder(builder: (context) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: FarmbrosAppbar(
                    icon: FluentIcons.re_order_16_regular,
                    appBarTitle: "Plots",
                    openSideBar: () {
                      Scaffold.of(context).openDrawer();
                    },
                    hasAction: false,
                  )),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      spacing: 10,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FluentIcons.location_24_filled,
                                  color: ColorUtils.secondaryColor),
                              Gap(5),
                              Text(
                                "My Plots",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorUtils.secondaryColor),
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Active Farm:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.inActiveColor,
                                    ),
                                  ),
                                  Gap(5),
                                  // Farm selector
                                  if (farms.isNotEmpty)
                                    Container(
                                      height: 40,
                                      width: 180,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: ColorUtils.secondaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: ColorUtils.secondaryColor,
                                            width: 1.5),
                                      ),
                                      child: DropdownButton<String>(
                                        value: selectedFarm["uuid"],
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        icon: Icon(FluentIcons
                                            .chevron_down_24_regular),
                                        items: farms
                                            .map<DropdownMenuItem<String>>(
                                                (farm) {
                                          return DropdownMenuItem<String>(
                                            value: farm["uuid"],
                                            child: Row(
                                              children: [
                                                Icon(
                                                    FluentIcons
                                                        .leaf_three_24_regular,
                                                    color: ColorUtils
                                                        .secondaryColor,
                                                    size: 20),
                                                SizedBox(width: 8),
                                                Text(farm["name"],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          logger.log(Level.info, value);
                                          setState(() {
                                            selectedFarm = farms.firstWhere(
                                                (farm) =>
                                                    farm["uuid"] == value);
                                          });
                                          // Fetch plots for the newly selected farm
                                          _fetchPlotsForFarm(value!);
                                        },
                                      ),
                                    )
                                  else
                                    // Fallback if no farms
                                    Material(
                                      elevation: 1,
                                      color: ColorUtils.secondaryColor
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          spacing: 5,
                                          children: [
                                            Icon(
                                              FluentIcons.circle_24_filled,
                                              color: ColorUtils.secondaryColor,
                                              size: 16,
                                            ),
                                            Text(
                                              "No Farm",
                                              style: TextStyle(
                                                  color:
                                                      ColorUtils.secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: SummaryStrip(),
                        ),
                        if (plotState is PlotStateSuccess && plots.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                Text(
                                  "Plots",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ColorUtils.inActiveColor),
                                ),
                                Column(
                                  spacing: 5,
                                  children: plots.map((plot) {
                                    return PlotComponent(plot: plot);
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        // Show alert when no plots are available
                        if (plotState is PlotStateSuccess && plots.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    ColorUtils.secondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: ColorUtils.secondaryColor
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    FluentIcons.info_24_regular,
                                    color: ColorUtils.secondaryColor,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "No Plots Found",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorUtils.secondaryColor,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "This farm doesn't have any plots yet. Tap the 'Add Plot' button below to create your first plot.",
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
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          drawer: FarmbrosNavigation(),
          floatingActionButton: SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(ColorUtils.secondaryColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              onPressed: () {
                logger.log(Level.trace, selectedFarm);
                context.push(
                    "${Routes.plots}/create_plot/${selectedFarm["uuid"]}",
                    extra: {
                      "farm": selectedFarm,
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Plot",
                    style:
                        TextStyle(color: ColorUtils.secondaryBackgroundColor),
                  ),
                  Gap(5),
                  Icon(
                    FluentIcons.add_24_regular,
                    color: ColorUtils.secondaryBackgroundColor,
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
