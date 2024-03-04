import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> _healthDataList = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    setState(() {
      _isFetching = true;
    });

    // 歩数データのタイプを指定
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.RESTING_HEART_RATE,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];
    List<HealthDataPoint> healthData = [];

    // データの取得
    try {
      bool accessGranted = await health.requestAuthorization(types);
      if (accessGranted) {
        healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
      }
    } catch (e) {
      print("Error fetching health data: $e");
    }

    // 取得したデータをフィルタリングしてリストに追加
    _healthDataList = HealthFactory.removeDuplicates(healthData);
    print(_healthDataList);

    setState(() {
      _isFetching = false;
    });

    // ここで次のポーリングをスケジュールします（例：60秒後）
    Future.delayed(const Duration(seconds: 60)).then((_) {
      if (mounted) {
        fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health Data Fetch Example'),
        ),
        body: Center(
          child: _isFetching
              ? const CircularProgressIndicator()
              : Text('Steps Today: ${_healthDataList.fold<int>(0, (sum, item) => sum + int.parse(item.value.toString()))}'),
        ),
      ),
    );
  }
}

