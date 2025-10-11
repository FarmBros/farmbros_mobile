import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_input.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:farmbros_mobile/routing/routes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateFarm extends StatefulWidget {
  const CreateFarm({super.key});

  @override
  State<CreateFarm> createState() => _CreateFarmState();
}

class _CreateFarmState extends State<CreateFarm> {
  late TextEditingController _farmNameController;
  late TextEditingController _farmDescriptionController;
  late TextEditingController _farmSizeController;
  late TextEditingController _farmLocationController;
  late TextEditingController _numberOfPlotsController;

  @override
  void initState() {
    super.initState();
    _farmNameController = TextEditingController();
    _farmDescriptionController = TextEditingController();
    _farmSizeController = TextEditingController();
    _farmLocationController = TextEditingController();
    _numberOfPlotsController = TextEditingController();
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _farmDescriptionController.dispose();
    _farmSizeController.dispose();
    _farmLocationController.dispose();
    _numberOfPlotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.lightBackgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: [
              FarmbrosAppbar(
                icon: FluentIcons.ios_arrow_24_regular,
                appBarTitle: "Create Farm",
                openSideBar: () {
                  context.pop();
                },
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
                            context.go("${Routes.farms}${Routes.createFarm}${Routes.map}");
                          },
                          child: Container(
                            width: double.infinity,
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
                                  FluentIcons.map_24_regular,
                                  size: 48,
                                  color: ColorUtils.inActiveColor,
                                ),
                                Gap(10),
                                Text(
                                  "Tap to set location",
                                  style: TextStyle(
                                    color: ColorUtils.inActiveColor,
                                    fontSize: 16,
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
                                Navigator.pop(context);
                              },
                              buttonColor: ColorUtils.secondaryBackgroundColor,
                              textColor: ColorUtils.failureColor,
                              icon: FluentIcons.dismiss_24_regular,
                              iconColor: ColorUtils.failureColor,
                            ),
                          ),
                          Expanded(
                            child: FarmbrosButton(
                              label: "Create Farm",
                              onPressed: () {
                                // Handle farm creation
                              },
                              buttonColor: ColorUtils.successColor,
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
          );
        },
      ),
      drawer: FarmbrosNavigation(),
    );
  }
}
