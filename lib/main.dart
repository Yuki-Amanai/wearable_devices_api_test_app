import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:wearable_devices_api_test_app/view_model/health_view_model.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthDataProvider);
    final getTotalSteps = ref.watch(getTotalStepsProvider).valueOrNull;
    final isSupported = !Platform.isAndroid;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
            const Text('ヘルスケアテスト',
                style:TextStyle(
                  fontSize: 22
                ),
            ),
              Text('総歩数: $getTotalSteps歩'),
            ],
          ),
        ),
        body: Center(
          child : healthData.when(data: (data) {
            final healthList = healthData.valueOrNull ?? [];
            print(healthList);
            return isSupported ?
            ListView.builder(
                physics:const ScrollPhysics(),
                itemCount: healthList.length,
                itemBuilder: (_, index) {
                  final health = healthList[index];
                  return ListTile(
                    title: Text("${getHealthDataTypeLabel(health.typeString)}: ${health.value}"),
                    subtitle: Text("${health.dateFrom} ~ ${health.dateTo}"),
                  );
                })
                : const Text('現在Androidはサポート外です');
          }, error:(e, stacktrace) => Text(e.toString()),
              loading: () => const Center(
                child:  CircularProgressIndicator(),
              )),
        ),
      ),
    );
  }
}
