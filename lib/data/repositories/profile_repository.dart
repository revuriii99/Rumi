import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;
  String? get currentUserEmail => _supabase.auth.currentUser?.email;

  Future<Map<String, dynamic>> getProfile() async {
    if (currentUserId == null) return {};

    final res = await _supabase
        .from('profiles')
        .select()
        .eq('id', currentUserId!)
        .maybeSingle();

    if (res != null) {
      return Map<String, dynamic>.from(res);
    }

    return {
      'full_name': _supabase.auth.currentUser?.userMetadata?['full_name'] ?? '',
      'username': '',
      'email': currentUserEmail ?? '',
      'dob': '',
      'avatar_url': null,
    };
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String dob,
  }) async {
    if (currentUserId == null) return;

    await _supabase.from('profiles').upsert({
      'id': currentUserId!,
      'email': currentUserEmail,
      'full_name': fullName,
      'username': username,
      'dob': dob,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<String?> uploadAvatar(File imageFile) async {
    if (currentUserId == null) return null;
    final fileExt = imageFile.path.split('.').last;
    final fileName =
        '$currentUserId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    await _supabase.storage
        .from('avatars')
        .upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

    await _supabase.from('profiles').upsert({
      'id': currentUserId!,
      'email': currentUserEmail,
      'avatar_url': imageUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });

    return imageUrl;
  }

  Future<Map<String, dynamic>?> getFinancialProfile() async {
    if (currentUserId == null) return null;
    final res = await _supabase
        .from('financial_profiles')
        .select()
        .eq('user_id', currentUserId!)
        .maybeSingle();
    return res;
  }

  Future<void> updateFinancialProfile(Map<String, dynamic> data) async {
    if (currentUserId == null) return;
    data['updated_at'] = DateTime.now().toIso8601String();
    await _supabase.from('financial_profiles').upsert({
      'user_id': currentUserId,
      ...data,
    });
  }

  Future<void> saveFinancialProfile(Map<String, dynamic> data) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('financial_profiles').upsert({
      'user_id': user.id,
      'monthly_income': data['monthly_income'] ?? 0,
      'transportation': data['transportation'] ?? 0,
      'daily_needs': data['daily_needs'] ?? 0,
      'routine_bills': data['routine_bills'] ?? 0,
      'savings_target': data['savings_target'] ?? 0,
      'other_expenses': data['other_expenses'] ?? 0,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
