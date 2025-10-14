import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_search_bar.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/domain/usecases/fetch_farms_use_case.dart';
import 'package:farmbros_mobile/presentation/farms/widgets/browse_farms.dart';
import 'package:farmbros_mobile/presentation/farms/widgets/my_farms_tab.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class Farms extends StatefulWidget {
  const Farms({super.key});

  @override
  State<Farms> createState() => _FarmsState();
}

class _FarmsState extends State<Farms> with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late TabController _farmTabController;

  List<Map<String, dynamic>> userFarms = [];

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _farmTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _farmTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FarmStateCubit>()..fetch(sl<FetchFarmsUsecase>()),
      child: Scaffold(
        backgroundColor: ColorUtils.lightBackgroundColor,
        body: BlocBuilder<FarmStateCubit, FarmState>(
            builder: (BuildContext context, state) {
          return Column(
            spacing: 5,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  FarmbrosAppbar(
                    icon: FluentIcons.re_order_16_regular,
                    appBarTitle: "farms",
                    openSideBar: () {
                      Scaffold.of(context).openDrawer();
                    },
                    hasAction: false,
                  ),
                  Positioned(
                      top: 100,
                      left: 20,
                      right: 20,
                      child: FarmbrosSearchBar(
                        searchQuery: _searchController,
                        searchResults: [],
                        hintText: "Enter Farm Name",
                      ))
                ],
              ),
              Gap(60),
              if (state is FarmStateSuccess)
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TabBar(
                          indicatorColor: ColorUtils.secondaryColor,
                          unselectedLabelColor: ColorUtils.inActiveColor,
                          labelColor: ColorUtils.secondaryColor,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _farmTabController,
                          tabs: [
                            Tab(
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(FluentIcons.leaf_three_20_regular),
                                  Text("My farms")
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(FluentIcons.sparkle_24_regular),
                                  Text("Browse farms")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Wrap TabBarView with Expanded to give it remaining height
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: TabBarView(
                            controller: _farmTabController,
                            children: [
                              MyFarmsTab(farms: state.farms!),
                              // Pass the actual farms data
                              BrowseFarms()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        }),
        floatingActionButton: SizedBox(
          width: 130,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorUtils.secondaryColor),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
              onPressed: () {
                context.go("${Routes.farms}${Routes.createFarm}");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    "Add Farm",
                    style:
                        TextStyle(color: ColorUtils.secondaryBackgroundColor),
                  ),
                  Icon(
                    FluentIcons.add_24_regular,
                    color: ColorUtils.secondaryBackgroundColor,
                  ),
                ],
              )),
        ),
        drawer: FarmbrosNavigation(),
      ),
    );
  }
}
