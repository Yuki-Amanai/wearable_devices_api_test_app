import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';
import 'package:wearable_devices_api_test_app/main.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

 List<HealthDataType> types = [
  HealthDataType.STEPS,
   HealthDataType.HEART_RATE,
   HealthDataType.RESTING_HEART_RATE,
   HealthDataType.DISTANCE_WALKING_RUNNING,
];

final healthProvider = StateNotifierProvider.autoDispose<HealthNotifier, AsyncValue<List<HealthDataPoint>>>((ref) => HealthNotifier(ref));

class HealthNotifier extends StateNotifier<AsyncValue<List<HealthDataPoint>>> {
  HealthNotifier(this.ref) : super(const AsyncLoading()) {
    fetchHealthData();
  }

  Ref ref;

  Future<void> fetchHealthData() async {
    try {
      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime.now();
      HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
      bool accessWasGranted = await health.requestAuthorization(types);
      if (!accessWasGranted) {
        print('エラー');
        return;
      }
      state = const AsyncLoading();
      final healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

      state = AsyncData(healthData);
    } catch (e) {
      throw e.toString();
    }
  }
}