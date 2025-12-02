import 'package:farmbros_mobile/core/configs/Utils/color_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashboardTipsCarousel extends StatefulWidget {
  final List<DashboardTip> tips;

  const DashboardTipsCarousel({
    super.key,
    required this.tips,
  });

  @override
  State<DashboardTipsCarousel> createState() => _DashboardTipsCarouselState();
}

class _DashboardTipsCarouselState extends State<DashboardTipsCarousel> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextTip() {
    if (_currentIndex < widget.tips.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousTip() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF008000),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Tips Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.tips.length,
            itemBuilder: (context, index) {
              final tip = widget.tips[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tip ${index + 1} of ${widget.tips.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      tip.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),

          // Navigation Arrows
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  FluentIcons.chevron_left_24_filled,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _currentIndex > 0 ? _previousTip : null,
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(
                  FluentIcons.chevron_right_24_filled,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed:
                    _currentIndex < widget.tips.length - 1 ? _nextTip : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardTip {
  final String message;
  final String? category;

  DashboardTip({
    required this.message,
    this.category,
  });
}
