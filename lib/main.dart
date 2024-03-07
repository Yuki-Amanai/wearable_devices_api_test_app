import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:wearable_devices_api_test_app/view_model/health_view_model.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthDataProvider);
    final isSupported = !Platform.isAndroid;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ヘルスケアテスト'),
        ),
        body: Center(
          child : healthData.when(data: (data) {
            final healthList = healthData.valueOrNull ?? [];
            return isSupported ?
              ListView.builder(
                physics:const ScrollPhysics(),
                itemCount: healthList.length,
                itemBuilder: (_, index) {
                  final health = healthList[index];
                  return ListTile(
                    title: Text("${health.typeString}: ${health.value}"),
                    trailing: Text('${health.unitString} '),
                    subtitle: Text('${health.dateFrom} - ${health.dateTo}'),
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
