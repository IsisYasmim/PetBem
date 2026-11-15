import 'package:petbem/features/profile/domain/entities/user_profile.dart';
import 'package:petbem/features/profile/domain/repositories/profile_repository.dart';

class MemoryProfileRepository implements ProfileRepository {
  MemoryProfileRepository({
    this.stored = UserProfile.empty,
    this.failOnLoad = false,
    this.failOnSave = false,
  });

  UserProfile stored;
  bool failOnLoad;
  bool failOnSave;
  int loadCalls = 0;
  int saveCalls = 0;

  @override
  Future<UserProfile> load() async {
    loadCalls++;
    if (failOnLoad) {
      throw Exception('falha ao ler');
    }
    return stored;
  }

  @override
  Future<void> save(UserProfile profile) async {
    saveCalls++;
    if (failOnSave) {
      throw Exception('falha ao gravar');
    }
    stored = profile;
  }
}
