import 'dart:math';
import 'package:flutter/material.dart';
import 'package:manalyze/constants.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:manalyze/services/card_api.dart';
import 'package:manalyze/model/cards.dart';
import '../widgets/app_bar_widget.dart';

const Color rewardColorActive = Colors.amberAccent;
const Color rewardColorInactive = Colors.grey;

const List<String> rewards = [
  'Create a Treasure Token',
  'Create Two Treasure Tokens',
  'Create two Treasure tokens *or* draw a card',
  '(Max) Create two Treasure tokens *and* draw a card.',
];

class BountyGame extends StatefulWidget {
  const BountyGame({super.key});

  @override
  State<BountyGame> createState() => _BountyGameState();
}

class _BountyGameState extends State<BountyGame> {
  int rewardLevel = 0;
  String? currentImageUrl;
  List<FetchedCards> bounties = [];

  @override
  void initState() {
    super.initState();
    // Enable wakelock when entering the screen
    WakelockPlus.enable();
    fetchBounties();
  }

  @override
  void dispose() {
    // Disable wakelock when leaving the screen
    WakelockPlus.disable();
    super.dispose();
  }

  void _incrementRewardLevel() {
    setState(() {
      if (rewardLevel < 3) {
        rewardLevel++;
      } else {
        rewardLevel = 0;
      }
    });
  }

  void _resetRewardLevel() {
    setState(() {
      rewardLevel = 0;
    });
  }

  Color _getTextColor(int index) {
    return rewardLevel >= index ? rewardColorActive : rewardColorInactive;
  }

  void _showBountiesDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Bounties (${bounties.length})',
            style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SizedBox(
            width: 420,
            height: 460,
            child: ListView.separated(
              itemCount: bounties.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final bounty = bounties[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: appPrimaryColor,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    bounty.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.open_in_full_rounded,
                    color: appPrimaryColor,
                  ),
                  onLongPress: () {
                    setState(() {
                      currentImageUrl =
                          bounty.imageUris?.large ??
                          bounty.cardFaces![0].imageUris.large;
                    });
                    Navigator.of(dialogContext).pop();
                  },
                );
              },
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

    double bountyHeight = screenHeight / 2;
    double bountyWidth = screenWidth;
    double rewardLevelHeight = screenHeight / 8.5;
    double rewardLevelWidth = screenWidth;

    return Container(
      decoration: const BoxDecoration(color: appBackgroundColor),
      child: Scaffold(
        appBar: const SharedAppBar(backgroundColor: appBarColor),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _incrementRewardLevel,
                onLongPress: () {
                  setState(() {
                    if (bounties.isNotEmpty) {
                      final randomIndex = Random().nextInt(bounties.length);
                      final randomBounty = bounties[randomIndex];
                      currentImageUrl =
                          randomBounty.imageUris?.large ??
                          randomBounty.cardFaces![0].imageUris.large;
                    }
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: bountyHeight,
                    width: bountyWidth,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Center(
                      child: currentImageUrl == null
                          ? Image.asset('images/bounty.jpg', fit: BoxFit.cover)
                          : Image.network(currentImageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _incrementRewardLevel,
                onLongPress: _resetRewardLevel,
                child: Container(
                  height: rewardLevelHeight * 2,
                  width: rewardLevelWidth,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            height: rewardLevelHeight,
                            width: rewardLevelWidth,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                rewards[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _getTextColor(index),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: buttonDecoration(),
                      child: const Center(
                        child: Text(
                          'Go back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _showBountiesDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: buttonDecoration(),
                      child: const Text(
                        'Show Bounties',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchBounties() async {
    final response = await CardApi.fetchCards(fetchAllBounties);
    setState(() {
      bounties = response;
    });
  }
}
