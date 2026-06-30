class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String photoBase64;
  final bool isOnline;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.photoBase64 = '',
    this.isOnline = false,
  });
}
