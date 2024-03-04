import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class HealthDataNotifier extends StateNotifier<List<HealthDataPoint>> {
  HealthFactory health = HealthFactory();

  HealthDataNotifier() : super([]) {
    fetchData();
  }

  void fetchData() async {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.RESTING_HEART_RATE,
    ];

    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
        state = HealthFactory.removeDuplicates(healthData);
      }
    } catch (e) {
      print("Error fetching health data: $e");
    }

    // 次のポーリングをスケジュール
    Future.delayed(const Duration(seconds: 60), fetchData);
  }
}

final healthDataProvider = StateNotifierProvider.autoDispose<HealthDataNotifier, List<HealthDataPoint>>((ref) => HealthDataNotifier());

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthDataProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Health Data Fetch Example'),
        ),
        body: Center(
          child: healthData.isEmpty
              ? const CircularProgressIndicator()
              : Text('Steps Today: ${healthData.fold<int>(0, (sum, item) => sum + int.parse(item.value.toString()))}'),
        ),
      ),
    );
  }
}
