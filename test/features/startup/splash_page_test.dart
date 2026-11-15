import 'package:flutter_test/flutter_test.dart';
import 'package:petbem/app/petbem_app.dart';
import 'package:petbem/app/shell/app_shell.dart';
import 'package:petbem/features/products/domain/entities/pet_type.dart';
import 'package:petbem/features/profile/domain/entities/pet.dart';
import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/presentation/profile_scope.dart';
import 'package:petbem/features/startup/presentation/splash_page.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../support/memory_profile_repository.dart';

void main() {
  const ana = UserProfile(
    name: 'Ana',
    pets: [Pet(id: '1', name: 'Luna', type: PetType.dog)],
  );

  testWidgets('carrega o perfil durante a Splash e abre o app', (tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({'onboarding_completed': true});
    final repository = MemoryProfileRepository(stored: ana);

    await tester.pumpWidget(PetBemApp(profileRepository: repository));
    expect(find.byType(SplashPage), findsOne);

    await tester.pump();
    expect(repository.loadCalls, 1);

    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.byType(AppShell), findsOne);
    final context = tester.element(find.byType(AppShell));
    expect(ProfileScope.read(context).profile, ana);
    expect(repository.loadCalls, 1);

    // O repositório falso da Home espera 800 ms. Sem este avanço, o
    // temporizador fica pendente no fim do teste.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });
}
