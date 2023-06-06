// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customdocumentHiveModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomDocumentHiveModelAdapter extends TypeAdapter<CustomDocumentHiveModel> {
  @override
  final int typeId = 0;

  @override
  CustomDocumentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomDocumentHiveModel(
      CustomDocumentID: fields[0] as String?,
      CustomDocumentTypeID: fields[1] as int,
      CreateUserID: fields[2] as String,
      ValidateUserID: fields[3] as int?,
      Place: fields[4] as String?,
      Address: fields[5] as String?,
      Year: fields[6] as String?,
      GeoLat: fields[7] as String?,
      GeoLon: fields[8] as String?,
      Photos: fields[9] as String,
      Persons: fields[10] as String?,
      Status: fields[11] as int,
      AdditionalInfo:  fields[12] as String?,
      personsTags:  fields[13] as String?,
      yearTags:  fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomDocumentHiveModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.CustomDocumentID)
      ..writeByte(1)
      ..write(obj.CustomDocumentTypeID)
      ..writeByte(2)
      ..write(obj.CreateUserID)
      ..writeByte(3)
      ..write(obj.ValidateUserID)
      ..writeByte(4)
      ..write(obj.Place)
      ..writeByte(5)
      ..write(obj.Address)
      ..writeByte(6)
      ..write(obj.Year)
      ..writeByte(7)
      ..write(obj.GeoLat)
      ..writeByte(8)
      ..write(obj.GeoLon)
      ..writeByte(9)
      ..write(obj.Photos)
      ..writeByte(10)
      ..write(obj.Persons)
      ..writeByte(11)
      ..write(obj.Status)
      ..writeByte(12)
      ..write(obj.AdditionalInfo)
      ..writeByte(13)
      ..write(obj.personsTags)
      ..writeByte(14)
      ..write(obj.yearTags);

  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDocumentHiveModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
