import 'package:farmbros_mobile/common/bloc/plot/plot_state.dart';
import 'package:farmbros_mobile/common/bloc/plot/plot_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_notification_banner.dart';
import 'package:farmbros_mobile/domain/usecases/save_plot_use_case.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/data/models/plot_details_params.dart';
import 'package:farmbros_mobile/domain/enums/enums.dart';
import 'package:farmbros_mobile/domain/enums/plot_type_enum.dart';
import 'package:farmbros_mobile/domain/enums/plot_type_field.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class CreatePlot extends StatefulWidget {
  const CreatePlot({super.key});

  @override
  State<CreatePlot> createState() => _CreatePlotState();
}

class _CreatePlotState extends State<CreatePlot> {
  Logger logger = Logger();
  final Map<CreatePlotInputType, TextEditingController> controllers = {};
  final ValueNotifier<String?> plotTypeController =
      ValueNotifier<String?>(null);

  List<String> plotTypeOptions =
      PlotType.values.map((e) => e.displayName).toList();
  PlotType? selectedType;
  List<PlotTypeField> fieldsToShow = [];
  final Map<PlotTypeField, TextEditingController> dynamicFieldControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for base inputs
    for (var input in CreatePlotInputType.values) {
      controllers[input] = TextEditingController();
    }

    // Listen to plot type changes
    plotTypeController.addListener(_onPlotTypeChanged);
  }

  void _onPlotTypeChanged() {
    final selectedDisplayName = plotTypeController.value;
    if (selectedDisplayName != null) {
      setState(() {
        selectedType = PlotType.values.firstWhere(
          (type) => type.displayName == selectedDisplayName,
        );
        fieldsToShow = selectedType!.getRequiredFields();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    plotTypeController.removeListener(_onPlotTypeChanged);
    plotTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    logger.log(Level.info, extra);
    return BlocBuilder<PlotStateCubit, PlotState>(
        builder: (context, plotState) {
      final bool hasPlotData =
          plotState is PlotStateLoadGeoJSON && plotState.plotGeoJson.isNotEmpty;

      final plotTypeApiString = selectedType?.toApiString();

      final Map<String, dynamic> plotTypeData = {};

      for (var field in fieldsToShow) {
        final rawValue = dynamicFieldControllers[field]?.text.trim();

        if (field.valueType == FieldValueType.integer) {
          if (rawValue == null || rawValue.isEmpty) {
            plotTypeData[field.toApiFieldName()] = null;
          } else {
            final parsed = int.tryParse(rawValue);
            if (parsed == null) {
              throw Exception("${field.label} must be a number");
            }
            plotTypeData[field.toApiFieldName()] = parsed;
          }
        } else {
          plotTypeData[field.toApiFieldName()] = rawValue;
        }
      }

      final geoJson =
          plotState is PlotStateLoadGeoJSON ? plotState.plotGeoJson : {};

      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                FarmbrosAppbar(
                  icon: FluentIcons.ios_arrow_24_regular,
                  appBarTitle: "Create Plot",
                  openSideBar: () {
                    context.pop();
                  },
                  hasAction: false,
                ),
                Gap(20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fill in the details below to add a new plot",
                            style: TextStyle(fontSize: 16),
                          ),
                          Gap(15),
                          Text(
                            "Map Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(10),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: GestureDetector(
                              onTap: () {
                                context.push(
                                    "${Routes.plots}${Routes.createPlot}${Routes.map}",
                                    extra: {
                                      "farm_id": extra!["farm"]["uuid"],
                                      "farm_boundary": extra["farm"]
                                          ["boundary"],
                                      "centroid": extra["farm"]["centroid"]
                                    });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: hasPlotData
                                      ? ColorUtils.successColor.withOpacity(0.1)
                                      : ColorUtils.secondaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: hasPlotData
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
                                      hasPlotData
                                          ? FluentIcons
                                              .checkmark_circle_24_filled
                                          : FluentIcons.map_24_regular,
                                      size: 48,
                                      color: hasPlotData
                                          ? ColorUtils.successColor
                                          : ColorUtils.inActiveColor,
                                    ),
                                    Gap(10),
                                    Text(
                                      hasPlotData
                                          ? "Farm boundary mapped"
                                          : "Tap to set location",
                                      style: TextStyle(
                                        color: hasPlotData
                                            ? ColorUtils.successColor
                                            : ColorUtils.inActiveColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (hasPlotData)
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
                          Gap(10),
                          Column(
                            children: CreatePlotInputType.values.map((input) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: FarmbrosInput(
                                  label: input.inputLabel,
                                  icon: input.inputIcon,
                                  isPassword: input.isPassword,
                                  controller: controllers[input]!,
                                  isTextArea: input.isTextArea,
                                  isDropDownField: input.isDropDownField,
                                  // Dropdown specific parameters
                                  dropDownItems: input.isDropDownField
                                      ? plotTypeOptions
                                      : null,
                                  dropdownController: input.isDropDownField
                                      ? plotTypeController
                                      : null,
                                  dropdownHint: input.isDropDownField
                                      ? 'Select plot type'
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),

                          // Dynamic fields based on selected plot type
                          if (selectedType != null &&
                              fieldsToShow.isNotEmpty) ...[
                            Gap(20),
                            Text(
                              "Additional ${selectedType!.displayName} Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(10),
                            Column(
                              children: fieldsToShow.map((field) {
                                if (!dynamicFieldControllers
                                    .containsKey(field)) {
                                  dynamicFieldControllers[field] =
                                      TextEditingController();
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: FarmbrosInput(
                                    label: field.label,
                                    icon: field.icon,
                                    isPassword: field.isPassword,
                                    controller: dynamicFieldControllers[field]!,
                                    isTextArea: field.isTextArea,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          FarmbrosButton(
                            label: "Create Plot",
                            buttonColor: ColorUtils.secondaryColor,
                            textColor: ColorUtils.primaryTextColor,
                            fontWeight: FontWeight.bold,
                            onPressed: () {
                              context.read<PlotStateCubit>().execute(
                                  PlotDetailsParams(
                                      name: controllers[
                                              CreatePlotInputType.plotName]!
                                          .text,
                                      farmId: extra!["farm"]["uuid"],
                                      notes: controllers[
                                              CreatePlotInputType.notes]!
                                          .text,
                                      plotNumber: controllers[
                                              CreatePlotInputType.plotNumber]!
                                          .text,
                                      plotType: plotTypeApiString,
                                      geoJson: geoJson,
                                      plotTypeData: plotTypeData),
                                  sl<SavePlotUseCase>());

                              if (plotState is PlotStateSuccess) {
                                Future.delayed(Duration(seconds: 2), () {
                                  if (mounted) {
                                    context.pop();
                                  }
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (plotState is PlotStateSuccess)
              Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: FarmbrosNotificationBanner(
                    message: "Plot Created successfully!",
                    color: ColorUtils.successColor,
                  )),
            if (plotState is PlotStateError)
              Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: FarmbrosNotificationBanner(
                    message: plotState.errorMessage,
                    color: ColorUtils.failureColor,
                  ))
          ],
        ),
      );
    });
  }
}
