import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class HealthDataNotifier extends StateNotifier<List<HealthDataPoint>> {
  final health = HealthFactory();

  HealthDataNotifier() : super([]) {
    fetchData();
  }

  void fetchData() async {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
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
    Future.delayed(const Duration(minutes: 30), fetchData);
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
          title: const Text('ヘルスケアテスト'),
        ),
        body: Center(
          child : healthData.isEmpty
            ? const Center(child: Text('データがありません',))
              : ListView.builder(
            physics:const ScrollPhysics(),
              itemCount: healthData.length,
              itemBuilder: (_, index) {
                final health = healthData[index];
                print(health);
                return ListTile(
                  title: Text("${health.typeString}: ${health.value}"),
                  trailing: Text('${health.unitString} '),
                  subtitle: Text('${health.dateFrom} - ${health.dateTo}'),
                );
    }),
        ),
      ),
    );
  }
}
