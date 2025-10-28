import 'package:flutter/material.dart';
import '../../../domain/entities/quest.dart';
import '../../../../../core/ui/app_colors.dart';
import '../../pages/upload_proof_page.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  const QuestCard({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    final bool done = quest.completed;

    // Use enum from entity
    final itemTypeEnum = quest.itemType; // ItemType.habit | ItemType.task
    final itemTypeLabel = itemTypeEnum == ItemType.habit ? 'habit' : 'task';

    final mq = MediaQuery.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => UploadProofPage(
              itemId: quest.id.toString(), // safe if id might be int
              itemTitle: quest.title,
              itemType: itemTypeLabel,     // ✅ send the label string
            ),
          ),
        );

        if (result == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks! Proof submitted.')),
          );
        }
      },
      child: MediaQuery(
        data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _TypeChip(type: itemTypeLabel), // Habit / Task chip
                        const SizedBox(height: 6),
                        Text(
                          quest.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: true,
                            applyHeightToLastDescent: false,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: done ? AppColors.green : const Color(0xFFBFC6D0),
                        width: 2,
                      ),
                      color: done ? AppColors.green : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: quest.progress.clamp(0.0, 1.0),
                  backgroundColor: const Color(0xFFE9EDF3),
                  valueColor: AlwaysStoppedAnimation(
                    done
                        ? AppColors.green
                        : (itemTypeEnum == ItemType.habit
                            ? const Color(0xFF3E75FF)
                            : const Color(0xFF7A5AF8)),
                  ),
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}

