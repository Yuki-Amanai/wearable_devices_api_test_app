import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';

final healthDataProvider = StateNotifierProvider.autoDispose<HealthDataNotifier, AsyncValue<List<HealthDataPoint>>>((ref) => HealthDataNotifier());

DateTime startDate = DateTime.now().subtract(const Duration(hours: 1));
DateTime endDate = DateTime.now();

String getHealthDataTypeLabel(String type) {
  switch (type) {
    case 'STEPS':
      return '徒歩数';

    case 'HEART_RATE':
      return '心拍数';

    case'RESTING_HEART_RATE':
      return '安静時心拍数';
  // 他のケースに対応する必要があれば、ここに追加
    default:
      return 'その他';
  }
}

final getTotalStepsProvider = FutureProvider.autoDispose((ref) async {
  final totalSteps = await health.getTotalStepsInInterval(startDate, endDate);
  return totalSteps;
});

final health = HealthFactory();

class HealthDataNotifier extends StateNotifier<AsyncValue<List<HealthDataPoint>>> {

  HealthDataNotifier() : super(const AsyncLoading()) {
    fetchData();
  }
  /// ヘルスデータを取得
  Future<void> fetchData() async {
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
      throw "エラー。ヘルスデータを取得できませんでした: $e";
    }

    // 次のポーリングをスケジュール
    Future.delayed(const Duration(seconds: 10), fetchData);
  }
}