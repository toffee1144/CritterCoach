import 'package:flutter/material.dart';
import '../../../domain/entities/quest.dart';
import '../../../../../core/ui/app_colors.dart';

class QuestItemTile extends StatelessWidget {
  final Quest quest;
  const QuestItemTile({super.key, required this.quest});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bool done = quest.completed;

    return MediaQuery(
      // Kunci scale teks supaya tinggi item konsisten
      data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFECECEC)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // checkbox bulat kecil
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
              child: done
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),

            // judul (fleksibel)
            Expanded(
              child: Text(
                quest.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: true,
                  applyHeightToLastDescent: false,
                ),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.15),
              ),
            ),
            const SizedBox(width: 10),

            // progress bar (fleksibel, bukan fixed 92px)
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 72, maxWidth: 120),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: quest.progress.clamp(0.0, 1.0),
                  minHeight: 6, // sedikit lebih tipis supaya nggak mepet tinggi
                  backgroundColor: const Color(0xFFF0F0F0),
                  valueColor: AlwaysStoppedAnimation(
                    done ? AppColors.green : AppColors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
