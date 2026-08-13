import 'package:flutter/material.dart';
import 'package:manalyze/services/mongo_service.dart';

import 'constants.dart';
import 'screens/game_tracking.dart';
import 'screens/bounty_game.dart';
import 'screens/game_five_players.dart';
import 'screens/game_four_players.dart';
import 'screens/game_three_players.dart';
import 'screens/game_two_players.dart';
import 'screens/mechanic_dungeons.dart';
import 'screens/mechanic_the_ring.dart';
import 'screens/plane_chase.dart';
import 'screens/statistics_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ManalyzeApp());

  Future.microtask(() async {
    try {
      debugPrint('Starting MongoDB initialization');
      await MongoService.init('Commanders');
      debugPrint('MongoDB initialization successful');
    } catch (e, stackTrace) {
      debugPrint('MongoDB initialization FAILED: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  });
}

class ManalyzeApp extends StatelessWidget {
  const ManalyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manalyze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appPrimaryColor,
          brightness: Brightness.dark,
          surface: appSurfaceColor,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: appBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appButtonColor,
            foregroundColor: Colors.white,
            elevation: 0,
            side: const BorderSide(color: appButtonBorderColor),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: appSurfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appRadius),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? appPrimaryColor
                : Colors.transparent,
          ),
        ),
      ),
      home: const FirstRoute(key: ValueKey('first_route')),
    );
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manalyze')),
      body: Container(
        decoration: const BoxDecoration(color: appBackgroundColor),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _HomeHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate([
                  _GameButton(
                    text: 'Life Counter',
                    imagePath: 'images/thb-250-plains.jpg',
                    icon: Icons.favorite_rounded,
                    onTap: () => _showPlayerSelectionDialog(context),
                  ),
                  _GameButton(
                    text: 'Plane Chase',
                    imagePath: 'images/thb-251-island.jpg',
                    icon: Icons.public_rounded,
                    onTap: () => _showPlaneSetSelectionDialog(context),
                  ),
                  _GameButton(
                    text: 'Bounty',
                    imagePath: 'images/thb-252-swamp.jpg',
                    icon: Icons.workspace_premium_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const BountyGame(key: ValueKey('bounty_game')),
                      ),
                    ),
                  ),
                  _GameButton(
                    text: 'Mechanics Guide',
                    imagePath: 'images/thb-253-mountain.jpg',
                    icon: Icons.menu_book_rounded,
                    onTap: () => _showMechanicSelectionDialog(context),
                  ),
                  _GameButton(
                    text: 'Track Games',
                    imagePath: 'images/thb-254-forest.jpg',
                    icon: Icons.edit_note_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CommanderGameTracking(
                          key: ValueKey('commander_tracking'),
                        ),
                      ),
                    ),
                  ),
                  _GameButton(
                    text: 'Commander Stats',
                    imagePath: 'images/wastes.jpg',
                    icon: Icons.insights_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const StatisticsPage(
                          key: ValueKey('statistics_page'),
                        ),
                      ),
                    ),
                  ),
                ]),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 280,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final IconData icon;
  final VoidCallback onTap;

  const _GameButton({
    required this.text,
    required this.imagePath,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: text,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(appRadius),
        clipBehavior: Clip.antiAlias,
        child: Ink.image(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          child: InkWell(
            onTap: onTap,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x22000000), Color(0xD9000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(icon, color: Colors.white, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your game night',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6),
          Text('Choose a tool to start playing or review commander stats.'),
        ],
      ),
    );
  }
}

void _showPlayerSelectionDialog(BuildContext context) {
  _showSelectionDialog(context, 'Choose player count', [
    _SelectionOption(
      'Four players',
      Icons.groups_rounded,
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const FourPlayers(
            key: ValueKey('unique_key_for_gameFourPlayers'),
          ),
        ),
      ),
    ),
    _SelectionOption(
      'Three players',
      Icons.people_outline_rounded,
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ThreePlayers(
            key: ValueKey('unique_key_for_gameThreePlayers'),
          ),
        ),
      ),
    ),
    _SelectionOption(
      'Five players',
      Icons.groups_rounded,
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              const FivePlayers(key: ValueKey('unique_key_game_five_players')),
        ),
      ),
    ),
    _SelectionOption(
      'Two players',
      Icons.people_outline_rounded,
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              const TwoPlayers(key: ValueKey('unique_key_for_gameTwoPlayers')),
        ),
      ),
    ),
  ]);
}

void _showPlaneSetSelectionDialog(BuildContext context) {
  _showSelectionDialog(context, 'Choose a Planechase set', [
    _SelectionOption(
      'All planes',
      Icons.public_rounded,
      () => _openPlaneChase(context, fetchAllPlanes),
    ),
    _SelectionOption(
      'Planechase Anthology',
      Icons.collections_bookmark_rounded,
      () => _openPlaneChase(context, fetchAnthology),
    ),
    _SelectionOption(
      'March of the Machine',
      Icons.auto_awesome_motion_rounded,
      () => _openPlaneChase(context, fetchMOM),
    ),
    _SelectionOption(
      'Doctor Who',
      Icons.travel_explore_rounded,
      () => _openPlaneChase(context, fetchWHO),
    ),
  ]);
}

void _showMechanicSelectionDialog(BuildContext context) {
  _showSelectionDialog(context, 'Choose a mechanic', [
    _SelectionOption(
      'The Ring tempts you',
      Icons.ring_volume_rounded,
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              const TheRing(key: ValueKey('unique_key_for_The_Ring')),
        ),
      ),
    ),
    _SelectionOption(
      'Dungeons',
      Icons.account_tree_rounded,
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              const Dungeons(key: ValueKey('unique_key_for_Dungeons')),
        ),
      ),
    ),
  ]);
}

void _openPlaneChase(BuildContext context, String apiUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PlaneChase(
        key: const ValueKey('unique_key_for_Plane_Chase'),
        apiUrl: apiUrl,
      ),
    ),
  );
}

void _showSelectionDialog(
  BuildContext context,
  String title,
  List<_SelectionOption> options,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    option.onSelected();
                  },
                  icon: Icon(option.icon),
                  label: Text(option.label),
                ),
              ),
              if (option != options.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    ),
  );
}

class _SelectionOption {
  const _SelectionOption(this.label, this.icon, this.onSelected);

  final String label;
  final IconData icon;
  final VoidCallback onSelected;
}
