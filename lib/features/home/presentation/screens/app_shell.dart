import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ymusic/core/constants/app_colors.dart';
import 'package:ymusic/core/constants/app_spacing.dart';
import 'package:ymusic/core/constants/app_strings.dart';
import 'package:ymusic/core/constants/app_typography.dart';
import 'package:ymusic/core/router/app_router.dart';
import 'package:ymusic/features/player/presentation/widgets/mini_player_bar.dart';

enum _NavTab { home, search, library }

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({required this.child, super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Navigation bar dimensions
  static const double _navBarPaddingBottom = 28;
  static const double _navBarPaddingTop = 10;

  // Tab item dimensions
  static const double _tabItemWidth = 64;
  static const double _tabItemHeight = 32;
  static const double _tabItemBorderRadius = 20;

  _NavTab _getCurrentTab() {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.search)) return _NavTab.search;
    if (location.startsWith(AppRoutes.library)) return _NavTab.library;
    return _NavTab.home;
  }

  void _onTabTapped(_NavTab tab) {
    switch (tab) {
      case _NavTab.home:
        context.go(AppRoutes.home);
      case _NavTab.search:
        context.go(AppRoutes.search);
      case _NavTab.library:
        context.go(AppRoutes.library);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = _getCurrentTab();

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.navBar,
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MiniPlayerBar(),
            Padding(
              padding: const EdgeInsets.only(
                top: _navBarPaddingTop,
                bottom: _navBarPaddingBottom,
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  icon: Icons.home,
                  label: AppStrings.navHome,
                  isActive: selectedTab == _NavTab.home,
                  onTap: () => _onTabTapped(_NavTab.home),
                ),
                _buildTabItem(
                  icon: Icons.search,
                  label: AppStrings.navSearch,
                  isActive: selectedTab == _NavTab.search,
                  onTap: () => _onTabTapped(_NavTab.search),
                ),
                _buildTabItem(
                  icon: Icons.library_music,
                  label: AppStrings.navLibrary,
                  isActive: selectedTab == _NavTab.library,
                  onTap: () => _onTabTapped(_NavTab.library),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _tabItemWidth,
            height: _tabItemHeight,
            decoration: BoxDecoration(
              color: isActive ? AppColors.loginGlowPurple : Colors.transparent,
              borderRadius: BorderRadius.circular(_tabItemBorderRadius),
            ),
            child: Center(
              child: Icon(
                icon,
                color: isActive ? Colors.white : AppColors.navIconInactive,
                size: AppSpacing.lg,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isActive ? Colors.white : AppColors.navIconInactive,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
