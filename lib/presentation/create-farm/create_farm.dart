import 'package:farmbros_mobile/common/bloc/farm/farm_state.dart';
import 'package:farmbros_mobile/common/bloc/farm/farm_state_cubit.dart';
import 'package:farmbros_mobile/common/bloc/farm_bros_map/farm_bros_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_notification_banner.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/farm_details_params.dart';
import 'package:farmbros_mobile/domain/usecases/save_farm_use_case.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class CreateFarm extends StatefulWidget {
  const CreateFarm({super.key});

  @override
  State<CreateFarm> createState() => _CreateFarmState();
}

class _CreateFarmState extends State<CreateFarm> {
  late TextEditingController _farmNameController;
  late TextEditingController _farmDescriptionController;

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _farmNameController = TextEditingController();
    _farmDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.lightBackgroundColor,
      body: BlocBuilder<FarmStateCubit, FarmState>(
        builder: (context, state) {
          final bool hasMapData =
              state is FarmStateLoadGeoJSON && state.farmGeoJson.isNotEmpty;

          return Stack(
            children: [
              Column(
                children: [
                  FarmbrosAppbar(
                    icon: FluentIcons.ios_arrow_24_regular,
                    appBarTitle: "Create Farm",
                    openSideBar: () {
                      context.pop();
                    },
                    hasAction: false,
                  ),
                  Gap(20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar and Farm Name Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 10,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle image upload
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.secondaryBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: ColorUtils.primaryBorderColor,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FluentIcons.image_add_24_regular,
                                        size: 40,
                                        color: ColorUtils.inActiveColor,
                                      ),
                                      Gap(5),
                                      Text(
                                        "Add Image",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: ColorUtils.inActiveColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FarmbrosInput(
                                  label: "Farm Name",
                                  icon: FluentIcons.text_field_24_regular,
                                  isPassword: false,
                                  controller: _farmNameController,
                                  isTextArea: false,
                                ),
                              ),
                            ],
                          ),

                          // Farm Description
                          FarmbrosInput(
                            label: "Farm Description",
                            icon: FluentIcons.document_text_24_regular,
                            isPassword: false,
                            controller: _farmDescriptionController,
                            isTextArea: true,
                          ),

                          // Map Section
                          Text(
                            "Map Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                context.go(
                                  "${Routes.farms}${Routes.createFarm}${Routes.map}",
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: hasMapData
                                      ? ColorUtils.successColor.withOpacity(0.1)
                                      : ColorUtils.secondaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: hasMapData
                                        ? ColorUtils.successColor
                                        : ColorUtils.primaryBorderColor,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      hasMapData
                                          ? FluentIcons
                                              .checkmark_circle_24_filled
                                          : FluentIcons.map_24_regular,
                                      size: 48,
                                      color: hasMapData
                                          ? ColorUtils.successColor
                                          : ColorUtils.inActiveColor,
                                    ),
                                    Gap(10),
                                    Text(
                                      hasMapData
                                          ? "Farm boundary mapped"
                                          : "Tap to set location",
                                      style: TextStyle(
                                        color: hasMapData
                                            ? ColorUtils.successColor
                                            : ColorUtils.inActiveColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (hasMapData)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "Tap to edit",
                                          style: TextStyle(
                                            color: ColorUtils.inActiveColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Action Buttons
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: FarmbrosButton(
                                  label: "Cancel",
                                  onPressed: () {
                                    // Clear the saved GeoJSON when canceling
                                    context
                                        .read<FarmStateCubit>()
                                        .clearFarmGeoJson();
                                    Navigator.pop(context);
                                  },
                                  buttonColor:
                                      ColorUtils.secondaryBackgroundColor,
                                  textColor: ColorUtils.failureColor,
                                  icon: FluentIcons.dismiss_24_regular,
                                  iconColor: ColorUtils.failureColor,
                                ),
                              ),
                              Expanded(
                                child: FarmbrosButton(
                                  label: "Create Farm",
                                  onPressed: hasMapData
                                      ? () {
                                          _createFarm(state.farmGeoJson, state);
                                        }
                                      : null,
                                  // Disable if no map data
                                  buttonColor: hasMapData
                                      ? ColorUtils.successColor
                                      : ColorUtils.inActiveColor,
                                  icon: FluentIcons.checkmark_24_regular,
                                  iconColor: ColorUtils.successColor,
                                ),
                              ),
                            ],
                          ),
                          Gap(20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (state is FarmStateSuccess)
                Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: FarmbrosNotificationBanner(
                      message: "Farm Created successfully!",
                      color: ColorUtils.successColor,
                    )),
              if (state is FarmStateError)
                Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: FarmbrosNotificationBanner(
                      message: state.errorMessage,
                      color: ColorUtils.failureColor,
                    ))
            ],
          );
        },
      ),
      drawer: FarmbrosNavigation(),
    );
  }

  void _createFarm(Map<String, dynamic> farmGeoJson, FarmState state) async {
    try {
      final farmDetailsParams = FarmDetailsParams(
        name: _farmNameController.text,
        description: _farmDescriptionController.text,
        geoJson: farmGeoJson,
      );

      // Execute the API call
      context
          .read<FarmStateCubit>()
          .execute(farmDetailsParams, sl<SaveFarmUseCase>());
      if (state is FarmStateSuccess) {
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
