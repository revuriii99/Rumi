import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>?> getProfile() async {
    if (currentUserId == null) return null;
    final res = await _supabase
        .from('profiles')
        .select()
        .eq('id', currentUserId!)
        .maybeSingle();
    return res;
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String dob,
  }) async {
    if (currentUserId == null) return;
    await _supabase
        .from('profiles')
        .update({
          'full_name': fullName,
          'username': username,
          'dob': dob,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', currentUserId!);
  }

  Future<String?> uploadAvatar(File imageFile) async {
    if (currentUserId == null) return null;
    final fileExt = imageFile.path.split('.').last;
    final fileName =
        '$currentUserId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = fileName;

    await _supabase.storage
        .from('avatars')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final imageUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);

    await _supabase
        .from('profiles')
        .update({'avatar_url': imageUrl})
        .eq('id', currentUserId!);

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
}
