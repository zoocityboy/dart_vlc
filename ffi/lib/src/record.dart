import 'dart:io';

import 'package:ffi/ffi.dart';

import '../dart_vlc_ffi.dart';
import 'internal/ffi.dart';

/// Internally used class to avoid direct creation of the object of a [Record] class.
class _Record extends Record {}

class Record {
  /// ID for this record.
  late int id;

  /// Recording from [Media].
  late Media media;

  /// Path where the recording is saved example: `/home/alexmercerind/recording.mp3`
  late File savingFile;

  /// Creates a new [Record] instance.
  static Record create({
    required int id,
    required Media media,
    required File savingFile,
  }) {
    final Record record = _Record()
      ..id = id
      ..media = media
      ..savingFile = savingFile;
    final savingFileCStr = savingFile.path.toNativeUtf8();
    final mediaTypeCStr = media.mediaType.toString().toNativeUtf8();
    final mediaResourceCStr = media.resource.toNativeUtf8();
    RecordFFI.create(
      record.id,
      savingFileCStr,
      mediaTypeCStr,
      mediaResourceCStr,
    );
    calloc
      ..free(savingFileCStr)
      ..free(mediaTypeCStr)
      ..free(mediaResourceCStr);
    return record;
  }

  /// Starts recording the [Media].
  void start() {
    RecordFFI.start(id);
  }

  /// Disposes this instance of [Record].
  void dispose() {
    RecordFFI.dispose(id);
  }
}
