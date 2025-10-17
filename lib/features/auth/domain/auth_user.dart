class AuthUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  AuthUser({required this.id, required this.name, required this.email, this.photoUrl});
}
