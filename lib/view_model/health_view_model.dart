import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';

final healthDataProvider = StateNotifierProvider.autoDispose<HealthDataNotifier, AsyncValue<List<HealthDataPoint>>>((ref) => HealthDataNotifier());

class HealthDataNotifier extends StateNotifier<AsyncValue<List<HealthDataPoint>>> {

  HealthDataNotifier() : super(const AsyncLoading()) {
    fetchData();
  }

  final health = HealthFactory();

  /// ヘルスデータを取得
  Future<void> fetchData() async {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
    print(startDate);
    DateTime endDate = DateTime.now();
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.RESTING_HEART_RATE,
    ];

    try {
      // ヘルスケア権限のauth処理
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
        state = AsyncData(HealthFactory.removeDuplicates(healthData));
      }
    } catch (e) {
      print(("エラー。ヘルスデータを取得できません: $e"));
    }

    // 次のポーリングをスケジュール
    Future.delayed(const Duration(minutes: 5), fetchData);
  }
}