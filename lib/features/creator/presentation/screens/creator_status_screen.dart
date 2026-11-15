import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class CreatorStatusScreen extends StatefulWidget {
  const CreatorStatusScreen({super.key});

  @override
  State<CreatorStatusScreen> createState() => _CreatorStatusScreenState();
}

class _CreatorStatusScreenState extends State<CreatorStatusScreen> {
  Map<String, dynamic>? _status;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final provider = context.read<AuthProvider>();
    final result = await provider.getCreatorStatus();
    if (mounted) {
      setState(() {
        _status = result;
        _loading = false;
      });
    }
  }

  int _activeStep(String status) {
    switch (status) {
      case 'approved':
        return 3;
      case 'rejected':
        return 2;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (_loading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primaryPurple),
                    ),
                  )
                else
                  Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final status = _status?['status'] as String? ?? 'pending';
    final activeStep = _activeStep(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application under\nreview',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "An admin is reviewing your application. We'll notify you as soon as there's a decision.",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _TimelineStep(
          title: 'Application sent',
          subtitle: 'Your request reached the admins',
          state: _StepState.completed,
          isLast: false,
        ),
        _TimelineStep(
          title: 'Admin review',
          subtitle: 'An admin checks your application',
          state: activeStep == 1 ? _StepState.active : (activeStep > 1 ? _StepState.completed : _StepState.pending),
          isLast: false,
        ),
        _TimelineStep(
          title: 'Decision',
          subtitle: status == 'rejected' ? 'Not approved this time' : 'Approved or rejected',
          state: activeStep >= 2
              ? (status == 'rejected' ? _StepState.rejected : _StepState.completed)
              : _StepState.pending,
          isLast: false,
        ),
        _TimelineStep(
          title: 'Creator Studio unlocked',
          subtitle: 'Create and submit games',
          state: activeStep >= 3 ? _StepState.completed : _StepState.pending,
          isLast: true,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
            ),
            child: Text(
              'Back to profile',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

enum _StepState { completed, active, pending, rejected }

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final _StepState state;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                _buildDot(),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: state == _StepState.completed || state == _StepState.active
                          ? AppColors.gold
                          : AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: state == _StepState.pending
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    switch (state) {
      case _StepState.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        );
      case _StepState.active:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2.5),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold,
              ),
            ),
          ),
        );
      case _StepState.rejected:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.error,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 14),
        );
      case _StepState.pending:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider, width: 2),
          ),
        );
    }
  }
}
