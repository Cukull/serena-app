/// Profil pengguna (tabel `profiles`).
class Profile {
  const Profile({
    required this.id,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.onboardingCompleted = false,
  });

  final String id;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final bool onboardingCompleted;

  String get displayName => (fullName == null || fullName!.trim().isEmpty)
      ? (email ?? 'Pengguna')
      : fullName!.trim();

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'] as String,
        email: json['email'] as String?,
        fullName: json['full_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'onboarding_completed': onboardingCompleted,
      };
}
