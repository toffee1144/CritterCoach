class AvatarState {
  final String body; // contoh: 'assets/avatar/base/Base.svg'
  final String? hair;
  final String? headAccessory;
  final String? faceAccessory;
  final String? outfit;
  final String? backAccessory;
  final List<String>? fx;
  final String? accessory;

  const AvatarState({
    required this.body,
    this.hair,
    this.headAccessory,
    this.faceAccessory,
    this.outfit,
    this.backAccessory,
    this.fx,
    this.accessory,
});
}

