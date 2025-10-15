import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loading_state.dart';
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

  Future<void> _onRefresh() async {
    await context.read<FarmStateCubit>().fetch(sl<FetchFarmsUsecase>());
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _farmTabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FarmStateCubit>().fetch(sl<FetchFarmsUsecase>());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _farmTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FarmStateCubit, FarmState>(
        builder: (BuildContext context, state) {
      if (state is FarmStateLoading) {
        return FarmBrosLoadingState();
      } else if (state is FarmStateSuccess) {
        final farms = state.farms ?? [];

        return Scaffold(
          backgroundColor: ColorUtils.lightBackgroundColor,
          body: Builder(
            builder: (context) {
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
                                ),
                              )
                            ],
                          ),
                          Gap(60),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(FluentIcons.leaf_three_20_regular),
                                Gap(5),
                                Text("My farms"),
                              ],
                            ),
                          ),
                          Gap(10),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            child: MyFarmsTab(farms: farms),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
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
                context.go("${Routes.farms}${Routes.createFarm}");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add Farm",
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
          drawer: FarmbrosNavigation(),
        );
      } else if (state is FarmStateError) {
        // Handle error state
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    FarmbrosAppbar(
                      icon: FluentIcons.re_order_16_regular,
                      appBarTitle: "farms",
                      openSideBar: () {
                        Scaffold.of(context).openDrawer();
                      },
                      hasAction: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.error_circle_24_regular,
                              size: 64,
                              color: Colors.red,
                            ),
                            Gap(16),
                            Text(
                              "Error loading farms",
                              style: TextStyle(fontSize: 18),
                            ),
                            Gap(8),
                            Text(
                              "Something went wrong",
                              textAlign: TextAlign.center,
                            ),
                            Gap(16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<FarmStateCubit>()
                                    .fetch(sl<FetchFarmsUsecase>());
                              },
                              child: Text("Retry"),
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
      } else {
        // Initial state or unknown state - show loading
        return FarmBrosLoadingState();
      }
    });
  }
}
