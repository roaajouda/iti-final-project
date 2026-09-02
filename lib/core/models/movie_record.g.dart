// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieRecordAdapter extends TypeAdapter<MovieRecord> {
  @override
  final int typeId = 0;

  @override
  MovieRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieRecord(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      releaseYear: fields[3] as int?,
      voteAverage: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MovieRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.releaseYear)
      ..writeByte(4)
      ..write(obj.voteAverage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
