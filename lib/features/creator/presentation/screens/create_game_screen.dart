import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/network/api_client.dart';
import '../../data/services/game_service.dart';

// ─── Data classes ────────────────────────────────────────────────────────────

class _GameCategory {
  final String id;
  final String label;
  final String emoji;
  final Color color;
  const _GameCategory(this.id, this.label, this.emoji, this.color);
}

const _categories = [
  _GameCategory('animals', 'Animals', '🐻', Color(0xFFFFA726)),
  _GameCategory('fruits', 'Fruits', '🍎', Color(0xFFEF5350)),
  _GameCategory('food', 'Food', '🍔', Color(0xFFEC407A)),
  _GameCategory('sports', 'Sports', '⚽', Color(0xFF26A69A)),
  _GameCategory('space', 'Space', '🪐', Color(0xFF42A5F5)),
  _GameCategory('nature', 'Nature', '🌿', Color(0xFF66BB6A)),
  _GameCategory('shapes', 'Shapes', '🔷', Color(0xFF7E57C2)),
  _GameCategory('patterns', 'Patterns', '🧩', Color(0xFF9575CD)),
  _GameCategory('stars', 'Stars', '⭐', Color(0xFFFF7043)),
];

const _categoryIcons = <String, List<String>>{
  'animals': [
    '🐶', '🐱', '🐻', '🐸', '🐰', '🐷', '🐵', '🦊', '🐼', '🐨',
    '🦁', '🐮', '🐔', '🐧', '🐢', '🐝', '🦋', '🐙', '🐠', '🦄',
    '🐺', '🐴', '🦉', '🐛', '🐞', '🦀', '🐍', '🦅', '🐳', '🦈',
  ],
  'fruits': [
    '🍎', '🍊', '🍋', '🍇', '🍓', '🍑', '🍒', '🍌', '🍉', '🍐',
    '🫐', '🥝', '🍍', '🥭', '🍈', '🥑', '🌶️', '🥕', '🌽', '🥬',
    '🥦', '🍄', '🌰', '🥜', '🫘', '🧅', '🥔', '🫛', '🧄', '🫑',
  ],
  'food': [
    '🍔', '🍕', '🌮', '🍣', '🍜', '🍩', '🧁', '🍰', '🍫', '🍿',
    '🥨', '🌭', '🍟', '🥪', '🧇', '🥞', '🍳', '🥓', '🥐', '🥯',
    '🧀', '🥗', '🫕', '🍲', '🥘', '🍱', '🥟', '🍘', '🍙', '🍚',
  ],
  'sports': [
    '⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸',
    '🥊', '🏊', '🚴', '🏋️', '⛷️', '🏄', '🤸', '⛹️', '🏇', '🥏',
    '🎿', '🛹', '🏹', '🥋', '🤺', '🎯', '🤾', '🧗', '🏌️', '🤽',
  ],
  'space': [
    '🚀', '🪐', '⭐', '🌙', '☄️', '🌍', '🛸', '👾', '🤖', '👽',
    '🌌', '🔭', '🛰️', '☀️', '🌑', '💫', '🌟', '✨', '🌠', '🌊',
    '🌋', '🏔️', '⚡', '🔥', '❄️', '🌈', '💎', '🔮', '🧲', '⏳',
  ],
  'nature': [
    '🌿', '🌸', '🌻', '🌲', '🍀', '🌵', '🍁', '🌺', '🌾', '🌴',
    '🌱', '🍂', '💐', '🪷', '🌹', '🏵️', '🪻', '🍃', '🪴', '🌊',
    '🏖️', '🌈', '☘️', '🪨', '🪵', '🍄', '🐚', '🪸', '🎋', '🎍',
  ],
  'shapes': [
    '🔴', '🔵', '🟢', '🟡', '🟣', '🟠', '⬛', '💎', '🔶', '🔷',
    '🔺', '🔻', '⬜', '🟥', '🟦', '🟩', '🟨', '🟪', '🟧', '⭕',
    '💠', '🔘', '🔲', '🔳', '♦️', '♠️', '♥️', '♣️', '🃏', '🀄',
  ],
  'patterns': [
    '🧩', '🎲', '🀄', '🃏', '♠️', '♥️', '♦️', '♣️', '🔢', '🔤',
    '🔣', '🎰', '🎪', '🎭', '🎨', '🎵', '🎶', '🎼', '📐', '📏',
    '🧮', '⚙️', '🔑', '🗝️', '📍', '🧿', '🪬', '🎴', '📌', '🏷️',
  ],
  'stars': [
    '⭐', '🌟', '✨', '💫', '🔆', '🔅', '☀️', '🌙', '🌛', '🌜',
    '🌝', '🌞', '💥', '🔥', '❄️', '🌊', '⚡', '🌈', '🎆', '🎇',
    '🎉', '🎊', '🏆', '🥇', '🎯', '💡', '🔔', '🎁', '🧨', '🪩',
  ],
};

