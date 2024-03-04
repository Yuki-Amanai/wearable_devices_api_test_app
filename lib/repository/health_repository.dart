import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';

abstract class BaseProfileRepository {
  Future<HealthDataPoint> fetchHealthData({required DateTime });
}

final profileRepositoryProvider = Provider<HealthRepository>(
      (ref) => HealthRepository(ref),
);

class HealthRepository implements BaseProfileRepository {

  Ref ref;

  HealthRepository(this.ref);

  /// ヘルスケア取得
  @override
  Future<HealthDataPoint> fetchHealthData() async {
    try {

    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  // 更新
  @override
  Future<void> updateProfile({required Profile profile}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .collection('profile')
          .doc(profile.id)
          .update({'name': profile.name});
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}