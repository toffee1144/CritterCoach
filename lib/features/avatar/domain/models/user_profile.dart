class UserProfile {
final int userId;
final int coins;
final List<String> ownedItems;
final Map<String, String> equipped;
UserProfile({
required this.userId,
required this.coins,
required this.ownedItems,
required this.equipped,
});
}
