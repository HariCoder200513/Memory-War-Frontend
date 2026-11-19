import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/game_models.dart';
import '../../data/services/game_service.dart';

class CreatorStudioScreen extends StatefulWidget {
  const CreatorStudioScreen({super.key});

  @override
  State<CreatorStudioScreen> createState() => _CreatorStudioScreenState();
}

class _CreatorStudioScreenState extends State<CreatorStudioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GameService _gameService;

  List<Game> _drafts = [];
  List<Game> _inReview = [];
  List<Game> _published = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) _loadCurrentTab();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameService = GameService(context.read<ApiClient>());
    _loadCurrentTab();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentTab() async {
    setState(() => _isLoading = true);
    try {
      switch (_tabController.index) {
        case 0:
          _drafts = await _gameService.listGames(status: 'draft');
          break;
        case 1:
          _inReview = await _gameService.listGames(status: 'pending_review');
          break;
        case 2:
          _published = await _gameService.listGames(status: 'published');
          break;
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: AppColors.textPrimary, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text('Creator Studio',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Creator',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryPurple)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusSm),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusXs),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(4),
                  dividerHeight: 0,
                  labelColor: AppColors.primaryBackground,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  tabs: const [
                    Tab(text: 'Drafts'),
                    Tab(text: 'In review'),
                    Tab(text: 'Published'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGameList(_drafts, 'No drafts yet',
                        'Start a game, preview it, and it will wait here until you submit it.'),
                    _buildGameList(_inReview, 'Nothing in review',
                        'Games you submit for approval will appear here.'),
                    _buildGameList(_published, 'No published games',
                        'Approved games go live here for all players.'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding, 0, AppSpacing.screenPadding,
                    AppSpacing.xl),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(context)
                          .pushNamed('/creator/create-game');
                      if (result == true) _loadCurrentTab();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.primaryBackground,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppSpacing.borderRadiusSm)),
                      elevation: 0,
                    ),
                    child: Text('Create a game',
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameList(
      List<Game> games, String emptyTitle, String emptyDesc) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple));
    }
    if (games.isEmpty) return _buildEmptyState(emptyTitle, emptyDesc);

    return RefreshIndicator(
      onRefresh: _loadCurrentTab,
      color: AppColors.primaryPurple,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: games.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildGameCard(games[i]),
      ),
    );
  }

  Widget _buildGameCard(Game game) {
    Color statusColor;
    String statusLabel;
    switch (game.status) {
      case 'draft':
        statusColor = AppColors.textSecondary;
        statusLabel = 'Draft';
        break;
      case 'pending_review':
        statusColor = AppColors.gold;
        statusLabel = 'In review';
        break;
      case 'published':
        statusColor = AppColors.success;
        statusLabel = 'Published';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusLabel = game.status;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              game.cardIcons.isNotEmpty ? game.cardIcons.first : '🎮',
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.name,
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${game.gridRows}x${game.gridColumns}',
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Text(game.category,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(statusLabel,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String description) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlaceholderCard(),
                const SizedBox(width: 12),
                _buildPlaceholderCard(),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text(description,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      width: 56,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusXs),
        border: Border.all(color: AppColors.divider),
      ),
    );
  }
}
