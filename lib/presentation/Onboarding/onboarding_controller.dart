import 'package:farmbros_mobile/presentation/Onboarding/onboarding_congratulations.dart';
import 'package:farmbros_mobile/presentation/Onboarding/onboarding_farm_page.dart';
import 'package:farmbros_mobile/presentation/Onboarding/onboarding_landing_page.dart';
import 'package:farmbros_mobile/presentation/Onboarding/onboarding_logger.dart';
import 'package:farmbros_mobile/presentation/farm-logger/farm_logger.dart';
import 'package:flutter/material.dart';

class OnboardingController extends StatelessWidget {
  const OnboardingController({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        OnboardingLandingPage(),
        OnboardingFarmPage(),
        OnboardingLogger(),
        FarmLogger(),
        OnboardingCongratulations()
      ],
    );
  }
}
