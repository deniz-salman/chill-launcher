// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppModelAdapter extends TypeAdapter<AppModel> {
  @override
  final int typeId = 1;

  @override
  AppModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppModel()
      ..apkFilePath = fields[1] as String
      ..appName = fields[2] as String
      ..category = fields[3] as String?
      ..dataDir = fields[4] as String?
      ..enabled = fields[5] as bool?
      ..icon = fields[6] as Uint8List
      ..installTimeMillis = fields[7] as int?
      ..packageName = fields[8] as String
      ..versionCode = fields[9] as int?
      ..versionName = fields[10] as String?
      ..systemApp = fields[11] as bool
      ..lastOpened = fields[12] as DateTime?
      ..timesOpened = fields[13] as int;
  }

  @override
  void write(BinaryWriter writer, AppModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(1)
      ..write(obj.apkFilePath)
      ..writeByte(2)
      ..write(obj.appName)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.dataDir)
      ..writeByte(5)
      ..write(obj.enabled)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.installTimeMillis)
      ..writeByte(8)
      ..write(obj.packageName)
      ..writeByte(9)
      ..write(obj.versionCode)
      ..writeByte(10)
      ..write(obj.versionName)
      ..writeByte(11)
      ..write(obj.systemApp)
      ..writeByte(12)
      ..write(obj.lastOpened)
      ..writeByte(13)
      ..write(obj.timesOpened);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
