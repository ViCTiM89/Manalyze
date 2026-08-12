import 'package:flutter/material.dart';

class RulingsDialog extends StatelessWidget {
  const RulingsDialog({required this.title, required this.rulings, super.key});

  final String title;
  final List<String> rulings;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<String> rulings,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => RulingsDialog(title: title, rulings: rulings),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < rulings.length; index++) ...[
                Text(
                  rulings[index],
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    height: 1.45,
                    fontWeight: index == 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (index < rulings.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}
