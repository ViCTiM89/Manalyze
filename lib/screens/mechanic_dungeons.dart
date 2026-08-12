import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:manalyze/services/card_api.dart';
import '../constants.dart';
import '../model/cards.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/rulings_dialog.dart';
import 'mechanic_dungeon_detail.dart';

const List<String> rulings = [
  'Whenever one or more creatures a player controls deal combat damage to you, that player takes the initiative.',
  '• Whenever you take the initiative and at the beginning of your upkeep, venture into Undercity.',
  '(If you’re in a dungeon, advance to the next room. If you’re not, enter Undercity. You can take the initiative even if you already have it.) ',
];

class Dungeons extends StatelessWidget {
  const Dungeons({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: MechanicDungeons(
        key: ValueKey<String>('unique_key_for_Dungeons'),
        title: 'Dungeons',
      ),
    );
  }
}

class MechanicDungeons extends StatefulWidget {
  const MechanicDungeons({required Key key, required this.title})
    : super(key: key);
  final String title;

  @override
  State<MechanicDungeons> createState() => _MechanicDungeonsState();
}

class _MechanicDungeonsState extends State<MechanicDungeons> {
  @override
  void initState() {
    super.initState();
    // Enable wakelock when entering the screen
    WakelockPlus.enable();
    fetchDungeons();
  }

  @override
  void dispose() {
    // Disable wakelock when leaving the screen
    WakelockPlus.disable();
    super.dispose();
  }

  Color shadowColor = Colors.white12;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: appBackgroundColor),
      child: Scaffold(
        appBar: const SharedAppBar(backgroundColor: appBarColor),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                height: 500,
                width: 500,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: dungeons.length,
                        itemBuilder: (context, index) {
                          final dungeon = dungeons[index];
                          final name = dungeon.name;
                          final typeLine = dungeon.typeLine;
                          return ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              typeLine,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DungeonDetail(dungeon: dungeon),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => RulingsDialog.show(
                        context,
                        title: 'Rulings for venturing into a dungeon',
                        rulings: rulings,
                      ),
                      child: Container(
                        height: 50.0,
                        width: 150.0,
                        decoration: buttonDecoration(),
                        child: const Center(
                          child: Text(
                            'Show Rulings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50.0,
                  width: 150.0,
                  decoration: buttonDecoration(),
                  child: const Center(
                    child: Text(
                      'Go back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  List<FetchedCards> dungeons = [];

  Future<void> fetchDungeons() async {
    final response = await CardApi.fetchCards(fetchAllDungeons);
    setState(() {
      dungeons = response;
    });
  }
}