class _GridPreset {
  final int rows;
  final int cols;
  final String difficulty;
  final Color difficultyColor;
  const _GridPreset(this.rows, this.cols, this.difficulty, this.difficultyColor);

  int get cells => rows * cols;
  int get pairs => cells ~/ 2;
}

const _presets = [
  _GridPreset(3, 4, 'Easy', AppColors.success),
  _GridPreset(4, 4, 'Easy', AppColors.success),
  _GridPreset(4, 6, 'Medium', AppColors.gold),
];

class _CardBackStyle {
  final String id;
  final String label;
  const _CardBackStyle(this.id, this.label);
}

const _cardBackStyles = [
  _CardBackStyle('classic', 'Classic'),
  _CardBackStyle('stripes', 'Stripes'),
  _CardBackStyle('dots', 'Dots'),
  _CardBackStyle('orange', 'Orange'),
  _CardBackStyle('green', 'Green'),
  _CardBackStyle('red', 'Red'),
];

// ─── Widget ──────────────────────────────────────────────────────────────────

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  int _currentStep = 1;
  static const _totalSteps = 6;
  bool _isSubmitting = false;

  static const _stepLabels = [
    'Game Details',
    'Grid Setup',
    'Card Design',
    'Appearance',
    'Rules & Rewards',
    'Preview & Publish',
  ];

  // ── Step 1 state ──
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = '';

  // ── Step 2 state ──
  int _gridRows = 4;
  int _gridColumns = 4;
  int? _selectedPresetIndex = 1;

  // ── Step 3 state ──
  String? _focusedIcon;
  List<String> _cellIcons = [];

  // ── Step 4 state ──
  String _cardBack = 'classic';
  final List<bool> _livePreviewFlipped = [true, true, false, false];

  // ── Step 5 state ──
  bool _timeLimitEnabled = true;
  int _timeLimitSeconds = 120;
  bool _moveLimitEnabled = false;
  int _moveLimit = 20;
  int _mismatchDelayMs = 1000;
  bool _allowHints = true;

  // ── Step 6 state ──
  List<String> _gameCards = [];
  List<bool> _revealedCards = [];
  List<bool> _matchedCards = [];
  int? _firstFlipped;
  int _moves = 0;
  int _pairsFound = 0;
  bool _isChecking = false;
  bool _hasCompletedPreview = false;

  // ── Computed ──

  int get _totalCells => _gridRows * _gridColumns;
  bool get _isEvenGrid => _totalCells % 2 == 0;
  int get _pairsNeeded => _totalCells ~/ 2;
  int get _maxScore => _pairsNeeded * 100;
  List<String> get _availableIcons => _categoryIcons[_selectedCategory] ?? [];
  Set<String> get _selectedIcons => _cellIcons.where((i) => i.isNotEmpty).toSet();

  String get _timeLimitDisplay {
    final m = _timeLimitSeconds ~/ 60;
    final s = _timeLimitSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get _mismatchDelayDisplay =>
      '${(_mismatchDelayMs / 1000).toStringAsFixed(1)} s';

  String get _difficultyLabel {
    final total = _totalCells;
    if (total <= 16) return 'Easy';
    if (total <= 30) return 'Medium';
    return 'Hard';
  }

  // ── Validation ──

  bool get _isStep1Valid =>
      _nameController.text.trim().isNotEmpty && _selectedCategory.isNotEmpty;

  bool get _isStep2Valid => _isEvenGrid;

  bool get _isStep3Valid =>
      _isEvenGrid &&
      _cellIcons.length == _totalCells &&
      _cellIcons.every((i) => i.isNotEmpty);

  bool get _isStep4Valid => true;
  bool get _isStep5Valid => true;
  bool get _isStep6Valid => _hasCompletedPreview;

  bool get _isCurrentStepValid {
    switch (_currentStep) {
      case 1:
        return _isStep1Valid;
      case 2:
        return _isStep2Valid;
      case 3:
        return _isStep3Valid;
      case 4:
        return _isStep4Valid;
      case 5:
        return _isStep5Valid;
      case 6:
        return _isStep6Valid;
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // ── Navigation ──

  void _onContinue() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
        if (_currentStep == 3) _ensureCellIcons();
        if (_currentStep == 6) _initPlayablePreview();
      });
    }
  }

  void _onBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  // ── Grid helpers ──

  void _syncPresetFromCustom() {
    _selectedPresetIndex = null;
    for (int i = 0; i < _presets.length; i++) {
      if (_presets[i].rows == _gridRows && _presets[i].cols == _gridColumns) {
        _selectedPresetIndex = i;
        break;
      }
    }
  }

  void _selectPreset(int index) {
    setState(() {
      _selectedPresetIndex = index;
      _gridRows = _presets[index].rows;
      _gridColumns = _presets[index].cols;
      _trimIconsToGrid();
    });
  }

  void _ensureCellIcons() {
    if (_cellIcons.length != _totalCells) {
      _cellIcons = List.filled(_totalCells, '');
      _focusedIcon = null;
    }
  }

  void _trimIconsToGrid() {
    if (_cellIcons.isEmpty) return;
    if (_cellIcons.length > _totalCells) {
      _cellIcons = _cellIcons.sublist(0, _totalCells);
    } else if (_cellIcons.length < _totalCells) {
      _cellIcons = [
        ..._cellIcons,
        ...List.filled(_totalCells - _cellIcons.length, ''),
      ];
    }
    _focusedIcon = null;
  }

  void _onPaletteIconTap(String icon) {
    setState(() {
      final count = _cellIcons.where((i) => i == icon).length;
      if (count >= 2 && _focusedIcon != icon) return;
      _focusedIcon = _focusedIcon == icon ? null : icon;
    });
  }

  void _onGridCellTap(int index) {
    if (index >= _cellIcons.length) return;
    setState(() {
      if (_cellIcons[index].isNotEmpty) {
        _cellIcons[index] = '';
      } else if (_focusedIcon != null) {
        final count = _cellIcons.where((i) => i == _focusedIcon).length;
        if (count < 2) {
          _cellIcons[index] = _focusedIcon!;
          if (count + 1 >= 2) _focusedIcon = null;
        }
      }
    });
  }

  // ── Playable preview (Step 6) ──

  void _initPlayablePreview() {
    final paired = List<String>.from(_cellIcons);
    paired.shuffle(Random());
    _gameCards = paired;
    _revealedCards = List.filled(paired.length, false);
    _matchedCards = List.filled(paired.length, false);
    _firstFlipped = null;
    _moves = 0;
    _pairsFound = 0;
    _isChecking = false;
    _hasCompletedPreview = false;
  }

  void _resetPreview() {
    setState(() => _initPlayablePreview());
  }

  void _onCardTap(int index) {
    if (_isChecking || _matchedCards[index] || _revealedCards[index]) return;
    setState(() {
      _revealedCards[index] = true;
      if (_firstFlipped == null) {
        _firstFlipped = index;
      } else {
        _moves++;
        final first = _firstFlipped!;
        _firstFlipped = null;
        if (_gameCards[first] == _gameCards[index]) {
          _matchedCards[first] = true;
          _matchedCards[index] = true;
          _pairsFound++;
          if (_pairsFound == _pairsNeeded) _hasCompletedPreview = true;
        } else {
          _isChecking = true;
          Future.delayed(Duration(milliseconds: _mismatchDelayMs), () {
            if (mounted) {
              setState(() {
                _revealedCards[first] = false;
                _revealedCards[index] = false;
                _isChecking = false;
              });
            }
          });
        }
      }
    });
  }

  // ── API calls ──

  Future<void> _onSubmit() async {
    setState(() => _isSubmitting = true);
    try {
      final apiClient = context.read<ApiClient>();
      final gameService = GameService(apiClient);
      final game = await gameService.createGame(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory,
        gridRows: _gridRows,
        gridColumns: _gridColumns,
        cardIcons: _selectedIcons.toList(),
        cardBack: _cardBack,
        timeLimitSeconds: _timeLimitEnabled ? _timeLimitSeconds : 0,
        moveLimit: _moveLimitEnabled ? _moveLimit : 0,
        mismatchDelayMs: _mismatchDelayMs,
        allowHints: _allowHints,
      );
      await gameService.submitGame(game.id);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Build ──

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
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding),
                  child: _buildCurrentStep(),
                ),
              ),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      case 5:
        return _buildStep5();
      case 6:
        return _buildStep6();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Header ──

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child:
                const Icon(Icons.close, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step $_currentStep of $_totalSteps',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              Text(
                _stepLabels[_currentStep - 1],
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          _buildBadge(),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    final valid = _isCurrentStepValid;
    final color = valid ? AppColors.success : AppColors.gold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            valid ? Icons.check : Icons.warning_amber_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            valid ? 'Ready' : 'Incomplete',
            style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding,
          AppSpacing.md, AppSpacing.screenPadding, AppSpacing.md),
      child: Row(
        children: List.generate(_totalSteps, (i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < _totalSteps - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: i < _currentStep
                    ? AppColors.primaryPurple
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STEP 1 — Game Details
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('Create Your Game',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text('Give your memory challenge an identity.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppSpacing.xl),
        _labelRow('Game name', '${_nameController.text.length}/30'),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _nameController,
          maxLength: 30,
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
          decoration: _inputDecoration('e.g. Jungle Match-Up'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        _labelRow('Short description', '${_descController.text.length}/120'),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _descController,
          maxLength: 120,
          maxLines: 3,
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
          decoration: _inputDecoration('What should players expect?'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Game category',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: _categories.length,
          itemBuilder: (_, i) => _buildCategoryChip(_categories[i]),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildCategoryChip(_GameCategory cat) {
    final selected = _selectedCategory == cat.id;
    return GestureDetector(
      onTap: () => setState(() {
        if (_selectedCategory != cat.id) {
          _selectedCategory = cat.id;
          _cellIcons = List.filled(_totalCells, '');
          _focusedIcon = null;
        }
      }),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: selected ? AppColors.primaryPurple : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(cat.emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 8),
            Text(cat.label,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STEP 2 — Grid Setup
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('Choose Your Board',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text('Decide how challenging your memory game should be.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppSpacing.xl),
        Text('Grid presets',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _presets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _buildPresetCard(i),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Custom grid',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            if (_selectedPresetIndex != null)
              Text('Matches a preset',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStepper('Rows', _gridRows, (v) {
                setState(() {
                  _gridRows = v;
                  _syncPresetFromCustom();
                  _trimIconsToGrid();
                });
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStepper('Columns', _gridColumns, (v) {
                setState(() {
                  _gridColumns = v;
                  _syncPresetFromCustom();
                  _trimIconsToGrid();
                });
              }),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text('From 3 × 3 up to 10 × 10.',
            style:
                GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
        if (!_isEvenGrid) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            const Icon(Icons.info_outline, size: 14, color: AppColors.error),
            const SizedBox(width: 6),
            Text(
              'Total cells must be even for equal pairs ($_totalCells is odd)',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
            ),
          ]),
        ],
        const SizedBox(height: AppSpacing.xl),
        _labelRow('Live preview', '$_gridRows × $_gridColumns'),
        const SizedBox(height: AppSpacing.md),
        _buildGridPreview(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildPresetCard(int index) {
    final preset = _presets[index];
    final selected = _selectedPresetIndex == index;
    return GestureDetector(
      onTap: () => _selectPreset(index),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: selected ? AppColors.primaryPurple : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMiniGrid(preset.rows, preset.cols)),
            const SizedBox(height: 8),
            Text('${preset.rows} × ${preset.cols}',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text('${preset.cells} cells · ${preset.pairs} pairs',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: preset.difficultyColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(preset.difficulty,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: preset.difficultyColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniGrid(int rows, int cols) {
    return LayoutBuilder(builder: (_, constraints) {
      const gap = 2.0;
      final cellSize =
          ((constraints.maxWidth - (cols - 1) * gap) / cols).clamp(4.0, 20.0);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(rows, (row) {
          return Padding(
            padding: EdgeInsets.only(top: row > 0 ? gap : 0),
            child: Row(
              children: List.generate(cols, (col) {
                return Padding(
                  padding: EdgeInsets.only(left: col > 0 ? gap : 0),
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      );
    });
  }

  Widget _buildGridPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: LayoutBuilder(builder: (_, constraints) {
        const gap = 4.0;
        final cellSize =
            ((constraints.maxWidth - (_gridColumns - 1) * gap) / _gridColumns)
                .clamp(8.0, 40.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_gridRows, (row) {
            return Padding(
              padding: EdgeInsets.only(top: row > 0 ? gap : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_gridColumns, (col) {
                  return Padding(
                    padding: EdgeInsets.only(left: col > 0 ? gap : 0),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      }),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STEP 3 — Card Design (icon selection)
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStep3() {
    _ensureCellIcons();
    final filledCount = _cellIcons.where((i) => i.isNotEmpty).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('Design Your Cards',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text(
            _focusedIcon != null
                ? 'Tap cells below to place $_focusedIcon'
                : 'Tap an icon to focus it, then place it on the board.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppSpacing.xl),
        _labelRow('Icons', '$filledCount / $_totalCells placed'),
        const SizedBox(height: AppSpacing.md),
        _buildIconPalette(),
        const SizedBox(height: AppSpacing.xl),
        _labelRow('Board', '$_gridRows × $_gridColumns'),
        const SizedBox(height: AppSpacing.md),
        _buildCellGrid(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildIconPalette() {
    final icons = _availableIcons;
    final counts = <String, int>{};
    for (final icon in _cellIcons) {
      if (icon.isNotEmpty) counts[icon] = (counts[icon] ?? 0) + 1;
    }
    final allFilled = _cellIcons.every((i) => i.isNotEmpty);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: icons.length,
      itemBuilder: (_, i) {
        final icon = icons[i];
        final placed = counts[icon] ?? 0;
        final isFocused = _focusedIcon == icon;
        final isPaired = placed >= 2;

        return GestureDetector(
          onTap: () => _onPaletteIconTap(icon),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isFocused
                  ? AppColors.primaryPurple.withValues(alpha: 0.3)
                  : isPaired
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXs),
              border: Border.all(
                color: isFocused
                    ? AppColors.primaryPurple
                    : isPaired
                        ? AppColors.success
                        : AppColors.divider,
                width: isFocused ? 2.5 : isPaired ? 1.5 : 1,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: AppColors.primaryPurple.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: (isPaired && !isFocused) || (allFilled && placed == 0)
                      ? 0.35
                      : 1.0,
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
                if (placed > 0 && !isFocused)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color:
                            isPaired ? AppColors.success : AppColors.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: isPaired
                          ? const Icon(Icons.check,
                              size: 10, color: Colors.white)
                          : Text('$placed',
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCellGrid() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: LayoutBuilder(builder: (_, constraints) {
        const gap = 6.0;
        final cellSize =
            ((constraints.maxWidth - (_gridColumns - 1) * gap) / _gridColumns)
                .clamp(20.0, 50.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_gridRows, (row) {
            return Padding(
              padding: EdgeInsets.only(top: row > 0 ? gap : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_gridColumns, (col) {
                  final idx = row * _gridColumns + col;
                  if (idx >= _cellIcons.length) return const SizedBox.shrink();
                  final icon = _cellIcons[idx];
                  final isEmpty = icon.isEmpty;
                  final canPlace = isEmpty &&
                      _focusedIcon != null &&
                      _cellIcons.where((i) => i == _focusedIcon).length < 2;

                  return Padding(
                    padding: EdgeInsets.only(left: col > 0 ? gap : 0),
                    child: GestureDetector(
                      onTap: () => _onGridCellTap(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color: !isEmpty
                              ? AppColors.primaryPurple.withValues(alpha: 0.5)
                              : canPlace
                                  ? AppColors.primaryPurple
                                      .withValues(alpha: 0.2)
                                  : AppColors.primaryPurple
                                      .withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: canPlace
                                ? AppColors.primaryPurple
                                : !isEmpty
                                    ? AppColors.primaryPurple
                                        .withValues(alpha: 0.6)
                                    : AppColors.divider,
                            width: canPlace ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: !isEmpty
                            ? FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(icon,
                                      style:
                                          TextStyle(fontSize: cellSize * 0.6)),
                                ),
                              )
                            : canPlace
                                ? Icon(Icons.add,
                                    size: cellSize * 0.3,
                                    color: AppColors.primaryPurple
                                        .withValues(alpha: 0.5))
                                : null,
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      }),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STEP 4 — Appearance (card back)
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStep4() {
    final sampleIcons =
        _selectedIcons.length >= 2 ? _selectedIcons.toList() : ['🐶', '💎'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('Style Your Cards',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text('Make your board look unmistakably yours.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Live Preview',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            Text('Tap a card to flip it',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            border: Border.all(color: AppColors.divider),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(4, (i) {
              final isFlipped = _livePreviewFlipped[i];
              final icon = sampleIcons[i % sampleIcons.length];
              return GestureDetector(
                onTap: () => setState(
                    () => _livePreviewFlipped[i] = !_livePreviewFlipped[i]),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isFlipped
                      ? _buildCardFront(icon, 100, key: ValueKey('front_$i'))
                      : _buildCardBackWidget(
                          _cardBack, 100, key: ValueKey('back_$i')),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Card back',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: _cardBackStyles.length,
          itemBuilder: (_, i) {
            final style = _cardBackStyles[i];
            final selected = _cardBack == style.id;
            return GestureDetector(
              onTap: () => setState(() => _cardBack = style.id),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  border: Border.all(
                    color:
                        selected ? AppColors.primaryPurple : AppColors.divider,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCardBackWidget(style.id, 60),
                    const SizedBox(height: 8),
                    Text(style.label,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildCardFront(String icon, double size, {Key? key}) {
    return Container(
      key: key,
      width: size * 0.75,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34D399), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(size * 0.1),
        border: Border.all(color: const Color(0xFF6EE7B7), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(icon, style: TextStyle(fontSize: size * 0.35)),
    );
  }

  Widget _buildCardBackWidget(String style, double size, {Key? key}) {
    final w = size * 0.75;
    final h = size * 1.0;
    final radius = BorderRadius.circular(size * 0.1);

    switch (style) {
      case 'stripes':
        return Container(
          key: key,
          width: w,
          height: h,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: CustomPaint(
              painter: _StripesPainter(
                const Color(0xFF6D28D9),
                const Color(0xFF8B5CF6),
              ),
            ),
          ),
        );
      case 'dots':
        return Container(
          key: key,
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFF5B21B6),
            borderRadius: radius,
            border: Border.all(color: const Color(0xFF7C3AED), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: CustomPaint(
              painter:
                  _DotsPainter(const Color(0xFF7C3AED).withValues(alpha: 0.5)),
            ),
          ),
        );
      case 'orange':
        return _solidBack(
            key, w, h, radius, const Color(0xFFF97316), const Color(0xFFFB923C));
      case 'green':
        return _solidBack(
            key, w, h, radius, const Color(0xFF22C55E), const Color(0xFF4ADE80));
      case 'red':
        return _solidBack(
            key, w, h, radius, const Color(0xFFEF4444), const Color(0xFFF87171));
      default:
        return Container(
          key: key,
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED),
            borderRadius: radius,
            border: Border.all(color: const Color(0xFF9F7AEA), width: 1.5),
          ),
          child: Icon(Icons.diamond_outlined,
              color: Colors.white70, size: size * 0.3),
        );
    }
  }

  Widget _solidBack(
      Key? key, double w, double h, BorderRadius radius, Color bg, Color border) {
    return Container(
      key: key,
      width: w,
      height: h,
      decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(color: border, width: 1.5)),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STEP 5 — Rules & Rewards
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('Set the Challenge',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text('Define the rules, the scoring and what players earn.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Max base score on your $_gridRows × $_gridColumns board',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('$_pairsNeeded pairs × 100 points, before bonuses',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text('$_maxScore',
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryPurple)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Game rules',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.md),
        _buildRuleCard(
          title: 'Time limit',
          subtitle: 'The round ends when time runs out.',
          enabled: _timeLimitEnabled,
          onToggle: (v) => setState(() => _timeLimitEnabled = v),
          child: _timeLimitEnabled ? _buildTimeStepper() : null,
        ),
        const SizedBox(height: 12),
        _buildRuleCard(
          title: 'Move limit',
          subtitle: 'Count each pair of flips as one move.',
          enabled: _moveLimitEnabled,
          onToggle: (v) => setState(() => _moveLimitEnabled = v),
          child: _moveLimitEnabled ? _buildMoveStepper() : null,
        ),
        const SizedBox(height: 12),
        _buildRuleCard(
          title: 'Mismatch flip-back delay',
          subtitle: 'How long a wrong pair stays visible.',
          enabled: true,
          child: _buildDelayStepper(),
        ),
        const SizedBox(height: 12),
        _buildRuleCard(
          title: 'Allow hints',
          subtitle: 'Players can peek at one card.',
          enabled: _allowHints,
          onToggle: (v) => setState(() => _allowHints = v),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildRuleCard({
    required String title,
    required String subtitle,
    required bool enabled,
    ValueChanged<bool>? onToggle,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (onToggle != null)
                Switch(
                  value: enabled,
                  onChanged: onToggle,
                  activeTrackColor: AppColors.primaryPurple,
                ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildTimeStepper() {
    return _buildValueStepper(
      _timeLimitDisplay,
      canDecrease: _timeLimitSeconds > 30,
      canIncrease: _timeLimitSeconds < 600,
      onDecrease: () => setState(
          () => _timeLimitSeconds = (_timeLimitSeconds - 30).clamp(30, 600)),
      onIncrease: () => setState(
          () => _timeLimitSeconds = (_timeLimitSeconds + 30).clamp(30, 600)),
    );
  }

  Widget _buildMoveStepper() {
    return _buildValueStepper(
      '$_moveLimit',
      canDecrease: _moveLimit > 5,
      canIncrease: _moveLimit < 100,
      onDecrease: () =>
          setState(() => _moveLimit = (_moveLimit - 5).clamp(5, 100)),
      onIncrease: () =>
          setState(() => _moveLimit = (_moveLimit + 5).clamp(5, 100)),
    );
  }

  Widget _buildDelayStepper() {
    return _buildValueStepper(
      _mismatchDelayDisplay,
      canDecrease: _mismatchDelayMs > 500,
      canIncrease: _mismatchDelayMs < 3000,
      onDecrease: () => setState(
          () => _mismatchDelayMs = (_mismatchDelayMs - 500).clamp(500, 3000)),
      onIncrease: () => setState(
          () => _mismatchDelayMs = (_mismatchDelayMs + 500).clamp(500, 3000)),
    );
  }

  Widget _buildValueStepper(
    String display, {
    required bool canDecrease,
    required bool canIncrease,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepperButton(Icons.remove, canDecrease ? onDecrease : null),
          Text(display,
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          _stepperButton(Icons.add, canIncrease ? onIncrease : null),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STEP 6 — Preview & Publish
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStep6() {
    final catObj = _categories.cast<_GameCategory?>().firstWhere(
        (c) => c!.id == _selectedCategory,
        orElse: () => null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text('Play, Then Publish',
            style: GoogleFonts.spaceGrotesk(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.sm),
        Text('Try your game once, then send it to an admin for approval.',
            style: GoogleFonts.inter(
                fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.diamond,
                    color: AppColors.primaryPurple, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_nameController.text.trim(),
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _tag(catObj?.label ?? _selectedCategory,
                            AppColors.textSecondary),
                        _tag(
                            _difficultyLabel,
                            _difficultyLabel == 'Easy'
                                ? AppColors.success
                                : AppColors.gold),
                        _tag('$_gridRows×$_gridColumns',
                            AppColors.textSecondary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Playable preview',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            GestureDetector(
              onTap: _resetPreview,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Restart',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Text('Moves',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('$_moves',
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Text('Pairs found',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('$_pairsFound / $_pairsNeeded',
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _hasCompletedPreview
                                ? AppColors.success
                                : AppColors.textPrimary)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPlayableGrid(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildPlayableGrid() {
    if (_gameCards.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: LayoutBuilder(builder: (_, constraints) {
        const gap = 6.0;
        final cellSize =
            ((constraints.maxWidth - (_gridColumns - 1) * gap) / _gridColumns)
                .clamp(20.0, 64.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_gridRows, (row) {
            return Padding(
              padding: EdgeInsets.only(top: row > 0 ? gap : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_gridColumns, (col) {
                  final idx = row * _gridColumns + col;
                  if (idx >= _gameCards.length) return const SizedBox.shrink();
                  final revealed = _revealedCards[idx];
                  final matched = _matchedCards[idx];
                  return Padding(
                    padding: EdgeInsets.only(left: col > 0 ? gap : 0),
                    child: GestureDetector(
                      onTap: () => _onCardTap(idx),
                      child: Container(
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color: matched
                              ? AppColors.success.withValues(alpha: 0.3)
                              : revealed
                                  ? const Color(0xFF059669)
                                  : _getCardBackColor(),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: matched
                                ? AppColors.success
                                : revealed
                                    ? const Color(0xFF6EE7B7)
                                    : _getCardBackBorderColor(),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: revealed || matched
                            ? FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(_gameCards[idx],
                                      style:
                                          TextStyle(fontSize: cellSize * 0.5)),
                                ),
                              )
                            : Icon(
                                _getCardBackIcon(),
                                color: Colors.white38,
                                size: cellSize * 0.35,
                              ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      }),
    );
  }

  Color _getCardBackColor() {
    switch (_cardBack) {
      case 'orange':
        return const Color(0xFFF97316);
      case 'green':
        return const Color(0xFF22C55E);
      case 'red':
        return const Color(0xFFEF4444);
      case 'stripes':
        return const Color(0xFF6D28D9);
      case 'dots':
        return const Color(0xFF5B21B6);
      default:
        return const Color(0xFF7C3AED);
    }
  }

  Color _getCardBackBorderColor() {
    switch (_cardBack) {
      case 'orange':
        return const Color(0xFFFB923C);
      case 'green':
        return const Color(0xFF4ADE80);
      case 'red':
        return const Color(0xFFF87171);
      default:
        return const Color(0xFF9F7AEA);
    }
  }

  IconData _getCardBackIcon() {
    switch (_cardBack) {
      case 'dots':
        return Icons.grid_on;
      case 'stripes':
        return Icons.line_style;
      default:
        return Icons.diamond_outlined;
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // Shared Widgets
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildButtons() {
    final isLastStep = _currentStep == _totalSteps;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding,
          AppSpacing.md, AppSpacing.screenPadding, AppSpacing.xl),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: AppSpacing.buttonHeight,
              child: OutlinedButton(
                onPressed: _onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusSm)),
                ),
                child: Text('Back',
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                onPressed: _isCurrentStepValid && !_isSubmitting
                    ? (isLastStep ? _onSubmit : _onContinue)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  disabledBackgroundColor: AppColors.cardBackground,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: AppColors.textDisabled,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusSm)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(isLastStep ? 'Submit for approval' : 'Continue',
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(String label, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepperButton(
                  Icons.remove, value > 3 ? () => onChanged(value - 1) : null),
              Text('$value',
                  style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              _stepperButton(
                  Icons.add, value < 10 ? () => onChanged(value + 1) : null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.secondaryBackground
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 18,
            color:
                onTap != null ? AppColors.textPrimary : AppColors.textDisabled),
      ),
    );
  }

  Widget _labelRow(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        Text(right,
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 15, color: AppColors.textTertiary),
      counterText: '',
      filled: true,
      fillColor: AppColors.cardBackground,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.inputBorder)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.inputBorder)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide:
              const BorderSide(color: AppColors.primaryPurple, width: 2)),
    );
  }
}

// ─── Custom painters ─────────────────────────────────────────────────────────

class _StripesPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  _StripesPainter(this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = color1;
    final paint2 = Paint()..color = color2;
    canvas.drawRect(Offset.zero & size, paint1);
    const stripeWidth = 6.0;
    final totalDiag = size.width + size.height;
    for (double d = 0; d < totalDiag; d += stripeWidth * 2) {
      final path = Path()
        ..moveTo(d, 0)
        ..lineTo(d + stripeWidth, 0)
        ..lineTo(0, d + stripeWidth)
        ..lineTo(0, d)
        ..close();
      canvas.drawPath(path, paint2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DotsPainter extends CustomPainter {
  final Color dotColor;
  _DotsPainter(this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    const spacing = 8.0;
    const radius = 1.5;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
