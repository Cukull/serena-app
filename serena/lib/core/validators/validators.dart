/// Validator terpusat untuk form Serena. Satu sumber kebenaran,
/// jangan tulis regex validasi di tiap screen.
abstract class AppValidators {
  static String? required(String? v, [String message = 'Wajib diisi']) =>
      (v == null || v.trim().isEmpty) ? message : null;

  static String? email(String? v) {
    final requiredError = required(v, 'Email wajib diisi');
    if (requiredError != null) return requiredError;
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(v!.trim()) ? null : 'Format email tidak valid';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 8) return 'Password minimal 8 karakter';
    return null;
  }

  static String? Function(String?) confirmPassword(String? Function() other) =>
      (v) => v == other() ? null : 'Password tidak cocok';
}
