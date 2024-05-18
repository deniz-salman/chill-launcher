import 'dart:typed_data';
import 'package:device_apps/device_apps.dart';
import 'package:hive_flutter/adapters.dart';
part 'app_model.g.dart';

@HiveType(typeId: 1)
class AppModel {
  @HiveField(1)
  late String apkFilePath;
  @HiveField(2)
  late String appName;
  @HiveField(3)
  String? category;
  @HiveField(4)
  String? dataDir;
  @HiveField(5)
  bool? enabled;
  @HiveField(6)
  late Uint8List icon;
  @HiveField(7)
  int? installTimeMillis;
  @HiveField(8)
  late String packageName;
  @HiveField(9)
  int? versionCode;
  @HiveField(10)
  String? versionName;
  @HiveField(11)
  late bool systemApp;
  @HiveField(12)
  DateTime? lastOpened;
  @HiveField(13)
  int timesOpened = 0;

  AppModel toApp(ApplicationWithIcon app) {
    return AppModel()
      ..apkFilePath = app.apkFilePath
      ..appName = app.appName
      ..category = app.category.name
      ..dataDir = app.dataDir
      ..enabled = app.enabled
      ..icon = app.icon
      ..installTimeMillis = app.installTimeMillis
      ..packageName = app.packageName
      ..versionCode = app.versionCode
      ..versionName = app.versionName
      ..systemApp = app.systemApp;
  }
}
