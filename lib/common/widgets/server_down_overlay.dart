import 'package:farmbros_mobile/common/widgets/farmbros_button.dart';
import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ServerDownOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ServerDownOverlay({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FluentIcons.plug_disconnected_24_regular,
                  size: 64,
                  color: ColorUtils.serverDownColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Server Disconnected',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorUtils.serverDownColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                FarmbrosButton(
                  label: 'Retry Connection',
                  onPressed: onRetry,
                  elevation: 0,
                  buttonColor: ColorUtils.serverDownColor,
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
