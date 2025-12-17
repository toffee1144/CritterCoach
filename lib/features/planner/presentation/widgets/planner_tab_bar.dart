import 'package:flutter/material.dart';
class PlannerTabBar extends StatelessWidget implements PreferredSizeWidget {
final TabController controller;
final List<String> labels;
final void Function(int) onTap;
const PlannerTabBar({
super.key,
required this.controller,
required this.labels,
required this.onTap,
});
@override
Size get preferredSize => const Size.fromHeight(40);
@override
Widget build(BuildContext context) {
final onSurface = Theme.of(context).colorScheme.onSurface;
final textStyle = (Theme.of(context).textTheme.titleMedium ?? const TextStyle())
.copyWith(fontSize: 17.5, fontWeight: FontWeight.w700, height: 1);
return Material(
  color: Colors.transparent,
  child: Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
    child: Theme(
      data: Theme.of(context).copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: TabBar(
        controller: controller,
        onTap: onTap,
        isScrollable: true,
        indicator: const BoxDecoration(),
        dividerColor: Colors.transparent,
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),

        tabs: List.generate(labels.length, (i) {
          return Tab(
            height: 36,
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                final selected = controller.index == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFFDA27) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    labels[i],
                    style: textStyle.copyWith(color: onSurface),
                    maxLines: 1,
                    softWrap: false,
                  ),
                );
              },
            ),
          );
        }),
      ),
    ),
  ),
);
}
}
