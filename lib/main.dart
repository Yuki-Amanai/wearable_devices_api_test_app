import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:health/health.dart';
import 'package:wearable_devices_api_test_app/view_model/health_view_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'テスト'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(healthProvider);
    final testList = [1, 2, 3, 4, 5];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: testList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 50,
                child: Center(
                  child: Text(testList[index].toString())
                ),
              );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
