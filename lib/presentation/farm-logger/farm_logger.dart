import 'package:farmbros_mobile/common/bloc/farm_logger/crop_logger_state.dart';
import 'package:farmbros_mobile/common/bloc/farm_logger/crop_logger_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_bottomsheet.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_loading_state.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/crop_logger_details_params.dart';
import 'package:farmbros_mobile/domain/usecases/crop_logger_usecase.dart';
import 'package:farmbros_mobile/presentation/farm-logger/widgets/empty_collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farmbros_mobile/service_locator.dart';

class FarmLogger extends StatefulWidget {
  const FarmLogger({super.key});

  @override
  State<FarmLogger> createState() => _FarmLoggerState();
}

class _FarmLoggerState extends State<FarmLogger> {
  void _openBottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FarmbrosBottomsheet(),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CropLoggerStateCubit>().fetchAllCrops(
          CropLoggerDetailsParams(skip: 0, limit: 100),
          sl<CropLoggerUseCase>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropLoggerStateCubit, CropLoggerState>(
        builder: (context, cropLogger) {
      if (cropLogger is CropLoggerStateLoading) {
        return FarmBrosLoadingState();
      } else if (cropLogger is CropLoggerStateSuccess) {
        final crops = cropLogger.crops ?? [];
      }

      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Builder(builder: (context) {
          return Column(
            children: [
              FarmbrosAppbar(
                icon: FluentIcons.re_order_16_regular,
                appBarTitle: "Farm Logger",
                openSideBar: () {
                  Scaffold.of(context).openDrawer();
                },
                hasAction: false,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorUtils.primaryTextColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorColor: ColorUtils.secondaryColor,
                            indicatorWeight: 3,
                            labelStyle: TextStyle(
                              color: ColorUtils.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            tabs: const [
                              Tab(text: "Animals"),
                              Tab(text: "Crops"),
                              Tab(text: "Equipment"),
                              Tab(text: "Structures"),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildAnimalLogger(context),
                                _buildCropLogger(context),
                                _buildEquipmentLogger(context),
                                _buildStructureLogger(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        drawer: FarmbrosNavigation(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorUtils.secondaryColor,
          child: const Icon(FluentIcons.add_24_filled),
          onPressed: () => _openBottomsheet(context),
        ),
      );
    });
  }

  Widget _buildAnimalLogger(BuildContext context) => const EmptyCollection(
        collectionName: "Animals",
        icon: FluentIcons.animal_cat_24_regular,
      );

  Widget _buildCropLogger(BuildContext context) => const EmptyCollection(
        collectionName: "Crops",
        icon: FluentIcons.plant_grass_24_regular,
      );

  Widget _buildStructureLogger(BuildContext context) => const EmptyCollection(
        collectionName: "Structures",
        icon: FluentIcons.building_24_regular,
      );

  Widget _buildEquipmentLogger(BuildContext context) => const EmptyCollection(
        collectionName: "Equipment",
        icon: FluentIcons.wrench_24_regular,
      );
}
