class CosmeticDef {
final String id;
final String slot;
final String displayName;
final String rarity;
final int priceCoins;
final bool available;
final String assetPathLocal;
CosmeticDef({
required this.id,
required this.slot,
required this.displayName,
required this.rarity,
required this.priceCoins,
required this.available,
required this.assetPathLocal,
});
factory CosmeticDef.fromJson(Map<String, dynamic> json) {
return CosmeticDef(
id: (json['id'] ?? '').toString(),
slot: (json['slot'] ?? '').toString(),
displayName: (json['displayName'] ?? '').toString(),
rarity: (json['rarity'] ?? '').toString(),
priceCoins: (json['priceCoins'] as num?)?.toInt() ?? 0,
available: (json['available'] == true),
assetPathLocal: (json['assetPathLocal'] ?? '').toString(),
);
}
Map<String, dynamic> toJson() => {
'id': id,
'slot': slot,
'displayName': displayName,
'rarity': rarity,
'priceCoins': priceCoins,
'available': available,
'assetPathLocal': assetPathLocal,
};
}