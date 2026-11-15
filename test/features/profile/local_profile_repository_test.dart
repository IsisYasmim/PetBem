import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/data/local_profile_repository.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  const ana = UserProfile(
    name: 'Ana',
    pets: [Pet(id: '1', name: 'Luna', type: PetType.dog)],
  );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('o que foi salvo é lido de volta', () async {
    await LocalProfileRepository().save(ana);

    expect(await LocalProfileRepository().load(), ana);
  });

  test('sem nada gravado, o perfil é vazio', () async {
    expect(await LocalProfileRepository().load(), UserProfile.empty);
  });

  test('texto corrompido devolve o perfil vazio, sem apagar', () async {
    final preferences = SharedPreferencesAsync();
    await preferences.setString('user_profile', '{isto não é json');

    expect(await LocalProfileRepository().load(), UserProfile.empty);
    expect(await preferences.getString('user_profile'), '{isto não é json');
  });
}
