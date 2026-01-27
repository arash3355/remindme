import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_provider.g.dart';

class ProfileData {
  final String name;
  final String email;
  final String? nim;

  const ProfileData({required this.name, required this.email, this.nim});
}

@riverpod
Future<ProfileData> profile(Ref ref) async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;

  if (user == null) {
    throw Exception('User not logged in');
  }

  final data = await client
      .from('profiles')
      .select('full_name, nim')
      .eq('id', user.id)
      .single();

  final fullName = (data['full_name'] as String?)?.trim();

  return ProfileData(
    name: (fullName != null && fullName.isNotEmpty)
        ? fullName
        : user.email!.split('@').first,
    email: user.email!,
    nim: data['nim'] as String?,
  );
}
