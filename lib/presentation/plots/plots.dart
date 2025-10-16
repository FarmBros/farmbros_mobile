import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_filter.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:farmbros_mobile/presentation/plots/utils/plot_utils.dart';
import 'package:farmbros_mobile/presentation/plots/widgets/plot_component.dart';
import 'package:farmbros_mobile/presentation/plots/widgets/summary_strip.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Logger logger = Logger();

  Future<void> _onRefresh() async {
    // await context.read<FarmStateCubit>().fetch(sl<FetchFarmsUsecase>());
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    print('Active filters: $filters');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        FarmbrosAppbar(
                          icon: FluentIcons.re_order_16_regular,
                          appBarTitle: "Plots",
                          openSideBar: () {
                            Scaffold.of(context).openDrawer();
                          },
                          hasAction: false,
                        ),
                        Positioned(
                          top: 100,
                          left: 20,
                          right: 20,
                          child: FarmbrosFilter(
                              filters: PlotUtils.$filters,
                              onFiltersChanged: _onFiltersChanged,
                              filterCount: 3),
                        )
                      ],
                    ),
                    Gap(30),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  spacing: 10,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(FluentIcons.location_24_filled,
                              color: ColorUtils.secondaryColor),
                          Gap(5),
                          Text(
                            "My Plots",
                            style: TextStyle(
                                fontSize: 16, color: ColorUtils.secondaryColor),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Active Farm:"),
                              Material(
                                elevation: 1,
                                color:
                                    ColorUtils.secondaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        FluentIcons.circle_24_filled,
                                        color: ColorUtils.secondaryColor,
                                      ),
                                      Text(
                                        "Farm Name",
                                        style: TextStyle(
                                            color: ColorUtils.secondaryColor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              )
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
                                fontSize: 14, color: ColorUtils.inActiveColor),
                          ),
                          Column(
                            spacing: 5,
                            children: [
                              PlotComponent(
                                  plotName: "Chicken Pen",
                                  plotContents: "50 Birds",
                                  structure: StructureType.chickenPen),
                              PlotComponent(
                                  plotName: "Cow Shed",
                                  plotContents: "20 Cows",
                                  structure: StructureType.cowShed),
                              PlotComponent(
                                  plotName: "Green House",
                                  plotContents: "50 Tomatoes",
                                  structure: StructureType.greenhouse)
                            ],
                          ),
                        ],
                      ),
                    )
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
            backgroundColor: WidgetStatePropertyAll(ColorUtils.secondaryColor),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          onPressed: () {
            context.go("${Routes.plots}${Routes.createPlot}");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Plot",
                style: TextStyle(color: ColorUtils.secondaryBackgroundColor),
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
  }
}
