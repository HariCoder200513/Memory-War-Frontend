import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../../core/widgets/mw_primary_button.dart';
import '../widgets/step_progress_bar.dart';

class ChooseUsernameScreen extends StatefulWidget {
  const ChooseUsernameScreen({super.key});

  @override
  State<ChooseUsernameScreen> createState() => _ChooseUsernameScreenState();
}

class _ChooseUsernameScreenState extends State<ChooseUsernameScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isChecking = false;
  bool _isSaving = false;
  bool? _isAvailable;
  String? _error;
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  bool get _isValid {
    final text = _controller.text;
    return text.length >= 3 &&
        text.length <= 16 &&
        RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text);
  }

  void _onUsernameChanged(String value) {
    _debounce?.cancel();
    setState(() {
      _isAvailable = null;
      _error = null;
    });

    if (value.isEmpty) return;

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      setState(() => _error = 'Only letters, numbers and underscores');
      return;
    }
    if (value.length < 3) {
      setState(() => _error = 'At least 3 characters');
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () => _checkAvailability(value));
  }

  Future<void> _checkAvailability(String username) async {
    setState(() => _isChecking = true);
    final available = await context.read<AuthProvider>().checkUsername(username);
    if (mounted && _controller.text == username) {
      setState(() {
        _isChecking = false;
        _isAvailable = available;
        if (!available) _error = 'Username already taken';
      });
    }
  }

  Future<void> _continue() async {
    if (!_isValid || _isAvailable != true) return;

    setState(() => _isSaving = true);
    final provider = context.read<AuthProvider>();
    final success = await provider.setUsername(_controller.text);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamed('/profile-setup/avatar');
    } else {
      setState(() {
        _isSaving = false;
        _error = provider.error ?? 'Failed to set username';
      });
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
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text(
                      'Step 1 of 3',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    const Expanded(
                      child: StepProgressBar(currentStep: 1, totalSteps: 3),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Choose your\nusername',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'This is the name other players see in the arena.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Username',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 4),
                      child: Text(
                        '@',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: 'your_name',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textTertiary,
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                      borderSide: BorderSide(
                        color: _error != null ? AppColors.error : AppColors.inputBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                      borderSide: BorderSide(
                        color: _error != null
                            ? AppColors.error
                            : (_isAvailable == true ? AppColors.success : AppColors.inputBorder),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                      borderSide: BorderSide(
                        color: _error != null ? AppColors.error : AppColors.primaryPurple,
                        width: 2,
                      ),
                    ),
                    suffixIcon: _buildSuffix(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                    LengthLimitingTextInputFormatter(16),
                  ],
                  onChanged: _onUsernameChanged,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_error != null)
                  Text(
                    _error!,
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
                  )
                else if (_isAvailable == true)
                  Text(
                    'Username is available!',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.success),
                  )
                else
                  Text(
                    '3–16 characters. Letters, numbers and underscores.',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary),
                  ),
                const Spacer(),
                MwPrimaryButton(
                  text: 'Continue',
                  onPressed: _continue,
                  isLoading: _isSaving,
                  enabled: _isValid && _isAvailable == true,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffix() {
    if (_isChecking) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textTertiary),
        ),
      );
    }
    if (_isAvailable == true) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: Icon(Icons.check_circle, color: AppColors.success, size: 22),
      );
    }
    if (_error != null && _controller.text.isNotEmpty) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: Icon(Icons.cancel, color: AppColors.error, size: 22),
      );
    }
    return null;
  }
}
