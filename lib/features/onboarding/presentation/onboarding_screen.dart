import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_illustration.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
      illustrationType: OnboardingIllustrationType.memoryCards,
    ),
    OnboardingPageData(
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
      illustrationType: OnboardingIllustrationType.compete,
    ),
    OnboardingPageData(
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
      illustrationType: OnboardingIllustrationType.progress,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onSkip() => _completeOnboarding();

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryBackground, Color(0xFF0F0D1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isLastPage)
                      TextButton(
                        onPressed: _onSkip,
                        child: Text(
                          AppStrings.onboardingSkip,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: _pages[index]);
                  },
                ),
              ),
              // Bottom controls
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  children: [
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primaryPurple
                                : AppColors.primaryPurple.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isLastPage
                              ? AppStrings.onboardingGetStarted
                              : AppStrings.onboardingNext,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final OnboardingIllustrationType illustrationType;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.illustrationType,
  });
}
