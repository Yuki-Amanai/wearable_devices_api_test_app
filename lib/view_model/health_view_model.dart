import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';
import 'dart:io';

class HealthDataNotifier extends StateNotifier<AsyncValue<List<HealthDataPoint>>> {
  final health = HealthFactory();

  HealthDataNotifier() : super(const AsyncLoading()) {
    fetchData();
  }

  void fetchData() async {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
    DateTime endDate = DateTime.now();
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.RESTING_HEART_RATE,
    ];

    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted && isSupported) {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
        state = AsyncData(HealthFactory.removeDuplicates(healthData));
      } else {
      }
    } catch (e) {
      print(("Error fetching health data: $e"));
    }

    // 次のポーリングをスケジュール
    Future.delayed(const Duration(seconds: 20), fetchData);
  }
}

final healthDataProvider = StateNotifierProvider.autoDispose<HealthDataNotifier, AsyncValue<List<HealthDataPoint>>>((ref) => HealthDataNotifier());