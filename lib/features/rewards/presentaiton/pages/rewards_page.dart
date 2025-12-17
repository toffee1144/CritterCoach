import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/ui/app_scaffold.dart';
import '../../../avatar/application/avatar_controller.dart';
import '../../../avatar/presentation/widgets/avatar_widget.dart';
import '../../../avatar/domain/models/cosmetic_def.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  final avatarCtrl = AvatarController();

  late TabController _tabController;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    avatarCtrl.loadInitialData().then((_) {
      if (!mounted) return;
      setState(() => _loaded = true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _slotForTab(int index) {
    switch (index) {
      case 0:
        return 'outfit';        // Outfits tab
      case 1:
        return 'headAccessory'; // Hats tab
      case 2:
        return 'accessory';     // Accessories tab
      default:
        return 'outfit';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const AppScaffold(
        currentIndex: 2,
        background: Color(0xFF4B6CB7),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final avatarState = avatarCtrl.avatarState;
    final currentSlot = _slotForTab(_tabController.index);
    final itemsInThisTab = avatarCtrl.getItemsBySlot(currentSlot);

    final body = Column(
      children: [
        // header "Rewards" di dalam SafeArea
        const SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(top: 8, bottom: 4),
            child: Center(
              child: Text(
                'Rewards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),

        // kartu avatar putih
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: AvatarWidget(state: avatarState),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A5AD8),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 6,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // bar "Shop" kuning + coin
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFE57A), Color(0xFFF4C02A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Shop',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.circle, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    avatarCtrl.coins.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // tab bar biru seperti desain
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF2E3E8A),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              onTap: (_) {
                setState(() {});
              },
              tabs: const [
                Tab(text: 'Outfits'),
                Tab(text: 'Hats'),
                Tab(text: 'Accesories'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // area kuning berisi grid item
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: _ShopGrid(
                    items: itemsInThisTab,
                    avatarCtrl: avatarCtrl,
                    onChanged: () {
                      setState(() {});
                    },
                  ),
                ),
                // slider kecil abu-abu di bawah seperti mockup
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return AppScaffold(
      currentIndex: 2, // index Rewards di bottom navbar kamu
      background: const Color(0xFF4B6CB7),
      body: body,
    );
  }
}

class _ShopGrid extends StatelessWidget {
final List<CosmeticDef> items;
final AvatarController avatarCtrl;
final VoidCallback onChanged;
const _ShopGrid({
required this.items,
required this.avatarCtrl,
required this.onChanged,
});

@override
Widget build(BuildContext context) {
    return GridView.builder(
    scrollDirection: Axis.horizontal, // ini yang bikin scroll ke samping
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1, // 2 baris, kamu bisa ubah ke 1 kalau mau 1 baris saja
    mainAxisSpacing: 12, // jarak antar item secara horizontal
    crossAxisSpacing: 12, // jarak antar item secara vertikal
    childAspectRatio: 0.8,
    ),

    itemCount: items.length,
    itemBuilder: (context, index) {
    final c = items[index];
    final owned = avatarCtrl.userOwns(c.id);
    final equipped = avatarCtrl.isEquipped(c.id);
        return GestureDetector(
          onTap: () async {
            if (owned) {
              if (equipped) {
                avatarCtrl.unequipSlot(c.slot);
              } else {
                avatarCtrl.equip(c.id);
              }
              onChanged();
            } else {
              final didBuy = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => _BuyDialog(
                  cosmetic: c,
                  coins: avatarCtrl.coins,
                ),
              );

              if (didBuy == true) {
                final ok = await avatarCtrl.buy(c.id);
                if (ok) {
                  avatarCtrl.equip(c.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not enough coins')),
                  );
                }
                onChanged();
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: !owned
                  ? const Color(0xFFFFF59D)
                  : (equipped
                      ? const Color(0xFFE3F2FD)
                      : Colors.white),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    c.assetPathLocal,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                if (!owned)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.circle, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        c.priceCoins.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: equipped
                          ? const Color(0xFFBBDEFB)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      equipped ? 'Using' : 'Owned',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// dialog konfirmasi beli
class _BuyDialog extends StatelessWidget {
  final CosmeticDef cosmetic;
  final int coins;

  const _BuyDialog({
    required this.cosmetic,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = coins >= cosmetic.priceCoins;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure to buy\nthis item?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                cosmetic.assetPathLocal,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.circle, size: 16, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  '${cosmetic.priceCoins}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canAfford ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: canAfford
                        ? () => Navigator.of(context).pop(true)
                        : null,
                    child: Text(
                      canAfford ? 'Sure' : 'No Coins',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
