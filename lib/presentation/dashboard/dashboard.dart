import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/presentation/dashboard/widgets/dashboard_task_list.dart';
import 'package:farmbros_mobile/presentation/dashboard/widgets/dashboard_tips_carousel.dart';
import 'package:farmbros_mobile/presentation/dashboard/widgets/dashboard_summary_card.dart';
import 'package:farmbros_mobile/presentation/dashboard/widgets/dashboard_inventory_alert.dart';
import 'package:farmbros_mobile/presentation/dashboard/widgets/dashboard_weekly_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              FarmbrosAppbar(
                icon: FluentIcons.re_order_16_regular,
                appBarTitle: "Welcome [Farmer]",
                openSideBar: () {
                  Scaffold.of(context).openDrawer();
                },
                hasAction: false,
              ),
              const Gap(16),

              // Tips Carousel
              DashboardTipsCarousel(
                tips: [
                  DashboardTip(
                    message:
                        'Plot [Maize] Needs to be irrigated, last done 3 days ago.',
                  ),
                  DashboardTip(
                    message:
                        'In the next 4 days, Lucy will be on heat, prepare for breeding',
                  ),
                  DashboardTip(
                    message:
                        'Mercy, Jeri & Veronica need to get milked within the hour',
                  ),
                ],
              ),
              const Gap(16),

              // Plot Summary
              DashboardSummaryCard(
                title: 'Plot Summary',
                dropdownValue: 'Weed',
                items: [
                  SummaryItem(
                    icon: FluentIcons.resize_24_regular,
                    label: 'Dimensions:',
                    value: '50 × 80 Mtrs',
                  ),
                  SummaryItem(
                    icon: FluentIcons.plant_grass_24_regular,
                    label: 'No of Plants:',
                    value: '200',
                  ),
                  SummaryItem(
                    icon: FluentIcons.checkmark_circle_24_regular,
                    label: 'Plot Status:',
                    value: 'Planted',
                    valueColor: const Color(0xFF008000),
                  ),
                  SummaryItem(
                    icon: FluentIcons.wrench_24_regular,
                    label: 'Actions:',
                    value: 'Apply Fertilizer',
                  ),
                  SummaryItem(
                    icon: FluentIcons.money_24_regular,
                    label: 'Production Cost:',
                    value: 'KES 25,000',
                  ),
                ],
              ),

              // Structure Summary
              DashboardSummaryCard(
                title: 'Structure Summary',
                dropdownValue: 'Chicken Pen',
                items: [
                  SummaryItem(
                    icon: FluentIcons.resize_24_regular,
                    label: 'Dimensions:',
                    value: '50 × 80 Mtrs',
                  ),
                  SummaryItem(
                    icon: FluentIcons.animal_cat_24_regular,
                    label: 'No of Animals:',
                    value: '200',
                  ),
                  SummaryItem(
                    icon: FluentIcons.checkmark_circle_24_regular,
                    label: 'Structure Status:',
                    value: 'Excellent',
                    valueColor: const Color(0xFF008000),
                  ),
                  SummaryItem(
                    icon: FluentIcons.sparkle_24_regular,
                    label: 'Actions:',
                    value: 'Clean Structure',
                  ),
                  SummaryItem(
                    icon: FluentIcons.money_24_regular,
                    label: 'Production Cost:',
                    value: 'KES 45,000',
                  ),
                ],
              ),

              // Inventory Alerts
              DashboardInventoryAlert(
                alerts: [
                  InventoryAlertItem(
                    message: 'Replenish your chicken feed supply',
                    severity: 'Severe',
                    remaining: '2 Bags',
                  ),
                  InventoryAlertItem(
                    message: 'Replenish your Hay supply',
                    severity: 'Severe',
                    remaining: '5 Bales',
                  ),
                  InventoryAlertItem(
                    message: 'Replenish your Maize Seeds Supply',
                    severity: 'Severe',
                    remaining: '3 Bags',
                  ),
                ],
              ),

              // Farm Tasks
              DashboardTasksList(
                tasks: [
                  FarmTask(
                    type: 'Irrigation Task',
                    description:
                        'Irrigate the Maize plot on Tuesday 12th August',
                    status: 'In Progress',
                    assignedTo: 'Employee Name',
                    icon: FluentIcons.drop_24_filled,
                  ),
                  FarmTask(
                    type: 'Milking Task',
                    description: 'Mercy, Jeri & Veronica need to be milked',
                    status: 'In Progress',
                    assignedTo: 'Employee Name',
                    icon: FluentIcons.food_24_filled,
                  ),
                  FarmTask(
                    type: 'Cleaning Task',
                    description: 'Clean the cow shed on Plot G',
                    status: 'Stalled',
                    assignedTo: 'Employee Name',
                    icon: FluentIcons.sparkle_24_filled,
                  ),
                ],
              ),

              // Milk Production Chart
              DashboardWeeklyChart(
                title: 'Milk Production Summary',
                weeklyData: [
                  DailyData(day: 'Mon', value: 350),
                  DailyData(day: 'Tue', value: 420),
                  DailyData(day: 'Wed', value: 80),
                  DailyData(day: 'Thurs', value: 120),
                  DailyData(day: 'Fri', value: 60),
                  DailyData(day: 'Sat', value: 250),
                  DailyData(day: 'Sun', value: 100),
                ],
              ),

              const Gap(80), // Space for bottom navigation
            ],
          ),
        );
      }),
      drawer: FarmbrosNavigation(),
    );
  }
}
