import 'package:farmbros_mobile/common/bloc/session/session_state_cubit.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_appbar.dart';
import 'package:farmbros_mobile/service_locator.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/common/widgets/farmbros_navigation.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

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
                appBarTitle: "Farmer Account",
                openSideBar: () {
                  Scaffold.of(context).openDrawer();
                },
                hasAction: false,
              ),

              // Profile Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorUtils.primaryTextColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorUtils.secondaryColor,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                ColorUtils.secondaryColor.withOpacity(0.1),
                            child: Icon(
                              FluentIcons.person_48_regular,
                              size: 50,
                              color: ColorUtils.secondaryColor,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorUtils.primaryTextColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              FluentIcons.camera_16_regular,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // User Name
                    const Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Username
                    Text(
                      "@johndoe",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Verification Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUtils.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorUtils.successColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FluentIcons.checkmark_circle_16_filled,
                            size: 16,
                            color: ColorUtils.successColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Verified Account",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.successColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Quick Stats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: FluentIcons.building_24_regular,
                        label: "Farms",
                        value: "5",
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: FluentIcons.grid_24_regular,
                        label: "Plots",
                        value: "12",
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: FluentIcons.calendar_24_regular,
                        label: "Days",
                        value: "156",
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Personal Information Section
              _SectionContainer(
                title: "Personal Information",
                child: Column(
                  children: [
                    _InfoRow(
                      icon: FluentIcons.mail_24_regular,
                      label: "Email",
                      value: "john.doe@example.com",
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: FluentIcons.call_24_regular,
                      label: "Phone",
                      value: "+254 712 345 678",
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: FluentIcons.calendar_24_regular,
                      label: "Joined",
                      value: "January 15, 2024",
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: FluentIcons.location_24_regular,
                      label: "Location",
                      value: "Nairobi, Kenya",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Account Settings Section
              _SectionContainer(
                title: "Account Settings",
                child: Column(
                  children: [
                    _SettingRow(
                      icon: FluentIcons.person_24_regular,
                      label: "Edit Profile",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: FluentIcons.key_24_regular,
                      label: "Change Password",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: FluentIcons.globe_24_regular,
                      label: "Language",
                      trailing: "English",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: FluentIcons.dark_theme_24_regular,
                      label: "Theme",
                      trailing: "Light",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Preferences Section
              _SectionContainer(
                title: "Preferences",
                child: Column(
                  children: [
                    _SettingRow(
                      icon: FluentIcons.alert_24_regular,
                      label: "Notifications",
                      trailingWidget: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: ColorUtils.secondaryColor,
                      ),
                      onTap: null,
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: FluentIcons.location_24_regular,
                      label: "Location Services",
                      trailingWidget: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: ColorUtils.secondaryColor,
                      ),
                      onTap: null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Support Section
              _SectionContainer(
                title: "Support",
                child: Column(
                  children: [
                    _SettingRow(
                      icon: FluentIcons.question_circle_24_regular,
                      label: "Help Center",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: FluentIcons.document_24_regular,
                      label: "Terms & Conditions",
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: FluentIcons.shield_24_regular,
                      label: "Privacy Policy",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FarmbrosButton(
                  label: "Logout",
                  buttonColor: ColorUtils.failureColor,
                  textColor: ColorUtils.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  onPressed: () async {
                    final sessionCubit = sl<SessionCubit>();
                    await sessionCubit.clearSession();
                  },
                  elevation: 2,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
      drawer: FarmbrosNavigation(),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.primaryTextColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Section Container Widget
class _SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionContainer({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.primaryTextColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorUtils.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: ColorUtils.secondaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Setting Row Widget
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.trailingWidget,
    this.onTap,
  });

  Widget get _trailing {
    if (trailingWidget != null) return trailingWidget!;
    if (trailing != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            FluentIcons.chevron_right_16_regular,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      );
    }
    return Icon(
      FluentIcons.chevron_right_16_regular,
      size: 16,
      color: Colors.grey.shade400,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorUtils.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: ColorUtils.secondaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            _trailing,
          ],
        ),
      ),
    );
  }
}
