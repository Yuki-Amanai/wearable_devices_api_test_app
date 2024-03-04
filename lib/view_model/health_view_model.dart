import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';
import 'package:wearable_devices_api_test_app/main.dart';

enum HealthState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  INIT,
  LOADING,
  ERROR_AUTHORIZE,
  ERROR_NO_DATA,
  SUCCESS,
}

 List<HealthDataType> healthDataTypes = [
  HealthDataType.STEPS,
   HealthDataType.HEART_RATE,
   HealthDataType.RESTING_HEART_RATE,
   HealthDataType.DISTANCE_WALKING_RUNNING,
];

final healthDataAccessPermission = [
  HealthDataAccess.READ_WRITE,
  HealthDataAccess.READ_WRITE,
];

final healthProvider = StateNotifierProvider.autoDispose<HealthNotifier, AsyncValue<List<HealthDataPoint>>>((ref) => HealthNotifier(ref));

class HealthNotifier extends StateNotifier<AsyncValue<List<HealthDataPoint>>> {
  HealthNotifier(this.ref) : super(const AsyncLoading()) {
    fetchHealthData();
  }

  Ref ref;

  final health = HealthFactory(useHealthConnectIfAvailable: true);

  Future<void> fetchHealthData() async {
    try {
      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime.now();
      bool accessWasGranted = await health.requestAuthorization(healthDataTypes);
      if (!accessWasGranted) {
        print('エラー');
        return;
      }
      state = const AsyncLoading();
      final healthData = await health.getHealthDataFromTypes(startDate, endDate, healthDataTypes);
      state = AsyncData(healthData);
    } catch (e) {
      throw e.toString();
    }
  }
}